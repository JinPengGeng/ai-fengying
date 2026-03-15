import z from "zod";
import * as fs from "fs";
import WebSocket from "ws";
import { CharacterAlignmentResponseModel } from "@elevenlabs/elevenlabs-js/api";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "../src/lib/constants";

let dashscopeApiKey: string | null = null;

export const setDashScopeApiKey = (key: string) => {
  dashscopeApiKey = key;
};

export const dashscopeStructuredCompletion = async <T>(
  prompt: string,
  schema: z.ZodType<T>,
): Promise<T> => {
  const jsonSchema = z.toJSONSchema(schema);

  const res = await fetch(
    "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${dashscopeApiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "qwen-plus",
        messages: [{ role: "user", content: prompt }],
        response_format: {
          type: "json_schema",
          json_schema: {
            name: "response",
            schema: {
              type: jsonSchema.type || "object",
              properties: jsonSchema.properties,
              required: jsonSchema.required,
              additionalProperties: jsonSchema.additionalProperties ?? false,
            },
            strict: true,
          },
        },
      }),
    },
  );

  if (!res.ok) throw new Error(`DashScope error: ${await res.text()}`);

  const data = await res.json();
  const content = data.choices[0]?.message?.content;

  if (!content) {
    throw new Error("No content in DashScope response");
  }

  const parsed = JSON.parse(content);
  return schema.parse(parsed);
};

function saveUint8ArrayToPng(uint8Array: Uint8Array, filePath: string) {
  const buffer = Buffer.from(uint8Array);
  fs.writeFileSync(filePath, buffer as Uint8Array);
}

export const generateWanxImage = async ({
  prompt,
  path,
  onRetry,
}: {
  prompt: string;
  path: string;
  onRetry: (attempt: number) => void;
}): Promise<void> => {
  const maxRetries = 3;
  let attempt = 0;
  let lastError: Error | null = null;

  while (attempt < maxRetries) {
    const res = await fetch(
      "https://dashscope.aliyuncs.com/api/v1/services/aigc/text2image/image-synthesis",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${dashscopeApiKey}`,
          "Content-Type": "application/json",
          "X-DashScope-Async": "enable",
        },
        body: JSON.stringify({
          model: "wanx-v1",
          input: {
            prompt,
          },
          parameters: {
            size: "720*1280",
            n: 1,
          },
        }),
      },
    );

    if (res.ok) {
      const data = await res.json();
      const taskId = data.output.task_id;

      const imageUrl = await pollForImageResult(taskId);

      const imageRes = await fetch(imageUrl);
      const arrayBuffer = await imageRes.arrayBuffer();
      const uint8Array = new Uint8Array(arrayBuffer);

      saveUint8ArrayToPng(uint8Array, path);
      return;
    } else {
      lastError = new Error(
        `Wanx error (attempt ${attempt + 1}): ${await res.text()}`,
      );
      attempt++;
      if (attempt < maxRetries) {
        await new Promise((resolve) => setTimeout(resolve, 2000));
      }
      onRetry(attempt);
    }
  }

  throw lastError!;
};

async function pollForImageResult(taskId: string): Promise<string> {
  const maxPolls = 60;
  for (let i = 0; i < maxPolls; i++) {
    const res = await fetch(
      `https://dashscope.aliyuncs.com/api/v1/tasks/${taskId}`,
      {
        method: "GET",
        headers: {
          Authorization: `Bearer ${dashscopeApiKey}`,
        },
      },
    );

    if (res.ok) {
      const data = await res.json();
      const status = data.output.task_status;

      if (status === "SUCCEEDED") {
        return data.output.results[0].url;
      } else if (status === "FAILED") {
        throw new Error(`Image generation failed: ${data.output.message}`);
      }
    }

    await new Promise((resolve) => setTimeout(resolve, 3000));
  }

  throw new Error("Image generation timeout");
}

export const getGenerateStoryPrompt = (title: string, topic: string) => {
  const prompt = `Write a short story with title [${title}] (its topic is [${topic}]).
   You must follow best practices for great storytelling. 
   The script must be 8-10 sentences long. 
   Story events can be from anywhere in the world, but text must be translated into Chinese language. 
   Result result without any formatting and title, as one continuous text. 
   Skip new lines.`;

  return prompt;
};

export const getGenerateImageDescriptionPrompt = (storyText: string) => {
  const prompt = `You are given story text.
  Generate (in Chinese) 5-8 very detailed image descriptions for this story. 
  Return their description as json array with story sentences matched to images. 
  Story sentences must be in the same order as in the story and their content must be preserved.
  Each image must match 1-2 sentence from the story.
  Images must show story content in a way that is visually appealing and engaging, not just characters.
  Give output in json format:

  [
    {
      "text": "....",
      "imageDescription": "..."
    }
  ]

  <story>
  ${storyText}
  </story>`;

  return prompt;
};

const saveBase64ToMp3 = (data: string, path: string) => {
  const buffer = Buffer.from(data, "base64");
  fs.writeFileSync(path, buffer as Uint8Array);
};

export const generateDashScopeVoice = async (
  text: string,
  path: string,
): Promise<CharacterAlignmentResponseModel> => {
  return new Promise((resolve, reject) => {
    const wsUrl = "wss://dashscope.aliyuncs.com/api-ws/v1/inference";
    const ws = new WebSocket(wsUrl, {
      headers: {
        Authorization: `Bearer ${dashscopeApiKey}`,
      },
    });

    const audioChunks: Buffer[] = [];
    const taskId = `tts-${Date.now()}-${Math.random().toString(36).substring(7)}`;
    let taskStarted = false;

    ws.on("open", () => {
      const message = {
        header: {
          action: "run-task",
          task_id: taskId,
          streaming: "duplex",
        },
        payload: {
          task_group: "audio",
          task: "tts",
          function: "SpeechSynthesizer",
          model: "cosyvoice-v1",
          input: {
            text: text,
          },
          parameters: {
            voice: "longxiaochun",
            format: "mp3",
            sample_rate: 22050,
          },
        },
      };
      ws.send(JSON.stringify(message));
    });

    ws.on("message", (data: Buffer, isBinary: boolean) => {
      try {
        if (isBinary) {
          audioChunks.push(data);
          return;
        }

        const response = JSON.parse(data.toString());
        const event = response.header?.event;
        
        if (event === "task-started") {
          taskStarted = true;
          const finishMessage = {
            header: {
              action: "finish-task",
              task_id: taskId,
              streaming: "duplex",
            },
            payload: {
              input: {},
            },
          };
          ws.send(JSON.stringify(finishMessage));
        }
        
        if (event === "task-finished") {
          const finalBuffer = Buffer.concat(audioChunks);
          if (finalBuffer.length > 0) {
            fs.writeFileSync(path, finalBuffer);
          }

          const textLength = text.length;
          const estimatedDuration = textLength * 0.15;
          const characters = text.split("");
          const charDuration = estimatedDuration / characters.length;

          const characterStartTimesSeconds = characters.map((_, i) => i * charDuration);
          const characterEndTimesSeconds = characters.map((_, i) => (i + 1) * charDuration);

          ws.close();
          resolve({
            characters,
            characterStartTimesSeconds,
            characterEndTimesSeconds,
          });
        }

        if (event === "task-failed") {
          ws.close();
          reject(new Error(`TTS failed: ${response.header?.error_message || JSON.stringify(response)}`));
        }
      } catch (e) {
        ws.close();
        reject(e);
      }
    });

    ws.on("error", (err) => {
      reject(err);
    });
  });
};
