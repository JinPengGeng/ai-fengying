# Vue 3 深入

## Composition API 深入

### 1. setup() 高级用法

```vue
<script setup>
import { ref, computed, watch, onMounted } from 'vue'

// 响应式状态
const count = ref(0)
const user = ref({ name: 'John', age: 25 })

// 计算属性
const doubleCount = computed(() => count.value * 2)
const isAdult = computed(() => user.value.age >= 18)

// 监听器
watch(count, (newVal, oldVal) => {
  console.log(`count 从 ${oldVal} 变为 ${newVal}`)
})

// 深度监听
watch(user, (newVal) => {
  console.log('user 变化:', newVal)
}, { deep: true })

// 生命周期钩子
onMounted(() => {
  console.log('组件挂载完成')
})

// 条件监听
watchEffect(() => {
  console.log('count 变化:', count.value)
})
</script>
```

### 2. 自定义指令

```javascript
// 全局指令
app.directive('focus', {
  mounted(el) {
    el.focus()
  },
  updated(el, binding) {
    if (binding.value) {
      el.focus()
    }
  }
})

// 使用
<input v-focus />
```

---

## 状态管理

### 3. Pinia 深入

```javascript
import { defineStore } from 'pinia'

// 基础 store
export const useUserStore = defineStore('user', {
  state: () => ({
    user: null,
    token: null
  }),
  
  getters: {
    isLoggedIn: (state) => !!state.token,
    userName: (state) => state.user?.name || 'Guest'
  },
  
  actions: {
    async login(credentials) {
      const response = await api.login(credentials)
      this.token = response.token
      this.user = response.user
    },
    
    logout() {
      this.token = null
      this.user = null
    }
  }
})

// 使用
import { useUserStore } from './stores/user'
const userStore = useUserStore()

// 在组件中
const isLoggedIn = computed(() => userStore.isLoggedIn)
```

---

## 路由

### 4. Vue Router 4

```javascript
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/user/:id',
    name: 'User',
    component: User,
    props: true,
    children: [
      {
        path: 'profile',
        name: 'UserProfile',
        component: UserProfile
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    }
    return { top: 0 }
  }
})

// 导航守卫
router.beforeEach((to, from, next) => {
  const isAuthenticated = store.isAuthenticated
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
  } else {
    next()
  }
})
```

---

## 性能优化

### 5. 懒加载

```javascript
// 路由懒加载
const Home = () => import('./views/Home.vue')
const About = () => import('./views/About.vue')

// 组件懒加载
const HeavyComponent = defineAsyncComponent({
  loader: () => import('./HeavyComponent.vue'),
  loadingComponent: LoadingComponent,
  delay: 200,
  onError(error, retry, fail, attempts) {
    if (attempts < 3) {
      retry()
    } else {
      fail()
    }
  }
})
```

### 6. v-memo

```vue
<!-- 只在变化时更新 -->
<div v-for="item in items" :key="item.id" v-memo="[item.selected]">
  <ComplexComponent :item="item" />
</div>
```

---

## 让我变强的 Vue 技能

1. **Composition API** - 深入响应式原理
2. **Pinia** - 状态管理最佳实践
3. **Router** - 路由守卫、懒加载
4. **性能优化** - v-memo、异步组件
5. **SSR** - Nuxt.js 服务端渲染
6. **测试** - Vitest、Playwright

---
