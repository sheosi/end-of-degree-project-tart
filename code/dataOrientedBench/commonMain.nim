import al
import common
#import oop
#import dataOriented

al_main:
  if not al.init():
    quit "Failed to initialize allegro!"

  display = al.createDisplay(640, 480)
  if display.isNil:
    quit "Failed to create display!"

  discard al.installEverything()
  discard al.initBaseAddons()

  let
    drawTimer = createTimer(1.0/60.0)
    queue = createEventQueue()
    #font = systemFont("VeraMono.ttf", 46)

  queue.registerEventSource display.eventSource
  queue.registerEventSource drawTimer.eventSource
  queue.registerEventSource getMouseEventSource()
  queue.register getKeyboardEventSource()

  drawTimer.start

  al.clearToColor al.mapRGB(0,0,0)
  al.flipDisplay()

  init()

  var ev: TEvent
  while true:
    queue.waitForEvent ev

    case ev.kind
    of EventTimer:
      if ev.timer.source == drawTimer.eventSource:
        redraw()


    of EventDisplayClose:
      break

    of EventKeyDown:

      if ev.keyboard.keycode == KeyEscape:
        break

    else:


  queue.destroy
display.destroy
