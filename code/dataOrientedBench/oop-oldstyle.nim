import al
import common

type OopObject = object

type Component = object
type Sprite = object

type Particle = object
  x:float
  y:float
  basicData: array[2048,char]
  img: PBitmap
  imgData: array[2048,char]
  width: uint
  height: uint
  physicsData: array[2048,char]
  shouldBeDrawn: bool
  drawntimer:  uint
  lastTimeDrawn: uint
  drawingData: array[2048,char]


var particles: array[numParticles,Particle]

proc init* (self: Particle) =
  discard

proc init* =
  for particle in mitems particles:
    particle.init()


proc redraw* =
  for particle in particles:
    pushTarget(display.getBackbuffer()):
      if particle.shouldBeDrawn:
        particle.drawBitmap(particle.x, particle.y, 0)




