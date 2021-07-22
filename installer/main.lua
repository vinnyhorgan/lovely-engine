local nuklear = require "nuklear"

function love.load()
    ui = nuklear.newUI()

    WIDTH = 250
    HEIGHT = 590

    love.window.setMode(WIDTH, HEIGHT)

    icon = love.image.newImageData("icon.png")

    love.window.setIcon(icon)

    love.window.setTitle("Lovely Engine Installer")

    win32 = {value = false}
    win64 = {value = false}
    macos = {value = false}
    linux32 = {value = false}
    linux64 = {value = false}
    web = {value = false}
    lite = {value = false}
    novels = {value = false}
end

function install()
    os.execute("git clone https://github.com/vinnyhorgan/lovely-utility")

    if win32["value"] == true then
        os.execute("mkdir -p ./export")
        os.execute("tar -xvf ./lovely-utility/win32.tar.xz")
        os.execute("mv win32 ./export")
    end

    if win64["value"] == true then
        os.execute("mkdir -p ./export")
        os.execute("tar -xvf ./lovely-utility/win64.tar.xz")
        os.execute("mv win64 ./export")
    end

    if macos["value"] == true then
        os.execute("mkdir -p ./export")
        os.execute("tar -xvf ./lovely-utility/macos.tar.xz")
        os.execute("mv macos ./export")
    end

    if linux32["value"] == true then
        os.execute("mkdir -p ./export")
        os.execute("tar -xvf ./lovely-utility/linux32.tar.xz")
        os.execute("mv linux32 ./export")
    end

    if linux64["value"] == true then
        os.execute("mkdir -p ./export")
        os.execute("tar -xvf ./lovely-utility/linux64.tar.xz")
        os.execute("mv linux64 ./export")
    end

    if web["value"] == true then
        os.execute("mkdir -p ./export")
        os.execute("tar -xvf ./lovely-utility/web.tar.xz")
        os.execute("mv web ./export")
    end

    if lite["value"] == true then
        os.execute("mkdir -p ./plugins")
        os.execute("tar -xvf ./lovely-utility/lite.tar.xz")
        os.execute("mv ./lite/lite.lua ./plugins")
    end

    if novels["value"] == true then
        os.execute("mkdir -p ./plugins")
        os.execute("tar -xvf ./lovely-utility/novels.tar.xz")
        os.execute("mv ./novels/novels.lua ./plugins")
    end

    os.execute("rm -rf lovely-utility")
end

function love.update(dt)
    ui:frameBegin()

    if ui:windowBegin("", 0, 0, WIDTH, HEIGHT, "border") then
        ui:layoutRow("dynamic", 30, 1)

        ui:label("INSTALL PACKAGES", "centered")

        ui:spacing(1)

        ui:label("EXPORT TEMPLATES")

        ui:spacing(1)

        ui:checkbox("Windows x86", win32)
        ui:checkbox("Windows x86_64", win64)
        ui:checkbox("MacOS", macos)
        ui:checkbox("Linux x86", linux32)
        ui:checkbox("Linux x86_64", linux64)
        ui:checkbox("Web", web)

        ui:spacing(1)

        ui:label("PLUGINS")

        ui:spacing(1)

        ui:checkbox("Lite Editor Plugin", lite)
        ui:checkbox("Novels Plugin", novels)

        ui:spacing(1)

        if ui:button("Install") then
            install()
        end
    end
    ui:windowEnd()

    ui:frameEnd()
end

function love.draw()
    ui:draw()
end

function love.keypressed(key, scancode, isrepeat)
    ui:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    ui:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    ui:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    ui:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    ui:mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
    ui:textinput(text)
end

function love.wheelmoved(x, y)
    ui:wheelmoved(x, y)
end