<template>
  <div class="splash-screen">
    <img :src="logoImg" alt="Logo" class="logo" />
    <p class="motto">BeeCreative</p>
  </div>
</template>

<script setup>
import logoImg from '../assets/logo.jpeg'
</script>

<style>

@import url('https://fonts.googleapis.com/css2?family=Lobster+Two:wght@400;700&display=swap');

.splash-screen {
  height: 100vh;                
  width: 100vw;                  
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: #fff;       
}

.logo {
  width: 200px;               
  margin-bottom: 20px;
}

.motto {
  font-family: 'Lobster Two', serif;
  font-size: 6rem;   
  color: #fff;                
  letter-spacing: 0.05em;
  text-align: center;
}
</style>
