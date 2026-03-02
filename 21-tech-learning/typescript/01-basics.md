# TypeScript 进阶

## 高级类型

### 1. 联合类型与交叉类型

```typescript
// 联合类型
type StringOrNumber = string | number;

// 交叉类型
type Extended = { a: string } & { b: number };

// 区分联合
type Action =
  | { type: 'increment'; delta: number }
  | { type: 'decrement'; delta: number }
  | { type: 'reset' };

function reducer(action: Action) {
  switch (action.type) {
    case 'increment':
      return action.delta;
    case 'decrement':
      return -action.delta;
    case 'reset':
      return 0;
  }
}
```

### 2. 泛型

```typescript
// 泛型函数
function identity<T>(arg: T): T {
  return arg;
}

// 泛型约束
interface Lengthwise {
  length: number;
}

function logLength<T extends Lengthwise>(arg: T): number {
  return arg.length;
}

// 泛型类
class Container<T> {
  private value: T;
  
  constructor(value: T) {
    this.value = value;
  }
  
  get(): T {
    return this.value;
  }
}
```

---

## 装饰器

### 3. 类装饰器

```typescript
function Logger(constructor: Function) {
  console.log('Logger:', constructor.name);
}

@Logger
class User {
  constructor(public name: string) {}
}
```

### 4. 方法装饰器

```typescript
function ReadOnly(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
  descriptor.writable = false;
}

class User {
  @ReadOnly
  name() {
    return 'John';
  }
}
```

---

## 模块系统

### 5. ES Modules

```typescript
// 导出
export interface User {
  id: number;
  name: string;
}

export class UserService {
  getUser(id: number): User {
    return { id, name: 'John' };
  }
}

export default UserService;

// 导入
import UserService, { User } from './user';
```

---

## 让我变强的 TypeScript 技能

1. **高级类型** - 联合、交叉、泛型
2. **装饰器** - 类、方法
3. **模块** - ES Modules
4. **类型守卫** - is
5. **映射类型** - Partial, Required

---
