# Rust 进阶编程

## 所有权系统深入

### 1. 生命周期标注

```rust
// 生命周期标注
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

// 结构体中的生命周期
struct ImportantExcerpt<'a> {
    part: &'a str,
}

impl<'a> ImportantExcerpt<'a> {
    fn announce_and_return(&self, announcement: &str) -> &str {
        println!("{}", announcement);
        self.part
    }
}
```

### 2. 智能指针

```rust
use std::rc::Rc;
use std::cell::RefCell;

// Rc - 引用计数
let data = Rc::new(vec![1, 2, 3]);
let clone1 = Rc::clone(&data);
let clone2 = Rc::clone(&data);

// RefCell - 内部可变性
let value = RefCell::new(5);
*value.borrow_mut() += 1;

// Rc + RefCell 组合
let data = Rc::new(RefCell::new(vec![1, 2, 3]));
data.borrow_mut().push(4);

// 线程安全: Arc + Mutex
use std::sync::{Arc, Mutex};
let data = Arc::new(Mutex::new(0));
let data1 = Arc::clone(&data);
let data2 = Arc::clone(&data);
```

---

## 并发编程

### 3. 线程与消息传递

```rust
use std::thread;
use std::sync::mpsc;

// 创建线程
let handle = thread::spawn(|| {
    for i in 1..10 {
        println!("子线程: {}", i);
    }
});

handle.join().unwrap();

// 消息传递
let (tx, rx) = mpsc::channel();

thread::spawn(move || {
    tx.send("Hello from thread".to_string()).unwrap();
});

let received = rx.recv().unwrap();
println!("收到: {}", received);
```

### 4. 并发原语

```rust
use std::sync::{Mutex, RwLock, Condvar, Barrier};
use std::time::Duration;

// Mutex - 互斥锁
let lock = Mutex::new(0);
{
    let mut num = lock.lock().unwrap();
    *num += 1;
} // 自动释放

// RwLock - 读写锁
let lock = RwLock::new(5);
{
    let r = lock.read().unwrap();
    println!("读取: {}", *r);
}
{
    let mut w = lock.write().unwrap();
    *w += 1;
}

// Barrier - 屏障
let barrier = Arc::new(Barrier::new(2));
let c1 = barrier.clone();
thread::spawn(move || {
    // 等待其他线程
    c1.wait();
});

// Condvar - 条件变量
let lock = Mutex::new(false);
let cvar = Condvar::new();
let mut started = lock.lock().unwrap();
while !*started {
    started = cvar.wait(started).unwrap().0;
}
```

---

## 异步编程

### 5. async/await

```rust
use async_std;

// async 函数
async fn fetch_url(url: &str) -> Result<String, reqwest::Error> {
    let response = reqwest::get(url).await?;
    let body = response.text().await?;
    Ok(body)
}

// 并发执行
use futures::join;

async fn fetch_all() {
    let future1 = fetch_url("https://example.com/1");
    let future2 = fetch_url("https://example.com/2");
    
    let (result1, result2) = join!(future1, future2);
    println!("结果: {:?}, {:?}", result1, result2);
}
```

### 6. Tokio 运行时

```rust
use tokio;

#[tokio::main]
async fn main() {
    // 并发任务
    let handle = tokio::spawn(async {
        process_item(1).await
    });
    
    // 超时
    match tokio::time::timeout(
        Duration::from_secs(5),
        do_something()
    ).await {
        Ok(result) => println!("完成: {:?}", result),
        Err(_) => println!("超时"),
    }
    
    handle.await.unwrap();
}

async fn do_something() -> &'static str {
    "完成"
}
```

---

## 错误处理

### 7. Result 与 ? 操作符

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_file(path: &str) -> Result<String, io::Error> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// 自定义错误类型
#[derive(Debug)]
enum MyError {
    IoError(io::Error),
    ParseError(std::num::ParseIntError),
    Custom(String),
}

impl From<io::Error> for MyError {
    fn from(err: io::Error) -> Self {
        MyError::IoError(err)
    }
}
```

---

## 宏与元编程

### 8. 声明宏

```rust
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}

// 使用
let v = vec![1, 2, 3, 4];
```

### 9. 过程宏

```rust
// derive 宏示例
#[derive(Debug, Clone, Copy, PartialEq)]
enum MyEnum {
    A,
    B,
}

// 属性宏
#[route(GET, "/")]
fn index() -> String {
    "Hello".to_string()
}
```

---

## 让我变强的 Rust 技能

1. **生命周期** - 深入理解 'a
2. **智能指针** - Rc、Arc、Box
3. **并发** - 线程、消息、锁
4. **异步** - async/await、Tokio
5. **宏** - 声明宏、过程宏
6. **unsafe** - 底层操作

---
