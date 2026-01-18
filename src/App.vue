<template>
  <div id="app">
    <section class="hero">
      <div class="honeycomb-bg"></div>

      <div class="hero-content">
        <h1 class="title">
          <span>Bee</span>
          <span>Creative</span>
        </h1>

        <div class="hero-buttons">
          <button @click="login">Login</button>
          <button @click="register">Register</button>
        </div>
      </div>

      <a href="#about" class="scroll-down">⬇</a>
    </section>

    <section id="about" class="about">
      <h2>Was ist BeeCreative?</h2>

      <p>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      </p>

      <p>
        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      </p>

      <p>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.
        Cras venenatis euismod malesuada.
      </p>
    </section>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'App',
  setup() {
    const login = () => alert('Login (Demo)');
    const register = () => alert('Register (Demo)');
    return { login, register };
  },
});
</script>

<style>
:root {
  --yellow: #FFD700;
  --purple: #8A2BE2;
  --cream: #FFF5E1;
}

html, body, #app {
  margin: 0;
  padding: 0;
  font-family: Arial, sans-serif;
  background: var(--cream);
}

.hero {
  position: relative;
  height: 100vh;
  background: linear-gradient(
    135deg,
    #f5c842,
    #fff4c2 
  );
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.honeycomb-bg {
  position: absolute;
  inset: 0;
  background-image: url('./assets/honeycomb.png');
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
  opacity: 0.18;
  z-index: 1;
}


/* Content on top */
.hero-content {
  position: relative;
  z-index: 2;
  text-align: center;
  color: white;
}

/* TITLE */
.title {
  font-size: 5rem;
  font-weight: 800;
  line-height: 1.1;
  margin: 0;
}

.title span {
  display: block;
}

/* BUTTONS */
.hero-buttons {
  margin-top: 40px;
  display: flex;
  gap: 20px;
  justify-content: center;
}

.hero-buttons button {
  padding: 15px 35px;
  font-size: 1.2rem;
  font-weight: bold;
  background: var(--purple);
  color: white;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  transition: transform 0.2s ease, background 0.2s ease;
}

.hero-buttons button:hover {
  transform: scale(1.07);
  background: #6f1fc0;
}

/* SCROLL */
.scroll-down {
  position: absolute;
  bottom: 20px;
  font-size: 2rem;
  color: white;
  text-decoration: none;
  animation: bounce 2s infinite;
  z-index: 2;
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(10px); }
}

/* ABOUT */
.about {
  max-width: 900px;
  margin: auto;
  padding: 90px 20px;
  text-align: center;
}

.about h2 {
  font-size: 3rem;
  color: var(--purple);
  margin-bottom: 30px;
}

.about p {
  font-size: 1.1rem;
  line-height: 1.8;
  margin-bottom: 20px;
}
</style>
