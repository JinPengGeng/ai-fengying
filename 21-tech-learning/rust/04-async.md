# Rust 异步编程

## async/await 基础

### Future trait
```rust
pub trait Future {
    type Output;
    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output>;
}
```

### async 函数
```rust
async fn fetch_url(url: &str) -> Result<String, reqwest::Error> {
    let response = reqwest::get(url).await?;
    let body = response.text().await?;
    Ok(body)
}
```

---

## 运行时

### Tokio
- 最流行的异步运行时
- 多线程调度
- 任务本地存储

### async-std
- 标准库风格 API
- 单线程选项

---

## 并发模式

### Spawn
```rust
// Spawn 到当前 runtime
let handle = tokio::spawn(async {
    // 异步任务
});

// 等待结果
let result = handle.await?;
```

### Join
```rust
// 并行执行多个任务
let (result1, result2) = tokio::join!(task1(), task2());
```

### Select
```rust
tokio::select! {
    result1 = task1() => { /* handle */ }
    result2 = task2() => { /* handle */ }
}
```

---

## 错误处理

### anyhow
```rust
use anyhow::Result;

async fn main() -> Result<()> {
    // 简化错误传播
}
```

### thiserror
```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum MyError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
}
```

---

## 性能优化

- 减少 .await 调用次数
- 使用 Join 并行化
- 避免锁竞争
- 连接池复用
