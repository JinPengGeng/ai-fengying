# Vue 3 组合式 API 进阶

## setup() 语法糖

### 基础结构
```vue
<script setup>
import { ref, computed, watch, onMounted } from 'vue'

const count = ref(0)
const doubled = computed(() => count.value * 2)

function increment() {
  count.value++
}

watch(count, (newVal) => {
  console.log('count changed:', newVal)
})

onMounted(() => {
  console.log('component mounted')
})
</script>
```

---

## 响应式系统

### ref vs reactive
```typescript
// ref - 基础类型
const count = ref(0)
count.value++

// reactive - 对象
const state = reactive({
  user: { name: 'John' },
  items: []
})
state.user.name = 'Jane'
```

### toRefs
```typescript
const state = reactive({ a: 1, b: 2 })
const { a, b } = toRefs(state)
// a 是 ref，保持响应式
```

---

## 依赖注入

### provide/inject
```typescript
// 父组件
import { provide } from 'vue'
provide('theme', 'dark')

// 子组件
import { inject } from 'vue'
const theme = inject('theme')
```

---

## 自定义指令

```typescript
// v-focus.ts
export default {
  mounted(el) {
    el.focus()
  }
}

// 使用
<input v-focus />
```

---

## 性能优化

| 优化点 | 方法 |
|--------|------|
| 组件懒加载 | defineAsyncComponent |
| v-memo | 条件更新 |
| shallowRef | 避免深层响应 |
| keep-alive | 缓存组件 |
