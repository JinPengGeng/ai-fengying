# Vue 基础速查

## 什么是 Vue？

**Vue** = 渐进式 JavaScript 框架
- 响应式数据绑定
- 组件化
- 简洁易学

---

## 基础语法

### 模板
```html
<div id="app">
  <h1>{{ message }}</h1>
  <button @click="count++">点击次数: {{ count }}</button>
</div>
```

### Vue 实例
```javascript
const app = Vue.createApp({
  data() {
    return {
      message: 'Hello Vue!',
      count: 0
    }
  }
})

app.mount('#app')
```

---

## 响应式

### data
```javascript
data() {
  return {
    name: 'Vue',
    user: { name: 'John' },
    items: ['a', 'b', 'c']
  }
}
```

### computed
```javascript
computed: {
  fullName() {
    return this.firstName + ' ' + this.lastName
  }
}
```

### watch
```javascript
watch: {
  question(newQuestion, oldQuestion) {
    console.log('变了')
  }
}
```

---

## 指令

| 指令 | 说明 |
|------|------|
| `v-bind:` / `:` | 绑定属性 |
| `v-on:` / `@` | 绑定事件 |
| `v-if` / `v-else` | 条件渲染 |
| `v-for` | 列表渲染 |
| `v-model` | 双向绑定 |
| `v-text` | 文本插值 |
| `v-html` | HTML 插值 |

### 例子
```html
<!-- 绑定 -->
<img :src="imageUrl">
<button @click="handleClick">点击</button>

<!-- 条件 -->
<div v-if="show">显示</div>
<div v-else>隐藏</div>

<!-- 循环 -->
<li v-for="item in items" :key="item.id">
  {{ item.name }}
</li>

<!-- 表单 -->
<input v-model="name">
```

---

## 组件

### 定义组件
```javascript
const MyComponent = {
  props: ['title'],
  emits: ['update'],
  template: `
    <div>
      <h1>{{ title }}</h1>
      <button @click="$emit('update')">点击</button>
    </div>
  `
}
```

### 使用组件
```html
<my-component title="Hello" @update="handleUpdate" />
```

---

## 生命周期

| 钩子 | 时机 |
|------|------|
| `onMounted` | 组件挂载完成 |
| `onUpdated` | 组件更新完成 |
| `onUnmounted` | 组件卸载 |
| `onBeforeMount` | 挂载前 |
| `onBeforeUpdate` | 更新前 |

```javascript
import { onMounted } from 'vue'

export default {
  setup() {
    onMounted(() => {
      console.log('组件挂载完成')
    })
  }
}
```

---

## Composition API

### setup
```javascript
import { ref, computed } from 'vue'

export default {
  setup() {
    const count = ref(0)
    const doubled = computed(() => count.value * 2)
    
    function increment() {
      count.value++
    }
    
    return { count, doubled, increment }
  }
}
```

### ref vs reactive
```javascript
import { ref, reactive } from 'vue'

// ref - 原始类型
const count = ref(0)

// reactive - 对象
const state = reactive({
  name: 'Vue',
  version: 3
})
```

---

## 让我变强的 Vue 技能

1. **基础**: 模板、指令、组件
2. **Composition API**: setup、ref、reactive
3. **路由**: Vue Router
4. **状态**: Pinia
5. **生态**: Vite、VueUse、 Nuxt

---
