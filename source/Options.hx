package;

//options code created by KadeDev

import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String { return throw "stub!"; };
	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}

class ResetSettings extends Option
	{
		var confirm:Bool = false;
	
		public function new(desc:String)
		{
			super();
			description = desc;
		}
		public override function press():Bool
		{
			if(!confirm)
			{
				confirm = true;
				display = updateDisplay();
				return true;
			}
			FlxG.save.data.newInput = null;
			FlxG.save.data.antialiasing = null;
			FlxG.save.data.dfjk = null;
			FlxG.save.data.songPosition = null;
			FlxG.save.data.engineWatermark = null;
			FlxG.save.data.language = null;
	
			SEData.initSave();
			confirm = false;
			trace('All settings have been reset');
			display = updateDisplay();
			return true;
		}
	
		private override function updateDisplay():String
		{
			return confirm ? "Confirm Settings Reset" : "Reset Settings";
		}
	}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Key Bindings";
	}
}

class EngineWatermarks extends Option
{
	public function new(desc:String)
		{
			super();
			description = desc;
		}
	
		public override function press():Bool
		{
			FlxG.save.data.engineWatermarks = !FlxG.save.data.engineWatermarks;
			display = updateDisplay();
			return true;
		}
	
		private override function updateDisplay():String
		{
			return FlxG.save.data.engineWatermarks ? "Engine Watermarks On" : "Engine Watermarks Off";
		}
}

class Language extends Option
{
	public function new(desc:String)
		{
			super();
			description = desc;
		}
	
		public override function press():Bool
		{
			FlxG.save.data.language = !FlxG.save.data.language;
			display = updateDisplay();
			return true;
		}
	
		private override function updateDisplay():String
		{
			return FlxG.save.data.language ? "Spanish" : "English";
		}
}

class BotPlay extends Option
{
	public function new(desc:String)
		{
			super();
			description = desc;
		}
	
		public override function press():Bool
		{
			FlxG.save.data.botplay = !FlxG.save.data.botplay;
			display = updateDisplay();
			return true;
		}
	
		private override function updateDisplay():String
		{
			return FlxG.save.data.botplay ? "BotPlay On" : "BotPlay Off";
		}
}

class MidScroll extends Option
{
	public function new(desc:String)
		{
			super();
			description = desc;
		}
	
		public override function press():Bool
		{
			FlxG.save.data.midScroll = !FlxG.save.data.midScroll;
			display = updateDisplay();
			return true;
		}
	
		private override function updateDisplay():String
		{
			return FlxG.save.data.midScroll ? "MidScroll On" : "MidScroll Off";
		}
}

class HealthBarColours extends Option
{
	public function new(desc:String)
		{
			super();
			description = desc;
		}
	
		public override function press():Bool
		{
			FlxG.save.data.healthBarColours = !FlxG.save.data.healthBarColours;
			display = updateDisplay();
			return true;
		}
	
		private override function updateDisplay():String
		{
			return FlxG.save.data.healthBarColours ? "Health Bar Colours On" : "Health Bar Colours Off";
		}
}

class PerfectMode extends Option
{
	public function new(desc:String)
		{
			super();
			description = desc;
		}
	
		public override function press():Bool
		{
			if (FlxG.save.data.newInput)
			{
			FlxG.save.data.perfect = !FlxG.save.data.perfect;
			display = updateDisplay();
			return true;
		    }
			else
			{
				!FlxG.save.data.perfect;
				return true;
			}	
		}
	
		private override function updateDisplay():String
		{
			if (FlxG.save.data.newInput)
				{
				return FlxG.save.data.perfect ? "Perfect Mode On" : "Perfect Mode Off";	
				}
			else
				{
				return FlxG.save.data.perfect ? "Perfect Mode Off" : "Perfect Mode Off";
				FlxG.sound.play(Paths.sound("nope"), 0.4);	
				}
		}
}


class DownScroll extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on");
	}
}

class EnemieDamage extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.enemieDamage = !FlxG.save.data.enemieDamage;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Enemie Damage " + (FlxG.save.data.enemieDamage ? "on" : "off");
	}
}
class ProggresiveDamage extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.proggresiveDamage = !FlxG.save.data.proggresiveDamage;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Proggresive Damage " + (FlxG.save.data.proggresiveDamage ? "on" : "off");
	}
}

class Optimization extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.optimization = !FlxG.save.data.optimization;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Optimization " + (FlxG.save.data.optimization ? "on" : "off");
	}
}

class Antialiasing extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Antialiasing " + (!FlxG.save.data.antialiasing ? "off" : "on");
	}
}

class NewInput extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.newInput = !FlxG.save.data.newInput;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return (!FlxG.save.data.newInput ? "Old Input" : "New Input");
	}
}