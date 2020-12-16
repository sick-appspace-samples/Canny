--[[----------------------------------------------------------------------------

  Application Name:
  Canny

  Summary:
  Extraction of edges in image, both strong and weak.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage.
  Restarting the Sample may be necessary to show images after loading the webpage.
  To run this Sample a device with SICK Algorithm API and AppEngine >= V2.5.0 is
  required. For example SIM4000 with latest firmware. Alternatively the Emulator
  in AppStudio 2.3 or higher can be used.

  More Information:
  Tutorial "Algorithms - Filtering and Arithmetic".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 700 -- ms between visualization steps for demonstration purpose

-- Creating viewer
local viewer = View.create("viewer2D1")

-- Setting up graphical overlay attributes
local decoration = View.ShapeDecoration.create()
decoration:setLineColor(0, 230, 0) -- Green

local textDecoration = View.TextDecoration.create()
textDecoration:setSize(50)
textDecoration:setPosition(20, 50)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  viewer:clear()
  local img = Image.load('resources/Canny.bmp')
  viewer:addImage(img)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Removing salt/pepper noise before Canny
  local img2 = Image.median(img, 5)
  viewer:addImage(img2)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Applying Canny filter, step 1: Changing high threshold to see its effect
  local lowThrStart = 15
  local highThrStart = 15
  local highThrStop = 25

  for i = highThrStart, highThrStop, 1 do
    local img3 = img2:canny(i, lowThrStart)
    viewer:clear()
    local imageID = viewer:addImage(img3)
    viewer:addText('Thresholds = ' .. i .. ', ' .. lowThrStart, textDecoration, nil, imageID)
    viewer:present() -- presenting single steps
    Script.sleep(DELAY) -- for demonstration purpose only
  end

  -- Applying Canny filter, step 2: Changing low threshold to see its effect
  local lowThrStop = 10

  for i = lowThrStart, lowThrStop, -1 do
    local img3 = img2:canny(highThrStop, i)
    viewer:clear()
    local imageID = viewer:addImage(img3)
    viewer:addText('Thresholds = ' .. highThrStop .. ', ' .. i, textDecoration, nil, imageID)
    viewer:present() -- presenting single steps
    Script.sleep(DELAY) -- for demonstration purpose only
  end

  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
