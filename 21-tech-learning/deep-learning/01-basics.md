# 深度学习基础

## 神经网络基础

### 1. 神经元模型

```
输入 → 权重 → 求和 → 激活函数 → 输出
```

```python
import numpy as np

class Neuron:
    def __init__(self, n_inputs):
        # 初始化权重
        self.weights = np.random.randn(n_inputs)
        self.bias = 0
    
    def forward(self, inputs):
        """前向传播"""
        # 加权求和
        z = np.dot(inputs, self.weights) + self.bias
        # 激活函数
        return self.activation(z)
    
    def activation(self, z):
        """激活函数"""
        return 1 / (1 + np.exp(-z))  # Sigmoid
```

### 2. 激活函数

| 函数 | 公式 | 特点 |
|------|------|------|
| **Sigmoid** | 1/(1+e^-x) | 输出0-1，用于概率 |
| **Tanh** | (e^x-e^-x)/(e^x+e^-x) | 输出-1到1，零中心 |
| **ReLU** | max(0, x) | 简单有效，缓解梯度消失 |
| **Leaky ReLU** | max(0.01x, x) | 解决ReLU死亡问题 |
| **Softmax** | e^x/Σe^x | 多分类输出 |

```python
def sigmoid(z):
    return 1 / (1 + np.exp(-z))

def relu(z):
    return np.maximum(0, z)

def softmax(z):
    exp_z = np.exp(z - np.max(z))  # 数值稳定
    return exp_z / np.sum(exp_z)
```

---

## 神经网络结构

### 3. 全连接层 (Dense)

```python
class Dense:
    def __init__(self, n_inputs, n_neurons):
        self.weights = 0.01 * np.random.randn(n_inputs, n_neurons)
        self.biases = np.zeros((1, n_neurons))
    
    def forward(self, inputs):
        self.inputs = inputs
        self.output = np.dot(inputs, self.weights) + self.biases
        return self.output
```

### 4. 多层神经网络

```python
class NeuralNetwork:
    def __init__(self, layer_sizes):
        self.layers = []
        for i in range(len(layer_sizes) - 1):
            layer = Dense(layer_sizes[i], layer_sizes[i+1])
            self.layers.append(layer)
    
    def forward(self, X):
        for layer in self.layers:
            X = layer.forward(X)
            X = relu(X)  # ReLU 激活
        return X
    
    def predict(self, X):
        output = self.forward(X)
        return np.argmax(output, axis=1)
```

---

## 反向传播

### 5. 反向传播算法

```python
class NeuralNetwork:
    def __init__(self, layer_sizes):
        self.weights = []
        self.biases = []
        for i in range(len(layer_sizes) - 1):
            self.weights.append(0.01 * np.random.randn(layer_sizes[i], layer_sizes[i+1]))
            self.biases.append(np.zeros((1, layer_sizes[i+1])))
    
    def forward(self, X):
        self.activations = [X]
        for i in range(len(self.weights)):
            z = np.dot(self.activations[-1], self.weights[i]) + self.biases[i]
            a = relu(z)
            self.activations.append(a)
        return self.activations[-1]
    
    def backward(self, X, y, learning_rate):
        m = X.shape[0]
        # 输出层梯度
        delta = self.activations[-1] - y
        
        # 反向传播
        for i in range(len(self.weights) - 1, -1, -1):
            dw = np.dot(self.activations[i].T, delta) / m
            db = np.sum(delta, axis=0, keepdims=True) / m
            
            self.weights[i] -= learning_rate * dw
            self.biases[i] -= learning_rate * db
            
            if i > 0:
                delta = np.dot(delta, self.weights[i].T)
                delta *= (self.activations[i] > 0)  # ReLU 梯度
    
    def train(self, X, y, epochs, learning_rate):
        for epoch in range(epochs):
            output = self.forward(X)
            self.backward(X, y, learning_rate)
            if epoch % 100 == 0:
                loss = np.mean((output - y) ** 2)
                print(f"Epoch {epoch}, Loss: {loss}")
```

---

## 卷积神经网络 (CNN)

### 6. 卷积层

```python
class Conv2D:
    def __init__(self, n_filters, kernel_size):
        self.n_filters = n_filters
        self.kernel_size = kernel_size
        self.weights = np.random.randn(n_filters, kernel_size, kernel_size)
        self.bias = np.zeros(n_filters)
    
    def forward(self, inputs):
        # 简化版 - 实际需要 padding, stride
        h, w = inputs.shape
        output = np.zeros((h - self.kernel_size + 1, 
                         w - self.kernel_size + 1, 
                         self.n_filters))
        
        for f in range(self.n_filters):
            for i in range(h - self.kernel_size + 1):
                for j in range(w - self.kernel_size + 1):
                    patch = inputs[i:i+self.kernel_size, j:j+self.kernel_size]
                    output[i, j, f] = np.sum(patch * self.weights[f]) + self.bias[f]
        
        return output
```

---

## 循环神经网络 (RNN)

### 7. RNN 单元

```python
class RNNCell:
    def __init__(self, input_size, hidden_size):
        self.hidden_size = hidden_size
        # Xavier 初始化
        self.Wxh = np.random.randn(hidden_size, input_size) * np.sqrt(2.0 / input_size)
        self.Whh = np.random.randn(hidden_size, hidden_size) * np.sqrt(2.0 / hidden_size)
        self.bh = np.zeros((hidden_size, 1))
    
    def forward(self, x, h_prev):
        """单步前向"""
        self.x = x
        self.h_prev = h_prev
        
        # RNN 公式
        h = np.tanh(np.dot(self.Wxh, x) + np.dot(self.Whh, h_prev) + self.bh)
        
        self.h = h
        return h
    
    def backward(self, dh_next, learning_rate):
        """单步反向"""
        # 简化版
        dh = dh_next * (1 - self.h ** 2)  # tanh 梯度
        
        # 梯度裁剪
        np.clip(dh, -5, 5, out=dh)
        
        # 更新参数
        self.Wxh -= learning_rate * np.outer(dh, self.x)
        self.Whh -= learning_rate * np.outer(dh, self.h_prev)
        self.bh -= learning_rate * dh
        
        # 返回给上一层
        return np.dot(self.Whh.T, dh)
```

---

## 训练技巧

### 8. 优化器

```python
class SGD:
    def __init__(self, lr=0.01):
        self.lr = lr
    
    def update(self, params, grads):
        for key in params:
            params[key] -= self.lr * grads[key]

class Adam:
    def __init__(self, lr=0.001, beta1=0.9, beta2=0.999):
        self.lr = lr
        self.beta1 = beta1
        self.beta2 = beta2
        self.m = {}  # 一阶矩估计
        self.v = {}  # 二阶矩估计
        self.t = 0
    
    def update(self, params, grads):
        self.t += 1
        for key in params:
            if key not in self.m:
                self.m[key] = np.zeros_like(params[key])
                self.v[key] = np.zeros_like(params[key])
            
            self.m[key] = self.beta1 * self.m[key] + (1 - self.beta1) * grads[key]
            self.v[key] = self.beta2 * self.v[key] + (1 - self.beta2) * (grads[key] ** 2)
            
            m_hat = self.m[key] / (1 - self.beta1 ** self.t)
            v_hat = self.v[key] / (1 - self.beta2 ** self.t)
            
            params[key] -= self.lr * m_hat / (np.sqrt(v_hat) + 1e-8)
```

---
