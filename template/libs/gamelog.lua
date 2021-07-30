local gamelog = {}

gamelog.message = ""

gamelog.x = 10
gamelog.y = 10

gamelog.red = 1
gamelog.green = 1
gamelog.blue = 1

gamelog.timer = 0
gamelog.fade = 0

function gamelog.log(message)
  gamelog.message = message
end

function gamelog.position(x, y)
  gamelog.x = x
  gamelog.y = y
end

function gamelog.color(red, green, blue)
  gamelog.red = red
  gamelog.green = green
  gamelog.blue = blue
end

function gamelog.update(dt)
  if gamelog.message ~= "" then
    gamelog.timer = gamelog.timer + dt

    if gamelog.timer > 0.05 and gamelog.timer < 0.1 then
      gamelog.fade = 0.1
    end

    if gamelog.timer > 0.1 and gamelog.timer < 0.15 then
      gamelog.fade = 0.2
    end

    if gamelog.timer > 0.15 and gamelog.timer < 0.2 then
      gamelog.fade = 0.3
    end

    if gamelog.timer > 0.2 and gamelog.timer < 0.25 then
      gamelog.fade = 0.4
    end

    if gamelog.timer > 0.25 and gamelog.timer < 0.3 then
      gamelog.fade = 0.5
    end

    if gamelog.timer > 0.3 and gamelog.timer < 0.35 then
      gamelog.fade = 0.6
    end

    if gamelog.timer > 0.35 and gamelog.timer < 0.4 then
      gamelog.fade = 0.7
    end

    if gamelog.timer > 0.4 and gamelog.timer < 0.45 then
      gamelog.fade = 0.8
    end

    if gamelog.timer > 0.45 and gamelog.timer < 0.5 then
      gamelog.fade = 0.9
    end

    if gamelog.timer > 0.5 and gamelog.timer < 0.55 then
      gamelog.fade = 1
    end

    if gamelog.timer > 0.55 and gamelog.timer < 0.6 then
      gamelog.fade = 0.9
    end

    if gamelog.timer > 0.6 and gamelog.timer < 0.65 then
      gamelog.fade = 0.8
    end

    if gamelog.timer > 0.65 and gamelog.timer < 0.7 then
      gamelog.fade = 0.7
    end

    if gamelog.timer > 0.7 and gamelog.timer < 0.75 then
      gamelog.fade = 0.6
    end

    if gamelog.timer > 0.75 and gamelog.timer < 0.8 then
      gamelog.fade = 0.5
    end

    if gamelog.timer > 0.8 and gamelog.timer < 0.85 then
      gamelog.fade = 0.4
    end

    if gamelog.timer > 0.85 and gamelog.timer < 0.9 then
      gamelog.fade = 0.3
    end

    if gamelog.timer > 0.9 and gamelog.timer < 0.95 then
      gamelog.fade = 0.2
    end

    if gamelog.timer > 0.95 and gamelog.timer < 1 then
      gamelog.fade = 0.1
    end

    if gamelog.timer > 1 then
      gamelog.message = ""
    end
  end
end

function gamelog.draw()
  if gamelog.message ~= "" then
    love.graphics.setColor(gamelog.red, gamelog.green, gamelog.blue, gamelog.fade)
    love.graphics.print(gamelog.message, gamelog.x, gamelog.y)
  end
end

return gamelog
