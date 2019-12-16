% Study paradigm used in the Steenbergen, Band, & Hommel (2009) paper

% clear everything:
clear all
close all

% set working directory 
MainDir=pwd;
cd(MainDir);

% set debug mode
Debug=1;

% screen and color setup
whichScreen = max(Screen('Screens'));
whiteColor = [255, 255, 255]; %white
grayColor = [192, 192, 192]; % gray
blackColor = [0 0 0]; %black

Screen('Preference', 'SkipSyncTests', 1);

[window,ScreenRect] = Screen(0,'OpenWindow',whiteColor,[0 0 500 500]);

ScreenWidth = ScreenRect(1,3);
ScreenHeight = ScreenRect(1,4);
SceneWidth = 200;
SceneHeight = 200;

% image setup
numImages = 3;
imageWidth = 1024;
imageHeight = 768;
imageMatrix = zeros(imageHeight,imageWidth,3,numImages);
cd('images');

imageCount = 1;
imageNames = ['happy.jpg'; 'neutral.jpg'; 'sad.jpg']

% read images
for image = 1:numImages
    
    imageFileName = imageNames(imageCount, :);
    
    imageCount = imageCount + 1;
    
    [img] = imread(imageFileName);
    imageMatrix(:,:,1:3,image) = img(:,:,:);
    
end

cd ('..');

% get participant id
participant_id = input('Please give us your id: ','s');

%% setup instructions
InstructionTest = ['A következõ feladatban egy nyilat fogsz látni.\n'...
    'A nyilak néha ugyanabba az irányba, néha különbözõ irányokba mutatnak.\n'...
    'A feladatod az lesz, hogy minél gyorsabban jelezd, hogy a középen lévõ nyíl milyen irányba mutat.\n'...
    'Ezen felül a nyilas feladatok között, azoktól függetlenül smileykat fogunk neked mutatni.\n'...
    'Minden alkalommal, amikor vidám smiley-t mutatunk neked 20 Ft-al többet adunk neked a kísérlet végén.\n'...
    'Amikor szomorú smiley-t mutatunk neked 20 Ft-al kevesebb pénzt adunk neked a kísérlet végén.\n'...
    'A semleges smiley-nál nem változik a kísérletért kapott pénzösszeg.\n'...
    'Nyomjd meg az "l" betût a gyakorló feladatokra való továbblépéshez!\n'...
    'Ebben a részben kapsz még visszajelzést a teljesítményedrõl.\n'...
    ];

%% show instructions
DrawFormattedText(window, InstructionTest, 100, 'center');
Screen(window,'Flip');

%% check response to finish the instructions and go to the practice trials
response = 0;

while response == 0
    [keyIsDown,secs,keyCode] = KbCheck;
    if ispc
        if (keyIsDown == 1 && keyCode(76) == 1)
            response = 1;
        end;
    else
        %response
        if (keyIsDown == 1) && keyCode(15) == 1
            response = 1;
        end;
    end
end