import al
import common
import times

const implementationName* = "DataOriented"

# Objects here are nothing but an index
type DOObject = uint

var
  allX:             array[numParticles, float]
  allY:             array[numParticles, float]
  allBasicData:     array[numParticles, FillingData]
  allImg:           array[numParticles, PBitmap]
  allImgData:       array[numParticles, FillingData]
  allWidth:         array[numParticles, float]
  allHeight:        array[numParticles, float]
  allPhysicsData:   array[numParticles, FillingData]
  allSpeedX:        array[numParticles, float]
  allSpeedY:        array[numParticles, float]
  allDrawnTimer:    array[numParticles, float]
  allLastTimeDrawn: array[numParticles, float]
  allParticleData:  array[numParticles, FillingData]
  allDrawIndex:     array[numParticles, uint]

  drawingNum: uint
  drawingList: array[numParticles, DOObject]


proc init* (self: DOObject) =
  allX[self] = 0
  allY[self] = 0
  allImg[self] = loadBitmap("Rectangle.png")
  allWidth[self] = 64
  allHeight[self] = 64
  allSpeedX[self] = random(-maxSpeed..maxSpeed)
  allSpeedY[self] = random(-maxSpeed..maxSpeed)
  allDrawnTimer[self] = random(maxDrawnTime)
  allLastTimeDrawn[self] = epochTime()

proc drawAll()=
  for idx in 0..drawingNum - 1:
    let obj = drawingList[idx]
    pushTarget(display.getBackbuffer()):
      drawBitmap(allImg[obj], allX[obj], allY[obj], 0)

proc calcAllPhysics()=
  for obj in 0..numParticles - 1:

    let x = allX[obj]
    let y = allY[obj]
    let width = allWidth[obj]
    let height = allHeight[obj]

    for otherObj in 0..numParticles - 1:

      let otherX       = allX[otherObj]
      let otherY       = allY[otherObj]
      let otherWidth   = allWidth[otherObj]
      let otherHeight  = allHeight[otherObj]

      if  x < otherX + otherWidth  and x + width  > otherX and y < otherY + otherHeight and y + height > otherY:

        # Is horizontal hit?
        if y < otherY + otherHeight and y > otherY:
          allSpeedX[obj] = -allSpeedX[obj]

        else:
          allSpeedY[obj] = -allSpeedY[obj]

    if x < 0 or x + width > screenWidth:
      allSpeedX[obj] = -allSpeedX[obj]

    if y < 0 or y + height > screenHeight:
      allSpeedY[obj] = -allSpeedY[obj]

    allX[obj] += allSpeedX[obj]
    allY[obj] += allSpeedY[obj]



proc handleAllParticles()=
  for obj in 0..numParticles - 1:
    if epochTime() > allLastTimeDrawn[obj] + allDrawnTimer[obj]:
      if allDrawIndex[obj] != 0: # It's being drawn
        allDrawIndex[obj] = drawingNum
        drawingList[drawingNum] = uint(obj)
        inc drawingNum

      else:

        drawingList[allDrawIndex[obj]] = drawingList[drawingNum - 1]
        dec drawingNum




var onFrameHandlers: seq[proc ()]

proc init* =
  for obj in 0..numParticles - 1:
    init(DOObject(obj))

  onFrameHandlers.add(drawAll)
  onFrameHandlers.add(calcAllPhysics)
  onFrameHandlers.add(handleAllParticles)

proc redraw* =
  for handle in onFrameHandlers:
    handle()

