import al
export al

const numParticles* = 1024
const screenWidth* = 800
const screenHeight* = 600
const maxSpeed* = 5'f32
const maxDrawnTime* = 2'f32
type FillingData* = array[2048,char]

var
  drawtTimer* :PTimer
  queue* :PEventQueue
  font* :PFont
  display* : PDisplay
