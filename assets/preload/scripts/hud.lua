local frame = 150
local holding = {}
function onCreatePost()
addHaxeLibrary('Std')
runHaxeCode([[
var wawa = [];
for (i in game.dad.healthColorArray) wawa.push(StringTools.hex(i, 2));
var wawa2 = [];
for (i in game.boyfriend.healthColorArray) wawa2.push(StringTools.hex(i, 2));
game.timeBar.createGradientBar([0x0], [Std.parseInt('0xFF' + wawa2.join('')), Std.parseInt('0xFF' + wawa.join(''))]);
]])
end

function onUpdate(elapsed)
-- Vanila End
for i = 0, getProperty('notes.length') - 1 do
sus = getPropertyFromGroup('notes', i, 'isSustainNote');
susEnd = getPropertyFromGroup('notes', i, 'animation.curAnim.name'):find('holdend');
if stringStartsWith(version, '0.7') then
versionCompatible = "states."
else
versionCompatible = ""
end
if sus and susEnd and not getPropertyFromClass(versionCompatible..'PlayState', 'isPixelStage') then
setPropertyFromGroup('notes', i, 'scale.y', 0.7);
setPropertyFromGroup('notes', i, 'offset.y', downscroll and -10 or 10);
end
end

-- Winning icons
mal = getProperty('iconP1.animation.name')
mal2 = getProperty('iconP2.animation.name')

makeAnimatedLuaSprite('simge1',nil, getProperty('iconP1.x'), getProperty('iconP1.y'))
loadGraphic('simge1','icons/icon-'..mal, frame)
addAnimation('simge1','icons/icon-'..mal, {0, 1, 2}, 0, true)
setObjectCamera('simge1', 'hud')
setObjectOrder('simge1', getObjectOrder('iconP1') + 1)

addLuaSprite('simge1', true)

makeAnimatedLuaSprite('simge2',nil, getProperty('iconP2.x'), getProperty('iconP2.y'))
loadGraphic('simge2','icons/icon-'..mal2, frame)
addAnimation('simge2','icons/icon-'..mal2, {0, 1, 2}, 0, true)
setObjectCamera('simge2', 'hud')
setObjectOrder('simge2', getObjectOrder('iconP2') + 1)

addLuaSprite('simge2', true)

setProperty('iconP1.alpha', 0)
setProperty('iconP2.alpha', 0)

setProperty('simge1.angle', getProperty('iconP1.angle'))
setProperty('simge1.scale.x', getProperty('iconP1.scale.x'))
setProperty('simge1.scale.y', getProperty('iconP1.scale.y'))
setProperty('simge2.flipX', false)
setProperty('simge1.flipX', true)
setProperty('simge2.angle', getProperty('iconP2.angle'))
setProperty('simge2.scale.x', getProperty('iconP2.scale.x'))
setProperty('simge2.scale.y', getProperty('iconP2.scale.y'))


if getProperty('health') > 1.6 then
setProperty('simge2.animation.curAnim.curFrame', '1')
setProperty('simge1.animation.curAnim.curFrame', '2')
end
if getProperty('health') < 1.6 and getProperty('health') > 0.4 then
setProperty('simge2.animation.curAnim.curFrame', '0')
setProperty('simge1.animation.curAnim.curFrame', '0')
end
if getProperty('health') < 0.4 then
setProperty('simge1.animation.curAnim.curFrame', '1')
setProperty('simge2.animation.curAnim.curFrame', '2')
end
end

local function hold(char, id, sustain)
    holding[char] = sustain and
                        not getPropertyFromGroup('notes', id, 'noAnimation') and
                        not stringEndsWith(
                            getPropertyFromGroup('notes', id,
                                                 'animation.curAnim.name'),
                            'end')
end

function onUpdatePost()
    for char, holds in pairs(holding) do
        if holds and
            not stringStartsWith(getProperty(char .. '.animation.curAnim.name'),
                                 'idle') and
            getProperty(char .. '.animation.curAnim.frames.length') > 2 and
            getProperty(char .. '.animation.curAnim.curFrame') > 1 then
            setProperty(char .. '.animation.curAnim.curFrame', 0)
        end
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    hold(getPropertyFromGroup('notes', id, 'gfNote') and 'gf' or 'boyfriend',
         id, isSustainNote)
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    hold(getPropertyFromGroup('notes', id, 'gfNote') and 'gf' or 'dad', id,
         isSustainNote)
end

function noteMissPress() if holding.boyfriend then holding.boyfriend = false end end

function noteMiss() noteMissPress() end

function onKeyRelease() noteMissPress() end