local sounds = {}

--this is mostly for loading sounds into the sound class.
--most of the calls happen elsewhere in the game
--
--test = love.audio.newSource("sounds/wind.mp3")
wind = love.sound.newSoundData('sounds/wind.mp3')
capeSwoosh = {'sounds/flap1.mp3', 'sounds/flap2.mp3', 'sounds/flap3.mp3', 'sounds/flap4.mp3',}
chute = love.sound.newSoundData('sounds/chute.mp3')
pitchFork = {'sounds/swoosh1.mp3', 'sounds/swoosh2.mp3', 'sounds/swoosh3.mp3', 'sounds/swoosh4.mp3', 'sounds/swoosh5.mp3', 'sounds/swoosh6.mp3', 'sounds/swoosh7.mp3', 'sounds/swoosh8.mp3'}
splat = love.sound.newSoundData('sounds/splat.mp3')
thuds = {'sounds/thud1.mp3', 'sounds/thud2.mp3', 'sounds/thud3.mp3', 'sounds/thud4.mp3', 'sounds/thud5.mp3'}
fire = love.sound.newSoundData('sounds/fire.mp3')
fireVolume = 0

repTimer = 0 -- for chute sound
repDelay = 0.5 -- for chute sound

function sounds.playSoundWithTimer(dt, sound)
    if repTimer >= repDelay then
        TEsound.play(sound)
        repTimer = 0
    else 
        repTimer = repTimer + dt*20
    end
end

return sounds

