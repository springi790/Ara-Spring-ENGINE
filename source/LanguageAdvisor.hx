package;

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.util.FlxColor;
import flixel.FlxG;

using StringTools;

class LanguageAdvisor extends MusicBeatState
{
    var text:FlxText;
    var bg:FlxSprite;

    override public function create()
    {
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('languagebg', 'shared'));
        bg.screenCenter();
        bg.alpha = 0.5;
        add(bg);

        var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Dialogue Video Language Can Be Changed In Options"
			+ "\n------------------------"
			+ "\nEl Lenguaje De Los Videos Puede Ser Cambiado En Options"
            + "\n"
			+ "\nDefault: English",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
        
        var txt:FlxText = new FlxText(168, 22, FlxG.width,
            "Press Any Key To Continue", 16);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE);
		add(txt);

        super.create();
    }

    override public function update(elapsed:Float)
    {

        if (FlxG.keys.justPressed.ANY)
            {
                FlxG.switchState(new MainMenuState());
            }
        
        super.update(elapsed);
    }
}