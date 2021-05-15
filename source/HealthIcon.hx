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
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('bf-holo', [24, 25], 0, false, isPlayer);
		animation.add('saltysunday', [46, 46], 0, false, isPlayer);
		animation.add('catcher', [47, 47], 0, false, isPlayer);
		animation.add('vswhitty', [48, 48], 0, false, isPlayer);
		animation.add('vsanders', [49, 49], 0, false, isPlayer);
		animation.add('vscarol', [50, 50], 0, false, isPlayer);
		animation.add('random', [51, 51], 0, false, isPlayer);
		animation.add('vsmatt', [52, 52], 0, false, isPlayer);
		animation.add('beachbrother', [53, 53], 0, false, isPlayer);
		animation.add('vsneon', [54, 54], 0, false, isPlayer);
		animation.add('vsabigail', [55, 55], 0, false, isPlayer);
		animation.add('shootin', [56, 56], 0, false, isPlayer);
		animation.add('tricky', [57, 57], 0, false, isPlayer);
		animation.add('vschara', [58, 58], 0, false, isPlayer);
		animation.add('funkin', [59, 59], 0, false, isPlayer);
		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
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
