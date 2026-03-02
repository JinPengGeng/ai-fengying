# 量化策略回测系统

## 回测框架设计

### 1. 数据处理

```python
import pandas as pd
import numpy as np

class DataLoader:
    def __init__(self, data_source):
        self.data_source = data_source
    
    def load_csv(self, path, date_col='date'):
        """加载 CSV 数据"""
        df = pd.read_csv(path, parse_dates=[date_col])
        df = df.set_index(date_col)
        return df
    
    def load_ohlcv(self, symbol, start, end):
        """加载 OHLCV 数据"""
        # 模拟数据
        dates = pd.date_range(start, end, freq='D')
        n = len(dates)
        
        return pd.DataFrame({
            'open': np.random.uniform(100, 110, n),
            'high': np.random.uniform(110, 120, n),
            'low': np.random.uniform(90, 100, n),
            'close': np.random.uniform(100, 110, n),
            'volume': np.random.uniform(1e6, 1e7, n)
        }, index=dates)
    
    def resample(self, df, freq='1H'):
        """重采样"""
        ohlc = {
            'open': 'first',
            'high': 'max',
            'low': 'min',
            'close': 'last',
            'volume': 'sum'
        }
        return df.resample(freq).agg(ohlc).dropna()
```

### 2. 信号生成

```python
class SignalGenerator:
    def __init__(self):
        self.signals = []
    
    def ma_cross(self, prices, short=5, long=20):
        """均线交叉信号"""
        ma_short = prices.rolling(short).mean()
        ma_long = prices.rolling(long).mean()
        
        # 金叉
        buy = (ma_short > ma_long) & (ma_short.shift(1) <= ma_long.shift(1))
        # 死叉
        sell = (ma_short < ma_long) & (ma_short.shift(1) >= ma_long.shift(1))
        
        return buy, sell
    
    def rsi_signal(self, prices, period=14, oversold=30, overbought=70):
        """RSI 信号"""
        delta = prices.diff()
        gain = delta.where(delta > 0, 0)
        loss = -delta.where(delta < 0, 0)
        
        avg_gain = gain.rolling(period).mean()
        avg_loss = loss.rolling(period).mean()
        
        rs = avg_gain / avg_loss
        rsi = 100 - (100 / (1 + rs))
        
        buy = rsi < oversold
        sell = rsi > overbought
        
        return buy, sell
    
    def bollinger_signal(self, prices, period=20):
        """布林带信号"""
        ma = prices.rolling(period).mean()
        std = prices.rolling(period).std()
        
        upper = ma + 2 * std
        lower = ma - 2 * std
        
        buy = prices < lower
        sell = prices > upper
        
        return buy, sell
```

### 3. 回测引擎

```python
class BacktestEngine:
    def __init__(self, initial_capital=100000, commission=0.001):
        self.initial_capital = initial_capital
        self.commission = commission
        self.reset()
    
    def reset(self):
        self.cash = self.initial_capital
        self.position = 0
        self.portfolio_value = [self.initial_capital]
        self.trades = []
        self.equity_curve = []
    
    def buy(self, date, price, quantity=None):
        """买入"""
        if quantity is None:
            # 全仓买入
            quantity = (self.cash * (1 - self.commission)) // price
        
        cost = quantity * price * (1 + self.commission)
        
        if cost <= self.cash:
            self.cash -= cost
            self.position += quantity
            self.trades.append({
                'date': date,
                'action': 'buy',
                'price': price,
                'quantity': quantity
            })
    
    def sell(self, date, price, quantity=None):
        """卖出"""
        if quantity is None:
            quantity = self.position
        
        if quantity > 0:
            revenue = quantity * price * (1 - self.commission)
            self.cash += revenue
            self.position -= quantity
            self.trades.append({
                'date': date,
                'action': 'sell',
                'price': price,
                'quantity': quantity
            })
    
    def update_equity(self, date, price):
        """更新权益"""
        equity = self.cash + self.position * price
        self.equity_curve.append({
            'date': date,
            'equity': equity
        })
    
    def run(self, prices, signals):
        """运行回测"""
        for date, price in prices.items():
            if date in signals.index:
                signal = signals.loc[date]
                
                if signal == 'buy':
                    self.buy(date, price)
                elif signal == 'sell':
                    self.sell(date, price)
            
            self.update_equity(date, price)
        
        return self.get_results()
    
    def get_results(self):
        """获取回测结果"""
        equity = pd.DataFrame(self.equity_curve)
        equity['returns'] = equity['equity'].pct_change()
        
        total_return = (equity['equity'].iloc[-1] - self.initial_capital) / self.initial_capital
        annual_return = (1 + total_return) ** (252 / len(equity)) - 1
        
        # 夏普比率
        excess_returns = equity['returns'] - 0.02 / 252
        sharpe = np.sqrt(252) * excess_returns.mean() / excess_returns.std()
        
        # 最大回撤
        equity['peak'] = equity['equity'].cummax()
        equity['drawdown'] = (equity['equity'] - equity['peak']) / equity['peak']
        max_drawdown = equity['drawdown'].min()
        
        return {
            'total_return': total_return,
            'annual_return': annual_return,
            'sharpe_ratio': sharpe,
            'max_drawdown': max_drawdown,
            'total_trades': len(self.trades),
            'equity_curve': equity
        }
```

---

## 策略优化

### 4. 参数优化

```python
class ParameterOptimizer:
    def __init__(self, engine, prices):
        self.engine = engine
        self.prices = prices
    
    def grid_search(self, param_grid):
        """网格搜索"""
        results = []
        
        for params in self.iter_params(param_grid):
            # 运行回测
            signals = self.generate_signals(**params)
            result = self.engine.run(self.prices, signals)
            
            results.append({
                'params': params,
                'return': result['total_return'],
                'sharpe': result['sharpe_ratio'],
                'drawdown': result['max_drawdown']
            })
        
        return pd.DataFrame(results)
    
    def iter_params(self, param_grid):
        """参数组合迭代器"""
        keys = param_grid.keys()
        values = param_grid.values()
        
        for combination in itertools.product(*values):
            yield dict(zip(keys, combination))
```

### 5. Walk-Forward 分析

```python
class WalkForwardAnalysis:
    def __init__(self, engine, prices):
        self.engine = engine
        self.prices = prices
    
    def analyze(self, train_period='1Y', test_period='3M', step='1M'):
        """Walk-Forward 分析"""
        results = []
        
        dates = self.prices.index
        train_start = dates[0]
        
        while True:
            train_end = train_start + pd.DateOffset(years=1)
            test_end = train_end + pd.DateOffset(months=3)
            
            if test_end > dates[-1]:
                break
            
            # 分割数据
            train_data = self.prices[train_start:train_end]
            test_data = self.prices[train_end:test_end]
            
            # 训练
            signals = self.train(train_data)
            
            # 测试
            self.engine.reset()
            result = self.engine.run(test_data, signals)
            
            results.append({
                'train_period': (train_start, train_end),
                'test_period': (train_end, test_end),
                'result': result
            })
            
            # 滑动窗口
            train_start = train_start + pd.DateOffset(months=1)
        
        return results
```

---

## 风险管理

### 6. 仓位管理

```python
class PositionSizing:
    @staticmethod
    def fixed_ratio(capital, risk_per_trade, stop_loss_pct):
        """固定比例"""
        risk_amount = capital * risk_per_trade
        position = risk_amount / stop_loss_pct
        return int(position)
    
    @staticmethod
    def kelly(capital, win_rate, avg_win, avg_loss):
        """Kelly 公式"""
        if avg_loss == 0:
            return 0
        
        win_loss_ratio = avg_win / avg_loss
        kelly_pct = (win_rate * win_loss_ratio - (1 - win_rate)) / win_loss_ratio
        
        # 限制仓位
        return max(0, min(kelly_pct, 0.25))
    
    @staticmethod
    def volatility(capital, price, volatility, target_vol=0.15):
        """波动率仓位"""
        position = (capital * target_vol) / (price * volatility)
        return int(position)
```

---

## 让我变强的量化技能

1. **数据处理** - 清洗、重采样
2. **信号生成** - 指标、策略
3. **回测引擎** - 交易、统计
4. **参数优化** - 网格搜索、Walk-Forward
5. **风险管理** - 仓位、止损

---
