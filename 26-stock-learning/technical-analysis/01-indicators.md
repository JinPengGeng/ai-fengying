# 股票技术指标详解

## 趋势指标

### 1. 移动平均线 (MA)

```python
def calculate_ma(prices, period):
    """简单移动平均"""
    if len(prices) < period:
        return None
    return sum(prices[-period:]) / period

def calculate_ema(prices, period):
    """指数移动平均"""
    multiplier = 2 / (period + 1)
    ema = prices[0]
    for price in prices[1:]:
        ema = (price - ema) * multiplier + ema
    return ema

# 使用示例
prices = [100, 102, 101, 105, 107, 106, 108]
ma5 = calculate_ma(prices, 5)
ema5 = calculate_ema(prices, 5)
```

### 2. MACD

```python
def calculate_macd(prices, fast=12, slow=26, signal=9):
    """MACD 计算"""
    # 计算快速和慢速 EMA
    ema_fast = calculate_ema(prices, fast)
    ema_slow = calculate_ema(prices, slow)
    
    # DIF (MACD 线)
    dif = ema_fast - ema_slow
    
    # DEA (信号线)
    # 需要历史 DIF 来计算 DEA
    
    # MACD 柱
    macd = (dif - dea) * 2
    
    return {"dif": dif, "dea": dea, "macd": macd}

def macd_signal(prices):
    """MACD 交易信号"""
    macd_data = calculate_macd(prices)
    
    signals = []
    # 金叉买入
    if macd_data["dif"] > macd_data["dea"] and \
       macd_data["dif_prev"] <= macd_data["dea_prev"]:
        signals.append("buy")
    # 死叉卖出
    elif macd_data["dif"] < macd_data["dea"] and \
         macd_data["dif_prev"] >= macd_data["dea_prev"]:
        signals.append("sell")
    
    return signals
```

---

## 动量指标

### 3. RSI (相对强弱指标)

```python
def calculate_rsi(prices, period=14):
    """RSI 计算"""
    if len(prices) < period + 1:
        return None
    
    gains = []
    losses = []
    
    for i in range(1, len(prices)):
        change = prices[i] - prices[i-1]
        if change > 0:
            gains.append(change)
            losses.append(0)
        else:
            gains.append(0)
            losses.append(abs(change))
    
    # 计算平均涨幅和跌幅
    avg_gain = sum(gains[-period:]) / period
    avg_loss = sum(losses[-period:]) / period
    
    if avg_loss == 0:
        return 100
    
    rs = avg_gain / avg_loss
    rsi = 100 - (100 / (1 + rs))
    
    return rsi

def rsi_signal(rsi):
    """RSI 信号"""
    if rsi > 70:
        return "overbought"  # 超买，可能卖出
    elif rsi < 30:
        return "oversold"    # 超卖，可能买入
    return "neutral"
```

### 4. KDJ 随机指标

```python
def calculate_kdj(highs, lows, closes, period=9):
    """KDJ 指标计算"""
    # 计算 RSV
    recent_closes = closes[-period:]
    recent_highs = max(highs[-period:])
    recent_lows = min(lows[-period:])
    
    rsv = (closes[-1] - recent_lows) / (recent_highs - recent_lows) * 100
    
    # 计算 K、D、J
    # 需要历史值，这里简化处理
    k = rsv
    d = k  # 简化
    j = 3 * k - 2 * d
    
    return {"k": k, "d": d, "j": j}
```

---

## 成交量指标

### 5. OBV (能量潮)

```python
def calculate_obv(prices, volumes):
    """OBV 计算"""
    obv = 0
    obv_values = []
    
    for i in range(1, len(prices)):
        if prices[i] > prices[i-1]:
            obv += volumes[i]
        elif prices[i] < prices[i-1]:
            obv -= volumes[i]
        obv_values.append(obv)
    
    return obv_values

def obv_signal(prices, volumes):
    """OBV 信号"""
    obv = calculate_obv(prices, volumes)
    
    # OBV 与价格背离
    if prices[-1] > prices[-2] and obv[-1] < obv[-2]:
        return "bearish_divergence"  # 顶背离
    
    if prices[-1] < prices[-2] and obv[-1] > obv[-2]:
        return "bullish_divergence"  # 底背离
    
    return "neutral"
```

---

## 波动率指标

### 6. 布林带 (Bollinger Bands)

```python
def calculate_bollinger_bands(prices, period=20, std_dev=2):
    """布林带计算"""
    # 中轨
    middle = calculate_ma(prices, period)
    
    # 标准差
    recent_prices = prices[-period:]
    variance = sum((p - middle) ** 2 for p in recent_prices) / period
    std = variance ** 0.5
    
    # 上轨和下轨
    upper = middle + std_dev * std
    lower = middle - std_dev * std
    
    return {"upper": upper, "middle": middle, "lower": lower}

def bollinger_signal(prices):
    """布林带信号"""
    bb = calculate_bollinger_bands(prices)
    
    current_price = prices[-1]
    
    if current_price < bb["lower"]:
        return "oversold"  # 超卖，可能反弹
    elif current_price > bb["upper"]:
        return "overbought"  # 超买，可能回调
    
    return "neutral"
```

---

## 综合使用

### 多指标确认

```python
def combined_signal(prices, volumes, highs, lows):
    """综合多指标信号"""
    signals = []
    
    # RSI
    rsi = calculate_rsi(prices)
    signals.append(rsi_signal(rsi))
    
    # MACD
    macd_data = calculate_macd(prices)
    signals.append("buy" if macd_data["dif"] > macd_data["dea"] else "sell")
    
    # 布林带
    signals.append(bollinger_signal(prices))
    
    # 统计买入信号数量
    buy_count = signals.count("buy") + signals.count("oversold")
    sell_count = signals.count("sell") + signals.count("overbought")
    
    if buy_count > sell_count:
        return "buy"
    elif sell_count > buy_count:
        return "sell"
    
    return "hold"
```

---
