# 区块链技术深入

## 共识机制

### PoW (工作量证明)
- 算力竞争
- Bitcoin 采用
- 能耗高，安全性高

### PoS (权益证明)
- 质押代币
- Energy Efficient
- Ethereum 采用

### DPoS (委托权益证明)
- 超级节点投票
- 高性能
- EOS, TRON 采用

### PoH (历史证明)
- 时间戳证明
- Solana 采用
- 高吞吐量

---

## 智能合约

### EVM 架构
- 栈式虚拟机
- 256位整数
- Gas 机制

### 常见合约模式
```solidity
// 代币合约 (ERC-20)
contract ERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    function transfer(address to, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }
}
```

### DeFi 原语
- AMM (自动做市商)
- Lending (借贷)
- Staking (质押)
- Flash Loan (闪电贷)

---

## Layer 2 方案

### Rollup
- Optimistic Rollup
- ZK Rollup

### 侧链
- Polygon
- BSC

### 状态通道
- Lightning Network

---

## 跨链技术

| 技术 | 描述 |
|------|------|
| 哈希锁定 | HTLC |
| 中继 | Relayer |
| 侧链 | Bridge |
| 中间件 | Oracle |
