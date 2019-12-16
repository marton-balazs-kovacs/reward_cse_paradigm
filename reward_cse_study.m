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

% setup practice trials (n = 24)
%% read the trial specifications
practiceBlock = readtable('practiceBlock.csv')

%% draw flanker
left_key = KbName('k');
right_key = KbName('l');

% instructions
%% setup instructions
InstructionTest = ['Véget ért a gyakorló rész!\n'...
    'Továbbra is az lesz a feladatod, hogy minél gyorsabban és pontosabban jelezd,\n'...
    ' hogy a középen lévõ nyíl milyen irányba mutat.\n'...
    'Ezen felül a nyilas feladatok között, azoktól függetlenül smileykat fogunk neked mutatni.\n'...
    'A smiley-iknak nincs köze a válaszaid pontosságához.\n'...
    'Nyomjd meg az "l" betût a gyakorló feladatokra való továbblépéshez!\n'...
    'Ebben a részben nem kapsz visszajelzést a teljesítményedrõl.\n'...
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

% first test block (n = 204)
%% read the trial specifications
firstBlock = readtable('blocks/firstBlock.csv')

%% number of all trials
numTrials = 204;

%% running the first test block
for trial = 1:numTrials

%% draw fixation cross
fixLineLength = 20;
HLine = [ScreenWidth/2-fixLineLength, ScreenHeight/2, ScreenWidth/2+fixLineLength, ScreenHeight/2];
VLine = [ScreenWidth/2, ScreenHeight/2-fixLineLength, ScreenWidth/2, ScreenHeight/2+fixLineLength];
FixLineWidth = 2;
Screen('DrawLine', window, [0 0 0], HLine(1),HLine(2),HLine(3),HLine(4),FixLineWidth);
Screen('DrawLine', window, [0 0 0], VLine(1),VLine(2),VLine(3),VLine(4),FixLineWidth);
Screen(window,'Flip');

%% for the first test block the fixation cross is presented for 200 ms
WaitSecs(0.2);

%% draw flanker
left_key = KbName('k');
right_key = KbName('l');

%%% draw stimuli
Screen('DrawText', window, firstBlock{trial, 1} [0] [0] [0 0 0] [255 255 255]);
Screen(window,'Flip');
KbWait();

%%% set original response value for loop 
response = NaN;

%%% keyboard wait to continue
  while (isnan(response))
    
    [keyIsDown,secs,keyCode]=KbCheck;
 
      if (keyCode(left_key)==1) 
        response='k';
      elseif(keyCode(right_key)==1) 
        response='l';
      end;
    end;

%%% save response in the trial spec
firstBlock{trial, 7} = response

%% draw smiley
Smiley = Screen('MakeTexture', window, imageMatrix(:,:,:,trial));
Screen('DrawTexture',window, Smiley,[],ScreenRect); 
Screen(window,'Flip');
WaitSecs(0.5);

end

% break screen (40 sec)
Screen('FillRect', window [255 255 255] [] );
Screen(window,'Flip');
WaitSecs(40);

% second test block (n = 204)
%% read the trial specifications
secondBlock = readtable('blocks/secondBlock.csv')

%% number of all trials
numTrials = 204;

%% running the second test block
for trial = 1:numTrials
  
%% draw fixation cross
fixLineLength=20;
HLine=[ScreenWidth/2-fixLineLength, ScreenHeight/2, ScreenWidth/2+fixLineLength, ScreenHeight/2];
VLine=[ScreenWidth/2, ScreenHeight/2-fixLineLength, ScreenWidth/2, ScreenHeight/2+fixLineLength];
FixLineWidth=2;
Screen('DrawLine', window, [0 0 0], HLine(1),HLine(2),HLine(3),HLine(4),FixLineWidth);
Screen('DrawLine', window, [0 0 0], VLine(1),VLine(2),VLine(3),VLine(4),FixLineWidth);
Screen(window,'Flip');

%% for the second test block the fixation cross is presented for 300 ms
WaitSecs(0.3);

%% draw flanker
left_key = KbName('k');
right_key = KbName('l');

%%% draw stimuli
Screen('DrawText', window, secondBlock{trial, 1} [0] [0] [0 0 0] [255 255 255]);
Screen(window,'Flip');
KbWait();

%%% set original response value for loop 
response = NaN;

%%% keyboard wait to continue
  while (isnan(response))
    
    [keyIsDown,secs,keyCode]=KbCheck;
 
      if (keyCode(left_key)==1) 
        response='k';
      elseif(keyCode(right_key)==1) 
        response='l';
      end;
    end;

%%% save response in the trial spec
secondBlock{trial, 7} = response

%% draw smiley
Smiley = Screen('MakeTexture', window, imageMatrix(:,:,:,trial));
Screen('DrawTexture',window, Smiley,[],ScreenRect); 
Screen(window,'Flip');
WaitSecs(0.5);

end

% break screen (40 sec)
Screen('FillRect', window [255 255 255] [] );
Screen(window,'Flip');
WaitSecs(40);

% third test block (n = 204)
%% read the trial specifications
thirdBlock = readtable('blocks/thirdBlock.csv')

%% number of all trials
numTrials = 204;

%% running the third test block
for trial = 1:numTrials
  
%% draw fixation cross
fixLineLength=20;
HLine=[ScreenWidth/2-fixLineLength, ScreenHeight/2, ScreenWidth/2+fixLineLength, ScreenHeight/2];
VLine=[ScreenWidth/2, ScreenHeight/2-fixLineLength, ScreenWidth/2, ScreenHeight/2+fixLineLength];
FixLineWidth=2;
Screen('DrawLine', window, [0 0 0], HLine(1),HLine(2),HLine(3),HLine(4),FixLineWidth);
Screen('DrawLine', window, [0 0 0], VLine(1),VLine(2),VLine(3),VLine(4),FixLineWidth);
Screen(window,'Flip');

%% for the third test block the fixation cross is presented for 400 ms
WaitSecs(0.4);

%% draw flanker
left_key = KbName('k');
right_key = KbName('l');

%%% draw stimuli
Screen('DrawText', window, thirdBlock{trial, 1} [0] [0] [0 0 0] [255 255 255]);
Screen(window,'Flip');
KbWait();

%%% set original response value for loop 
response = NaN;

%%% keyboard wait to continue
  while (isnan(response))
    
    [keyIsDown,secs,keyCode]=KbCheck;
 
      if (keyCode(left_key)==1) 
        response='k';
      elseif(keyCode(right_key)==1) 
        response='l';
      end;
    end;

%%% save response in the trial spec
thirdBlock{trial, 7} = response

%% draw smiley
Smiley = Screen('MakeTexture', window, imageMatrix(:,:,:,trial));
Screen('DrawTexture',window, Smiley,[],ScreenRect); 
Screen(window,'Flip');
WaitSecs(0.5);

end