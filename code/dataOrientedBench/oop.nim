import al
import common
import times

const implementationName* = "OOP"

type
  OopObject = object
    components: seq[Component]

  Component = ref object of RootObj
    parent: ptr OopObject

type PositionComp = ref object of Component
  x:float
  y:float
  basicData: FillingData

type SpriteComp = ref object of Component
  img: PBitmap
  imgData: FillingData
  shouldBeDrawn: bool

type PhysicsComp = ref object of Component
  width: float
  height: float
  physicsData: FillingData

  speedX: float
  speedY: float

type ParticleComp = ref object of Component
  drawnTimer:  float
  lastTimeDrawn: float
  particleData: FillingData


var particles: array[numParticles,OopObject]



proc init* (self: var OopObject) =
  var posComp = new(PositionComp)
  posComp.parent = addr self
  posComp.x = 0
  posComp.y = 0

  var sprComp = new(SpriteComp)
  sprComp.parent = addr self
  sprComp.img = loadBitmap("Rectangle.png")
  sprComp.shouldBeDrawn = true

  var physicsComp = new(PhysicsComp)
  physicsComp.parent = addr self
  physicsComp.width = 64
  physicsComp.height = 64
  physicsComp.speedX = random(-maxSpeed..maxSpeed)
  physicsComp.speedY = random(-maxSpeed..maxSpeed)

  var particleComp = new(ParticleComp)
  particleComp.parent = addr self
  particleComp.drawnTimer = random(maxDrawnTime)
  particleComp.lastTimeDrawn = epochTime()


  self.components.add(posComp)
  self.components.add(sprComp)
  self.components.add(physicsComp)
  self.components.add(particleComp)

proc init* =
  for particle in mitems particles:
    particle.init()

method onFrame(self: var Component){.base.}=
  echo "Base method, should not be used"

method onFrame(self: var SpriteComp)=
  let posComp = cast[PositionComp](self.parent.components[0])

  pushTarget(display.getBackbuffer()):
    if self.shouldBeDrawn:
      self.img.drawBitmap(posComp.x, posComp.y, 0)

method onFrame(thisPhysics: var PhysicsComp)=
  let thisPos = cast[PositionComp](thisPhysics.parent.components[0])
  let x = thisPos.x
  let y = thisPos.y
  let width = thisPhysics.width
  let height = thisPhysics.height

  for particle in particles:
    let otherPhysics = cast[PhysicsComp](particle.components[2])
    let otherPos     = cast[PositionComp](particle.components[0])

    let otherX       = otherPos.x
    let otherY       = otherPos.y
    let otherWidth   = otherPhysics.width
    let otherHeight  = otherPhysics.height


    if  x < otherX + otherWidth  and x + width  > otherX and y < otherY + otherHeight and y + height > otherY:

      # Is horizontal hit?
      if y < otherY + otherHeight and y > otherY:
        thisPhysics.speedX = -thisPhysics.speedX

      else:
        thisPhysics.speedY = -thisPhysics.speedY

  if x < 0 or x + width > screenWidth:
    thisPhysics.speedX = -thisPhysics.speedX
    allSpeedX[obj] = -allSpeedX[obj]

  if y < 0 or y + height > screenHeight:
    thisPhysics.speedY = -thisPhysics.speedY

  thisPos.x += thisPhysics.speedX
  thisPos.y += thisPhysics.speedY

method onFrame(self: var ParticleComp)=
  if epochTime() > self.lastTimeDrawn + self.drawnTimer:
    var spriteComp = cast[SpriteComp](self.parent.components[1])
    spriteComp.shouldBeDrawn = not spriteComp.shouldBeDrawn


proc redraw* =
  for particle in mitems(particles):
    for comp in mitems(particle.components):
      comp.onFrame()
