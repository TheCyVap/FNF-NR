package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1, 50], 0, false, isPlayer);
		animation.add('bf-car', [0, 1, 50], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1, 50], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3, 52], 0, false, isPlayer);
		animation.add('pico', [4, 5, 53], 0, false, isPlayer);
		animation.add('mom', [6, 7, 54], 0, false, isPlayer);
		animation.add('mom-car', [6, 7, 54], 0, false, isPlayer);
		animation.add('tankman', [8, 9, 56], 0, false, isPlayer);
		animation.add('face', [10, 11, 10], 0, false, isPlayer);
		//
		if (Main.ExtraIcons == 1)
			animation.add('dad', [12, 13, 51], 0, false, isPlayer);
		else
			animation.add('dad', [12, 12, 12], 0, false, isPlayer);
		//
		animation.add('senpai', [22, 22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15, 14], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18, 57], 0, false, isPlayer);
		//
		if (Main.ExtraIcons == 1)
			animation.add('parents-christmas', [17, 18, 57], 0, false, isPlayer);
		else
			animation.add('parents-christmas', [17, 17, 17], 0, false, isPlayer);
		//
		animation.add('monster', [19, 20, 55], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20, 55], 0, false, isPlayer);
		animation.add('bf-holo', [24, 25, 26], 0, false, isPlayer);
		animation.add('dad-pixel', [30, 30, 30], 0, false, isPlayer);
		animation.add('spooky-pixel', [31, 31, 31], 0, false, isPlayer);
		animation.add('pico-pixel', [32, 32, 32], 0, false, isPlayer);
		animation.add('flchan', [81, 45, 45], 0, false, isPlayer);
		animation.add('tord', [82, 45, 45], 0, false, isPlayer);
		animation.add('b3remix', [83, 45, 45], 0, false, isPlayer);
		animation.add('b3whitty', [84, 45, 45], 0, false, isPlayer);
		animation.add('vstabi', [85, 45, 45], 0, false, isPlayer);
		animation.add('saltysunday', [86, 46, 46], 0, false, isPlayer);
		animation.add('catcher', [87, 47, 47], 0, false, isPlayer);
		animation.add('vswhitty', [88, 48, 48], 0, false, isPlayer);
		animation.add('vsanders', [89, 49, 49], 0, false, isPlayer);
		animation.add('vscarol', [90, 50, 50], 0, false, isPlayer);
		animation.add('random', [91, 51, 51], 0, false, isPlayer);
		animation.add('vsmatt', [92, 52, 52], 0, false, isPlayer);
		animation.add('beachbrother', [93, 53, 53], 0, false, isPlayer);
		animation.add('vsneon', [94, 54, 54], 0, false, isPlayer);
		animation.add('vsabigail', [95, 55, 55], 0, false, isPlayer);
		animation.add('shootin', [96, 56, 56], 0, false, isPlayer);
		animation.add('tricky', [97, 57, 57], 0, false, isPlayer);
		animation.add('vschara', [98, 58, 58], 0, false, isPlayer);
		animation.add('funkin', [99, 59, 59], 0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel' | 'dad-pixel' | 'spooky-pixel' | 'pico-pixel':
				antialiasing = false;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
