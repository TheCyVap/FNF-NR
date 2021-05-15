package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";
	public static var RandomizationToggle:FlxText;
	public static var RandomSeedText:FlxText;
	public static var RInstruct:FlxText;
	public static var RInstruct2:FlxText;
	public static var RSelect:FlxText;
	public static var ExtremeToggle:FlxText;

	public static var NumInput = 0;
	public static var numchange = 0;
	public static var numpress = -1;

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		Main.StoryMenu = 0;
		Main.BotMode = 0;
		Main.BotDemo = 0;
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		/*
		public static var NumInput = 0;
		public static var num0 = 0;
		public static var num1 = 0;
		public static var num2 = 0;
		public static var num3 = 0;
		public static var num4 = 0;
		public static var num5 = 0;
		public static var num6 = 0;
		public static var num7 = 0;
		public static var num8 = 0;
		public static var num9 = 0;
		*/
		
		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer + " [Modded K.E. " + kadeEngineVer + " Build]", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		RandomizationToggle = new FlxText(5, FlxG.height - 44, 0,"", 12);
		RandomizationToggle.scrollFactor.set();
		RandomizationToggle.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(RandomizationToggle);
		RandomizationToggle.text = "Randomized Notes: " + Main.RandomizeOn;
		
		RandomSeedText = new FlxText(5, FlxG.height - 62, 0,"", 12);
		RandomSeedText.scrollFactor.set();
		RandomSeedText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(RandomSeedText);
		RandomSeedText.text = "Seed: [RANDOMIZED]";
		
		RInstruct = new FlxText(5, FlxG.height - 120, 0,"[Left/Right] Change Digit\n[Up/Down] Raise/Lower Digit", 12);
		RInstruct.scrollFactor.set();
		RInstruct.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(RInstruct);
		RInstruct.text = "[C] to set seed";
		
		RSelect = new FlxText(-3+(RandomSeedText.width), FlxG.height - 62, 0,"", 12);
		RSelect.scrollFactor.set();
		RSelect.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(RSelect);
		RSelect.alpha = 0;
		
		RInstruct2 = new FlxText(5, FlxG.height - 102, 0,	"[V] to reset seed", 12);
		RInstruct2.scrollFactor.set();
		RInstruct2.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(RInstruct2);
		
		RandomSeedText.alpha = 0;
		RSelect.alpha = 0;
		RInstruct.alpha = 0;
		RInstruct2.alpha = 0;
		
		ExtremeToggle = new FlxText(5, FlxG.height - 26, 0,"Press [R] for Randomization Options", 12);
		ExtremeToggle.scrollFactor.set();
		ExtremeToggle.setFormat("VCR OSD Mono", 24, FlxColor.CYAN, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(ExtremeToggle);
		ExtremeToggle.x = FlxG.width-(ExtremeToggle.width)-4;

		NumInput = 0;		
		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
	
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (FlxG.keys.justPressed.R)
			{
				selectedSomethin = true;
				FlxG.switchState(new RandomizerOptionsMenu());
			}
			if (numchange == 0)
			{
				if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

				if (controls.BACK)
				{
					curBeat = 15;
					FlxG.switchState(new TitleState());
				}

				if (controls.ACCEPT)
				{
					if (optionShit[curSelected] == 'donate')
					{
						#if linux
						Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
						#else
						FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
						#end
					}
					else
					{
						selectedSomethin = true;
						FlxG.sound.play(Paths.sound('confirmMenu'));

						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

						menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
							{
								FlxTween.tween(spr, {alpha: 0}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
							else
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = optionShit[curSelected];

									switch (daChoice)
									{
										case 'story mode':
											Main.StoryMenu = -1;
											FlxG.switchState(new FreeplayState());
											trace("Story Menu Selected");
										case 'freeplay':
											FlxG.switchState(new FreeplayState());

											trace("Freeplay Menu Selected");

										case 'options':
											FlxG.switchState(new OptionsMenu());
									}
								});
							}
						remove(RandomizationToggle);
						remove(RandomSeedText);
						remove(RInstruct);
						remove(RInstruct2);
						remove(RSelect);
						remove(ExtremeToggle);
						
						FlxG.sound.muteKeys = [52];
						FlxG.sound.volumeUpKeys = [187];
						FlxG.sound.volumeDownKeys = [189];
						});
					}
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	
	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
