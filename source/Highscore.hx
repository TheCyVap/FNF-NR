package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		if (Main.ExtremeMode == 0 && Main.BotMode == 0)
		{
		var daSong:String = formatSong(song, diff);


		#if !switch
		NGio.postScore(score, song);
		#end

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
		}
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{
		if (Main.ExtremeMode == 0)
		{
		#if !switch
		NGio.postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff);
		
			if (Main.StoryMenu == 1)
			{
				if (songScores.exists(daWeek))
				{
					if (songScores.get(daWeek) < score)
						setScore(daWeek, score);
				}
				else
				{
					setScore(daWeek, score);
				}
			}
			if (Main.StoryMenu == 2)
			{
				daWeek = formatSong('SCweek' + week, diff);
				if (songScores.exists(daWeek))
				{
					if (songScores.get(daWeek) < score)
						setScore(daWeek, score);
				}
				else
				{
					setScore(daWeek, score);
				}
			}
			if (Main.StoryMenu == 3)
			{
				daWeek = formatSong('SSweek' + week, diff);
				if (songScores.exists(daWeek))
				{
					if (songScores.get(daWeek) < score)
						setScore(daWeek, score);
				}
				else
				{
					setScore(daWeek, score);
				}
			}
			if (Main.StoryMenu == 4)
			{
				daWeek = formatSong('B3week' + week, diff);
				if (songScores.exists(daWeek))
				{
					if (songScores.get(daWeek) < score)
						setScore(daWeek, score);
				}
				else
				{
					setScore(daWeek, score);
				}
			}
		}
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song.toLowerCase();

		switch (diff)
		{
			case 0:
			daSong += '-easy';
			case 2:
			daSong += '-hard';
			case 3:
			daSong += '-crazy';
		}

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		var oop = 'week';
		if (Main.StoryMenu == 1)
		{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);
		}
		if (Main.StoryMenu == 2)
		{
		if (!songScores.exists(formatSong('SCweek' + week, diff)))
			setScore(formatSong('SCweek' + week, diff), 0);
			
		oop = 'SCweek';
		}
		if (Main.StoryMenu == 3)
		{
		if (!songScores.exists(formatSong('SSweek' + week, diff)))
			setScore(formatSong('SSweek' + week, diff), 0);
			
		oop = 'SCweek';
		}
		if (Main.StoryMenu == 4)
		{
		if (!songScores.exists(formatSong('B3week' + week, diff)))
			setScore(formatSong('B3week' + week, diff), 0);
			
		oop = 'B3week';
		}
		return songScores.get(formatSong(oop + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
	}
}
