package;

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.util.FlxColor;
import flixel.FlxG;

using StringTools;

//Im too lazy to make a better menu

class Cutscenes extends MusicBeatState
{
    var video:MP4Handler = new MP4Handler();

    var bg:FlxSprite;
    var cutscene1:FlxSprite;
    var cutscene2:FlxSprite;
    var cutscene3:FlxSprite;
    var cutscene4:FlxSprite;
    var cutscene5:FlxSprite;

    override public function create()
    {

        FlxG.mouse.visible = true;

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('cutscenes-menu', 'shared'));
        bg.screenCenter();
        add(bg);

        cutscene1 = new FlxSprite(192, 237).loadGraphic(Paths.image('cutscenesmenu/lonelycutscene'));
        add(cutscene1);

        cutscene2 = new FlxSprite(513, 237).loadGraphic(Paths.image('cutscenesmenu/nyacutscene'));
        add(cutscene2);
        
        cutscene3 = new FlxSprite(839, 237).loadGraphic(Paths.image('cutscenesmenu/verrucktcutscene'));
        add(cutscene3);

        cutscene4 = new FlxSprite(513, 428).loadGraphic(Paths.image('cutscenesmenu/verrucktfinalcutscene'));
        add(cutscene4);

        super.create();
    }

    override public function update(elapsed:Float)
    {

        if(FlxG.keys.justPressed.BACKSPACE)
            {
                FlxG.switchState(new MainMenuState());
            }
    
           if(FlxG.keys.justPressed.ESCAPE)
            {
                FlxG.switchState(new MainMenuState());
            }

            if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(cutscene1))
                {
                    if (FlxG.save.data.language)
						{video.playMP4(Paths.video('lonely' + 'spanishdialogue'));}
						else
						{video.playMP4(Paths.video('lonely' + 'englishdialogue'));}
						video.finishCallback = function()
						{
                            FlxG.switchState(new Cutscenes());
                            FlxG.sound.playMusic(Paths.music('freakyMenu'));
						}
						
                }
            
                if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(cutscene2))
                    {
                        if (FlxG.save.data.language)
                            {video.playMP4(Paths.video('nya' + 'spanishdialogue'));}
                            else
                            {video.playMP4(Paths.video('nya' + 'englishdialogue'));}
                            video.finishCallback = function()
                            {
                                FlxG.switchState(new Cutscenes());
                                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                            }
                            
                    }
                    if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(cutscene3))
                        {
                            if (FlxG.save.data.language)
                                {video.playMP4(Paths.video('verruckt' + 'spanishdialogue'));}
                                else
                                {video.playMP4(Paths.video('verruckt' + 'englishdialogue'));}
                                video.finishCallback = function()
                                {
                                    FlxG.switchState(new Cutscenes());
                                    FlxG.sound.playMusic(Paths.music('freakyMenu'));
                                }
                                
                        }

                        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(cutscene4))
                            {
                                if (FlxG.save.data.language)
                                    {video.playMP4(Paths.video('verrucktfinalscene-spanish'));}
                                    else
                                    {video.playMP4(Paths.video('verrucktfinalscene-english'));}
                                    video.finishCallback = function()
                                    {
                                        FlxG.switchState(new Cutscenes());
                                        FlxG.sound.playMusic(Paths.music('freakyMenu'));
                                    }
                                    
                            }
 
        super.update(elapsed);
    }
}