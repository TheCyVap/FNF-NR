package;

import openfl.display.BlendMode;
import openfl.text.TextFormat;
import openfl.display.Application;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var RandomizeOn = true; //Random Notes?
	public static var ExtremeMode:Int = 0; //Extreme Mode lol
	public static var JackMode:Int = 0; //Jacks galore
	public static var JackPrev:Int = 0; //Previous Note
	public static var ROpponents:Int = 0; //random opponents or some fucking shit fuck dammit
	public static var ExtraIcons:Int = 1; //Extra Icons
	
	
	public static var FPMenu = 0; //Wee
	public static var FreeplayActive:Int = 0; //dfsddfhndskjfsnfsdkugsdgnjdsi
	public static var StoryMenu = 0; //Wee
	public static var EDance:Int = 0; //For opponent dancing lol
	public static var ESpecial:Int = 0; //For special anims
	
	public static var BP = 0; //Don't ask
	
	public static var BotMode:Int = 0;
	public static var BotDemo:Int = 0;
	public static var LeftTimer:Int = 0;
	public static var UpTimer:Int = 0;
	public static var DownTimer:Int = 0;
	public static var RightTimer:Int = 0;
	public static var LeftBot:Bool = false;
	public static var UpBot:Bool = false;
	public static var DownBot:Bool = false;
	public static var RightBot:Bool = false;
	public static var LeftBotH:Bool = false;
	public static var UpBotH:Bool = false;
	public static var DownBotH:Bool = false;
	public static var RightBotH:Bool = false;
	public static var NoneThing:Bool = false;
	
	public static var RandomizeSeed = 0; //Random Seed
	public static var RCurrentSeed = FlxG.random.resetInitialSeed();//Current Seed
	public static var daPos:Int = 0;

	public static var watermarks = true; // Whether to put Kade Engine liteartly anywhere

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{

		// quick checks 

		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);

		addChild(game);

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		toggleFPS(FlxG.save.data.fps);

		#end
	}

	var game:FlxGame;

	var fpsCounter:FPS;

	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}

	public function changeFPSColor(color:FlxColor)
	{
		fpsCounter.textColor = color;
	}

	public function setFPSCap(cap:Float)
	{
		openfl.Lib.current.stage.frameRate = cap;
	}

	public function getFPSCap():Float
	{
		return openfl.Lib.current.stage.frameRate;
	}

	public function getFPS():Float
	{
		return fpsCounter.currentFPS;
	}
}
