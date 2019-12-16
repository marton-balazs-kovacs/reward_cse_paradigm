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
InstructionTest = ['A k�vetkez� feladatban egy nyilat fogsz l�tni.\n'...
    'A nyilak n�ha ugyanabba az ir�nyba, n�ha k�l�nb�z� ir�nyokba mutatnak.\n'...
    'A feladatod az lesz, hogy min�l gyorsabban jelezd, hogy a k�z�pen l�v� ny�l milyen ir�nyba mutat.\n'...
    'Ezen fel�l a nyilas feladatok k�z�tt, azokt�l f�ggetlen�l smileykat fogunk neked mutatni.\n'...
    'Minden alkalommal, amikor vid�m smiley-t mutatunk neked 20 Ft-al t�bbet adunk neked a k�s�rlet v�g�n.\n'...
    'Amikor szomor� smiley-t mutatunk neked 20 Ft-al kevesebb p�nzt adunk neked a k�s�rlet v�g�n.\n'...
    'A semleges smiley-n�l nem v�ltozik a k�s�rlet�rt kapott p�nz�sszeg.\n'...
    'Nyomjd meg az "l" bet�t a gyakorl� feladatokra val� tov�bbl�p�shez!\n'...
    'Ebben a r�szben kapsz m�g visszajelz�st a teljes�tm�nyedr�l.\n'...
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