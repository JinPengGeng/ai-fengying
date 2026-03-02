# 区块链基础

## 核心概念

### 1. 区块链结构

```
区块:
├── 区块头
│   ├── 版本
│   ├── 前一个区块的哈希
│   ├── Merkle 根
│   ├── 时间戳
│   └── 难度目标
└── 交易数据
```

### 2. 共识机制

| 机制 | 说明 | 优点 | 缺点 |
|------|------|------|------|
| PoW | 工作量证明 | 安全 | 耗能 |
| PoS | 权益证明 | 节能 | 集中化风险 |
| DPoS | 委托权益证明 | 高效 | 中心化 |
| PBFT | 实用拜占庭 | 快速确认 | 需要许可 |

---

## 智能合约

### 3. Solidity 示例

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private value;
    
    // 事件
    event ValueChanged(uint256 newValue);
    
    // 存储值
    function store(uint256 _value) public {
        value = _value;
        emit ValueChanged(_value);
    }
    
    // 读取值
    function retrieve() public view returns (uint256) {
        return value;
    }
}
```

---

## 让我变强的区块链技能

1. **区块链** - 结构、原理
2. **共识** - PoW, PoS
3. **智能合约** - Solidity
4. **DeFi** - DEX, 借贷
5. **NFT** - 标准、应用

---
