package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	var curMenu:Int = Main.FPMenu;
	var musplaying = 0;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('no'));
		
		if (curMenu == 0)
		{
			initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaymodlist'));
			curSelected = 1;
		}
		if (curMenu == 1)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-fnf'));
		if (curMenu == 2)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-chara'));
		if (curMenu == 3)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-tricky'));
		if (curMenu == 4)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-vsabigail'));
		if (curMenu == 5)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-vsneon'));
		if (curMenu == 6)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-beachbrother'));
		if (curMenu == 7)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-fns'));
		if (curMenu == 8)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-vsmatt'));
		if (curMenu == 9)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-vscarol'));
		if (curMenu == 10)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-vsanders'));
		if (curMenu == 11)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-vswhitty'));
		if (curMenu == 12)
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-starcatcher'));
		if (curMenu == 13)
		{
			initSonglist = CoolUtil.coolTextFile(Paths.txt('songlist-saltysunday'));
			curDifficulty = 2;
		}
			
		if (Main.StoryMenu == -1)
		{
			curMenu = -1;
			initSonglist = CoolUtil.coolTextFile(Paths.txt('storymodlist'));
			curSelected = 0;
		}
			
		
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (curMenu > 0)
		{
		scoreText.text = "PERSONAL BEST:" + lerpScore;
		}
		else
		{
			scoreText.text = "";
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			if (curMenu > 0)
			{
			Main.FPMenu = 0;
			FlxG.switchState(new FreeplayState());
			}
			else
			{
			FlxG.switchState(new MainMenuState());
			}
		}

		if (accepted)
		{
			if (curMenu > 0)
			{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);
			
			if (FlxG.keys.pressed.B)
			{
			Main.BotMode = 1;
			trace("Bot Mode Active??");
			}
			if (!FlxG.keys.pressed.B)
			{
			Main.BotMode = 0;
			trace("Bot Mode Not Active??");
			}

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
			}
			else
			{
				if (curMenu == 0)
				{
					if (curSelected == 0)
					{
						if (FlxG.keys.pressed.B)
						{
						Main.BotMode = 1;
						trace("Bot Mode Active??");
						}
						if (!FlxG.keys.pressed.B)
						{
						Main.BotMode = 0;
						trace("Bot Mode Not Active??");
						}
						playRandomSong();
					}
					else
					{
					curBeat = -1;
					curStep = -1;
					Main.FPMenu = curSelected;
					FlxG.switchState(new FreeplayState());
					}
				}
				if (curMenu == -1)
				{
					Main.StoryMenu = curSelected+1;
					FlxG.switchState(new StoryMenuState());
				}
			}
		}
		if (curMenu == 0)
		{
		diffText.text = "";
		scoreText.text = "SELECT A MOD/GAME";
		
			if (curSelected == 0)
			{
				scoreText.text = "RANDOM SONG";
				switch (curDifficulty)
				{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
				}
			}
			else
			{
				switch (curSelected)
				{
				case 1:
					diffText.text = "Friday Night Funkin' (19T)";
				case 2:
					diffText.text = "Vs. Chara (1T)";
				case 3:
					diffText.text = "Vs. Tricky (2T)";
				case 4:
					diffText.text = "Vs. Abigail (3T)";
				case 5:
					diffText.text = "Vs. Neon (3T)";
				case 6:
					diffText.text = "Beach Brother (3T)";
				case 7:
					diffText.text = "Friday Night Shootin' (3T)";
				case 8:
					diffText.text = "Vs. Matt (5T)";
				case 9:
					diffText.text = "Vs. Carol (3T)";
				case 10:
					diffText.text = "Vs. Anders (3T)";
				case 11:
					diffText.text = "Vs. Whitty (3T)";
				case 12:
					diffText.text = "Starcatcher (13T)";
				case 13:
					diffText.text = "Salty's Sunday Night (19T)";
				}
			}
		}
		if (curMenu == -1)
		{
		diffText.text = "";
		scoreText.text = "STORY MODE";
		
				switch (curSelected)
				{
				case 0:
					diffText.text = "Friday Night Funkin' (19T)";
				case 1:
					diffText.text = "Starcatcher (13T)";
				case 2:
					diffText.text = "Salty's Sunday Night (19T)";
				}
		}
	}

	function playRandomSong()
	{
				Main.RCurrentSeed = FlxG.random.resetInitialSeed();
				var songtype = FlxG.random.int(1, 4);
				var songnumber = 1;
				var songname = "";
				var week = 1;
				
				Main.RCurrentSeed = FlxG.random.resetInitialSeed();
				songnumber = FlxG.random.int(1, 81);
				
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
						week = 6;
					case 28:
						songname = "ordinance";
						week = 6;
					case 29:
						songname = "transgression";
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
				}
				
				if (songnumber >= 63 && songnumber <= 81)
					curDifficulty = 2;
				
				var poop:String = Highscore.formatSong(songname, curDifficulty);
				
				PlayState.SONG = Song.loadFromJson(poop, songname);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.storyWeek = week;
				trace('CUR WEEK' + week);
				LoadingState.loadAndSwitchState(new PlayState());
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curMenu == 5)
		{
		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;
		}
		else
		{
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		}
		
		if (curMenu == 13)
		{
			curDifficulty = 2;
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		
		if (curMenu > 0)
		{
			switch (curDifficulty)
			{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
				case 3:
					diffText.text = "CRAZY";
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		if (curMenu > 0)
		{
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		}
		else
		{
		if (musplaying == 0)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		
		musplaying = 1;
		}
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
