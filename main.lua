-- Imports
local nuklear = require "nuklear"
log = require "libs/log"

-- Love2d callback: runs once when the project is loaded
function love.load()
    log.info("Starting love2d window...")
    love.window.setMode(960, 540)
    icon = love.image.newImageData("icon.png")
    love.window.setIcon(icon)
    love.window.setTitle("Lovely Engine by Vinny v0.2")
    log.info("Love2d window created successfully")

    log.info("Checking if projects folder exists...")
    os.execute("mkdir -p ./projects")

    log.info("Starting nuklear...")
    ui = nuklear.newUI()
    log.info("Nuklear started successfully")

    welcome = true
    new = false
    closed = true

    projects = love.filesystem.getDirectoryItems("projects")
    plugins = love.filesystem.getDirectoryItems("plugins")

    newProject = {value = ""}
    command = {value = ""}

    projectDirectory = {}

    openProject = ""
    thumbnail = ""
    output = ""
    currentDirectory = ""
end

-- Function to refresh the projects table
function updateProjects()
    log.info("Updating projects list...")
    projects = love.filesystem.getDirectoryItems("projects")
    projectDirectory = love.filesystem.getDirectoryItems("projects/" .. openProject)
    log.info("Projects list updated")
end

-- Function to execute system commands and format the output
function execute(cmd, raw)
    log.info("Executing system command...")
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    log.info("System command executed successfully")
    return s
end

-- Function to create exported versions of the game using the installed modules
function package()
    -- Create releases folder
    log.info("Checking if releases folder exists...")
    os.execute("mkdir -p ./projects/" .. openProject .. "/releases")
    -- Create .love file
    log.info("Creating game.love file...")
    os.execute("cd ./projects/" .. openProject .. " && zip -9 -r game.love . > /dev/null && mv game.love ../../")
    log.info("File game.love created successfully")
    -- Create win32 release
    if love.filesystem.getInfo("export/win32") ~= nil then
        log.info("Found win32 export template, packaging...")
        os.execute("cat ./export/win32/love.exe game.love > game.exe")
        os.execute("cp -r ./export/win32/template win32")
        os.execute("mv game.exe win32")
        os.execute("zip -9 -r win32.zip win32 > /dev/null")
        os.execute("rm -rf win32")
        os.execute("mv win32.zip ./projects/" .. openProject .. "/releases")
        log.info("Exported win32 and placed it in ./projects/" .. openProject .. "/releases")
    else
        log.warn("Export template not found: win32")
    end
    -- Create win64 release
    if love.filesystem.getInfo("export/win64") ~= nil then
        log.info("Found win64 export template, packaging...")
        os.execute("cat ./export/win64/love.exe game.love > game.exe")
        os.execute("cp -r ./export/win64/template win64")
        os.execute("mv game.exe win64")
        os.execute("zip -9 -r win64.zip win64 > /dev/null")
        os.execute("rm -rf win64")
        os.execute("mv win64.zip ./projects/" .. openProject .. "/releases")
        log.info("Exported win64 and placed it in ./projects/" .. openProject .. "/releases")
    else
        log.warn("Export template not found: win64")
    end
    -- Create macos release
    if love.filesystem.getInfo("export/macos") ~= nil then
        log.info("Found macos export template, packaging...")
        os.execute("cp -r ./export/macos/template game.app")
        os.execute("cp game.love ./game.app/Contents/Resources")
        os.execute("zip -9 -r -y macos.zip game.app > /dev/null")
        os.execute("rm -rf game.app")
        os.execute("mv macos.zip ./projects/" .. openProject .. "/releases")
        log.info("Exported macos and placed it in ./projects/" .. openProject .. "/releases")
    else
        log.warn("Export template not found: macos")
    end
    -- Create linux32 release
    if love.filesystem.getInfo("export/linux32") ~= nil then
        log.info("Found linux32 export template, packaging...")
        os.execute("cp -r ./export/linux32 linux32")
        os.execute("cp game.love linux32")
        os.execute("zip -9 -r linux32.zip linux32 > /dev/null")
        os.execute("rm -rf linux32")
        os.execute("mv linux32.zip ./projects/" .. openProject .. "/releases")
        log.info("Exported linux32 and placed it in ./projects/" .. openProject .. "/releases")
    else
        log.warn("Export template not found: linux32")
    end
    -- Create linux64 release
    if love.filesystem.getInfo("export/linux64") ~= nil then
        log.info("Found linux64 export template, packaging...")
        os.execute("cp -r ./export/linux64 linux64")
        os.execute("cp game.love linux64")
        os.execute("zip -9 -r linux64.zip linux64 > /dev/null")
        os.execute("rm -rf linux64")
        os.execute("mv linux64.zip ./projects/" .. openProject .. "/releases")
        log.info("Exported linux64 and placed it in ./projects/" .. openProject .. "/releases")
    else
        log.warn("Export template not found: linux64")
    end
    -- Create web release
    if love.filesystem.getInfo("export/web") ~= nil then
        log.info("Found web export template, packaging...")
        os.execute("./export/web/node ./export/web/index.js game.love game -c -t game")
        os.execute("zip -9 -r web.zip game > /dev/null")
        os.execute("rm -rf game")
        os.execute("mv web.zip ./projects/" .. openProject .. "/releases")
        log.info("Exported web and placed it in ./projects/" .. openProject .. "/releases")
    else
        log.warn("Export template not found: web")
    end
    -- Move game.love in releases folder
    os.execute("mv game.love ./projects/" .. openProject .. "/releases")
    log.info("Placed game.love in ./projects/" .. openProject .. "/releases")
end

-- Love2d callback: runs every frame
function love.update(dt)
    ui:frameBegin()

    -- Projects window
    if ui:windowBegin("Projects", 0, 0, 200, 540, "border", "title", "scrollbar", "scroll auto hide") then
        ui:layoutRow("dynamic", 50, 2)

        if ui:button("New") then
            new = true
            log.info("Requested new project panel...")
        end

        if ui:button("Refresh") then
            updateProjects()
        end

        if new == true then
            ui:layoutRow("dynamic", 50, 1)
            ui:spacing(1)
            ui:label("Enter name:")
            ui:edit("simple", newProject)

            if ui:button("Create") then
                os.execute("cp -r template ./projects/" .. newProject["value"])
                log.info("Created new project named " .. newProject["value"])
                newProject["value"] = ""
                new = false
                updateProjects()
                log.info("Closed new project panel")
            end

            if ui:button("Cancel") then
                new = false
                newProject["value"] = ""
                log.info("Closed new project panel")
            end
        end

        ui:spacing(1)
        ui:layoutRow("dynamic", 50, 1)
        ui:label("Existing projects:")

        for k, v in pairs(projects) do
            if ui:button(v) then
                openProject = v

                if love.filesystem.getInfo("projects/" .. openProject .. "/thumbnail.png") ~= nil then
                    thumbnail = love.graphics.newImage("projects/" .. openProject .. "/thumbnail.png")
                    log.info("Thumbnail found")
                else
                    if love.filesystem.getInfo("projects/" .. openProject .. "/default.png") ~= nil then
                        thumbnail = love.graphics.newImage("projects/" .. openProject .. "/default.png")
                        log.warn("Thumbnail not found, loaded default one")
                    else
                        log.error("Thumbnail default.png not found")
                    end
                end

                projectDirectory = love.filesystem.getDirectoryItems("projects/" .. openProject)
                log.info("Opened project " .. v)
            end
        end
    end
    ui:windowEnd()

    -- Check if the welcome page needs to be displayed
    if openProject == "" then
        welcome = true
    else
        welcome = false
    end

    -- If yes create welcome window, else create the project window
    if welcome == true then
        if ui:windowBegin("Welcome", 200, 0, 560, 540, "border", "background") then
            ui:layoutRow("dynamic", 50, 1)
            ui:spacing(4)
            ui:label("Welcome to Lovely Engine! To start open or create a new project :)", "centered")
        end
        ui:windowEnd()
    else
        if ui:windowBegin("Project", 200, 0, 560, 540, "border", "background", "scrollbar", "scroll auto hide") then
            ui:layoutRow("dynamic", 50, 1)
            ui:label(openProject, "centered")

            if thumbnail ~= "" then
                ui:layoutRow("dynamic", 300, 1)
                ui:image(thumbnail)
            end

            ui:layoutRow("dynamic", 50, 2)
            ui:spacing(1)
            ui:spacing(1)

            if ui:button("Run") then
                log.info("Running " .. openProject .. "...")
                os.execute("./love ./projects/" .. openProject)
                log.info("Finished running " .. openProject)
            end

            if ui:button("Delete") then
                os.execute("rm -rf ./projects/" .. openProject)
                openProject = ""
                updateProjects()
                ui:windowSetScroll(0, 0)
                projectDirectory = {}
                log.info("Deleted " .. openProject)
            end

            if ui:button("Package") then
                log.info("Starting packaging routine...")
                package()
                log.info("Finished packaging")
            end

            if ui:button("Close") then
                log.info("Closed " .. openProject)
                openProject = ""
                ui:windowSetScroll(0, 0)
                projectDirectory = {}
            end

            ui:spacing(1)
            ui:spacing(1)
        end
        ui:windowEnd()
    end

    -- Project Directory window
    if ui:windowBegin("Project Directory", 760, 0, 200, 270, "border", "title", "scrollbar", "scroll auto hide") then
        ui:layoutRow("dynamic", 25, 1)

        if ui:button("Back to top") then
            currentDirectory = ""
            projectDirectory = love.filesystem.getDirectoryItems("projects/" .. openProject)
            log.info("Reset directory path")
        end

        ui:spacing(1)

        for k, v in pairs(projectDirectory) do
            if ui:button(v) then
                currentDirectory = currentDirectory .. v .. "/"
                projectDirectory = love.filesystem.getDirectoryItems("projects/" .. openProject .. "/" .. currentDirectory)
                log.info("Opened directory projects/" .. openProject .. "/" .. currentDirectory)
            end
        end
    end
    ui:windowEnd()

    -- Plugins window
    if ui:windowBegin("Plugins", 760, 270, 200, 270, "border", "title", "scrollbar", "scroll auto hide") then
        ui:layoutRow("dynamic", 50, 1)

        for k, v in pairs(plugins) do
            filename = v:gsub("%.lua", "")

            if ui:button(filename) then
                require("plugins/" .. filename).start()
                log.info("Executed plugin " .. v)
            end
        end
    end
    ui:windowEnd()

    -- If closed is true create open terminal window, else create the terminal and input windows
    if closed == true then
        if ui:windowBegin("Open Terminal", 200, 478, 560, 62, "border") then
            ui:layoutRow("dynamic", 50, 8)
            ui:label("Terminal")
            ui:spacing(1)
            ui:spacing(1)
            ui:spacing(1)
            ui:spacing(1)
            ui:spacing(1)
            ui:spacing(1)

            if ui:button("+") then
                closed = false
                log.info("Opened terminal")
            end
        end
        ui:windowEnd()
    else
        if ui:windowBegin("Terminal", 200, 340, 560, 138, "border", "title") then
            ui:layoutRow("dynamic", 50, 1)
            ui:label(output)
        end
        ui:windowEnd()

        if ui:windowBegin("Input", 200, 478, 560, 62, "border") then
            ui:layoutRow("dynamic", 50, 4)

            if ui:button("Close") then
                closed = true
                log.info("Closed terminal")
            end

            if ui:button("Clear") then
                output = ""
                log.info("Cleared terminal output")
            end

            ui:edit("simple", command)

            if ui:button("Enter") then
                output = execute(command["value"], false)

                if output == "" then
                    output = "No ouput for this command"
                end

                log.info("Executed command " .. command["value"])
                command["value"] = ""
            end
        end
        ui:windowEnd()
    end

    ui:frameEnd()
end

-- Love2d callback: runs every frame and is used to draw things on screen
function love.draw()
    ui:draw()
end

-- Love2d callbacks used by nuklear to handle input
function love.keypressed(key, scancode, isrepeat)
    ui:keypressed(key, scancode, isrepeat)
    log.debug("NUKLEAR: Key " .. key .. " pressed")
end

function love.keyreleased(key, scancode)
    ui:keyreleased(key, scancode)
    log.debug("NUKLEAR: Key " .. key .. " released")
end

function love.mousepressed(x, y, button, istouch, presses)
    ui:mousepressed(x, y, button, istouch, presses)
    log.debug("NUKLEAR: Mouse button " .. button .. " pressed")
end

function love.mousereleased(x, y, button, istouch, presses)
    ui:mousereleased(x, y, button, istouch, presses)
    log.debug("NUKLEAR: Mouse button " .. button .. " released")
end

function love.mousemoved(x, y, dx, dy, istouch)
    ui:mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
    ui:textinput(text)
    log.debug("NUKLEAR: Text input")
end

function love.wheelmoved(x, y)
    ui:wheelmoved(x, y)
end