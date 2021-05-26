package;

import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;

class RandomizerOptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 1;
	
	
	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCatagory;
	var OTitle:FlxText;
	var OMenu1:FlxText;
	var OMenu2:FlxText;
	var OMenu3:FlxText;
	var OSeed:FlxText;		
	var OMenu4:FlxText;
	var OMenu5:FlxText;
	var OMenu6:FlxText;
	var OMenu7:FlxText;
	var SeedX = 0;
	var SettingSeed = 0;
	var ded = 0;
	var numpress = -1;
	var NumInput = Main.RandomizeSeed;
	var bgArrows:FlxSprite;
	var bgturn = 0;
	var bgtimer = 300;

	override function create()
	{
	
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;
		
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("options1BG"));

		menuBG.updateHitbox();
		menuBG.antialiasing = true;
		add(menuBG);
		
		bgArrows = new FlxSprite(0,0);
		bgArrows.frames = Paths.getSparrowAtlas('arrowBG');
		bgArrows.animation.addByPrefix('startA', 'startA',16, false);
		bgArrows.animation.addByPrefix('rotateA', 'rotateA',16, false);
		bgArrows.animation.addByPrefix('rotateB', 'rotateB',16, false);
		bgArrows.animation.addByPrefix('rotateC', 'rotateC',16, false);
		bgArrows.animation.addByPrefix('rotateD', 'rotateD',16, false);
		bgArrows.scale.set(4,4);
		bgArrows.updateHitbox();
		bgArrows.antialiasing = true;
		bgArrows.alpha = 0.5;
		add(bgArrows);
		bgArrows.animation.play('startA');
		
		Main.RCurrentSeed = FlxG.random.resetInitialSeed();

		new FlxTimer().start(0.02, function(tmr:FlxTimer)
		{
			bgtimer -= FlxG.random.int(1,4);
			if (bgtimer <= 0)
			{
				bgturn += 1;
				bgtimer += 300;
				
				switch (bgturn)
				{
					case 1:
						bgArrows.animation.play('rotateA');
					case 2:
						bgArrows.animation.play('rotateB');
					case 3:
						bgArrows.animation.play('rotateC');
					case 4:
					{
						bgArrows.animation.play('rotateD');
						bgturn = 0;
					}
				}
			}
		
			menuBG.x -= 0.5;
			menuBG.y -= 0.5;
			
			if (menuBG.x <= -128)
			{
				menuBG.x += 128;
				menuBG.y += 128;
			}
			
			bgArrows.x -= 0.5;
			bgArrows.y -= 0.5;
			
			if (bgArrows.x <= -256)
			{
				bgArrows.x += 256;
				bgArrows.y += 256;
			}
			
		}, 0);

		currentDescription = "none";

		OTitle = new FlxText(FlxG.width/2, 32, 0, "RANDOMIZER OPTIONS", 12);
		OTitle.scrollFactor.set();
		OTitle.setFormat("VCR OSD Mono", 60, FlxColor.CYAN, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLUE);
		add(OTitle);
		OTitle.x -= OTitle.width/2;
		
		OMenu1 = new FlxText(FlxG.width/2,  100, 0, "Note Randomization:  ON", 12);
		OMenu1.scrollFactor.set();
		OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OMenu1);
		OMenu1.x -= OMenu1.width/2;
		
		OMenu2 = new FlxText(FlxG.width/2, 150, 0, "     Seed: [          ]", 12);
		OMenu2.scrollFactor.set();
		OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OMenu2);
		OMenu2.x -= OMenu2.width/2;
		
		OSeed = new FlxText(FlxG.width/2, 150, 0,  "RANDOMIZED", 12);
		OSeed.scrollFactor.set();
		OSeed.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OSeed);
		SeedX = Math.round(OSeed.x + ((OMenu2.width/2)-30));
		OSeed.x = SeedX;
		if (Main.RandomizeSeed != 0)
		{
			OSeed.text = ""+Main.RandomizeSeed;
			OSeed.x = SeedX-OSeed.width;
		}
		
		OMenu3 = new FlxText(FlxG.width/2, 200, 0, "      Extreme Mode:  ON", 12);
		OMenu3.scrollFactor.set();
		OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OMenu3);
		OMenu3.x -= OMenu3.width/2;

		OMenu4 = new FlxText(FlxG.width/2, 250, 0, "         Jack Mode:  ON", 12);
		OMenu4.scrollFactor.set();
		OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OMenu4);
		OMenu4.x -= OMenu4.width/2;
		
		OMenu5 = new FlxText(FlxG.width/2, 300, 0, "   Random Opponent:  ON", 12);
		OMenu5.scrollFactor.set();
		OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OMenu5);
		OMenu5.x -= OMenu5.width/2;
		
		OMenu6 = new FlxText(FlxG.width/2, 350, 0, "Extra Health Icons:  ON", 12);
		OMenu6.scrollFactor.set();
		OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OMenu6);
		OMenu6.x -= OMenu6.width/2;
		
		OMenu7 = new FlxText(FlxG.width/2, 500, 0, "BACK TO MAIN MENU", 12);
		OMenu7.scrollFactor.set();
		OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(OMenu7);
		OMenu7.x -= OMenu7.width/2;

		versionShit = new FlxText(5, FlxG.height - 24, 0, "text", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		if (Main.RandomizeOn == false)
		{
			OMenu4.alpha = 0;
			OMenu5.alpha = 0;
		}
		
		updateMenuStuff();

		super.create();
	}

	var isCat:Bool = false;
	

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
			if (ded == 0 && SettingSeed == 0)
			{
				if (controls.UP_P)
					changeSelection(-1);
				if (controls.DOWN_P)
					changeSelection(1);
			}
			
			if (SettingSeed == 1)
			{
			
				numpress = -1;
				if (FlxG.keys.justPressed.ZERO)
					numpress = 0;
				if (FlxG.keys.justPressed.ONE)
					numpress = 1;
				if (FlxG.keys.justPressed.TWO)
					numpress = 2;
				if (FlxG.keys.justPressed.THREE)
					numpress = 3;
				if (FlxG.keys.justPressed.FOUR)
					numpress = 4;
				if (FlxG.keys.justPressed.FIVE)
					numpress = 5;
				if (FlxG.keys.justPressed.SIX)
					numpress = 6;
				if (FlxG.keys.justPressed.SEVEN)
					numpress = 7;
				if (FlxG.keys.justPressed.EIGHT)
					numpress = 8;
				if (FlxG.keys.justPressed.NINE)
					numpress = 9;
					
				if (numpress > -1)
				{
					if (NumInput > 214748364)
					{
						NumInput = 2147483647;
						numpress = -1;
					}
					if (NumInput == 214748364 && numpress > 7)
					{
						NumInput = 2147483647;
						numpress = -1;
					}
					
					if (numpress > -1)
					{
					NumInput = NumInput*10;
					NumInput += numpress;
					numpress = -1;
					}
				}
				
				if (FlxG.keys.justPressed.BACKSPACE)
				{
					NumInput = Math.floor(NumInput/10);
				}
				
				if (FlxG.keys.justPressed.R)
				{
					SettingSeed = 0;
					NumInput = 0;
					Main.RandomizeSeed = NumInput;
				}
				
				if (NumInput < 0)
				{
				NumInput = 0;
				}
				
				OSeed.text = ""+NumInput;
				OSeed.x = SeedX-OSeed.width;
			}

			if (controls.ACCEPT)
			{
				if (ded == 0)
				{
					switch(curSelected)
					{
						case 1:
						{
							var oop = Main.RandomizeOn;
							if (oop == false)
							{
								Main.RandomizeOn = true;
							}
							else
							{
								Main.RandomizeOn = false;
								Main.JackMode = 0;
								Main.ROpponents = 0;
							}
						}
						case 2:
						{
							var oop = SettingSeed;
							if (oop == 0)
							{
								SettingSeed = 1;
							}
							else
							{
								SettingSeed = 0;
								Main.RandomizeSeed = NumInput;
							}
						}
						case 3:
						{
							var oop = Main.ExtremeMode;
							if (oop == 0)
							{
								Main.ExtremeMode = 1;
							}
							else
							{
								Main.ExtremeMode = 0;
							}
						}
						case 4:
						{
							var oop = Main.JackMode;
							if (oop == 0)
							{
								Main.JackMode = 1;
							}
							else
							{
								Main.JackMode = 0;
							}
						}
						case 5:
						{
							var oop = Main.ROpponents;
							if (oop == 0)
							{
								Main.ROpponents = 1;
							}
							else
							{
								Main.ROpponents = 0;
							}
						}
						case 6:
						{
							var oop = Main.ExtraIcons;
							if (oop == 0)
							{
								Main.ExtraIcons = 1;
							}
							else
							{
								Main.ExtraIcons = 0;
							}
						}
						case 7:
						{
							ded = 1;
							FlxG.switchState(new MainMenuState());
						}
					}
				updateMenuStuff();
				}
			}
			
	}

	var isSettingControl:Bool = false;

	function updateMenuStuff()
	{
		versionShit.text = "";
		OMenu1.text = "Note Randomization: OFF";
		OMenu2.text = "     Seed: [          ]";
		OSeed.text = "RANDOMIZED";
		OMenu3.text = "      Extreme Mode: OFF";
		OMenu4.text = "         Jack Mode: OFF";
		OMenu5.text = "   Random Opponent: OFF";
		OMenu6.text = "Extra Health Icons: OFF";
		
		if (Main.RandomizeOn == true)
		{
			OMenu4.alpha = 1;
			OMenu5.alpha = 1;
			OMenu1.text = "Note Randomization:  ON";
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		if (Main.RandomizeSeed == 0)
		{
		OSeed.text = "RANDOMIZED";
		OSeed.x = SeedX-OSeed.width;
		}
		else
		{
		OSeed.text = ""+Main.RandomizeSeed;
		OSeed.x = SeedX-OSeed.width;
		}
		if (Main.ExtremeMode == 1)
			OMenu3.text = "      Extreme Mode:  ON";
		if (Main.JackMode == 1)
			OMenu4.text = "         Jack Mode:  ON";
		if (Main.ROpponents == 1)
			OMenu5.text = "   Random Opponent:  ON";
		if (Main.ExtraIcons == 1)
			OMenu6.text = "Extra Health Icons:  ON";
			
		switch(curSelected)
		{
			case 1:
			{
			OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48,  FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.text = "Randomizes what arrow every note is on!";
			}
			case 2:
			{
			OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48,  FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			if (SettingSeed == 0)
				versionShit.text = "Your current Random Seed. Press [ENTER] to set it.";
			if (SettingSeed == 1)
				versionShit.text = "Set your seed by typing it, or press [R] to make it random.";
			}
			case 3:
			{
			OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48,  FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.text = "BF will get every note in the usual chart. (Freeplay Only)";
			}
			case 4:
			{
			OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48,  FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.text = "The Randomizer will attempt to create many more jacks than usual when it can.";
			}
			case 5:
			{
			OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48,  FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.text = "Opponent is randomized on each song play, which will probably break things. (Freeplay Only)";
			}
			case 6:
			{
			OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48,  FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.text = "Adds in winning icons for everyone. (GF/Week 6 excluded.)";
			}	
			case 7:
			{
			OMenu1.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48,  FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu3.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu4.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu5.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu6.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OMenu7.setFormat("VCR OSD Mono", 48, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			versionShit.text = "Exit this menu.";
			}	
		}
		
		if (Main.RandomizeOn == false)
		{
			OMenu4.alpha = 0;
			OMenu5.alpha = 0;
			if (curSelected != 2)
			{
			OMenu2.setFormat("VCR OSD Mono", 48, FlxColor.GRAY, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			OSeed.setFormat("VCR OSD Mono", 48, FlxColor.GRAY, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			}
		}
		
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end
		
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (Main.RandomizeOn == false)
		{
			if (change == 1 && curSelected == 2)
			{
			curSelected = 3;
			}
			if (change == -1 && curSelected == 2)
			{
			curSelected = 1;
			}
			if (change == 1 && curSelected == 4)
			{
			curSelected = 6;
			}
			if (change == -1 && curSelected == 5)
			{
			curSelected = 3;
			}
		}

		if (curSelected < 1)
		{
			curSelected = 7;
		}
		if (curSelected > 7)
		{
			curSelected = 1;
		}

		updateMenuStuff();

		var bullShit:Int = 0;
	}
}
