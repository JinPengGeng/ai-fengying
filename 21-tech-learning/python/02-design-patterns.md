# Python 进阶设计模式

## 创建型模式

### 1. 单例模式 (Singleton)

```python
class Singleton:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

# 线程安全版本
import threading

class ThreadSafeSingleton:
    _instance = None
    _lock = threading.Lock()
    
    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
        return cls._instance
```

### 2. 工厂模式 (Factory)

```python
class Animal:
    def speak(self):
        raise NotImplementedError

class Dog(Animal):
    def speak(self):
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"

class AnimalFactory:
    @staticmethod
    def create_animal(animal_type):
        animals = {
            "dog": Dog,
            "cat": Cat
        }
        animal_class = animals.get(animal_type.lower())
        if animal_class:
            return animal_class()
        raise ValueError(f"Unknown animal: {animal_type}")

# 使用
factory = AnimalFactory()
dog = factory.create_animal("dog")
```

### 3. 建造者模式 (Builder)

```python
class Pizza:
    def __init__(self):
        self.size = None
        self.crust = None
        self.toppings = []
    
    def __str__(self):
        return f"Pizza(size={self.size}, crust={self.crust}, toppings={self.toppings})"

class PizzaBuilder:
    def __init__(self):
        self.pizza = Pizza()
    
    def set_size(self, size):
        self.pizza.size = size
        return self
    
    def set_crust(self, crust):
        self.pizza.crust = crust
        return self
    
    def add_topping(self, topping):
        self.pizza.toppings.append(topping)
        return self
    
    def build(self):
        return self.pizza

# 使用
pizza = (PizzaBuilder()
    .set_size("large")
    .set_crust("thin")
    .add_topping("cheese")
    .add_topping("pepperoni")
    .build())
```

---

## 结构型模式

### 4. 装饰器模式 (Decorator)

```python
def log_calls(func):
    def wrapper(*args, **kwargs):
        print(f"调用 {func.__name__}")
        result = func(*args, **kwargs)
        print(f"{func.__name__} 返回: {result}")
        return result
    return wrapper

@log_calls
def add(a, b):
    return a + b

# 等价于: add = log_calls(add)

# 装饰器带参数
def retry(max_attempts=3, delay=1):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    print(f"重试 {attempt + 1}/{max_attempts}")
        return wrapper
    return decorator

@retry(max_attempts=5)
def risky_operation():
    pass
```

### 5. 代理模式 (Proxy)

```python
class RealSubject:
    def request(self):
        return "真实请求"

class ProxySubject:
    def __init__(self):
        self.real_subject = None
    
    def request(self):
        # 访问控制
        if self.check_access():
            # 懒加载
            if self.real_subject is None:
                self.real_subject = RealSubject()
            result = self.real_subject.request()
            self.log_access()
            return result
        return "拒绝访问"
    
    def check_access(self):
        return True
    
    def log_access(self):
        print("记录访问")
```

---

## 行为型模式

### 6. 观察者模式 (Observer)

```python
class Subject:
    def __init__(self):
        self.observers = []
    
    def attach(self, observer):
        self.observers.append(observer)
    
    def detach(self, observer):
        self.observers.remove(observer)
    
    def notify(self):
        for observer in self.observers:
            observer.update(self)

class Observer:
    def update(self, subject):
        pass

class ConcreteObserver(Observer):
    def __init__(self, name):
        self.name = name
    
    def update(self, subject):
        print(f"{self.name} 收到通知")

# 使用
subject = Subject()
observer1 = ConcreteObserver("观察者1")
observer2 = ConcreteObserver("观察者2")

subject.attach(observer1)
subject.attach(observer2)
subject.notify()
```

### 7. 策略模式 (Strategy)

```python
class PaymentStrategy:
    def pay(self, amount):
        raise NotImplementedError

class CreditCardPayment(PaymentStrategy):
    def __init__(self, card_number):
        self.card_number = card_number
    
    def pay(self, amount):
        print(f"信用卡支付: {amount}")

class AlipayPayment(PaymentStrategy):
    def pay(self, amount):
        print(f"支付宝支付: {amount}")

class ShoppingCart:
    def __init__(self):
        self.items = []
        self.payment_strategy = None
    
    def add_item(self, item):
        self.items.append(item)
    
    def set_payment(self, strategy: PaymentStrategy):
        self.payment_strategy = strategy
    
    def checkout(self):
        total = sum(item["price"] for item in self.items)
        if self.payment_strategy:
            self.payment_strategy.pay(total)
        else:
            print("请选择支付方式")

# 使用
cart = ShoppingCart()
cart.add_item({"name": "商品1", "price": 100})
cart.set_payment(CreditCardPayment("1234-5678"))
cart.checkout()
```

---

## 让我变强的设计模式应用

1. **代码重构** - 识别代码 smell，应用合适模式
2. **框架设计** - 构建可扩展系统
3. **团队协作** - 统一代码风格
4. **面试准备** - 经典模式必知

---
