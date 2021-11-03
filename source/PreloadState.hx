package;

import flixel.graphics.FlxGraphic;
import sys.thread.Thread;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

enum PreloadType {
    atlas;
    image;
    image1;
}

class PreloadState extends FlxState {

    var globalRescale:Float = 2/3;
    var preloadStart:Bool = false;

    var loadText:FlxText;
    var assetStack:Map<String, PreloadType> = [
        'ara/verruckt/particles' => PreloadType.image, 
        'randomImages/BG_1' => PreloadType.image, 
        'randomImages/BG_2' => PreloadType.image,
        'randomImages/BG_3' => PreloadType.image,
        'ara/verruckt/Glitch' => PreloadType.image, 
        'ara/verruckt/BG' => PreloadType.image,
        'characters/Ara' => PreloadType.image,
        'characters/AraNya' => PreloadType.image,
        'characters/AraVer' => PreloadType.image,
        'characters/BOYFRIEND' => PreloadType.image,
        'characters/GF_assets' => PreloadType.image,
        'characters/Destroyed_boombox' => PreloadType.image,
        'characters/BF_post_exp' => PreloadType.image,
        'characters/PostExpGF_Assets' => PreloadType.image,
        'characters/MadTabi' => PreloadType.image,
        'custom-notes' => PreloadType.image,
        'TABI_notes' => PreloadType.image,
        'NOTE_assets' => PreloadType.image,
        'noteSplashes' => PreloadType.image,
        'healthBar' => PreloadType.image,
        'icons/icon-ara' => PreloadType.image1,
        'icons/icon-aranya' => PreloadType.image1,
        'icons/icon-araver' => PreloadType.image1,
        'icons/icon-bf' => PreloadType.image1,
        'icons/icon-bf-tabi-crazy' => PreloadType.image1,
        'icons/icon-tabi-crazy' => PreloadType.image1,
        'icons/icon-gf' => PreloadType.image1,
    ];
    var maxCount:Int;

    public static var preloadedAssets:Map<String, FlxGraphic>;
    var backgroundGroup:FlxTypedGroup<FlxSprite>;
    var bg:FlxSprite;

    public static var unlockedSongs:Array<Bool> = [false, false];

    override public function create() {
        super.create();

        FlxG.camera.alpha = 0;

        maxCount = Lambda.count(assetStack);
        trace(maxCount);
        // create funny assets
        backgroundGroup = new FlxTypedGroup<FlxSprite>();
        FlxG.mouse.visible = false;

        preloadedAssets = new Map<String, FlxGraphic>();

        bg = new FlxSprite();
		bg.loadGraphic(Paths.image('languagebg', 'shared'));
        bg.screenCenter();
        bg.updateHitbox();
		backgroundGroup.add(bg);

        add(backgroundGroup);
        FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5, {
            onComplete: function(tween:FlxTween){
                Thread.create(function(){
                    assetGenerate();
                });
            }
        });

        // save bullshit

        loadText = new FlxText(5, FlxG.height - (32 + 5), 0, 'Loading...', 32);
		loadText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    var storedPercentage:Float = 0;

    function assetGenerate() {
        //
        var countUp:Int = 0;
        for (i in assetStack.keys()) {
            trace('calling asset $i');

            FlxGraphic.defaultPersist = true;
            switch(assetStack[i]) {
                case PreloadType.image:
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(i, 'shared'));
                    preloadedAssets.set(i, savedGraphic);
                    trace(savedGraphic + ', yeah its working');
                case PreloadType.image1:
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(i));
                    preloadedAssets.set(i, savedGraphic);
                    trace(savedGraphic + ', yeah its working');
                case PreloadType.atlas:
                    var preloadedCharacter:Character = new Character(FlxG.width / 2, FlxG.height / 2, i);
                    preloadedCharacter.visible = false;
                    add(preloadedCharacter);
                    trace('character loaded ${preloadedCharacter.frames}');
            }
            FlxGraphic.defaultPersist = false;
        
            countUp++;
            storedPercentage = countUp/maxCount;
            loadText.text = 'Loading... Progress at ${Math.floor(storedPercentage * 100)}%';
        }

        ///*
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {
            onComplete: function(tween:FlxTween){
                FlxG.switchState(new TitleState());
            }
        });
        //*/

    }
}