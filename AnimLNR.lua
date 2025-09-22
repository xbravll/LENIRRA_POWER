pcall(function()

if not game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character:WaitForChild("Humanoid").RigType ~= Enum.HumanoidRigType.R15 then 
    game.StarterGui:SetCore("SendNotification", {Title = "R6", Text = "You're on R6, bro. Change to R15!", Duration = 60})
    return 
end

-- Variables and Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
cloneref = cloneref or function(o) return o end
local LNRGoGui = cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = game.Workspace.CurrentCamera

-- States
local guiVisible = false

local st = os.clock()
local Notifbro = {}

-- Notification System
function Notify(titletxt, text, time)
    coroutine.wrap(function()
        local GUI = Instance.new("ScreenGui")
        local Main = Instance.new("Frame", GUI)
        local title = Instance.new("TextLabel", Main)
        local message = Instance.new("TextLabel", Main)

        GUI.Name = "BackgroundNotif"
        GUI.Parent = LNRGoGui

        local sw = workspace.CurrentCamera.ViewportSize.X
        local sh = workspace.CurrentCamera.ViewportSize.Y
        local nh = sh / 7
        local nw = sw / 5

        Main.Name = "MainFrame"
        Main.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Main.BackgroundTransparency = 0.2
        Main.BorderSizePixel = 0
        Main.Size = UDim2.new(0, nw, 0, nh)

        title.BackgroundColor3 = Color3.new(0, 0, 0)
        title.BackgroundTransparency = 0.9
        title.Size = UDim2.new(1, 0, 0, nh / 2)
        title.Font = Enum.Font.GothamBold
        title.Text = titletxt
        title.TextColor3 = Color3.new(1, 1, 1)
        title.TextScaled = true

        message.BackgroundColor3 = Color3.new(0, 0, 0)
        message.BackgroundTransparency = 1
        message.Position = UDim2.new(0, 0, 0, nh / 2)
        message.Size = UDim2.new(1, 0, 1, -nh / 2)
        message.Font = Enum.Font.Gotham
        message.Text = text
        message.TextColor3 = Color3.new(1, 1, 1)
        message.TextScaled = true

        local offset = 50
        for _, notif in ipairs(Notifbro) do
            offset = offset + notif.Size.Y.Offset + 10
        end

        Main.Position = UDim2.new(1, 5, 0, offset)
        table.insert(Notifbro, Main)

        task.wait(0.1)
        Main:TweenPosition(UDim2.new(1, -nw, 0, offset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.5, true)
        task.wait(0.1)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.2, true)

        task.wait(time)

        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenPosition(UDim2.new(1, 5, 0, offset), Enum.EasingDirection.In, Enum.EasingStyle.Bounce, 0.5, true)
        task.wait(0.1)

        GUI:Destroy()
        for i, notif in ipairs(Notifbro) do
            if notif == Main then
                table.remove(Notifbro, i)
                break
            end
        end

        for i, notif in ipairs(Notifbro) do
            local newOffset = 50 + (nh + 10) * (i - 1)
            notif:TweenPosition(UDim2.new(1, -nw, 0, newOffset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        end
    end)()
end

task.wait(0.1)

local guiName = "LNRVerificator"

if LNRGoGui:FindFirstChild(guiName) then
    Notify("Error","Script Already Executed", 1)
    return
end

-- Create Modern GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LNRModernHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LNRGoGui

-- Create verificator to prevent multiple executions
local verificator = Instance.new("Frame")
verificator.Name = guiName
verificator.Visible = false
verificator.Parent = screenGui

print("Creating Mobile Toggle Button...")

-- Mobile Toggle Button (Floating)
local mobileToggle = Instance.new("TextButton")
mobileToggle.Name = "MobileToggle"
mobileToggle.Size = UDim2.new(0, 60, 0, 60)
mobileToggle.Position = UDim2.new(1, -80, 0, 100)
mobileToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
mobileToggle.BorderSizePixel = 0
mobileToggle.Text = "⚡"
mobileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileToggle.TextSize = 28
mobileToggle.Font = Enum.Font.GothamBold
mobileToggle.Active = true
mobileToggle.Draggable = true
mobileToggle.Parent = screenGui

-- Make toggle button circular
local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0.5, 0)
mobileCorner.Parent = mobileToggle

-- Add gradient to mobile button
local mobileGradient = Instance.new("UIGradient")
mobileGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 160, 255))
}
mobileGradient.Parent = mobileToggle

print("Creating Main Frame...")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 750)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -375)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ LENNIRAxZONE Hub 1.0"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 22
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -50, 0, 7.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 28
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 10)
closeBtnCorner.Parent = closeBtn

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 70)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabFrame

-- Tabs
local tabs = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "Emotes", "Donate"}
local tabButtons = {}
local contentFrames = {}
local activeTab = 1

-- Create tab buttons
for i, tabName in pairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -2, 1, -4)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 1, 0, 2)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(50, 50, 50)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = 10
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = tabFrame
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 6)
    tabBtnCorner.Parent = tabBtn
    
    tabButtons[i] = tabBtn
end

-- Search Bar
local searchBar = Instance.new("TextBox")
searchBar.Name = "SearchBar"
searchBar.Size = UDim2.new(1, -20, 0, 35)
searchBar.Position = UDim2.new(0, 10, 0, 120)
searchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchBar.BorderSizePixel = 0
searchBar.Text = ""
searchBar.PlaceholderText = "🔍 Search animations..."
searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBar.TextSize = 14
searchBar.Font = Enum.Font.Gotham
searchBar.ClearTextOnFocus = false
searchBar.Parent = mainFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchBar

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -20, 1, -175)
contentArea.Position = UDim2.new(0, 10, 0, 165)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Create content frames for each tab
for i = 1, #tabs do
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Visible = i == 1
    contentFrame.Parent = contentArea
    
    contentFrames[i] = contentFrame
end

print("Creating Animation Data...")

-- Animation Variables
local CurrentIdle = "None"
local CurrentWalk = "None"
local CurrentRun = "None"
local CurrentJump = "None"
local CurrentFall = "None"
local CurrentSwimIdle = "None"
local CurrentSwim = "None"
local CurrentClimb = "None"

local Players = game:GetService("Players")
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Animate = Char.Animate
local lastAnimations = {}

-- Animation Data
local Animations = {
    Idle = {
        ["2016 Animation (mm2)"] = {"387947158", "387947464"},
        ["Oh Really?"] = {"98004748982532", "98004748982532"},
        Astronaut = {"891621366", "891633237"},
        ["Adidas Community"] = {"122257458498464", "102357151005774"},
        Bold = {"16738333868", "16738334710"},
        Sans = {"123627677663418", "123627677663418"},
        Sans2 = {"113203077347750", "113203077347750"},
        Magician = {"139433213852503", "139433213852503"},
        ["John Doe"] = {"72526127498800", "72526127498800"},
        Noli = {"139360856809483", "139360856809483"},
        Coolkid = {"95203125292023", "95203125292023"},
        ["Survivor Injured"] = {"73905365652295", "73905365652295"},
        ["1x1x1x1"] = {"76780522821306", "76780522821306"},
        Borock = {"3293641938", "3293642554"},
        Kaneki = {"133277876379233", "133277876379233"},
        Bubbly = {"910004836", "910009958"},
        Cartoony = {"742637544", "742638445"},
        Confident = {"1069977950", "1069987858"},
        ["Catwalk Glam"] = {"133806214992291","94970088341563"},
        Cowboy = {"1014390418", "1014398616"},
        ["Drooling Zombie"] = {"3489171152", "3489171152"},
        Elder = {"10921101664", "10921102574"},
        Ghost = {"616006778","616008087"},
        Knight = {"657595757", "657568135"},
        Levitation = {"616006778", "616008087"},
        Mage = {"707742142", "707855907"},
        MrToilet = {"4417977954", "4417978624"},
        Ninja = {"656117400", "656118341"},
        NFL = {"92080889861410", "74451233229259"},
        OldSchool = {"10921230744", "10921232093"},
        Patrol = {"1149612882", "1150842221"},
        Pirate = {"750781874", "750782770"},
        ["Default Retarget"] = {"95884606664820", "95884606664820"},
        ["Very Long"] = {"18307781743", "18307781743"},
        Sway = {"560832030", "560833564"},
        Popstar = {"1212900985", "1150842221"},
        Princess = {"941003647", "941013098"},
        R6 = {"12521158637","12521162526"},
        ["R15 Reanimated"] = {"4211217646", "4211218409"},
        Realistic = {"17172918855", "17173014241"},
        Robot = {"616088211", "616089559"},
        Sneaky = {"1132473842", "1132477671"},
        ["Sports (Adidas)"] = {"18537376492", "18537371272"},
        Soldier = {"3972151362", "3972151362"},
        Stylish = {"616136790", "616138447"},
        ["Stylized Female"] = {"4708191566", "4708192150"},
        Superhero = {"10921288909", "10921290167"},
        Toy = {"782841498", "782845736"},
        Udzal = {"3303162274", "3303162549"},
        Vampire = {"1083445855", "1083450166"},
        Werewolf = {"1083195517", "1083214717"},
        ["Wicked (Popular)"] = {"118832222982049", "76049494037641"},
        ["No Boundaries (Walmart)"] = {"18747067405", "18747063918"},
        Zombie = {"616158929", "616160636"},
        ZombieUGC = {"77672872857991", "77672872857991"},
        TailWag = {"129026910898635", "129026910898635"},
    },
    Walk = {
        Gojo = "95643163365384",
        Geto = "85811471336028",
        Astronaut = "891667138",
        ZombieUGC = "113603435314095",
        ["Adidas Community"] = "122150855457006",
        Bold = "16738340646",
        Bubbly = "910034870",
        Smooth = "76630051272791",
        Cartoony = "742640026",
        Confident = "1070017263",
        Cowboy = "1014421541",
        ["Catwalk Glam"] = "109168724482748",
        ["Drooling Zombie"] = "3489174223",
        Elder = "10921111375",
        Ghost = "616013216",
        Knight = "10921127095",
        Levitation = "616013216",
        Mage = "707897309",
        Ninja = "656121766",
        NFL = "110358958299415",
        OldSchool = "10921244891",
        Patrol = "1151231493",
        Pirate = "750785693",
        ["Default Retarget"] = "115825677624788",
        Popstar = "1212980338",
        Princess = "941028902",
        R6 = "12518152696",
        ["R15 Reanimated"] = "4211223236",
        ["2016 Animation (mm2)"] = "387947975",
        Robot = "616095330",
        Sneaky = "1132510133",
        ["Sports (Adidas)"] = "18537392113",
        Stylish = "616146177",
        ["Stylized Female"] = "4708193840",
        Superhero = "10921298616",
        Toy = "782843345",
        Udzal = "3303162967",
        Vampire = "1083473930",
        Werewolf = "1083178339",
        ["Wicked (Popular)"] = "92072849924640",
        ["No Boundaries (Walmart)"] = "18747074203",
        Zombie = "616168032",
    },
    Run = {
        ["2016 Animation (mm2)"] = "387947975",
        Soccer = "116881956670910",
        ["Adidas Community"] = "82598234841035",
        Astronaut = "10921039308",
        Naruto = "104074120169874",
        Bold = "16738337225",
        Bubbly = "10921057244",
        Cartoony = "10921076136",
        Dog = "130072963359721",
        Confident = "1070001516",
        Lagging = "71095688469567",
        Cowboy = "1014401683",
        ["Catwalk Glam"] = "81024476153754",
        ["Drooling Zombie"] = "3489173414",
        Elder = "10921104374",
        Ghost = "616013216",
        ["Heavy Run (Udzal / Borock)"] = "3236836670",
        Knight = "10921121197",
        Levitation = "616010382",
        Mage = "10921148209",
        MrToilet = "4417979645",
        Ninja = "656118852",
        NFL = "117333533048078",
        OldSchool = "10921240218",
        Patrol = "1150967949",
        Pirate = "750783738",
        ["Default Retarget"] = "102294264237491",
        Popstar = "1212980348",
        Princess = "941015281",
        R6 = "12518152696",
        ["R15 Reanimated"] = "4211220381",
        Robot = "10921250460",
        Sneaky = "1132494274",
        ["Sports (Adidas)"] = "18537384940",
        Stylish = "10921276116",
        ["Stylized Female"] = "4708192705",
        Superhero = "10921291831",
        Toy = "10921306285",
        Vampire = "10921320299",
        Werewolf = "10921336997",
        ["Wicked (Popular)"] = "72301599441680",
        ["No Boundaries (Walmart)"] = "18747070484",
        Zombie = "616163682",
    },
    Jump = {
        Astronaut = "891627522",
        ["Adidas Community"] = "656117878",
        Bold = "16738336650",
        Bubbly = "910016857",
        Cartoony = "742637942",
        ["Catwalk Glam"] = "116936326516985",
        Confident = "1069984524",
        Cowboy = "1014394726",
        Elder = "10921107367",
        Ghost = "616008936",
        Knight = "910016857",
        Levitation = "616008936",
        Mage = "10921149743",
        Ninja = "656117878",
        NFL = "119846112151352",
        OldSchool = "10921242013",
        Patrol = "1148811837",
        Pirate = "750782230",
        ["Default Retarget"] = "117150377950987",
        Popstar = "1212954642",
        Princess = "941008832",
        Robot = "616090535",
        ["R15 Reanimated"] = "4211219390",
        R6 = "12520880485",
        Sneaky = "1132489853",
        ["Sports (Adidas)"] = "18537380791",
        Stylish = "616139451",
        ["Stylized Female"] = "4708188025",
        Superhero = "10921294559",
        Toy = "10921308158",
        Vampire = "1083455352",
        Werewolf = "1083218792",
        ["Wicked (Popular)"] = "104325245285198",
        ["No Boundaries (Walmart)"] = "18747069148",
        Zombie = "616161997",
    },
    Fall = {
        Astronaut = "891617961",
        ["Adidas Community"] = "98600215928904",
        Bold = "16738333171",
        Bubbly = "910001910",
        Cartoony = "742637151",
        ["Catwalk Glam"] = "92294537340807",
        Confident = "1069973677",
        Cowboy = "1014384571",
        Elder = "10921105765",
        Knight = "10921122579",
        Levitation = "616005863",
        Mage = "707829716",
        Ninja = "656115606",
        NFL = "129773241321032",
        OldSchool = "10921241244",
        Patrol = "1148863382",
        Pirate = "750780242",
        ["Default Retarget"] = "110205622518029",
        Popstar = "1212900995",
        Princess = "941000007",
        Robot = "616087089",
        ["R15 Reanimated"] = "4211216152",
        R6 = "12520972571",
        Sneaky = "1132469004",
        ["Sports (Adidas)"] = "18537367238",
        Stylish = "616134815",
        ["Stylized Female"] = "4708186162",
        Superhero = "10921293373",
        Toy = "782846423",
        Vampire = "1083443587",
        Werewolf = "1083189019",
        ["Wicked (Popular)"] = "121152442762481",
        ["No Boundaries (Walmart)"] = "18747062535",
        Zombie = "616157476",
    },
    SwimIdle = {
        Astronaut = "891663592",
        ["Adidas Community"] = "109346520324160",
        Bold = "16738339817",
        Bubbly = "910030921",
        Cartoony = "10921079380",
        ["Catwalk Glam"] = "98854111361360",
        Confident = "1070012133",
        CowBoy = "1014411816",
        Elder = "10921110146",
        Mage = "707894699",
        Ninja = "656118341",
        NFL = "79090109939093",
        Patrol = "1151221899",
        Knight = "10921125935",
        OldSchool = "10921244018",
        Levitation = "10921139478",
        Popstar = "1212998578",
        Princess = "941025398",
        Pirate = "750785176",
        R6 = "12518152696",
        Robot = "10921253767",
        Sneaky = "1132506407",
        ["Sports (Adidas)"] = "18537387180",
        Stylish = "10921281964",
        Stylized = "4708190607",
        SuperHero = "10921297391",
        Toy = "10921310341",
        Vampire = "10921325443",
        Werewolf ="10921341319",
        ["Wicked (Popular)"] = "113199415118199",
        ["No Boundaries (Walmart)"] = "18747071682",
    },
    Swim = {
        Astronaut = "891663592",
        ["Adidas Community"] = "133308483266208",
        Bubbly = "910028158",
        Bold = "16738339158",
        Cartoony = "10921079380",
        ["Catwalk Glam"] = "134591743181628",
        CowBoy = "1014406523",
        Confident = "1070009914",
        Elder = "10921108971",
        Knight = "10921125160",
        Mage = "707876443",
        NFL = "132697394189921",
        OldSchool = "10921243048",
        PopStar = "1212998578",
        Princess = "941018893",
        Pirate = "750784579",
        Patrol = "1151204998",
        R6 = "12518152696",
        Robot = "10921253142",
        Levitation = "10921138209",
        Stylish = "10921281000",
        SuperHero = "10921295495",
        Sneaky = "1132500520",
        ["Sports (Adidas)"] = "18537389531",
        Toy = "10921309319",
        Vampire = "10921324408",
        Werewolf = "10921340419",
        ["Wicked (Popular)"] = "99384245425157",
        ["No Boundaries (Walmart)"] = "18747073181",
        Zombie = "616165109",
    },
    Climb = {
        Astronaut = "10921032124",
        ["Adidas Community"] = "88763136693023",
        Bold = "16738332169",
        Cartoony = "742636889",
        ["Catwalk Glam"] = "119377220967554",
        Confident = "1069946257",
        CowBoy = "1014380606",
        Elder = "845392038",
        Ghost = "616003713",
        Knight = "10921125160",
        Levitation = "10921132092",
        Mage = "707826056",
        Ninja = "656114359",
        NFL = "134630013742019",
        OldSchool = "10921229866",
        Patrol = "1148811837",
        Popstar = "1213044953",
        Princess = "940996062",
        R6 = "12520982150",
        ["Reanimated R15"] = "4211214992",
        Robot = "616086039",
        Sneaky = "1132461372",
        ["Sports (Adidas)"] = "18537363391",
        Stylish = "10921271391",
        ["Stylized Female"] = "4708184253",
        SuperHero = "10921286911",
        Toy = "10921300839",
        Vampire = "1083439238",
        WereWolf = "10921329322",
        ["Wicked (Popular)"] = "131326830509784",
        ["No Boundaries (Walmart)"] = "18747060903",
        Zombie = "616156119"
    }
}

print("Loading Animation Functions...")

-- Helper Functions
local function Wait1()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    while humanoid.Health <= 2 do
        task.wait(0.3)
    end
end

local function Wait2()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    while humanoid:GetState() == Enum.HumanoidStateType.Dead or 
          humanoid:GetState() == Enum.HumanoidStateType.Ragdoll do
        task.wait(0.3)
    end
end

local function StopAnim()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
end

local function refresh()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

local function refreshswim()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    task.wait(0.1)
    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
end

local function refreshclimb()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    task.wait(0.1)
    humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
end

-- Reset Functions
local function ResetIdle()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    pcall(function()
        local Animate = Char.Animate
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=0"
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=0"
    end)
end

local function ResetWalk()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    pcall(function()
        local Animate = Char.Animate
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    end)
end

local function ResetRun()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    task.wait(0.1)
    pcall(function()
        local Animate = Char.Animate
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    end)
end

local function ResetJump()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    task.wait(0.1)
    pcall(function()
        local Animate = Char.Animate
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    end)
end

local function ResetFall()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    pcall(function()
        local Animate = Char.Animate
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    end)
end

local function ResetSwim()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    pcall(function()
        local Animate = Char.Animate
        if Animate.swim then
            Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=0"
        end
    end)
end

local function ResetSwimIdle()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    pcall(function()
        local Animate = Char.Animate
        if Animate.swimidle then
            Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=0"
        end
    end)
end

local function ResetClimb()
    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
    for _, v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
    pcall(function()
        local Animate = Char.Animate
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
    end)
end

-- Freeze/Unfreeze Functions
local function freeze()
    local player = cloneref(game:GetService("Players")).LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.PlatformStand = true
    
    if player and player.Character then
        task.spawn(function()
            for i, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and not part.Anchored then
                    part.Anchored = true
                end
            end
        end)
    end
end

local function unfreeze()
    local player = cloneref(game:GetService("Players")).LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.PlatformStand = false
    
    if player and player.Character then
        task.spawn(function()
            for i, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Anchored then
                    part.Anchored = false
                end
            end
        end)
    end
end

-- Main Animation Setting Function
local function setAnimation(animationType, animationId)
    local function saveLastAnimations()
        local data = HttpService:JSONEncode(lastAnimations)
        writefile("MeWhenUrMom.json", data)
    end

    local speaker = Players.LocalPlayer
    local Char = speaker.Character
    local Animate = Char:FindFirstChild("Animate")

    if not Animate then return end
    
    freeze()
    task.wait(0.1)

    if animationType == "Idle" then
        lastAnimations.Idle = animationId
        ResetIdle()
        Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId[1]
        Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId[2]
        refresh()
    elseif animationType == "Walk" then
        lastAnimations.Walk = animationId
        ResetWalk()
        Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId
        refresh()
    elseif animationType == "Run" then
        lastAnimations.Run = animationId
        ResetRun()
        Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId
        refresh()
    elseif animationType == "Jump" then
        lastAnimations.Jump = animationId
        ResetJump()
        Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId
        refresh()
    elseif animationType == "Fall" then
        lastAnimations.Fall = animationId
        ResetFall()
        Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId
        refresh()
    elseif animationType == "Swim" then
        lastAnimations.Swim = animationId
        if Animate.swim then
            ResetSwim()
            Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId
            refreshswim()
        end
    elseif animationType == "SwimIdle" then
        lastAnimations.SwimIdle = animationId
        if Animate.swimidle then
            ResetSwimIdle()
            Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId
            refreshswim()
        end
    elseif animationType == "Climb" then
        lastAnimations.Climb = animationId
        ResetClimb()
        Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=" .. animationId
        refreshclimb()
    end  
    saveLastAnimations()
    task.wait(0.1)
    unfreeze()
end

-- Emote Functions
local function PlayEmote(animationId)
    StopAnim()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId
    local animationTrack = humanoid:LoadAnimation(animation)
    animationTrack:Play()
    local function onMoved()
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            animationTrack:Stop()
        end
    end
    local checkMovement = game:GetService("RunService").RenderStepped:Connect(onMoved)
end

local function ZeroPlayEmote(animationId)
    StopAnim()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId
    local animationTrack = humanoid:LoadAnimation(animation)
    animationTrack:Play()
    animationTrack:AdjustSpeed(0)
    local function onMoved()
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            animationTrack:Stop()
        end
    end
    local checkMovement = game:GetService("RunService").RenderStepped:Connect(onMoved)
end

local function FPlayEmote(animationId)
    StopAnim()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:wait(0.1)
    local humanoid = character:WaitForChild("Humanoid")
    
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId
    local animationTrack = humanoid:LoadAnimation(animation)
    animationTrack:Play()
    
    local function freezeAnimation()
        animationTrack:AdjustSpeed(0)
    end
    task.delay(animationTrack.Length * 0.9, freezeAnimation)

    local function onMoved()
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            animationTrack:Stop()
        end
    end
    
    local checkMovement = game:GetService("RunService").RenderStepped:Connect(onMoved)
end

-- Buy Function
local function Buy(gamePassID)
    local MarketplaceService = game:GetService("MarketplaceService")
    local success, errorMessage = pcall(function()
        MarketplaceService:PromptGamePassPurchase(game:GetService("Players").LocalPlayer, gamePassID)
    end)
    
    if not success then
        setclipboard("https://www.roblox.com/game-pass/" .. gamePassID)
        Notify("Copied", "Gamepass Link", 5)
    end
end

-- Load Saved Animations
local function loadLastAnimations()
    print("Checking if MeWhenUrMom.json exists...")
    if isfile("MeWhenUrMom.json") then
        local data = readfile("MeWhenUrMom.json")
        Notify("Yippe", "Saved Animation Found, loading it", 10)

        local lastAnimationsData = HttpService:JSONDecode(data)
        if lastAnimationsData.Idle then setAnimation("Idle", lastAnimationsData.Idle) end
        if lastAnimationsData.Walk then setAnimation("Walk", lastAnimationsData.Walk) end
        if lastAnimationsData.Run then setAnimation("Run", lastAnimationsData.Run) end
        if lastAnimationsData.Jump then setAnimation("Jump", lastAnimationsData.Jump) end
        if lastAnimationsData.Fall then setAnimation("Fall", lastAnimationsData.Fall) end
        if lastAnimationsData.Climb then setAnimation("Climb", lastAnimationsData.Climb) end
        if lastAnimationsData.Swim then setAnimation("Swim", lastAnimationsData.Swim) end
        if lastAnimationsData.SwimIdle then setAnimation("SwimIdle", lastAnimationsData.SwimIdle) end
    else
        Notify("First?", "No Saved Animations Found", 5)
    end
end

print("Creating UI Components...")

-- Create Feature Frame Helper
local function createFeatureFrame(parent, yPos, height)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, height or 60)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    return frame
end

-- Create Animation Button
local function createAnimButton(parent, animName, animType, animId, yPos)
    local frame = createFeatureFrame(parent, yPos, 60)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = animName
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 40)
    button.Position = UDim2.new(1, -110, 0.5, -20)
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    button.BorderSizePixel = 0
    button.Text = "Apply"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        setAnimation(animType, animId)
        Notify(animType, animName, 1)
    end)
    
    return frame
end

-- Create Emote Button
local function createEmoteButton(parent, emoteName, emoteId, yPos, emoteType)
    local frame = createFeatureFrame(parent, yPos, 60)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = emoteName
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 40)
    button.Position = UDim2.new(1, -110, 0.5, -20)
    button.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    button.BorderSizePixel = 0
    button.Text = "Play"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if emoteType == "freeze" then
            FPlayEmote(emoteId)
        elseif emoteType == "zero" then
            ZeroPlayEmote(emoteId)
        else
            PlayEmote(emoteId)
        end
        Notify("Emote", emoteName, 1)
    end)
    
    return frame
end

-- Create Donate Button
local function createDonateButton(parent, price, gamepassId, yPos)
    local frame = createFeatureFrame(parent, yPos, 60)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Donate " .. price .. " Robux"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 40)
    button.Position = UDim2.new(1, -110, 0.5, -20)
    button.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
    button.BorderSizePixel = 0
    button.Text = "Donate"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        Buy(gamepassId)
    end)
    
    return frame
end

print("Populating Content...")

-- Populate Content Frames
local allButtons = {}

-- Tab 1: Idle Animations
local yPosition = 10
for name, ids in pairs(Animations.Idle) do
    local button = createAnimButton(contentFrames[1], name, "Idle", ids, yPosition)
    table.insert(allButtons, {button = button, name = name, type = "Idle"})
    yPosition = yPosition + 70
end
contentFrames[1].CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- Tab 2: Walk Animations
yPosition = 10
for name, id in pairs(Animations.Walk) do
    local button = createAnimButton(contentFrames[2], name, "Walk", id, yPosition)
    table.insert(allButtons, {button = button, name = name, type = "Walk"})
    yPosition = yPosition + 70
end
contentFrames[2].CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- Tab 3: Run Animations
yPosition = 10
for name, id in pairs(Animations.Run) do
    local button = createAnimButton(contentFrames[3], name, "Run", id, yPosition)
    table.insert(allButtons, {button = button, name = name, type = "Run"})
    yPosition = yPosition + 70
end
contentFrames[3].CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- Tab 4: Jump Animations
yPosition = 10
for name, id in pairs(Animations.Jump) do
    local button = createAnimButton(contentFrames[4], name, "Jump", id, yPosition)
    table.insert(allButtons, {button = button, name = name, type = "Jump"})
    yPosition = yPosition + 70
end
contentFrames[4].CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- Tab 5: Fall Animations
yPosition = 10
for name, id in pairs(Animations.Fall) do
    local button = createAnimButton(contentFrames[5], name, "Fall", id, yPosition)
    table.insert(allButtons, {button = button, name = name, type = "Fall"})
    yPosition = yPosition + 70
end
contentFrames[5].CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- Tab 6: Swim Animations (combining Swim and SwimIdle)
yPosition = 10
for name, id in pairs(Animations.Swim) do
    local button = createAnimButton(contentFrames[6], name, "Swim", id, yPosition)
    table.insert(allButtons, {button = button, name = name, type = "Swim"})
    yPosition = yPosition + 70
end
for name, id in pairs(Animations.SwimIdle) do
    local button = createAnimButton(contentFrames[6], name .. " (Idle)", "SwimIdle", id, yPosition)
    table.insert(allButtons, {button = button, name = name .. " (Idle)", type = "SwimIdle"})
    yPosition = yPosition + 70
end
for name, id in pairs(Animations.Climb) do
    local button = createAnimButton(contentFrames[6], name .. " (Climb)", "Climb", id, yPosition)
    table.insert(allButtons, {button = button, name = name .. " (Climb)", type = "Climb"})
    yPosition = yPosition + 70
end
contentFrames[6].CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- Tab 7: Emotes
yPosition = 10
local emoteList = {
    {"Sturdy", "17746180844"},
    {"ACELERADA", "103360497719320"},
    {"POPULAR", "95750161368281"},
    {"Stylish Floating", "112089880074848"},
    {"Aura Ganier", "91340687009482"},
    {"Hug", "139846829336719"},
    {"TV Time Dance", "104748118296461"},
    {"invisible me", "127212897044971", "freeze"},
    {"Soldier - Assault Aim", "4713633512"},
    {"Zombie - Attack", "3489169607"},
    {"Zombie - Death", "3716468774", "freeze"},
    {"Roblox - Sleep", "2695918332"},
    {"Roblox - Quake", "2917204509"},
    {"Roblox - Rifle Reload", "3972131105"},
    {"Accurate T Pose", "2516930867", "zero"},
}

for _, emoteData in pairs(emoteList) do
    local emoteName, emoteId, emoteType = emoteData[1], emoteData[2], emoteData[3]
    local button = createEmoteButton(contentFrames[7], emoteName, emoteId, yPosition, emoteType)
    table.insert(allButtons, {button = button, name = emoteName, type = "Emote"})
    yPosition = yPosition + 70
end
contentFrames[7].CanvasSize = UDim2.new(0, 0, 0, yPosition)

-- Tab 8: Donate
yPosition = 10
local donateList = {
    {"20", 3369743468},
    {"100", 3369746821},
    {"150", 3369747361},
    {"50", 3369745702},
}

for _, donateData in pairs(donateList) do
    local price, gamepassId = donateData[1], donateData[2]
    local button = createDonateButton(contentFrames[8], price, gamepassId, yPosition)
    yPosition = yPosition + 70
end
contentFrames[8].CanvasSize = UDim2.new(0, 0, 0, yPosition)

print("Setting up GUI Functions...")

-- GUI Functions
local function toggleGUI()
    guiVisible = not guiVisible
    
    if guiVisible then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local targetSize = UDim2.new(0, 520, 0, 750)
        local targetPosition = UDim2.new(0.5, -260, 0.5, -375)
        
        -- Check if mobile
        local screenSize = camera.ViewportSize
        local isMobile = screenSize.X < 800 or UserInputService.TouchEnabled
        
        if isMobile then
            local newWidth = math.min(screenSize.X - 40, 480)
            local newHeight = math.min(screenSize.Y - 80, 650)
            targetSize = UDim2.new(0, newWidth, 0, newHeight)
            targetPosition = UDim2.new(0.5, -newWidth/2, 0.5, -newHeight/2)
        end
        
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = targetSize,
            Position = targetPosition
        }):Play()
        
        mobileToggle.Text = "×"
    else
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        
        closeTween:Play()
        mobileToggle.Text = "⚡"
        
        closeTween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

local function switchTab(tabIndex)
    activeTab = tabIndex
    
    for i = 1, #tabs do
        contentFrames[i].Visible = (i == tabIndex)
        tabButtons[i].BackgroundColor3 = (i == tabIndex) and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(50, 50, 50)
    end
end

-- Search Functionality
searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchBar.Text:lower()
    
    for _, buttonData in pairs(allButtons) do
        local shouldShow = searchText == "" or buttonData.name:lower():find(searchText)
        buttonData.button.Visible = shouldShow
    end
    
    -- Update canvas sizes for each content frame
    for i = 1, #contentFrames do
        local visibleCount = 0
        for _, child in pairs(contentFrames[i]:GetChildren()) do
            if child:IsA("Frame") and child.Visible then
                child.Position = UDim2.new(0, 0, 0, visibleCount * 70 + 10)
                visibleCount = visibleCount + 1
            end
        end
        contentFrames[i].CanvasSize = UDim2.new(0, 0, 0, visibleCount * 70 + 20)
    end
end)

print("Connecting Events...")

-- Event Connections
closeBtn.MouseButton1Click:Connect(function()
    toggleGUI()
end)

-- Mobile Toggle Button Events
mobileToggle.MouseButton1Click:Connect(function()
    toggleGUI()
end)

-- Tab switching
for i, tabBtn in pairs(tabButtons) do
    tabBtn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- Keyboard Controls (PC only)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleGUI()
    end
end)

-- Character Respawn Handling
Players.LocalPlayer.CharacterAdded:Connect(function(character)
    Wait1()
    Wait2()

    task.wait(0.1)
    if lastAnimations.Idle then
        setAnimation("Idle", lastAnimations.Idle)
    end
    if lastAnimations.Walk then
        setAnimation("Walk", lastAnimations.Walk)
    end
    if lastAnimations.Run then
        setAnimation("Run", lastAnimations.Run)
    end
    if lastAnimations.Jump then
        setAnimation("Jump", lastAnimations.Jump)
    end
    if lastAnimations.Fall then
        setAnimation("Fall", lastAnimations.Fall)
    end
    if lastAnimations.Climb then
        setAnimation("Climb", lastAnimations.Climb)
    end
    if lastAnimations.Swim then
        setAnimation("Swim", lastAnimations.Swim)
    end
    if lastAnimations.SwimIdle then
        setAnimation("SwimIdle", lastAnimations.SwimIdle)
    end
end)

print("Loading saved animations...")

-- Load saved animations on start
loadLastAnimations()

print("Initializing GUI...")

-- Initialize and show GUI
local lt = os.clock() - st
Notify("Loaded", string.format("in %.3f seconds.", lt), 5)
Notify("Changelog", "New Modern UI Design + Mobile Support!", 30)
Notify("Controls", "Tap ⚡ button or press F to open", 5)

-- Show mobile toggle button immediately
mobileToggle.Visible = true

-- Auto-show GUI for testing (remove this line if you don't want auto-open)
task.wait(2)
print("🔧 Auto-opening GUI for testing...")
if not guiVisible then
    toggleGUI()
end

print("✅ LNR Animation Hub v2.0 Loaded Successfully!")
print("📱 Mobile Support: Tap the floating ⚡ button to open GUI")
print("📋 Press F to open GUI (PC only)")
print("🚀 Features Loaded:")
print("   • Modern Tabbed Interface")
print("   • Mobile-Friendly Design") 
print("   • Floating Toggle Button")
print("   • Search Functionality") 
print("   • All Animation Types")
print("   • Emotes & Donate Options")
print("   • Auto-Save & Load")
print("")
print("⌨️ Controls:")
print("   F - Toggle GUI (PC)")
print("   Tap ⚡ button - Toggle GUI (Mobile)")
print("")
print("🎮 Use responsibly and have fun!")

end)