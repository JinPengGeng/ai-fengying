# Rust 基础速查

## 什么是 Rust？

**Rust** = 系统级编程语言
- 内存安全（无 GC）
- 高性能
- 所有权系统

---

## 基础语法

### 变量与可变性
```rust
// 不可变
let x = 5;

// 可变
let mut y = 5;
y = 6;

// 常量
const MAX: i32 = 100;
```

### 数据类型
```rust
// 标量
let int: i32 = 42;
let float: f64 = 3.14;
let bool: bool = true;
let char: char = 'A';

// 复合
let tuple: (i32, f64) = (500, 6.4);
let array: [i32; 3] = [1, 2, 3];
```

### 函数
```rust
fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

// 闭包
let add = |a, b| a + b;
```

---

## 核心特性

### 1. 所有权 (Ownership)
```rust
let s1 = String::from("hello");
let s2 = s1; // s1 移动到 s2
// println!("{}", s1); // 错误！s1 已失效
```

### 2. 借用 (Borrowing)
```rust
fn calculate(s: &String) -> usize {
    s.len()
}

let s1 = String::from("hello");
let len = calculate(&s1); // 借用
println!("{}", s1); // OK
```

### 3. 生命周期
```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

---

## 常用集合

### Vec (动态数组)
```rust
let mut v = Vec::new();
v.push(1);
v.push(2);

let v = vec![1, 2, 3];
let third = v[2];
```

### HashMap
```rust
use std::collections::HashMap;

let mut scores = HashMap::new();
scores.insert("Blue", 10);
scores.insert("Yellow", 50);
```

---

## 错误处理

### Option
```rust
fn find_user(id: u32) -> Option<String> {
    if id == 1 { Some("Alice".to_string()) }
    else { None }
}

match find_user(1) {
    Some(name) => println!("{}", name),
    None => println!("User not found"),
}
```

### Result
```rust
use std::fs::File;

let f = File::open("file.txt");

match f {
    Ok(file) => println!("File opened"),
    Err(e) => println!("Error: {}", e),
}
```

---

## 面向对象

### 结构体
```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}
```

### 枚举
```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}
```

---

## 并发

### 线程
```rust
use std::thread;

let handle = thread::spawn(|| {
    println!("Hello from thread");
});

handle.join().unwrap();
```

### 通道
```rust
use std::sync::mpsc;

let (tx, rx) = mpsc::channel();
tx.send("Hello").unwrap();
println!("{}", rx.recv().unwrap());
```

---

## 让我变强的 Rust 技能

1. **内存管理**: 理解所有权、借用、生命周期
2. **并发**: 线程、通道、Mutex
3. **系统编程**: 文件、网络、系统调用
4. **WebAssembly**: 浏览器端 Rust
5. **Rust Web**: Actix、Axum、Rocket

---
