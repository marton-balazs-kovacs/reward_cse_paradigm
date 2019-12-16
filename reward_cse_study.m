% Study paradigm used in the Steenbergen, Band, & Hommel (2009) paper

% clear everything
clear all
close all

% set working directory 
MainDir=pwd;
cd(MainDir);

% load packages
pkg load io

% set debug mode
Debug=1;

% setup variables
left_key = KbName('k');
right_key = KbName('l');

% screen and color setup
whichScreen = max(Screen('Screens'));
whiteColor = [255, 255, 255]; %white
grayColor = [192, 192, 192]; % gray
blackColor = [0 0 0]; %black

Screen('Preference', 'SkipSyncTests', 1);

[window,ScreenRect] = Screen(0,'OpenWindow',whiteColor,[0 0 500 500]);

ScreenWidth = ScreenRect(1,3);
ScreenHeight = ScreenRect(1,4);

% read images
cd('images');
images=dir([pwd, '/*.jpg']);

for i=1:size(images, 1)

  imageFileName = images(i).name;
  [img] = imread(imageFileName);
  imageMatrix{i,1} = img(:,:,:);
  imageMatrix{i,2} = imageFileName;
end;

cd ('..');

% get participant id
participant_id = input('Please give us your id: ','s');

%% setup instructions
InstructionTest = ['A kovetkezo feladatban egy nyilat fogsz latni.\n'...
    'A nyilak neha ugyanabba az iranyba, neha kulonbozo iranyokba mutatnak.\n'...
    'A feladatod az lesz, hogy minel gyorsabban jelezd, hogy a kozepen levo nyil milyen iranyba mutat.\n'...
    'Ezen felul a nyilas feladatok kozott, azoktol fuggetlenul smileykat fogunk neked mutatni.\n'...
    'Minden alkalommal, amikor vidam smiley-t mutatunk neked 20 Ft-al tobbet adunk neked a kiserlet vegen.\n'...
    'Amikor szomoru smiley-t mutatunk neked 20 Ft-al kevesebb penzt adunk neked a kiserlet vegen.\n'...
    'A semleges smiley-nal nem valtozik a kiserletert kapott penzosszeg.\n'...
    'Nyomjd meg az "l" betut a gyakorlo feladatokra valo tovabblepeshez!\n'...
    'Ebben a reszben kapsz meg visszajelzest a teljesetmenyedrol.\n'...
    ];

%% show instructions
DrawFormattedText(window, InstructionTest, 100, 'center');
Screen(window,'Flip');

%% check response to finish the instructions and go to the practice trials
response = 0;

while response == 0
    [keyIsDown,secs,keyCode] = KbCheck;
        if (keyIsDown == 1 && keyCode(76) == 1)
            response = 1;
        end;
end

% setup practice trials (n = 24)
%% read the trial specifications
cd('blocks');
practiceBlock = csv2cell('practiceBlock.csv')
cd ('..');

%% number of all trials
numTrials = 24;

%% running the practice block
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

%% draw stimuli
DrawFormattedText(window, char(practiceBlock(trial, 5)), 100, 'center');
Screen(window,'Flip');
KbWait();

%% set original response value for loop 
response = NaN;

%% keyboard wait to continue
  while (isnan(response))
    
    [keyIsDown,secs,keyCode]=KbCheck;
 
      if (keyCode(left_key)==1) 
        response='k';
      elseif(keyCode(right_key)==1) 
        response='l';
      end;
    end;

%% draw smiley
Smiley = Screen('MakeTexture', window, imageMatrix(:,:,:,trial));
Screen('DrawTexture',window, Smiley,[],ScreenRect); 
Screen(window,'Flip');
WaitSecs(0.5);

%% save response in the trial spec
firstBlock{trial, 7} = response

end

% instructions
%% setup instructions
InstructionTest = ['Veget ert a gyakorlo resz!\n'...
    'Tovabbra is az lesz a feladatod, hogy minel gyorsabban es pontosabban jelezd,\n'...
    ' hogy a kozepen levo nyil milyen iranyba mutat.\n'...
    'Ezen felul a nyilas feladatok kozott, azoktol fuggetlenul smileykat fogunk neked mutatni.\n'...
    'A smiley-iknak nincs koze a valaszaid pontossagahoz.\n'...
    'Nyomjd meg az "l" betut a gyakorlo feladatokra valo tovabblepeshez!\n'...
    'Ebben a reszben nem kapsz visszajelzest a teljesitmenyedrol.\n'...
    ];

%% show instructions
DrawFormattedText(window, InstructionTest, 100, 'center');
Screen(window,'Flip');

%% check response to finish the instructions and go to the practice trials
response = 0;

while response == 0
    [keyIsDown,secs,keyCode] = KbCheck;
        if (keyIsDown == 1 && keyCode(76) == 1)
            response = 1;
        end;
end

Screen('CloseAll');