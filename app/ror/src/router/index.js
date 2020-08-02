import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import ROR from '../views/ROR.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/ror',
    name: 'ROR',
    component: ROR
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
