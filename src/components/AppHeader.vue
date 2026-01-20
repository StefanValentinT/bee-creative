<template>
  <header>
    <canvas ref="hexCanvas"></canvas>
    <h1>Bee Creative</h1>
  </header>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

import SimplexNoise from 'simplex-noise'

const noise = new SimplexNoise()
const hexCanvas = ref(null)

const HEX_RADIUS = 25   
const HEX_PADDING = 5 
const COLORS = ['#FFD700', '#FFEC8B']
const STROKE_COLOR = '#E0C200'
const STROKE_WIDTH = 1

let resizeListener = null

function drawHexGrid() {
  const canvas = hexCanvas.value
  const ctx = canvas.getContext('2d')
  const dpr = window.devicePixelRatio || 1
  const rect = canvas.parentElement.getBoundingClientRect()

  canvas.width = rect.width * dpr
  canvas.height = rect.height * dpr
  canvas.style.width = rect.width + 'px'
  canvas.style.height = rect.height + 'px'
  ctx.scale(dpr, dpr)
  ctx.clearRect(0, 0, rect.width, rect.height)

  const hexHeight = Math.sqrt(3) * HEX_RADIUS
  const hexWidth = 2 * HEX_RADIUS

  const horizDist = 1.5 * HEX_RADIUS + HEX_PADDING
  const vertDist = (hexHeight * 0.75) + HEX_PADDING * 3
  const vertShift = vertDist / 2

  const cols = Math.ceil(rect.width / horizDist)
  const rows = Math.ceil(rect.height / vertDist) + 2

  const startX = HEX_RADIUS + HEX_PADDING / 2
  const startY = HEX_RADIUS + HEX_PADDING / 2 - vertDist

  for (let col = 0; col < cols; col++) {
    const offsetY = (col % 2) * vertShift
    for (let row = 0; row < rows; row++) {
      const x = startX + col * horizDist
      const y = startY + row * vertDist + offsetY

      if (x + HEX_RADIUS > rect.width || y + HEX_RADIUS < 0 || y - HEX_RADIUS > rect.height) continue

const n = noise.noise2D(col / 5, row / 5) 

if (n > 0.2) {
  drawHex(ctx, x, y, HEX_RADIUS, COLORS[0])
} else if (n < -0.2) {
  drawHex(ctx, x, y, HEX_RADIUS, COLORS[1])
}

    }
  }

  function drawHex(ctx, x, y, radius, fillColor) {
    ctx.beginPath()
    for (let i = 0; i < 6; i++) {
      const angle = Math.PI / 3 * i
      const px = x + radius * Math.cos(angle)
      const py = y + radius * Math.sin(angle)
      if (i === 0) ctx.moveTo(px, py)
      else ctx.lineTo(px, py)
    }
    ctx.closePath()
    ctx.fillStyle = fillColor
    ctx.fill()
    ctx.strokeStyle = STROKE_COLOR
    ctx.lineWidth = STROKE_WIDTH
    ctx.stroke()
  }
}

onMounted(() => {
  drawHexGrid()
  resizeListener = () => drawHexGrid()
  window.addEventListener('resize', resizeListener)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeListener)
})
</script>

<style scoped>
header {
  position: relative;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border-bottom: 1px solid #ddd;
  background: white;
}

header canvas {
  position: absolute;
  top: 0;
  left: 0;
  z-index: 0;
}

header h1 {
  position: relative;
  z-index: 1;
  font-size: 2rem;
  margin: 0;
  color: #333;
}
</style>
