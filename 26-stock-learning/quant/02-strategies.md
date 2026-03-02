# 量化策略实战

## 趋势跟踪策略

### 1. 移动平均线策略

```python
import pandas as pd
import numpy as np

def moving_average_strategy(prices, short_period=5, long_period=20):
    """
    双均线策略:
    - 金叉买入: 短期均线从下往上穿过长期均线
    - 死叉卖出: 短期均线从上往下穿过长期均线
    """
    signals = pd.DataFrame(index=prices.index)
    signals['price'] = prices
    signals['ma_short'] = prices.rolling(short_period).mean()
    signals['ma_long'] = prices.rolling(long_period).mean()
    
    # 买入信号
    signals['buy'] = (signals['ma_short'] > signals['ma_long']) & \
                     (signals['ma_short'].shift(1) <= signals['ma_long'].shift(1))
    
    # 卖出信号
    signals['sell'] = (signals['ma_short'] < signals['ma_long']) & \
                      (signals['ma_short'].shift(1) >= signals['ma_long'].shift(1))
    
    return signals


def backtest(signals, initial_capital=100000):
    """
    回测函数
    """
    capital = initial_capital
    position = 0  # 持仓数量
    trades = []
    
    for i, row in signals.iterrows():
        if row['buy'] and position == 0:
            # 买入
            position = capital / row['price']
            capital = 0
            trades.append(('buy', i, row['price']))
        
        elif row['sell'] and position > 0:
            # 卖出
            capital = position * row['price']
            position = 0
            trades.append(('sell', i, row['price']))
    
    # 计算收益
    final_value = capital + position * signals.iloc[-1]['price']
    returns = (final_value - initial_capital) / initial_capital
    
    return {
        'final_value': final_value,
        'returns': returns,
        'trades': trades
    }
```

---

## 均值回归策略

### 2. RSI 策略

```python
def rsi_strategy(prices, period=14, oversold=30, overbought=70):
    """
    RSI 策略:
    - RSI < 30 超卖，买入
    - RSI > 70 超买，卖出
    """
    # 计算 RSI
    delta = prices.diff()
    gain = delta.where(delta > 0, 0)
    loss = -delta.where(delta < 0, 0)
    
    avg_gain = gain.rolling(period).mean()
    avg_loss = loss.rolling(period).mean()
    
    rs = avg_gain / avg_loss
    rsi = 100 - (100 / (1 + rs))
    
    signals = pd.DataFrame(index=prices.index)
    signals['price'] = prices
    signals['rsi'] = rsi
    
    signals['buy'] = rsi < oversold
    signals['sell'] = rsi > overbought
    
    return signals
```

---

## 动量策略

### 3. 动量突破策略

```python
def momentum_strategy(prices, lookback=20, threshold=0.05):
    """
    动量策略:
    - 价格突破过去 N 天最高点买入
    - 价格跌破过去 N 天最低点卖出
    """
    signals = pd.DataFrame(index=prices.index)
    signals['price'] = prices
    
    # 最高点/最低点
    signals['highest'] = prices.rolling(lookback).max()
    signals['lowest'] = prices.rolling(lookback).min()
    
    # 突破信号
    signals['buy'] = prices > signals['highest'].shift(1) * (1 + threshold)
    signals['sell'] = prices < signals['lowest'].shift(1) * (1 - threshold)
    
    return signals
```

---

## 配对交易

### 4. 协整策略

```python
def pairs_trading_strategy(price1, price2, lookback=60):
    """
    配对交易策略:
    - 两只股票存在协整关系
    - 当价差偏离均值时套利
    """
    # 计算价差
    spread = price1 - price2
    
    # 计算 z-score
    spread_mean = spread.rolling(lookback).mean()
    spread_std = spread.rolling(lookback).std()
    z_score = (spread - spread_mean) / spread_std
    
    signals = pd.DataFrame(index=price1.index)
    signals['price1'] = price1
    signals['price2'] = price2
    signals['spread'] = spread
    signals['z_score'] = z_score
    
    # 买入价差（做多 price1，做空 price2）
    signals['buy_spread'] = z_score < -2
    
    # 卖出价差（做空 price1，做多 price2）
    signals['sell_spread'] = z_score > 2
    
    # 平仓
    signals['close'] = abs(z_score) < 0.5
    
    return signals
```

---

## 因子策略

### 5. 多因子模型

```python
def multi_factor_strategy(factors_df, weights=None):
    """
    多因子策略:
    - 多个因子加权打分
    - 选取分数最高的股票
    """
    if weights is None:
        # 等权重
        weights = {factor: 1/len(factors_df.columns) for factor in factors_df.columns}
    
    # 因子标准化
    normalized = (factors_df - factors_df.mean()) / factors_df.std()
    
    # 加权得分
    scores = pd.Series(0, index=factors_df.index)
    for factor, weight in weights.items():
        scores += normalized[factor] * weight
    
    # 排序
    ranked = scores.rank(ascending=False)
    
    return ranked


def backtest_factors(factors, prices, top_n=10, rebalance_days=20):
    """
    因子策略回测
    """
    portfolio_value = [100000]
    holdings = []
    
    for i in range(0, len(factors), rebalance_days):
        # 获取当前日期的因子
        current_factors = factors.iloc[i]
        
        # 选取 top N
        top_stocks = current_factors.nlargest(top_n).index
        
        # 调仓
        current_prices = prices.iloc[i]
        # ... 实现调仓逻辑
        
        holdings = top_stocks
    
    return portfolio_value
```

---

## 风险管理

### 6. 止损与仓位管理

```python
class RiskManager:
    def __init__(self, max_position=0.1, max_loss=0.02):
        self.max_position = max_position  # 最大仓位 10%
        self.max_loss = max_loss  # 最大单笔亏损 2%
    
    def calculate_position_size(self, price, stop_loss_pct):
        """
        根据止损线计算仓位
        """
        # 仓位 = 账户金额 * 最大亏损% / 止损幅度
        position = self.account_value * self.max_loss / stop_loss_pct
        return position / price
    
    def check_stop_loss(self, entry_price, current_price):
        """
        检查是否触发止损
        """
        loss_pct = (current_price - entry_price) / entry_price
        
        if loss_pct < -self.max_loss:
            return True, 'stop_loss'
        
        return False, None
    
    def calculate_kelly_criterion(win_rate, avg_win, avg_loss):
        """
        Kelly 公式计算最优仓位
        """
        if avg_loss == 0:
            return 0
        
        win_loss_ratio = avg_win / avg_loss
        kelly = (win_rate * win_loss_ratio - (1 - win_rate)) / win_loss_ratio
        
        return max(0, min(kelly, 0.25))  # 限制最大25%
```

---

## 让我变强的量化技能

1. **策略开发** - 趋势、均值回归、动量、配对
2. **因子挖掘** - 多因子模型、机器学习因子
3. **回测系统** - 数据处理、信号生成、回测框架
4. **风险管理** - 仓位、止损、VaR
5. **实盘交易** - API 对接、滑点控制

---
