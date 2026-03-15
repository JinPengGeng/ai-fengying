#!/usr/bin/env node

import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import prompts from "prompts";
import ora from "ora";
import chalk from "chalk";
import * as dotenv from "dotenv";
import {
  generateWanxImage,
  generateDashScopeVoice,
  getGenerateImageDescriptionPrompt,
  getGenerateStoryPrompt,
  dashscopeStructuredCompletion,
  setDashScopeApiKey,
} from "./dashscope-service";
import {
  ContentItemWithDetails,
  StoryMetadataWithDetails,
  StoryScript,
  StoryWithImages,
  Timeline,
} from "../src/lib/types";
import { v4 as uuidv4 } from "uuid";
import * as fs from "fs";
import * as path from "path";
import { createTimeLineFromStoryWithDetails } from "./timeline";

dotenv.config({ quiet: true });

interface GenerateOptions {
  apiKey?: string;
  title?: string;
  topic?: string;
}

class ContentFS {
  title: string;
  slug: string;

  constructor(title: string) {
    this.title = title;
    this.slug = this.getSlug();
  }

  saveDescriptor(descriptor: StoryMetadataWithDetails) {
    const dirPath = this.getDir();
    const filePath = path.join(dirPath, "descriptor.json");
    fs.writeFileSync(filePath, JSON.stringify(descriptor, null, 2));
  }

  saveTimeline(timeline: Timeline) {
    const dirPath = this.getDir();
    const filePath = path.join(dirPath, "timeline.json");
    fs.writeFileSync(filePath, JSON.stringify(timeline, null, 2));
  }

  getDir(dir?: string): string {
    const segments = ["public", "content", this.slug];
    if (dir) {
      segments.push(dir);
    }
    const p = path.join(process.cwd(), ...segments);
    fs.mkdirSync(p, { recursive: true });
    return p;
  }

  getImagePath(uid: string): string {
    const dirPath = this.getDir("images");
    return path.join(dirPath, `${uid}.png`);
  }

  getAudioPath(uid: string): string {
    const dirPath = this.getDir("audio");
    return path.join(dirPath, `${uid}.mp3`);
  }

  getSlug(): string {
    return this.title
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "");
  }
}

async function generateStory(options: GenerateOptions) {
  try {
    let apiKey =
      options.apiKey || process.env.DASHSCOPE_API_KEY;

    if (!apiKey) {
      const response = await prompts({
        type: "password",
        name: "apiKey",
        message: "请输入你的阿里百炼 API Key:",
        validate: (value) => value.length > 0 || "API Key 是必需的",
      });

      if (!response.apiKey) {
        console.log(chalk.red("API Key 是必需的，正在退出..."));
        process.exit(1);
      }

      apiKey = response.apiKey;
    }

    let { title, topic } = options;

    if (!title || !topic) {
      const response = await prompts([
        {
          type: "text",
          name: "title",
          message: "视频标题:",
          initial: title,
          validate: (value) => value.length > 0 || "标题是必需的",
        },
        {
          type: "text",
          name: "topic",
          message: "视频主题:",
          initial: topic,
          validate: (value) => value.length > 0 || "主题是必需的",
        },
      ]);

      if (!response.title || !response.topic) {
        console.log(chalk.red("标题和主题是必需的，正在退出..."));
        process.exit(1);
      }

      title = response.title;
      topic = response.topic;
    }

    console.log(chalk.blue(`\n📖 正在创建视频: "${title}"`));
    console.log(chalk.blue(`📝 主题: ${topic}\n`));

    const storyWithDetails: StoryMetadataWithDetails = {
      shortTitle: title!,
      content: [],
    };

    const storySpinner = ora("正在生成故事脚本...").start();
    setDashScopeApiKey(apiKey!);
    const storyRes = await dashscopeStructuredCompletion(
      getGenerateStoryPrompt(title!, topic!),
      StoryScript,
    );
    storySpinner.succeed(chalk.green("故事脚本生成完成!"));

    const descriptionsSpinner = ora("正在生成图片描述...").start();
    const storyWithImagesRes = await dashscopeStructuredCompletion(
      getGenerateImageDescriptionPrompt(storyRes.text),
      StoryWithImages,
    );
    descriptionsSpinner.succeed(chalk.green("图片描述生成完成!"));

    for (const item of storyWithImagesRes.result) {
      const contentWithDetails: ContentItemWithDetails = {
        text: item.text,
        imageDescription: item.imageDescription,
        uid: uuidv4(),
        audioTimestamps: {
          characters: [],
          characterStartTimesSeconds: [],
          characterEndTimesSeconds: [],
        },
      };

      storyWithDetails.content.push(contentWithDetails);
    }

    const contentFs = new ContentFS(title!);
    contentFs.saveDescriptor(storyWithDetails);

    const imagesSpinner = ora("正在生成图片和配音...").start();
    for (let i = 0; i < storyWithDetails.content.length; i++) {
      const storyItem = storyWithDetails.content[i];
      imagesSpinner.text = `[${i * 2 + 1}/${storyWithDetails.content.length * 2}] 正在生成图片: ${storyItem.text.substring(0, 30)}...`;
      await generateWanxImage({
        prompt: storyItem.imageDescription,
        path: contentFs.getImagePath(storyItem.uid),
        onRetry: (attempt) => {
          imagesSpinner.text = `[${i * 2 + 1}/${storyWithDetails.content.length * 2}] 正在重试生成图片 (${attempt + 1})...`;
        },
      });
      imagesSpinner.text = `[${i * 2 + 2}/${storyWithDetails.content.length * 2}] 正在生成配音: ${storyItem.text.substring(0, 30)}...`;
      const timings = await generateDashScopeVoice(
        storyItem.text,
        contentFs.getAudioPath(storyItem.uid),
      );
      storyItem.audioTimestamps = timings;
    }
    contentFs.saveDescriptor(storyWithDetails);
    imagesSpinner.succeed(chalk.green("图片和配音生成完成!"));

    const finalSpinner = ora("正在生成最终结果...").start();
    const timeline = createTimeLineFromStoryWithDetails(storyWithDetails);
    contentFs.saveTimeline(timeline);
    finalSpinner.succeed(chalk.green("最终结果生成完成!"));

    console.log(chalk.green.bold("\n✨ 视频生成完成!\n"));
    console.log("运行 " + chalk.blue("npm run dev") + " 预览视频");

    return {};
  } catch (error) {
    console.error(chalk.red("\n❌ 错误:"), error);
    process.exit(1);
  }
}

yargs(hideBin(process.argv))
  .command(
    "generate",
    "使用阿里百炼生成视频",
    (yargs) => {
      return yargs
        .option("api-key", {
          alias: "k",
          type: "string",
          description: "阿里百炼 API Key",
        })
        .option("title", {
          alias: "t",
          type: "string",
          description: "视频标题",
        })
        .option("topic", {
          alias: "p",
          type: "string",
          description: "视频主题",
        });
    },
    async (argv) => {
      await generateStory({
        apiKey: argv["api-key"],
        title: argv.title,
        topic: argv.topic,
      });
    },
  )
  .command(
    "$0",
    "生成视频 (默认命令)",
    (yargs) => {
      return yargs
        .option("api-key", {
          alias: "k",
          type: "string",
          description: "阿里百炼 API Key",
        })
        .option("title", {
          alias: "t",
          type: "string",
          description: "视频标题",
        })
        .option("topic", {
          alias: "p",
          type: "string",
          description: "视频主题",
        });
    },
    async (argv) => {
      await generateStory({
        apiKey: argv["api-key"],
        title: argv.title,
        topic: argv.topic,
      });
    },
  )
  .demandCommand(0, 1)
  .help()
  .alias("help", "h")
  .version()
  .alias("version", "v")
  .strict()
  .parse();
