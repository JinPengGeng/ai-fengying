# Rust Web 开发

## Actix-web 入门

### 1. 基本示例

```rust
use actix_web::{web, App, HttpServer, Responder};

async fn hello() -> impl Responder {
    "Hello, World!"
}

async fn greet(web::Path(name): web::Path<String>) -> impl Responder {
    format!("Hello, {}!", name)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(hello))
            .route("/hello/{name}", web::get().to(greet))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
```

### 2. 处理 JSON

```rust
use actix_web::{web, App, HttpServer, Result};
use serde::{Deserialize, Serialize};

#[derive(Deserialize)]
struct UserRequest {
    name: String,
    email: String,
}

#[derive(Serialize)]
struct UserResponse {
    id: u64,
    name: String,
    email: String,
}

async fn create_user(
    item: web::Json<UserRequest>
) -> Result<UserResponse> {
    Ok(UserResponse {
        id: 1,
        name: item.name.clone(),
        email: item.email.clone(),
    })
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/users", web::post().to(create_user))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
```

---

## 数据库集成

### 3. SQLx 使用

```rust
use sqlx::{PgPool, Row};

#[derive(Debug)]
struct User {
    id: i64,
    name: String,
    email: String,
}

async fn get_users(pool: &PgPool) -> Result<Vec<User>, sqlx::Error> {
    let rows = sqlx::query("SELECT id, name, email FROM users")
        .fetch_all(pool)
        .await?;
    
    let users: Vec<User> = rows
        .iter()
        .map(|row| User {
            id: row.get("id"),
            name: row.get("name"),
            email: row.get("email"),
        })
        .collect();
    
    Ok(users)
}

async fn create_user(
    pool: &PgPool,
    name: String,
    email: String
) -> Result<i64, sqlx::Error> {
    let result = sqlx::query(
        "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING id"
    )
    .bind(&name)
    .bind(&email)
    .fetch_one(pool)
    .await?;
    
    Ok(result.get("id"))
}
```

---

## 异步编程

### 4. Tokio 运行时

```rust
use tokio::time::{sleep, Duration};

#[tokio::main]
async fn main() {
    // 并发任务
    let handle1 = tokio::spawn(async {
        task_one().await
    });
    
    let handle2 = tokio::spawn(async {
        task_two().await
    });
    
    // 等待所有任务完成
    let results = tokio::join!(handle1, handle2);
    
    println!("Results: {:?}", results);
}

async fn task_one() -> String {
    sleep(Duration::from_secs(1)).await;
    "Task 1 done".to_string()
}

async fn task_two() -> String {
    sleep(Duration::from_millis(500)).await;
    "Task 2 done".to_string()
}
```

### 5. 通道

```rust
use tokio::sync::mpsc;

#[tokio::main]
async fn main() {
    let (tx, mut rx) = mpsc::channel(100);
    
    // 发送消息
    tokio::spawn(async move {
        for i in 0..10 {
            if tx.send(i).await.is_err() {
                break;
            }
        }
    });
    
    // 接收消息
    while let Some(msg) = rx.recv().await {
        println!("Received: {}", msg);
    }
}
```

---

## 错误处理

### 6. Result 与 ?

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_file(path: &str) -> Result<String, io::Error> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// 使用 ?
async fn handler() -> Result<String, MyError> {
    let content = read_file("config.toml")
        .map_err(|e| MyError::IoError(e))?;
    
    Ok(content)
}

#[derive(Debug)]
enum MyError {
    IoError(std::io::Error),
    ParseError(String),
}

impl From<std::io::Error> for MyError {
    fn from(err: std::io::Error) -> Self {
        MyError::IoError(err)
    }
}
```

---

## 中间件

### 7.  Logging 中间件

```rust
use actix_web::{dev::ServiceRequest, Error, HttpMessage};
use actix_web::middleware::Logger;

async fn log_request(req: ServiceRequest, _app: &App) -> Result<ServiceRequest, Error> {
    println!("{} {} {}", 
        req.method(),
        req.path(),
        req.version()
    );
    Ok(req)
}
```

---

## 让我变强的 Rust Web 技能

1. **Actix-web** - 高性能 Web 框架
2. **SQLx** - 异步数据库
3. **Tokio** - 异步运行时
4. **中间件** - 日志、认证
5. **部署** - Docker、二进制

---
