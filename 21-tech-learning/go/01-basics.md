# Go 语言进阶

## 并发

### 1. Goroutine

```go
func main() {
    // 启动 goroutine
    go sayHello("World")
    go sayHello("Go")
    
    time.Sleep(time.Second)
}

func sayHello(name string) {
    fmt.Printf("Hello, %s!\n", name)
}
```

### 2. Channel

```go
func main() {
    ch := make(chan string)
    
    go func() {
        ch <- "message"
    }()
    
    msg := <-ch
    fmt.Println(msg)
}

// 带缓冲的 Channel
ch := make(chan int, 10)
```

### 3. Select

```go
func main() {
    ch1 := make(chan string)
    ch2 := make(chan string)
    
    go func() {
        time.Sleep(1 * time.Second)
        ch1 <- "one"
    }()
    
    go func() {
        time.Sleep(2 * time.Second)
        ch2 <- "two"
    }()
    
    for i := 0; i < 2; i++ {
        select {
        case msg1 := <-ch1:
            fmt.Println(msg1)
        case msg2 := <-ch2:
            fmt.Println(msg2)
        }
    }
}
```

---

## 错误处理

### 4. Error 接口

```go
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("Result:", result)
}
```

---

## 接口

### 5. 接口定义

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// 接口组合
type ReadWriter interface {
    Reader
    Writer
}
```

---

## 让我变强的 Go 技能

1. **并发** - Goroutine, Channel
2. **Select** - 多通道
3. **Error** - 错误处理
4. **接口** - 多态
5. **Go Routine** - 轻量级线程

---
