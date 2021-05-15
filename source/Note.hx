package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var Randomization:Bool = Main.RandomizeOn;
	public var TestPrefix:String = '';
	public var PressCheck = 0;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?mustPress:Bool)
	{
		super();
		
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		
		//trace(mustPress);
		this.mustPress = mustPress;
		if (mustPress == null)
			mustPress = true;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		if (Randomization == false)
		{
			this.noteData = noteData;
		}

		if (Randomization == true)
		{
			var rn = 0;
			var prev = Main.JackPrev;
			
			if (Main.JackMode == 0)
			{
			rn = FlxG.random.int(0, 3);
			this.noteData = rn;
			}
			else
			{
				this.noteData = noteData;
			}
		
			if (prevNote != null && isSustainNote == true)
			{
				this.noteData = prevNote.noteData;
			}
		}

		var daStage:String = PlayState.curStage;
		
		if ((PlayState.SONG.song.toLowerCase() == 'test') && (this.mustPress == false))
		{
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels','week6'), true, 17, 17);

				animation.add('p_greenScroll', [6]);
				animation.add('p_redScroll', [7]);
				animation.add('p_blueScroll', [5]);
				animation.add('p_purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds','week6'), true, 7, 6);

					animation.add('p_purpleholdend', [4]);
					animation.add('p_greenholdend', [6]);
					animation.add('p_redholdend', [7]);
					animation.add('p_blueholdend', [5]);

					animation.add('p_purplehold', [0]);
					animation.add('p_greenhold', [2]);
					animation.add('p_redhold', [3]);
					animation.add('p_bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
		}
		else
		{
			switch (PlayState.SONG.noteStyle)
			{
				case 'pixel':
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels','week6'), true, 17, 17);

					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);

					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds','week6'), true, 7, 6);

						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);

						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
				default:
					frames = Paths.getSparrowAtlas('NOTE_assets');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
			}
		}
		
		if (this.mustPress == false && PlayState.SONG.song.toLowerCase() == 'test')
		{
			TestPrefix = "p_";
		}
		else
		{
			TestPrefix = "";
		}

		if (Randomization == false)
		{
			switch (noteData)
			{
				case 0:
					x += swagWidth * 0;
					animation.play(TestPrefix+'purpleScroll');
				case 1:
					x += swagWidth * 1;
					animation.play(TestPrefix+'blueScroll');
				case 2:
					x += swagWidth * 2;
					animation.play(TestPrefix+'greenScroll');
				case 3:
					x += swagWidth * 3;
					animation.play(TestPrefix+'redScroll');
			}
		}
		if (Randomization == true)
		{
			if (this.noteData == 0)
			{
					x += swagWidth * 0;
					animation.play(TestPrefix+'purpleScroll');
			}
			if (this.noteData == 1)
			{
					x += swagWidth * 1;
					animation.play(TestPrefix+'blueScroll');
			}
			if (this.noteData == 2)
			{
					x += swagWidth * 2;
					animation.play(TestPrefix+'greenScroll');
			}
			if (this.noteData == 3)
			{
					x += swagWidth * 3;
					animation.play(TestPrefix+'redScroll');
			}
		}

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;
			if (Randomization == false)
			{
				switch (noteData)
				{
					case 2:
						animation.play(TestPrefix+'greenholdend');
					case 3:
						animation.play(TestPrefix+'redholdend');
					case 1:
						animation.play(TestPrefix+'blueholdend');
					case 0:
						animation.play(TestPrefix+'purpleholdend');
				}
			}
			if (Randomization == true)
			{
				switch (this.noteData)
				{
					case 2:
						animation.play(TestPrefix+'greenholdend');
					case 3:
						animation.play(TestPrefix+'redholdend');
					case 1:
						animation.play(TestPrefix+'blueholdend');
					case 0:
						animation.play(TestPrefix+'purpleholdend');
				}
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;
			else
			{
				if (PlayState.SONG.song.toLowerCase() == 'test')
				{
				x += 30;
				}
			}

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play(TestPrefix+'purplehold');
					case 1:
						prevNote.animation.play(TestPrefix+'bluehold');
					case 2:
						prevNote.animation.play(TestPrefix+'greenhold');
					case 3:
						prevNote.animation.play(TestPrefix+'redhold');
				}

				
				if(FlxG.save.data.scrollSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * FlxG.save.data.scrollSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
		
	}

	override function update(elapsed:Float)
	{
		if (Main.BotDemo == 2)
		{
			y = 999999;
			alpha = 0;
		}
		super.update(elapsed);
		
		if (mustPress)
		{
			if (PlayState.SONG.song.toLowerCase() == 'test')
			{
				if (PressCheck == 0)
				{
				
				}
			}
		
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (Main.BotMode == 1 && strumTime < Conductor.songPosition)
			{
				strumTime = Conductor.songPosition;
			}
			
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
			{
				if (Main.BotMode == 0 || (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)))
				{
				canBeHit = false;
				}
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit && Main.BotMode == 0)
			{
				trace("FUCK");
				tooLate = true;
			}
				
			if (Main.BotMode == 1)
			{
			var fakeFramerate:Int = Math.round(openfl.Lib.current.stage.frameRate);
			var holdtime = Math.round((fakeFramerate*60) / (PlayState.SONG.bpm))+1;
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5) && strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.4))
				{
					if (isSustainNote && prevNote != null)
					{
					if (this.noteData == 0)
					{
						Main.LeftBotH = true;
						Main.LeftTimer = holdtime;
					}
					if (this.noteData == 1)
					{
						Main.DownBotH = true;
						Main.DownTimer = holdtime;
					}
					if (this.noteData == 2)
					{
						Main.UpBotH = true;
						Main.UpTimer = holdtime;
					}
					if (this.noteData == 3)
					{
						Main.RightBotH = true;
						Main.RightTimer = holdtime;
					}
					}
				}
				if (strumTime <= Conductor.songPosition + (Conductor.safeZoneOffset * 0.02))
				{
					if (isSustainNote && prevNote != null)
					{		
					
					}
					else
					{
					if (this.noteData == 0)
					{
						Main.LeftBot = true;
						Main.LeftBotH = true;
						Main.LeftTimer = Math.round(holdtime/2);
					}
					if (this.noteData == 1)
					{
						Main.DownBot = true;
						Main.DownBotH = true;
						Main.DownTimer = Math.round(holdtime/2);
					}
					if (this.noteData == 2)
					{
						Main.UpBot = true;
						Main.UpBotH = true;
						Main.UpTimer = Math.round(holdtime/2);
					}
					if (this.noteData == 3)
					{
						Main.RightBot = true;
						Main.RightBotH = true;
						Main.RightTimer = Math.round(holdtime/2);
					}
					}
				}
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
