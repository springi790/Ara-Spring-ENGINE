import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

class SEData
{
    public static function initSave()
    {
		if (FlxG.save.data.language == null)
			FlxG.save.data.language = false;

		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.engineWatermarks == null)
			FlxG.save.data.engineWatermarks = true;

        if (FlxG.save.data.healthBarColours == null)
			FlxG.save.data.healthBarColours = true;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		KeyBinds.gamepad = gamepad != null;
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		(cast (Lib.current.getChildAt(0), Main));
	}
}