<template>
  <div class="login-page">
    <h1>BeeCreative</h1>
    <form @submit.prevent="login">
      <input type="text" placeholder="Benutzername" v-model="username" required />
      <input type="password" placeholder="Passwort" v-model="password" required />
      <button type="submit">Einloggen</button>
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
export default defineComponent({
  name: 'LoginForm',
  emits: ['login-success'],
  setup(_, { emit }) {
    const username = ref('');
    const password = ref('');
    const login = () => {
      alert(`Willkommen, ${username.value}!`);
      emit('login-success');
    };
    return { username, password, login };
  },
});
</script>

<style scoped>
.login-page {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background: var(--primary-purple);
  color: white;
  gap: 20px;
}
input {
  padding: 10px;
  width: 250px;
  border-radius: 8px;
  border: none;
}
button {
  padding: 10px 20px;
  background: var(--button-bg);
  color: var(--button-text);
  font-weight: bold;
}
</style>
