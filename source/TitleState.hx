package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var oops = 0;
	var oops2 = 5;
	var BeatMoment = 0;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		Main.BP = 0;
		oops2 = 5;
		Main.LeftBot = false;
		Main.DownBot = false;
		Main.UpBot = false;
		Main.RightBot = false;
		Main.LeftBotH = false;
		Main.DownBotH = false;
		Main.UpBotH = false;
		Main.RightBotH = false;
		Main.LeftTimer = 0;
		Main.DownTimer = 0;
		Main.UpTimer = 0;
		Main.RightTimer = 0;
		trace(curBeat);
		trace(curStep);
		if (Main.BotDemo == 2)
		{
			initialized = false;
		}
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var titBG:FlxSprite;
	var titleNR:FlxSprite;
	var titleBF:FlxSprite;
	var NRy:Float = 0;
	//
	var Note1:FlxSprite;
	var Note2:FlxSprite;
	var Note3:FlxSprite;
	var Note4:FlxSprite;
	var Note5:FlxSprite;
	var Note6:FlxSprite;
	var Note7:FlxSprite;
	var Note8:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		titBG = new FlxSprite(0, 0);
		titBG.loadGraphic(Paths.image('titleBG'));
		titBG.updateHitbox();
		add(titBG);

		createNotes();

		add(Note1);
		add(Note2);
		add(Note3);
		add(Note4);

		titleBF = new FlxSprite(-30, (FlxG.height/2)-130);
		titleBF.loadGraphic(Paths.image('BFtitle'));
		titleBF.antialiasing = true;
		titleBF.scale.set(0.95,0.97);
		titleBF.updateHitbox();
		add(titleBF);
		
		add(Note5);
		add(Note6);
		add(Note7);
		add(Note8);

		logoBl = new FlxSprite((FlxG.width/2)-160, -90);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.scale.set(0.8, 0.8);
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		gfDance.alpha = 0;
		add(logoBl);

		titleNR = new FlxSprite(FlxG.width/2 - 100, 165);
		titleNR.loadGraphic(Paths.image('NRlogo'));
		titleNR.updateHitbox();
		titleNR.antialiasing = true;
		titleNR.scale.set(0.7,0.7);
		add(titleNR);

		titleText = new FlxSprite(FlxG.width/2, FlxG.height * 0.78);
		titleText.frames = Paths.getSparrowAtlas('titleEnter2');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.scale.set(1.25,1.25);
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		curBeat = 0;
		curStep = 0;

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
		{
			skipIntro();
			BeatMoment = 40;
		}
		else
			initialized = true;

		// credGroup.add(credTextShit);
		oops = FlxG.random.int(1, 100);
		
		new FlxTimer().start(0.02, function(tmr:FlxTimer)
		{
			if (titleNR.y < 172)
			{
				NRy += 0.0125;
			}
			if (titleNR.y > 172)
			{
				NRy -= 0.0125;
			}
			
			titleNR.y += NRy;
			
			titBG.x -= 0.5;
			titBG.y -= 0.5;
			
			if (titBG.x <= -128)
			{
				titBG.x += 128;
				titBG.y += 128;
			}
			
			//
				noteStep();
		}, 0);
	}

	function createNotes()
	{
		Note1 = new FlxSprite(0,-120);
		Note1.frames = Paths.getSparrowAtlas('notelol');
		Note1.animation.addByPrefix('greenScroll', 'green0');
		Note1.animation.addByPrefix('redScroll', 'red0');
		Note1.animation.addByPrefix('blueScroll', 'blue0');
		Note1.animation.addByPrefix('purpleScroll', 'purple0');
		Note1.scale.set(0.6,0.6);
		//
		Note2 = new FlxSprite(0,-120);
		//Note2.loadGraphic(Paths.image('notelol'));
		Note2.frames = Paths.getSparrowAtlas('notelol');
		Note2.animation.addByPrefix('greenScroll', 'green0');
		Note2.animation.addByPrefix('redScroll', 'red0');
		Note2.animation.addByPrefix('blueScroll', 'blue0');
		Note2.animation.addByPrefix('purpleScroll', 'purple0');
		Note2.scale.set(0.6,0.6);
		//
		Note3 = new FlxSprite(0,-120);
		//Note3.loadGraphic(Paths.image('notelol'));
		Note3.frames = Paths.getSparrowAtlas('notelol');
		Note3.animation.addByPrefix('greenScroll', 'green0');
		Note3.animation.addByPrefix('redScroll', 'red0');
		Note3.animation.addByPrefix('blueScroll', 'blue0');
		Note3.animation.addByPrefix('purpleScroll', 'purple0');
		Note3.scale.set(0.64,0.64);
		//
		Note4 = new FlxSprite(0,-120);
		//Note4.loadGraphic(Paths.image('notelol'));
		Note4.frames = Paths.getSparrowAtlas('notelol');
		Note4.animation.addByPrefix('greenScroll', 'green0');
		Note4.animation.addByPrefix('redScroll', 'red0');
		Note4.animation.addByPrefix('blueScroll', 'blue0');
		Note4.animation.addByPrefix('purpleScroll', 'purple0');
		Note4.scale.set(0.64,0.64);
		//
		Note5 = new FlxSprite(0,-120);
		//Note5.loadGraphic(Paths.image('notelol'));
		Note5.frames = Paths.getSparrowAtlas('notelol');
		Note5.animation.addByPrefix('greenScroll', 'green0');
		Note5.animation.addByPrefix('redScroll', 'red0');
		Note5.animation.addByPrefix('blueScroll', 'blue0');
		Note5.animation.addByPrefix('purpleScroll', 'purple0');
		Note5.scale.set(0.67,0.67);
		//
		Note6 = new FlxSprite(0,-120);
		//Note6.loadGraphic(Paths.image('notelol'));
		Note6.frames = Paths.getSparrowAtlas('notelol');
		Note6.animation.addByPrefix('greenScroll', 'green0');
		Note6.animation.addByPrefix('redScroll', 'red0');
		Note6.animation.addByPrefix('blueScroll', 'blue0');
		Note6.animation.addByPrefix('purpleScroll', 'purple0');
		Note6.scale.set(0.67,0.67);
		//
		Note7 = new FlxSprite(0,-120);
		//Note7.loadGraphic(Paths.image('notelol'));
		Note7.frames = Paths.getSparrowAtlas('notelol');
		Note7.animation.addByPrefix('greenScroll', 'green0');
		Note7.animation.addByPrefix('redScroll', 'red0');
		Note7.animation.addByPrefix('blueScroll', 'blue0');
		Note7.animation.addByPrefix('purpleScroll', 'purple0');
		Note7.scale.set(0.7,0.7);
		//
		Note8 = new FlxSprite(0,-120);
		//Note8.loadGraphic(Paths.image('notelol'));
		Note8.frames = Paths.getSparrowAtlas('notelol');
		Note8.animation.addByPrefix('greenScroll', 'green0');
		Note8.animation.addByPrefix('redScroll', 'red0');
		Note8.animation.addByPrefix('blueScroll', 'blue0');
		Note8.animation.addByPrefix('purpleScroll', 'purple0');
		Note8.scale.set(0.7,0.7);
		//
		Main.RCurrentSeed = FlxG.random.resetInitialSeed();
	}
	
	function noteStep()
	{
		var woah = 0;
		Note1.y -= 3;
		Note2.y	-= 5;
		Note3.y	-= 6;
		Note4.y	-= 7;
		Note5.y -= 8;
		Note6.y	-= 9;
		Note7.y	-= 10;
		Note8.y	-= 11;
	
		if (Note1.y < -120)
		{
			Note1.x = FlxG.random.int(-80, Std.int(FlxG.width/2));
			Note1.y = FlxG.height+FlxG.random.int(100, 600);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note1.animation.play('greenScroll');
				case 2:
					Note1.animation.play('redScroll');
				case 3:
					Note1.animation.play('blueScroll');
				case 4:
					Note1.animation.play('purpleScroll');
			}
			
		}
		if (Note2.y < -120)
		{
			Note2.x = FlxG.random.int(-80, Std.int(FlxG.width/2)-100);
			Note2.y = FlxG.height+FlxG.random.int(100, 600);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note2.animation.play('greenScroll');
				case 2:
					Note2.animation.play('redScroll');
				case 3:
					Note2.animation.play('blueScroll');
				case 4:
					Note2.animation.play('purpleScroll');
			}
		}
		if (Note3.y < -120)
		{
			Note3.x = FlxG.random.int(-80, Std.int(FlxG.width/2)-100);
			Note3.y = FlxG.height+FlxG.random.int(300, 480);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note3.animation.play('greenScroll');
				case 2:
					Note3.animation.play('redScroll');
				case 3:
					Note3.animation.play('blueScroll');
				case 4:
					Note3.animation.play('purpleScroll');
			}
		}
		if (Note4.y < -120)
		{
			Note4.x = FlxG.random.int(-80, Std.int(FlxG.width/2)-100);
			Note4.y = FlxG.height+FlxG.random.int(300, 480);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note4.animation.play('greenScroll');
				case 2:
					Note4.animation.play('redScroll');
				case 3:
					Note4.animation.play('blueScroll');
				case 4:
					Note4.animation.play('purpleScroll');
			}
		}
		if (Note5.y < -120)
		{
			Note5.x = FlxG.random.int(-80, Std.int(FlxG.width/2)-100);
			Note5.y = FlxG.height+FlxG.random.int(300, 480);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note5.animation.play('greenScroll');
				case 2:
					Note5.animation.play('redScroll');
				case 3:
					Note5.animation.play('blueScroll');
				case 4:
					Note5.animation.play('purpleScroll');
			}
		}
		if (Note6.y < -120)
		{
			Note6.x = FlxG.random.int(-80, Std.int(FlxG.width/2)-100);
			Note6.y = FlxG.height+FlxG.random.int(300, 480);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note6.animation.play('greenScroll');
				case 2:
					Note6.animation.play('redScroll');
				case 3:
					Note6.animation.play('blueScroll');
				case 4:
					Note6.animation.play('purpleScroll');
			}
		}
		if (Note7.y < -120)
		{
			Note7.x = FlxG.random.int(-80, Std.int(FlxG.width/2)-100);
			Note7.y = FlxG.height+FlxG.random.int(300, 480);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note7.animation.play('greenScroll');
				case 2:
					Note7.animation.play('redScroll');
				case 3:
					Note7.animation.play('blueScroll');
				case 4:
					Note7.animation.play('purpleScroll');
			}
		}
		if (Note8.y < -120)
		{
			Note8.x = FlxG.random.int(-80, Std.int(FlxG.width/2)-100);
			Note8.y = FlxG.height+FlxG.random.int(300, 480);
			woah = FlxG.random.int(1,4);
			switch (woah)
			{
				case 1:
					Note8.animation.play('greenScroll');
				case 2:
					Note8.animation.play('redScroll');
				case 3:
					Note8.animation.play('blueScroll');
				case 4:
					Note8.animation.play('purpleScroll');
			}
		}
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (oops2 > 0)
		{
			oops2 -= 1;
			if (oops == 0)
			{
			Main.BotDemo = 0;
			}
		}
		
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{

				// Get current version of Kade Engine

				var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe");

				http.onData = function (data:String) {
				  
				  	if (!MainMenuState.kadeEngineVer.contains(data.trim()) && !OutdatedSubState.leftState && MainMenuState.nightly == "")
					{
						FlxG.switchState(new MainMenuState());
					}
					else
					{
						FlxG.switchState(new MainMenuState());
					}
				}
				
				http.onError = function (error) {
				  trace('error: $error');
				  FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}
				
				http.request();

			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		if (Main.BotDemo == 0 && oops2 == 0)
		{
		super.beatHit();

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');
		

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 2:
				createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				if (Main.watermarks)
					createCoolText(['Kade Engine', 'by']);
				else
					createCoolText(['In Partnership', 'with']);
			case 7:
				if (Main.watermarks)
					addMoreText('KadeDeveloper');
				else
				{
					addMoreText('Newgrounds');
					ngSpr.visible = true;
				}
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				if (oops > 1)
				{
				addMoreText('FNF');
				}
				else
				{
				addMoreText('WAIT');
				}
			// credTextShit.visible = true;
			case 14:
				if (oops > 1)
				{
				addMoreText('NOTE');
				}
				else
				{
				addMoreText('I FORGOT');
				}
			// credTextShit.text += '\nNight';
			case 15:
				if (oops > 1)
				{
				addMoreText('RANDOMIZER');
				}
				else
				{
				addMoreText('THE NAME');
				}
			case 16:
				if (oops > 1)
				{
				BeatMoment = -1;
				skipIntro();
				}
				else
				{
				addMoreText('SHIT');
				}
			case 17:
				if (oops == 1)
				{
				BeatMoment = 0;
				skipIntro();
				}
		}
		
		BeatMoment += 1;
		
		if (BeatMoment >= 80 && Main.BotDemo == 0)
		{
				Main.RCurrentSeed = FlxG.random.resetInitialSeed();
				var songtype = 0;
				var songnumber = 1;
				var bopoobochance = FlxG.random.int(1, 1000);
				var songname = "";
				var week = 1;
				Main.BotDemo = 1;
				Main.BotMode = 1;
				Main.ExtremeMode = 0;
				Main.RandomizeOn = true;
				var difficultpoop = 2;
				
				Main.RCurrentSeed = FlxG.random.resetInitialSeed();
				songnumber = FlxG.random.int(1, 118);
				
				switch (songnumber)
				{
					case 1:
						songname = "tutorial";
					case 2:
						songname = "bopeebo";
					case 3:
						songname = "fresh";
					case 4:
						songname = "dadbattle";
					case 5:
						songname = "spookeez";
						week = 2;
					case 6:
						songname = "south";
						week = 2;
					case 7:
						songname = "monster";
						week = 2;
					case 8:
						songname = "pico";
						week = 3;
					case 9:
						songname = "philly";
						week = 3;
					case 10:
						songname = "blammed";
						week = 3;
					case 11:
						songname = "satin-panties";
						week = 4;
					case 12:
						songname = "high";
						week = 4;
					case 13:
						songname = "milf";
						week = 4;
					case 14:
						songname = "cocoa";
						week = 5;
					case 15:
						songname = "eggnog";
						week = 5;
					case 16:
						songname = "winter-horrorland";
						week = 5;
					case 17:
						songname = "senpai";
						week = 6;
					case 18:
						songname = "roses";
						week = 6;
					case 19:
						songname = "thorns";
						week = 6;
					case 20:
						songname = "test";
						week = 6;
					case 21:
						songname = "megalo strike back";
					case 22:
						songname = "improbable outset";
					case 23:
						songname = "madness";
					case 24:
						songname = "abigail";
					case 25:
						songname = "engage foe";
					case 26:
						songname = "eat your heart out";
					case 27:
						songname = "highrise";
						difficultpoop = 3;
						week = 6;
					case 28:
						songname = "ordinance";
						difficultpoop = 3;
						week = 6;
					case 29:
						songname = "transgression";
						difficultpoop = 3;
						week = 6;
					case 30:
						songname = "surfs up";
					case 31:
						songname = "tides";
					case 32:
						songname = "beach brawl";
					case 33:
						songname = "smooth";
					case 34:
						songname = "gossip";
					case 35:
						songname = "teen suicide";
					case 36:
						songname = "light it up";
					case 37:
						songname = "ruckus";
					case 38:
						songname = "target practice";
					case 39:
						songname = "sporting";
					case 40:
						songname = "boxing match";
					case 41:
						songname = "carol roll";
						week = 3;
					case 42:
						songname = "body";
						week = 3;
					case 43:
						songname = "boogie";
						week = 3;
					case 44:
						songname = "pentafluoride";
					case 45:
						songname = "diminished";
					case 46:
						songname = "psychoneurotic";
					case 47:
						songname = "lo-fight";
					case 48:
						songname = "overhead";
					case 49:
						songname = "ballistic";
					case 50:
						songname = "sc-tutorial";
					case 51:
						songname = "sc-bopeebo";
					case 52:
						songname = "sc-fresh";
					case 53:
						songname = "sc-dadbattle";
					case 54:
						songname = "sc-spookeez";
						week = 2;
					case 55:
						songname = "sc-south";
						week = 2;
					case 56:
						songname = "sc-sugar rush";
						week = 2;
					case 57:
						songname = "sc-pico";
						week = 3;
					case 58:
						songname = "sc-philly";
						week = 3;
					case 59:
						songname = "sc-blammed";
						week = 3;
					case 60:
						songname = "sc-satin panties";
						week = 4;
					case 61:
						songname = "sc-high";
						week = 4;
					case 62:
						songname = "sc-milf";
						week = 4;
					case 63:
						songname = "Best Girl";
					case 64:
						songname = "Daddy's Girl";
					case 65:
						songname = "Salty Love";
					case 66:
						songname = "Daughter Complex";
					case 67:
						songname = "Sweet n' Spooky";
						week = 2;
					case 68:
						songname = "Sour n' Scary";
						week = 2;
					case 69:
						songname = "Opheebop";
						week = 2;
					case 70:
						songname = "Protect";
						week = 3;
					case 71:
						songname = "Defend";
						week = 3;
					case 72:
						songname = "Safeguard";
						week = 3;
					case 73:
						songname = "Indie Star";
						week = 4;
					case 74:
						songname = "Rising Star";
						week = 4;
					case 75:
						songname = "Superstar";
						week = 4;
					case 76:
						songname = "Order Up";
						week = 5;
					case 77:
						songname = "Rush Hour";
						week = 5;
					case 78:
						songname = "Freedom";
						week = 5;
					case 79:
						songname = "Buckets";
						week = 6;
					case 80:
						songname = "Logarithms";
						week = 6;
					case 81:
						songname = "Terminal";
						week = 6;
					case 82:
						songname = "My Battle";
					case 83:
						songname = "Last Chance";
					case 84:
						songname = "Genocide";
					case 85:
						songname = "BoPanties";
					case 86:
						songname = "Highly Fresh";
					case 87:
						songname = "GFILFW";
					case 88:
						songname = "b3-tutorial";
					case 89:
						songname = "b3-bopeebo";
					case 90:
						songname = "b3-fresh";
					case 91:
						songname = "b3-dadbattle";
					case 92:
						songname = "b3-spookeez";
						week = 2;
					case 93:
						songname = "b3-south";
						week = 2;
					case 94:
						songname = "b3-pico";
						week = 3;
					case 95:
						songname = "b3-philly";
						week = 3;
					case 96:
						songname = "b3-blammed";
						week = 3;
					case 97:
						songname = "b3-satin panties";
						week = 4;
					case 98:
						songname = "b3-high";
						week = 4;
					case 99:
						songname = "b3-milf";
						week = 4;
					case 100:
						songname = "b3-cocoa";
						week = 5;
					case 101:
						songname = "b3-eggnog";
						week = 5;
					case 102:
						songname = "b3-winter horrorland";
						week = 5;
					case 103:
						songname = "b3-senpai";
						week = 6;
					case 104:
						songname = "b3-roses";
						week = 6;
					case 105:
						songname = "b3-thorns";
						week = 6;
					case 106:
						songname = "b3-lo-fight";
					case 107:
						songname = "b3-overhead";
					case 108:
						songname = "b3-ballistic";
					case 109:
						songname = "ballistic-old";
					case 110:
						songname = "fns-tutorial";
						difficultpoop = 1;
					case 111:
						songname = "adobe thrash";
					case 112:
						songname = "piconjo's school";
					case 113:
						songname = "trapped in teh 6aym";
					case 114:
						songname = "norway";
					case 115:
						songname = "tordbot";
					case 116:
						songname = "eferu chan";
					case 117:
						songname = "fruity reeverb 2";
					case 118:
						songname = "fl slayer";
					
				}
				
				if (bopoobochance == 1)
				{
					songname = "bopoobo";
					week = 1;
				}
				
				
				var poop:String = Highscore.formatSong(songname, 2);
				
				PlayState.SONG = Song.loadFromJson(poop, songname);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = difficultpoop;
				PlayState.storyWeek = week;
				trace('CUR WEEK' + week);
				LoadingState.loadAndSwitchState(new PlayState());
		}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
