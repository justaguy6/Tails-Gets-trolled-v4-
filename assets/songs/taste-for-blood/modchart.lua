local introBFNotes = {
    144,
    148,
    152,
    156,
    160,

    176,
    180,
    184,
    188,
    192,

    208,
    212,
    216,
    220,
    224,

    1200,
    1204,
    1208,
    1212,
    1216,

    1232,
    1236,
    1240,
    1244,
    1248,

    1264,
    1268,
    1272,
    1276,
    1280,

    1328,
    1332,
    1336,
    1340,
    1344,

    1360,
    1364,
    1368,
    1372,
    1376,

    1392,
    1396,
    1400,
    1404,
    1408
}

local spinBursts = {
    { 2018, 0, 1 },
    {2030,0,1},
    {2034,1,1},
    {2050,0,1},
    {2062,2,1},

    {2064,3,1},
    {2066,3,1},

    {2082,0,1},
    {2094,0,1},
    {2098,1,1},
    {2114,0,1},
    {2126,2,1},

    {2128,4,1},
    {2130,4,1},
}

local offsets = {
    [0] = { 0, 0.5, 1, 2 },
    [1] = { 0, 0.5, 1, 1.5 },
    [2] = { 0, 0.5, 1 },
    [3] = { 0, 0.5, 1 },
    [4] = { 0, 0.5, 1 },
}

local receptors = {
    [0] = { 0, 1, 3, 2 },
    [1] = { 0, 1, 2, 3 },
    [2] = { 0, 1, 3 },
    [3] = { 2, 1, 0 },
    [4] = { 0, 1, 2 },
}

for i = 1,#spinBursts do
    local burst = spinBursts[i]
    local step = (burst[1] - 2016)
    local type = burst[2]
    local pn = burst[3]

    table.insert(spinBursts, {2144 + step, type, 0})
    table.insert(spinBursts, {656 + step, type, 1})
    table.insert(spinBursts, {784 + step, type, 0})
end

local hudZoom = 1;
local gameZoom = 1;

function onCreate()
    makeLuaSprite('flash', '', 0, 0);
    makeGraphic('flash', 1280, 720, 'ffffff')
    addLuaSprite('flash', true);
    setObjectCamera("flash","hud")
    setLuaSpriteScrollFactor('flash', 0, 0)
    setProperty('flash.scale.x', 2)
    setProperty('flash.scale.y', 2)
    setProperty('flash.alpha', 0)
end

function postModifierRegister()
    -- just registering some blank modifiers to be used for things later
    addBlankMod("hudCamZoom", 1);
    addBlankMod("hudCamZoomMod", 1);
    addBlankMod("gameCamZoom", 1);
    addBlankMod("gameCamZoomMod", 1);

    addBlankMod("hudCamAngle", 0);
    addBlankMod("gameCamAngle", 0);
    addBlankMod("kadeWave", 0);

    addBlankMod("hudShake", 0)

    addBlankMod("haloRadiusX", 0)
    addBlankMod("haloRadiusZ", 0)
    addBlankMod("haloSpeed", 0)
end

local continuous = {}
local oneExecute = {}
local function queueContFunc(startStep, endStep, callback)
    table.insert(continuous, { startStep, endStep, callback })
end

local function queueFunc(step, callback)
    table.insert(oneExecute, {step, callback})
end

local function everyBeat(sStep, eStep, callback)
    for step = sStep, eStep do
        if (step % 4 == 0) then
            local beat = step / 4;
            callback(step, beat)
        end
    end
end

local function everySecondBeat(sStep, eStep, callback)
    for step = sStep, eStep do
        if (step % 8 == 0) then
            local beat = step / 4;
            callback(step, beat)
        end
    end
end

function onCountdownStarted() -- creates the modchart itself
    if (disableModcharts) then
        return
    end

   -- setValue("alpha", 1);
    local val = -1;
    for pn = 0, 1 do
        for i = 0, 3 do
            val = val * -1;
            setValue("alpha" .. tostring(i), 1, pn)
            setValue("transform" .. tostring(i) .. "Y", -50 * val, pn)
            queueSet(0, "alpha" .. tostring(i), 1, pn)
            queueSet(0, "transform" .. tostring(i) .. "Y", -50 * val, pn)
        end
        --setValue("dark" .. tostring(i), 1)
    end

    queueSet(-16, "flashR", 0.07, 1);
    queueSet(-16, "flashG", 0.07, 1);
    queueSet(-16, "flashB", 0.5, 1);

    queueEase(16, 16 + 8, 'transform0Y', 0, 'quadOut', 1)
    queueEase(16, 16 + 8, 'alpha0', 0, 'quadOut', 1)

    queueEase(48, 48 + 8, 'transform1Y', 0, 'quadOut', 1)
    queueEase(48, 48 + 8, 'alpha1', 0, 'quadOut', 1)

    queueEase(60, 60 + 8, 'transform2Y', 0, 'quadOut', 1)
    queueEase(60, 60 + 8, 'alpha2', 0, 'quadOut', 1)

    queueEase(80, 80 + 8, 'transform3Y', 0, 'quadOut', 1)
    queueEase(80, 80 + 8, 'alpha3', 0, 'quadOut', 1)

    queueEase(80, 80 + 8, 'transform0Y', 0, 'quadOut', 0)
    queueEase(80, 80 + 8, 'alpha0', 0, 'quadOut', 0)

    queueEase(112, 112 + 8, 'transform1Y', 0, 'quadOut', 0)
    queueEase(112, 112 + 8, 'alpha1', 0, 'quadOut', 0)

    queueEase(124, 124 + 8, 'transform2Y', 0, 'quadOut', 0)
    queueEase(124, 124 + 8, 'alpha2', 0, 'quadOut', 0)

    queueEase(140, 140 + 8, 'transform3Y', 0, 'quadOut', 0)
    queueEase(140, 140 + 8, 'alpha3', 0, 'quadOut', 0)

    queueSet(140, 'confusionOffset', -360*3)
    queueEase(140, 140 + 4, 'confusionOffset', 0, 'quadOut')

    for i = 1,#introBFNotes do
        local step = introBFNotes[i]
        --local shit = i >= 6 and i <= 10 and 1 or -1;
        local shit = i%2==1 and -1 or 1;
        queueSet(step,'transformX',25*shit)
        queueEase(step,step+4,'transformX',0,'quartOut')
        queueSet(step, 'hudCamZoomMod', 1.1)
        queueEase(step, step+4, 'hudCamZoomMod', 1, 'quartOut')
        queueSet(step, 'hudCamAngle', 5 * shit)
        queueEase(step, step + 4, 'hudCamAngle', 0, 'quartOut')

        queueSetP(step, 'drunk', 75 * shit)
        queueEaseP(step, step+4, 'drunk', 0, 'sineInOut')

        queueSetP(step, 'tipsy', -50 * shit)
        queueEaseP(step, step + 4, 'tipsy', 0, 'sineInOut')
    end

    queueSet(164, 'hudShake', 75)
    queueSet(164, 'confusionOffset', -360)
    queueEase(164, 164 + 8, 'confusionOffset', 0, 'quadOut')
    queueEaseP(164, 164 + 8, 'reverse', 100, 'quadOut')
    queueEase(164, 164 + 8, 'hudShake', 0, 'linear')

    queueSet(196, 'confusionOffset', 360)
    queueEase(196, 196 + 8, 'confusionOffset', 0, 'quadOut')
    queueEaseP(196, 196 + 8, 'reverse', 0, 'quadOut')
    queueSet(196, 'hudShake', 75)
    queueEase(196, 196 + 8, 'hudShake', 0, 'linear')

    queueSet(228, 'confusionOffset', 360)
    queueEase(228, 228 + 8, 'confusionOffset', 0, 'quadOut')
    queueEaseP(228, 228 + 8, 'opponentSwap', 100, 'quadOut')

    queueSet(228, 'hudShake', 75)
    queueEase(228, 228 + 8, 'hudShake', 0, 'linear')

    queueSetP(240, 'squish', 50, 0)
    queueEaseP(240, 240 + 2, 'squish', 0, 'sineInOut', 0)
    queueEaseP(240, 240 + 2, 'invert', 100, 'sineOut', 0)

    queueSetP(246, 'squish', 50, 0)
    queueEaseP(246, 246 + 2, 'squish', 0, 'sineInOut', 0)
    queueEaseP(246, 246 + 2, 'flip', 75, 'sineOut', 0)
    queueEaseP(246, 246 + 2, 'invert', 75, 'sineOut', 0)

    queueSetP(252, 'squish0', 50, 0)
    queueEaseP(252, 252 + 2, 'squish0', 0, 'sineInOut', 0)
    queueSetP(252, 'squish3', 50, 0)
    queueEaseP(252, 252 + 2, 'squish3', 0, 'sineInOut', 0)

    queueEaseP(252, 252 + 2, 'flip', 0, 'sineOut', 0)
    queueEaseP(252, 252 + 2, 'invert', 0, 'sineOut', 0)

    queueSet(292, 'confusionOffset0', -360)
    queueEase(292, 292 + 8, 'confusionOffset0', 0, 'quadOut')
    queueSet(292, 'confusionOffset3', -360)
    queueEase(292, 292 + 8, 'confusionOffset3', 0, 'quadOut')

    queueEaseP(292, 292 + 8, 'reverse0', 100, 'quadOut')
    queueEaseP(292, 292 + 8, 'reverse3', 100, 'quadOut')

    queueSet(324, 'confusionOffset1', -360)
    queueEase(324, 324 + 8, 'confusionOffset1', 0, 'quadOut')
    queueSet(324, 'confusionOffset2', -360)
    queueEase(324, 324 + 8, 'confusionOffset2', 0, 'quadOut')

    queueEaseP(324, 324 + 8, 'reverse1', 100, 'quadOut')
    queueEaseP(324, 324 + 8, 'reverse2', 100, 'quadOut')

    queueSet(356,  'confusionOffset', -360)
    queueEase(356, 356 + 8, 'confusionOffset', 0, 'quadOut')

    queueEaseP(356, 356 + 8, 'opponentSwap', 0, 'quadOut')

    queueSetP(388, 'squish', 100)
    queueEaseP(388, 388 + 2, 'squish', 0, 'sineInOut')
    queueEaseP(388, 388 + 2, 'opponentSwap', 100, 'sineOut')

    queueSetP(392, 'squish', 100)
    queueEaseP(392, 392 + 2, 'squish', 0, 'sineInOut')
    queueEaseP(392, 392 + 2, 'opponentSwap', 0, 'sineOut')
    
    queueSetP(396, 'stretch', 50)
    queueEaseP(396, 396 + 2, 'opponentSwap', 50, 'sineOut')
    queueEaseP(396, 396 + 2, 'stealth', 30, 'sineOut', 1)
    queueEaseP(396, 396 + 2, 'alpha', 80, 'sineOut', 1)
    queueEaseP(396, 396 + 2, 'stretch', 0, 'sineInOut')
    queueEaseP(396, 396 + 2, 'reverse0', 0, 'sineOut')
    queueEaseP(396, 396 + 2, 'reverse1', 0, 'sineOut')
    queueEaseP(396, 396 + 2, 'reverse2', 0, 'sineOut')
    queueEaseP(396, 396 + 2, 'reverse3', 0, 'sineOut')

    queueSet(414, 'confusionOffset', -360, 1)
    queueEase(414, 420, 'confusionOffset', 0, 'quartOut', 1)
    queueEaseP(414, 420, 'reverse', 100, 'quartOut', 1)

    queueEaseP(528, 534, 'flip', -125, 'quadOut', 1)
    queueEaseP(528, 534, 'invert', 125, 'quadOut', 1)

    queueEaseP(592, 596, 'flip', 0, 'quadOut', 1)
    queueEaseP(592, 596, 'invert', 0, 'quadOut', 1)
    queueEaseP(592, 596, 'reverse', 0, 'quadOut', 1)

    local shit = 1;
    queueEaseP(624, 636, 'reverse', 100)
    for s = 624, 636 do
        shit = shit * -1
        queueEase(s, s+1, 'transformX', 25 * shit, 'quadOut')
    end
    queueEaseP(576, 580, 'stealth', 75, 'quadOut', 1)

    queueEase(636, 637, 'transformX', 0, 'quadOut')
    queueEaseP(636, 644, 'reverse', 0, 'quadOut')
    queueEaseP(636, 656, 'opponentSwap', 0, 'quadOut')
    queueEaseP(636, 656, 'stealth', 0, 'quadOut', 1)
    queueEaseP(636, 656, 'alpha', 0, 'quadOut', 1)

    do
        local v = 1;

        --queueSetP(0, "beat", 25)
        everySecondBeat(656, 912, function(step, beat)
            queueSetP(step, 'transformX', -35 * v);

            queueSetP(step, 'drunk', 25 * v);
            queueSetP(step, 'flip', 15 * v);

            queueSetP(step, 'tipsy', -50 * v);
            queueSetP(step, 'tipZ', 50 * v);
            queueSetP(step, 'tipsySpeed', math.cos(step) * 0.05);
            queueSetP(step, 'drunkSpeed', math.sin(step) * math.cos(step / 2) * 0.075);
            queueSetP(step, 'tipsyOffset', math.sin(step) * 0.1);
            queueEaseP(step, step + 6, 'transformX', 0, 'quartOut')

            queueEaseP(step, step + 6, 'drunk', 0, 'sineInOut')
            queueEaseP(step, step + 6, 'tipsy', 0, 'quadOut')
            queueEaseP(step, step + 6, 'tipZ', 0, 'quadOut')
            queueEaseP(step, step + 6, 'flip', 0, 'sineOut')

            queueEase(step, step + 6, 'drunkSpeed', 0, 'quadOut')
            queueEase(step, step + 6, 'tipsySpeed', 0, 'quadOut')
            queueEase(step, step + 6, 'tipsyOffset', 0, 'quadOut')

            v = v * -1;
        end)
    end

    for i = 1,#spinBursts do
        local burst = spinBursts[i]
        local step = burst[1]
        local type = burst[2]
        local pn = burst[3]

        print(step,type,pn)
        
        local affectedOffsets = offsets[type]
        local affectedReceptors = receptors[type]

        for i = 1,#affectedOffsets do
            local qStep = step + affectedOffsets[i]
            queueSet(qStep, 'hudShake', 150)
            queueEase(qStep, qStep + 4, "hudShake", 0, 'quadOut')

            queueSet(qStep, 'confusionOffset' .. affectedReceptors[i], 360, pn)
            queueEase(qStep, qStep + 4, "confusionOffset" .. affectedReceptors[i],0,'quadOut',pn)

            queueSet(qStep, 'transform' .. affectedReceptors[i] .. 'Z', -256, pn)
            queueEase(qStep, qStep + 4, "transform" .. affectedReceptors[i] .. 'Z', 0, 'quadOut', pn)
        end
    end

    queueEaseP(912, 912 + 2, 'opponentSwap', -50, 'quadOut', 0)
    queueEaseP(912, 912 + 2, 'opponentSwap', 50, 'quadOut', 1)
    queueSetP(912, 'squish', 50)
    queueEaseP(912, 912 + 2, 'squish', 0, 'quadInOut')

    local knockOffset = 0.5;

    queueEaseP(916-4, 916, "flip", 25, "quadIn", 0)
    queueEaseP(916, 916 + 2, "flip", 0, "quadOut", 0)

    queueEaseP(916 + knockOffset, 916 + knockOffset + 2, 'opponentSwap', -50, 'quadOut', 1)
    queueEaseP(916, 916 + 2, 'opponentSwap', 50, 'quadOut', 0)
    queueSetP(916 + knockOffset, 'squish', 50, 1)
    queueEaseP(916 + knockOffset, 916 + knockOffset + 2, 'squish', 0, 'quadInOut', 1)
    queueSetP(916, 'squish', 50, 0)
    queueEaseP(916, 916 + 2, 'squish', 0, 'quadInOut', 0)

    queueEaseP(922 - 4, 922, "flip", 25, "quadIn", 1)
    queueEaseP(922, 922 + 2, "flip", 0, "quadOut", 1)
    
    queueEaseP(922 + knockOffset, 922 + knockOffset + 2, 'opponentSwap', -50, 'quadOut', 0)
    queueSetP(922 + knockOffset, 'squish', 50, 0)
    queueEaseP(922 + knockOffset, 922 + knockOffset + 2, 'squish', 0, 'quadInOut', 0)
    queueEaseP(922, 922 + 2, 'opponentSwap', 50, 'quadOut', 1)
    queueSetP(922, 'squish', 50, 1)
    queueEaseP(922, 922 + 2, 'squish', 0, 'quadInOut', 1)

    queueEaseP(928 - 4, 928, "flip", 25, "quadIn", 0)
    queueEaseP(928, 928 + 2, "flip", 0, "quadOut", 0)

    queueEaseP(928 + knockOffset, 928 + knockOffset + 2, 'opponentSwap', -50, 'quadOut', 1)
    queueEaseP(928 + knockOffset, 928 + knockOffset + 2, 'opponentSwap', -50, 'quadOut', 1)
    queueEaseP(928, 928 + 2, 'opponentSwap', 50, 'quadOut', 0)
    queueSetP(928 + knockOffset, 'squish', 50, 1)
    queueEaseP(928 + knockOffset, 928 + knockOffset + 2, 'squish', 0, 'quadInOut', 1)
    queueSetP(928, 'squish', 50, 0)
    queueEaseP(928, 928 + 2, 'squish', 0, 'quadInOut', 0)

    queueSetP(934, 'squish', 50)
    queueEaseP(934, 934 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(934, 934 + 2, 'opponentSwap', 0, 'quadInOut')

    -- kade wave :D


    queueEaseP(942, 948, "kadeWave", 100, "quadOut");

    queueContFunc(940, 1168, function(step)
        local beat = (step - 940) / 4;
        beat = beat + 1

        for col = 0, 3 do
            local mu = 1 --col%2==0 and -1 or 1;
            for pN = 0, 1 do
                setValue("transform" .. col .. "X", 32 * math.sin((beat + col * 0.25) * 0.25 * math.pi) * getValue("kadeWave", pN), pN);
                setValue("transform" .. col .. "Y", 32 * mu * math.cos((beat + col * .25) * 0.25 * math.pi) * getValue("kadeWave", pN), pN);
            end
        end
    end)

    queueEaseP(1156, 1168, "kadeWave", 0, "quadOut");

    for i = 0, 3 do
        queueEaseP(1168, 1168 + 2, 'transform' .. i .. 'X', 0, 'quadInOut')
        queueEaseP(1168, 1168 + 2, 'transform' .. i .. 'Y', 'quadInOut')
    end

    queueEaseP(1172, 1172 + 2, 'flip', 100, 'quadOut')
    queueSetP(1172, 'squish', 50)
    queueEaseP(1172, 1172 + 2, 'squish', 0, 'quadInOut')

    queueEaseP(1176, 1176 + 2, 'flip', 0, 'quadOut')
    queueSetP(1176, 'squish', 50)
    queueEaseP(1176, 1176 + 2, 'squish', 0, 'quadInOut')

    queueEaseP(1180, 1180 + 2, 'flip', 0, 'quadOut')
    queueEaseP(1180, 1180 + 2, 'invert', 100, 'quadOut')
    queueSetP(1180, 'squish', 50)
    queueEaseP(1180, 1180 + 2, 'squish', 0, 'quadInOut')

    queueEaseP(1184, 1184 + 2, 'invert', 0, 'quadOut')
    queueSetP(1184, 'squish', 50)
    queueEaseP(1184, 1184 + 2, 'squish', 0, 'quadInOut')

    queueEaseP(1188, 1188 + 2, 'flip', 100, 'quadOut')
    queueEaseP(1188, 1188 + 2, 'invert', -100, 'quadOut')
    queueSetP(1188, 'squish', 50)
    queueEaseP(1188, 1188 + 2, 'squish', 0, 'quadInOut')

    queueEaseP(1192, 1192 + 2, 'invert', 0, 'quadOut')
    queueEaseP(1192, 1192 + 2, 'flip', 0, 'quadOut')
    queueSetP(1192, 'squish', 50)
    queueEaseP(1192, 1192 + 2, 'squish', 0, 'quadInOut')

    queueEaseP(1220, 1228, 'flip', 100, 'quadInOut')
    queueSet(1220, 'hudShake', 75)
    queueEase(1220, 1228, 'hudShake', 0, 'quadInOut')

    queueSet(1252, 'hudShake', 75)
    queueEase(1252, 1260, 'hudShake', 0, 'quadInOut')
    queueEaseP(1252, 1260, 'flip', 0, 'quadInOut')
    queueEaseP(1252, 1260, 'invert', 100, 'quadInOut')

    queueEaseP(1284, 1292, 'invert', 0, 'quadInOut')
    queueSet(1284, 'hudShake', 75)
    queueEase(1284, 1292, 'hudShake', 0, 'quadInOut')

    queueSetP(1296, 'squish', 100)
    queueEaseP(1296, 1296+2, 'squish', 0, 'quadInOut')
    queueEaseP(1296, 1296+2, 'opponentSwap', 100, 'quadOut')

    queueSetP(1302, 'squish', 100)
    queueEaseP(1302, 1302 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(1302, 1302 + 2, 'opponentSwap', 0, 'quadOut')

    queueSetP(1308, 'squish', 100)
    queueEaseP(1308, 1308 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(1308, 1308 + 2, 'opponentSwap', 50, 'quadOut')
    queueEaseP(1308, 1308 + 2, 'stealth', 75, 'quadOut', 1)
    queueEaseP(1308, 1308 + 2, 'alpha', 75, 'quadOut', 1)

    queueEaseP(1348, 1356, 'reverse', 100, 'quadInOut', 0)
    queueSet(1348, 'confusionOffset', 360, 0)
    queueEase(1348, 1356, 'confusionOffset', 0, 'quadInOut', 0)

    queueEaseP(1380, 1388, 'reverse', 0, 'quadInOut', 0)
    queueSet(1380, 'confusionOffset', -360, 0)
    queueEase(1380, 1388, 'confusionOffset', 0, 'quadInOut', 0)

    queueEaseP(1412, 1420, 'opponentSwap', 0, 'quadInOut')
    queueEaseP(1412, 1420, 'stealth', 0, 'quadInOut')
    queueEaseP(1412, 1420, 'alpha', 0, 'quadInOut')
    queueSet(1412, 'confusionOffset', -360, 0)
    queueEase(1412, 1420, 'confusionOffset', 0, 'quadInOut', 0)
    queueSet(1412, 'confusionOffset', 360, 1)
    queueEase(1412, 1420, 'confusionOffset', 0, 'quadInOut', 1)

    queueEaseP(1444, 1444 + 2, 'flip', 100, 'quadInOut')
    queueEase(1444, 1444+2, 'confusionOffset', 180, 'quadInOut')

    queueEaseP(1448, 1448 + 2, 'flip', 0, 'quadInOut')
    queueEase(1448, 1448 + 2, 'confusionOffset', 0, 'quadInOut')
    queueEaseP(1448, 1448 + 2, 'invert', 100, 'quadInOut')
    queueEase(1448, 1448 + 2, 'confusionOffset0', -90, 'quadInOut')
    queueEase(1448, 1448 + 2, 'confusionOffset1', 90, 'quadInOut')
    queueEase(1448, 1448 + 2, 'confusionOffset2', 90, 'quadInOut')
    queueEase(1448, 1448 + 2, 'confusionOffset3', -90, 'quadInOut')

    queueEaseP(1452, 1452 + 2, 'invert', 0, 'quadInOut')
    queueEase(1452, 1452 + 2, 'confusionOffset0', 0, 'quadInOut')
    queueEase(1452, 1452 + 2, 'confusionOffset1', 0, 'quadInOut')
    queueEase(1452, 1452 + 2, 'confusionOffset2', 0, 'quadInOut')
    queueEase(1452, 1452 + 2, 'confusionOffset3', 0, 'quadInOut')
    
    queueEaseP(1456, 1456 + 4, "flip", 25, "quadIn")
    queueEaseP(1456, 1456 + 4, "opponentSwap", 25, "quadIn")
    queueEaseP(1456 + 4, 1456 + 4 + 2, "flip", 0, "quadOut")
    queueEaseP(1456 + 4, 1456 + 4 + 2, "squish", 0, "quadOut")
    queueEaseP(1456 + 4, 1456 + 4 + 2, "opponentSwap", -200, "quadOut")
    queueSetP(1456 + 4, "squish", 200)

    queueSetP(1464, "alpha", 100)
    queueSet(1464, "unboundedReverse", 1)
    for i = 0, 3 do
        queueSetP(1464, "reverse" .. i, -100, 0)
        queueSetP(1464, "reverse" .. i, 150, 1)
        queueSetP(1464, "alpha" .. i, 100, 1)
    end
    queueSetP(1464, "opponentSwap", 50)
    queueSetP(1464, "alpha", 0, 0)
    queueSetP(1464, "alpha", 50, 1)
    queueSetP(1464, "stealth", 15, 1)
    for i = 0, 3 do
        queueEaseP(1488 + i, 1488 + i + 6, "reverse" .. i, 0, 'backOut', 0)
        queueEaseP(1488 + (3 - i), 1488 + (3 - i) + 6, "reverse" .. i, 100, 'backOut', 1)
        queueEaseP(1488 + (3 - i), 1488 + (3 - i) + 6, "alpha" .. i, 0, 'backOut', 1)
        queueSetP(1488 + 4 + 6, "reverse" .. i, 0, 1)
    end
    queueEaseP(1544, 1552, "alpha", 90, 'quadOut', 1)
    queueSetP(1488 + 4 + 6, "reverse", 100, 1)

    queueEaseP(1616, 1620, "reverse", 100, 'backOut', 0)
    queueEaseP(1616, 1620, "reverse", 0, 'backOut', 1)
    do
        local v = 1;

        --queueSetP(0, "beat", 25)
        everyBeat(1488, 1734, function(step, beat)
            if (step < 1734 or step > 1742) then
                if(step < 1742)then
                    queueSetP(step, 'transformX', -35 * v);
                end
                queueSetP(step, 'drunk', 25 * v);
                if(step < 1780 or step > 1792)then
                    queueSetP(step, 'flip', 15 * v);
                end
                queueSetP(step, 'tipsy', -50 * v);
                queueSetP(step, 'tipsySpeed', math.cos(step) * 0.05);
                queueSetP(step, 'drunkSpeed', math.sin(step) * math.cos(step/2) * 0.075);
                queueSetP(step, 'tipsyOffset', math.sin(step) * 0.1);
                if(step < 1742)then
                    queueEaseP(step, step + 4, 'transformX', 0, 'quartOut')
                end
                queueEaseP(step, step + 4, 'drunk', 0, 'sineInOut')
                queueEaseP(step, step + 4, 'tipsy', 0, 'quadOut')
                if(step < 1780 or step > 1792)then
                    queueEaseP(step, step + 4, 'flip', 0, 'sineOut')
                end
                queueEase(step, step + 4, 'drunkSpeed', 0, 'quadOut')
                queueEase(step, step + 4, 'tipsySpeed', 0, 'quadOut')
                queueEase(step, step + 4, 'tipsyOffset', 0, 'quadOut')

                v = v * -1;
            end
        end)
    end

    -- flash 1
    queueSet(1734, 'xmod', 0.2)
    queueSetP(1734, 'flip', 100)
    queueSetP(1734, 'drunk', 50)
    queueSetP(1734, 'tipsy', 125)
    queueSetP(1734, 'reverse', 0)
    queueSetP(1734, 'opponentSwap', 100)
    queueSetP(1734, 'stealth', 0)
    queueSetP(1734, 'alpha', 0)
    queueEase(1734, 1738, 'xmod', 1, 'backOut')
    -- flash 2
    queueSet(1738, 'xmod', 0.2)
    queueSetP(1738, 'flip', 0)
    queueSetP(1738, 'split', 100)
    queueSetP(1734, 'drunk', 0)
    queueSetP(1734, 'tipsy', -50)
    queueSetP(1734, 'tipsyOffset', 100)
    queueSetP(1738, 'centered', 100)
    queueSetP(1738, 'reverse', 0)
    queueSetP(1738, 'opponentSwap', 50)
    queueSetP(1738, "alpha", 50, 1)
    queueSetP(1738, "stealth", 15, 1)
    queueEase(1738, 1742, 'xmod', 1, 'backOut')

    -- flash 3
    queueSet(1738, 'xmod', 0.5)
    queueSetP(1742, 'flip', 0)
    queueSetP(1742, 'tipsyOffset', 0)
    queueSetP(1742, 'tipsy', 0)
    queueSetP(1742, 'split', 0)
    queueSetP(1742, 'centered', 0)
    queueSetP(1742, 'opponentSwap', 0)
    queueSetP(1742, 'stealth', 0)
    queueSetP(1742, 'alpha', 0)
    queueEase(1742, 1746, 'xmod', 1, 'backOut')

    queueFunc(1734, function ()
        hudZoom = hudZoom + 0.1 * getProperty("camZoomingMult");
        cancelTween('flTw')
        setProperty('flash.alpha', 0.7)
        doTweenAlpha('flTw', 'flash', 0, 0.2, 'linear')
    end)

    queueFunc(1738, function()
        hudZoom = hudZoom + 0.1 * getProperty("camZoomingMult");
        setProperty('flash.alpha', 0.8)
        doTweenAlpha('flTw', 'flash', 0, 0.4, 'linear')
    end)

    queueFunc(1742, function()
        hudZoom = hudZoom + 0.1 * getProperty("camZoomingMult");
        setProperty('flash.alpha', 1)
        doTweenAlpha('flTw', 'flash', 0, 0.8, 'linear')
    end)

    queueSetP(1780, 'squish', 100)
    queueEaseP(1780, 1780+2, 'squish', 0, 'quadInOut')
    queueEaseP(1780, 1780+2, 'flip', 100, 'quadOut')

    queueSetP(1784, 'squish', 100)
    queueEaseP(1784, 1784 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(1784, 1784 + 2, 'flip', 0, 'quadOut')

    queueSetP(1788, 'squish', 100)
    queueEaseP(1788, 1788 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(1788, 1788 + 2, 'invert', 100, 'quadOut')

    queueSetP(1792, 'squish', 100)
    queueEaseP(1792, 1792 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(1792, 1792 + 2, 'invert', 0, 'quadOut')

    queueSetP(1796, 'squish', 35)
    queueEaseP(1796, 1796 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(1796, 1796 + 2, 'invert', -100, 'quadOut')
    queueEaseP(1796, 1796 + 2, 'flip', 100, 'quadOut')

    queueSetP(1800, 'squish', 35)
    queueEaseP(1800, 1800 + 2, 'squish', 0, 'quadInOut')
    queueEaseP(1800, 1800 + 2, 'invert', 0, 'quadOut')
    queueEaseP(1800, 1800 + 2, 'flip', 0, 'quadOut')

    queueEase(1838, 1840, 'hudShake', 150, 'quartOut')
    queueEase(1862, 1888, 'hudShake', 0, 'quartOut')

    local mmmm = (35 / 7);
    for i = 1, 7 do
        local step = 1970 + (i*2)
        queueEaseP(step, step+2, "flip", (mmmm * i)/2, 'quadOut');
        queueEaseP(step, step+2, "opponentSwap", mmmm * i, 'quadOut');
    end
    -- kade wave :D 2

    queueSet(1984, "confusionOffset", -360, 0)
    queueSet(1984, "confusionOffset", 360, 1)
    queueEase(1984, 1988, "confusionOffset", 0, 'quadOut');
    queueEaseP(1984, 1988, "opponentSwap", 0, 'quadOut');
    queueEaseP(1984, 1988, "flip", 0, 'quadOut');
    queueEaseP(1738, 1742, 'kadeWave', 100, 'quadOut')
    queueEaseP(1960, 1968, 'kadeWave', 0, 'linear')

    queueContFunc(1738, 1968, function(step)
        local beat = (step - 1742) / 4;  
        beat = beat + 1
        --print(step)

        for col = 0, 3 do
            for pN = 0, 1 do
                local mu = 1 --col%2==0 and -1 or 1;
                setValue("transform" .. col .. "X", 32 * math.sin((beat + col * 0.75) * 0.25 * math.pi) * getValue("kadeWave", pN), pN);
                setValue("transform" .. col .. "Z", 112 * mu * math.sin((beat + col * 1.25) * 0.125 * math.pi) * getValue("kadeWave", pN), pN);
                setValue("confusionOffset" .. col, 4 * mu * math.sin((beat + col * 1.25) * 0.125 * math.pi) * getValue("kadeWave", pN), pN);
            end
        end
    end)  

    for col = 0, 3 do
        local mu = 1 --col%2==0 and -1 or 1;
        queueEaseP(1968, 1968+4, "transform" .. col .. "X", 0);
        queueEaseP(1968, 1968+4, "transform" .. col .. "Y", 0);
        queueEaseP(1968, 1968 + 4, "transform" .. col .. "Z", 0);
        queueEaseP(1968, 1968+4, "confusionOffset" .. col, 0, 0);
    end

    do
        local v = 1;

        --queueSetP(0, "beat", 25)
        everySecondBeat(2016, 2268, function(step, beat)
            queueSetP(step, 'transformX', -35 * v);
            
            queueSetP(step, 'drunk', 25 * v);
            queueSetP(step, 'flip', 15 * v);
            
            queueSetP(step, 'tipsy', -50 * v);
            queueSetP(step, 'tipZ', 50 * v);
            queueSetP(step, 'tipsySpeed', math.cos(step) * 0.05);
            queueSetP(step, 'drunkSpeed', math.sin(step) * math.cos(step / 2) * 0.075);
            queueSetP(step, 'tipsyOffset', math.sin(step) * 0.1);
            queueEaseP(step, step + 6, 'transformX', 0, 'quartOut')
            
            queueEaseP(step, step + 6, 'drunk', 0, 'sineInOut')
            queueEaseP(step, step + 6, 'tipsy', 0, 'quadOut')
            queueEaseP(step, step + 6, 'tipZ', 0, 'quadOut')
            queueEaseP(step, step + 6, 'flip', 0, 'sineOut')
            
            queueEase(step, step + 6, 'drunkSpeed', 0, 'quadOut')
            queueEase(step, step + 6, 'tipsySpeed', 0, 'quadOut')
            queueEase(step, step + 6, 'tipsyOffset', 0, 'quadOut')

            v = v * -1;
            
        end)
    end

    queueContFunc(2272, 2364, function(step)
        local beat = step / 4;
        for col = 0, 3 do
            local speed = getValue("haloSpeed", 0)
            local input = (col + 1 + beat) * math.rad(360 / 4)
            local radiusX = getValue("haloRadiusX", 0)
            local radiusZ = getValue("haloRadiusZ", 0)
            setValue("transform" .. col .. "X", radiusX * math.sin(input) * speed, 1)
            setValue("transform" .. col .. "Z", radiusZ * math.cos(input) * speed, 1)
        end
    end)

    queueEase(2272, 2308, 'haloRadiusX', 256, 'quartOut')
    queueEase(2272, 2308, 'haloRadiusZ', 192, 'quartOut')
    queueEase(2272, 2308, 'haloSpeed', 1.5, 'quartOut')

    queueEase(2308, 2320, 'haloRadiusX', 2048, 'quadIn')
    queueEase(2308, 2320, 'haloRadiusZ', 1024, 'quadIn')
    queueEase(2308, 2320, 'haloSpeed', 3, 'quadIn')

    queueEaseP(2308, 2320, "alpha", 100, 'quadIn')
    
    queueEaseP(2268, 2272, "opponentSwap", 50, 'quadOut', 1)
    queueEaseP(2268, 2272, "flip", 50, 'quadOut', 1)

    if (downscroll) then
        for col = 0, 3 do
            queueEase(2270 + (col * .5), 2280 + (col * .5), 'transform' .. col .. 'Y', -1280, 'backIn', 0)
        end
    else
        for col = 0, 3 do
            queueEase(2270 + (col * .5), 2280 + (col * .5), 'transform' .. col .. 'Y', 1280, 'backIn', 0)
        end
    end
end

function onSectionHit()
    if(getProperty("camGame.zoom") < 1.35 and cameraZoomOnBeat)then
        hudZoom = hudZoom + 0.015 * getProperty("camZoomingMult");
        gameZoom = gameZoom + 0.03 * getProperty("camZoomingMult");
    end
end

function onStepHit()
    for i = #oneExecute, 1, -1 do
        local data = oneExecute[i]
        if(curStep >= data[1])then
            data[2]();
            table.remove(oneExecute, i)
        end
    end
end

function numLerp(a, b, c)
    return a + (b - a) * c
end

function boundTo(val,min,max)
    return math.max(min, math.min(max, val));
end

function onUpdate(elapsed) -- updates anything (hud cam zoom for eg)
    if (inGameOver) then
        return;
    end

    for i = #continuous, 1, -1 do
        local data = continuous[i];
        if(curStep >= data[1])then
            if(curStep > data[2])then
                table.remove(continuous, i)
            else
                data[3](getProperty("curDecStep"));
            end
        end
    end
    setProperty("camZooming", false);
	
	-- hides the health bar when it obstructs your receptors
	local revMod = getValue("reverse");
	for i = 0,3 do
		revMod = math.max(getValue("reverse"..i), revMod);
	end
	if revMod > 0 then
		setProperty("healthBar.alpha", (1-revMod)*(healthBarAlpha or 1));
	end

	--
    local defaultHudZoom = getValue("hudCamZoom")
    local defaultCamZoom = getValue("gameCamZoom")
	
	local playbackRate = tonumber(getProperty("playbackRate")) or 1; -- lol 
	
    hudZoom  = numLerp(
        defaultHudZoom, 
        hudZoom,
        boundTo(1 - (elapsed * 3.125 * getProperty("camZoomingDecay") * playbackRate), 0, 1)
    )
    gameZoom = numLerp(
        getProperty("defaultCamZoom") * defaultCamZoom,
        gameZoom,
        boundTo(1 - (elapsed * 3.125 * getProperty("camZoomingDecay") * playbackRate), 0, 1)
    )

    setProperty("camHUD.zoom", hudZoom * getValue("hudCamZoomMod"))
    setProperty("camGame.zoom", gameZoom * getValue("gameCamZoomMod"))

    setProperty("camHUD.angle", getValue("hudCamAngle"))
    setProperty("camGame.angle", getValue("gameCamAngle"))

    setProperty("camHUD.x", (((screenWidth - getProperty("camHUD.width")) / 2) + math.random(-getValue("hudShake")*hudZoom, getValue("hudShake") * hudZoom)/10000) * getProperty("camHUD.width") )
    setProperty("camHUD.y", (((screenHeight - getProperty("camHUD.height")) / 2) + math.random(-getValue("hudShake") * hudZoom, getValue("hudShake") * hudZoom) / 10000) * getProperty("camHUD.height"))
end