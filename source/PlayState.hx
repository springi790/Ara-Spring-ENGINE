package;

import flixel.math.FlxAngle;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import polymod.Polymod.ModMetadata;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import flixel.tweens.FlxTween;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	var video:MP4Handler = new MP4Handler();

	var healthBarColors:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
	var col:Array<FlxColor> = [
		0xFF51d8fb, // BF
		0xFF51d8fb, // BF-TABI
		0xFFA5004D, // GF
		0xFFA6C5B5, // ARA
		0xFFA6C5B5, // ARA
		0xFFA6C5B5, // ARA
		0xFFFFA258, // TABI
	];

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	var difficultyText:String = "";
	var isCutscene:Bool = false;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var instance:PlayState;

	private var momT:FlxTrail;
	private var bfT:FlxTrail;

	var chromeValue:Float = 0;

	var bambi:FlxSprite;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	var halloweenLevel:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	var tree1:FlxSprite;
	var rock3:FlxSprite;
	var rock2:FlxSprite;
	var rock1:FlxSprite;
	var tree0:FlxSprite;
	var mountain:FlxSprite;
	var sky:FlxSprite;
	var floor:FlxSprite;

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var cutsceneOp:Bool;
	var noteGlow:Bool;

	var glitch:FlxSprite;


	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var songTxt:FlxText;
	var difficultyTxt:FlxText;
	var replayTxt:FlxText;

	var stage2:FlxSprite;
	var genocideBG:FlxSprite;
	var genocideBoard:FlxSprite;
	var siniFireBehind:FlxTypedGroup<SiniFire>;
	var siniFireFront:FlxTypedGroup<SiniFire>;

	
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	var randombg:FlxSprite;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var sectionStart:Bool =  false;
	public static var sectionStartPoint:Int =  0;
	public static var sectionStartTime:Float =  0;

	override public function create()
	{

		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		difficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');


		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
		}

    switch(SONG.song.toLowerCase())
	{
		case 'lonely' | 'nya':
			{
				curStage = 'AraStage1';
	
				defaultCamZoom = 0.80;
	
				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('ara/sky'));
				if (FlxG.save.data.antialiasing)
					{
						bg.antialiasing = true;
					}	
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
	
				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('ara/stage'));
				if (FlxG.save.data.antialiasing)
					{
						bgEscalator.antialiasing = true;
					}
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);
	
				var fgSnow:FlxSprite = new FlxSprite(-600, 750).loadGraphic(Paths.image('ara/front'));
				fgSnow.active = false;
				if (FlxG.save.data.antialiasing)
					{
						fgSnow.antialiasing = true;		
					}
				add(fgSnow);
			}
			case 'verruckt': 
			{
				curStage = 'AraStage2';
				defaultCamZoom = 0.77;
		
				sky = new FlxSprite(-200, -100);
				sky.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				sky.animation.addByPrefix('idle', 'sky');
				sky.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						sky.antialiasing = true;
					}
				add(sky);
		
				mountain = new FlxSprite(-200, -100);
				mountain.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				mountain.animation.addByPrefix('idle', 'mountain');
				mountain.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						mountain.antialiasing = true;
					}
				add(mountain);
		
				tree0 = new FlxSprite(-200, -100);
				tree0.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				tree0.animation.addByPrefix('idle', 'tree0');
				tree0.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						tree0.antialiasing = true;
					}
				add(tree0);
	
				rock1 = new FlxSprite(-200, -100);
				rock1.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				rock1.animation.addByPrefix('idle', 'rock1');
				rock1.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						rock1.antialiasing = true;
					}
				add(rock1);
		
				rock2 = new FlxSprite(-200, -100);
				rock2.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				rock2.animation.addByPrefix('idle', 'rock2');
				rock2.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						rock2.antialiasing = true;
					}
				add(rock2);
		
				rock3 = new FlxSprite(-200, -100);
				rock3.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				rock3.animation.addByPrefix('idle', 'rock3');
				rock3.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						rock3.antialiasing = true;
					}
				add(rock3);
		
				tree1 = new FlxSprite(-200, -100);
				tree1.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				tree1.animation.addByPrefix('idle', 'tree1');
				tree1.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						tree1.antialiasing = true;
					}
				add(tree1);
			}
		   case 'verruckt-':
		   {
			defaultCamZoom = 0.8;
				curStage = 'genocide';
	
				siniFireBehind = new FlxTypedGroup<SiniFire>();
				siniFireFront = new FlxTypedGroup<SiniFire>();
				
				genocideBG = new FlxSprite(-600, -300).loadGraphic(Paths.image('fire/wadsaaa'));
				genocideBG.antialiasing = true;
				genocideBG.scrollFactor.set(0.9, 0.9);
				add(genocideBG);
	
				for (i in 0...2)
					{
						var daFire:SiniFire = new SiniFire(genocideBG.x + (720 + (((95 * 10) / 2) * i)), genocideBG.y + 180, true, false, 30, i * 10, 84);
						daFire.antialiasing = true;
						daFire.scrollFactor.set(0.9, 0.9);
						daFire.scale.set(0.4, 1);
						daFire.y += 50;
						siniFireBehind.add(daFire);
					}
	
					add(siniFireBehind);
				
				genocideBoard = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/boards'));
				genocideBoard.antialiasing = true;
				genocideBoard.scrollFactor.set(0.9, 0.9);
				add(genocideBoard);
	
				var fire1:SiniFire = new SiniFire(genocideBG.x + (-100), genocideBG.y + 889, true, false, 30);
				fire1.antialiasing = true;
				fire1.scrollFactor.set(0.9, 0.9);
				fire1.scale.set(2.5, 1.5);
				fire1.y -= fire1.height * 1.5;
				fire1.flipX = true;
				
				var fire2:SiniFire = new SiniFire((fire1.x + fire1.width) - 80, genocideBG.y + 889, true, false, 30);
				fire2.antialiasing = true;
				fire2.scrollFactor.set(0.9, 0.9);
				//fire2.scale.set(2.5, 1);
				fire2.y -= fire2.height * 1;
				
				var fire3:SiniFire = new SiniFire((fire2.x + fire2.width) - 30, genocideBG.y + 889, true, false, 30);
				fire3.antialiasing = true;
				fire3.scrollFactor.set(0.9, 0.9);
				//fire3.scale.set(2.5, 1);
				fire3.y -= fire3.height * 1;
				
				var fire4:SiniFire = new SiniFire((fire3.x + fire3.width) - 10, genocideBG.y + 889, true, false, 30);
				fire4.antialiasing = true;
				fire4.scrollFactor.set(0.9, 0.9);
				fire4.scale.set(1.5, 1.5);
				fire4.y -= fire4.height * 1.5;
	
				siniFireFront.add(fire1);
				siniFireFront.add(fire2);
				siniFireFront.add(fire3);
				siniFireFront.add(fire4);
	
				add(siniFireFront);
		
				var fuckYouFurniture:FlxSprite = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/glowyfurniture'));
				fuckYouFurniture.antialiasing = true;
				fuckYouFurniture.scrollFactor.set(0.9, 0.9);
				add(fuckYouFurniture);
		   }
		case 'test' :
		{
			defaultCamZoom = 0.9;
			curStage = 'test';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			if (FlxG.save.data.antialiasing)
				{
					bg.antialiasing = true;
				}
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			if (!FlxG.save.data.optimization)
				{add(bg);}

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			if (!FlxG.save.data.antialiasing)
				{
					stageFront.antialiasing = true;
				}
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			if (!FlxG.save.data.optimization)
				{add(stageFront);}	

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			if (FlxG.save.data.antialiasing)
				{
					stageCurtains.antialiasing = true;
				}
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			if (!FlxG.save.data.optimization)
				{add(stageCurtains);}
		}
		default :
		{
			defaultCamZoom = 0.9;
			curStage = 'stage';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			if (FlxG.save.data.antialiasing)
				{
					bg.antialiasing = true;
				}
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			if (!FlxG.save.data.optimization)
				{add(bg);}

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			if (!FlxG.save.data.antialiasing)
				{
					stageFront.antialiasing = true;
				}
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			if (!FlxG.save.data.optimization)
				{add(stageFront);}	

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			if (FlxG.save.data.antialiasing)
				{
					stageCurtains.antialiasing = true;
				}
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			if (!FlxG.save.data.optimization)
				{add(stageCurtains);}
		}
	}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
				case 'genocide':
				gfVersion = 'gf-tabi-crazy';
				var destBoombox:FlxSprite = new FlxSprite(400, 130).loadGraphic(Paths.image('characters/Destroyed_boombox'));
				destBoombox.y += (destBoombox.height - 648) * -1;
				destBoombox.y += 150;
				destBoombox.x -= 110;
				destBoombox.scale.set(1.2, 1.2);
				add(destBoombox);

		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (curStage != 'genocide')
			{
				gf.scrollFactor.set(0.95, 0.95);
			}

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico' | 'bf' | 'bf-pixel':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		
			case 'test':
				dad.y += 450;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

				case 'AraStage1':
					dad.x += 121;
					dad.y += 227;
					boyfriend.x += 200;
					case 'AraStage2':
					dad.x += 200;
					dad.y += 120;
					boyfriend.y -= 100;
					gf.y = 80;
					var tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
					add(tabiTrail);
					case 'genocide':
					boyfriend.x += 300;
					//gf.y -= 20;
					gf.x += 100;
					var tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
					add(tabiTrail);
		}

		
		if (curStage == 'AraStage2')
			{
				floor = new FlxSprite(-200, -100);
				floor.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				floor.animation.addByPrefix('idle', 'floor');
				floor.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						floor.antialiasing = true;
					}
				add(floor);
			}
    if (!FlxG.save.data.optimization)
		{
		
			if(SONG.song.toLowerCase() == 'monster')
				{
				}
				else
					{
					add(gf);	
					}
		
		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		trace('Loading Characters...');
        }

		if (curStage == 'AraStage1'){	
		var particles = new FlxSprite(-200, -100);
		particles.frames = Paths.getSparrowAtlas('ara/verruckt/particles');
		particles.animation.addByPrefix('idle', 'particles idle');
		particles.screenCenter();
		particles.animation.play('idle');
		var widShit = Std.int(particles.width * 6);
		particles.setGraphicSize(Std.int(widShit * 0.50));
				if (FlxG.save.data.antialiasing)
					{
						particles.antialiasing = true;
					}
				add(particles);}

		if (curStage == 'AraStage2')
			{glitch = new FlxSprite(-200, -100);
				glitch.frames = Paths.getSparrowAtlas('ara/verruckt/Glitch');
				glitch.animation.addByPrefix('idle', 'Glitch', 24);
				glitch.animation.play('idle');
				glitch.scrollFactor.set(0.9, 0.9);}
				
			

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, strumLine.y - 15).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
	
				if (curStage.contains("school") && FlxG.save.data.downscroll)
					songPosBG.y -= 45;
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
				songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				if (!curStage.contains("school"))
					songName.x -= 15;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
				songName.scrollFactor.set();			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		if (FlxG.save.data.healthBarColours)
			{healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
			healthBar.scrollFactor.set();
			var curcol:FlxColor = col[healthBarColors.indexOf(dad.curCharacter)]; // Dad Icon
			var curcol2:FlxColor = col[healthBarColors.indexOf(boyfriend.curCharacter)]; // Bf Icon
			healthBar.createFilledBar(curcol, curcol2);
			add(healthBar);}
		else
			{healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		    'health', 0, 2);
	        healthBar.scrollFactor.set();
	        healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
	        // healthBar
	        add(healthBar);}

			add(songPosBG);
			add(songPosBar);
			add(songName);

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("NotoSansTC-Medium.otf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		songTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
			songTxt.x = healthBarBG.x + healthBarBG.width / 2;
		songTxt.setFormat(Paths.font("NotoSansTC-Medium.otf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		songTxt.scrollFactor.set();
		add(songTxt);

		difficultyTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
		difficultyTxt.x = healthBarBG.x + healthBarBG.width / 2;
		difficultyTxt.setFormat(Paths.font("NotoSansTC-Medium.otf"), 25, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		difficultyTxt.scrollFactor.set();
		add(difficultyTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);
		trace('Loading Player1 icon...');

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		trace('Loading Player2 icon...');

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		difficultyTxt.cameras = [camHUD];
		if(curSong.toLowerCase() == 'verruckt')
		{
			glitch.cameras = [camHUD];
		}
		if (FlxG.save.data.songPosition)
			{
				songPosBG.cameras = [camHUD];
				songPosBar.cameras = [camHUD];
				songName.cameras = [camHUD];
			}
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'monster':
					monsterIntro();
				case 'nya':
					araIntro();
				case 'lonely':
					araIntro();
				case 'verruckt':
					araIntro();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

			function araIntro()
				{
					if(!isCutscene){
					if (FlxG.save.data.language)
						{video.playMP4(Paths.video(curSong + 'spanishdialogue'));}
						else
						{video.playMP4(Paths.video(curSong + 'englishdialogue'));}
						video.finishCallback = function()
						{
							create();
							startCountdown();
							generateStaticArrows(1);
							generateStaticArrows(0);
						}
						
					}
					else
					{
						if (isCutscene)
							video.onVLCComplete();
			
						startCountdown();
					}
				}

	function monsterIntro():Void
		{
			inCutscene = false;
	
			generateStaticArrows(0);
			generateStaticArrows(1);
	
			talking = false;
			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
	
			var swagCounter:Int = 0;
	
			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				dad.dance();
				gf.dance();
				boyfriend.playAnim('scared');
	
				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', "set", "go"]);
				introAssets.set('school', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);
				introAssets.set('schoolEvil', [
					'weeb/pixelUI/ready-pixel',
					'weeb/pixelUI/set-pixel',
					'weeb/pixelUI/date-pixel'
				]);
	
				var introAlts:Array<String> = introAssets.get('default');
				var altSuffix:String = "";
	
				for (value in introAssets.keys())
				{
					if (value == curStage)
					{
						introAlts = introAssets.get(value);
						altSuffix = '-pixel';
					}
				}
	
				switch (swagCounter)
	
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3'), 0.6);
					case 1:
						var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						ready.scrollFactor.set();
						ready.updateHitbox();
	
						if (curStage.startsWith('school'))
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
	
						ready.screenCenter();
						add(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								ready.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2'), 0.6);
					case 2:
						var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						set.scrollFactor.set();
	
						if (curStage.startsWith('school'))
							set.setGraphicSize(Std.int(set.width * daPixelZoom));
	
						set.screenCenter();
						add(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								set.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1'), 0.6);
					case 3:
						var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						go.scrollFactor.set();
	
						if (curStage.startsWith('school'))
							go.setGraphicSize(Std.int(go.width * daPixelZoom));
	
						go.updateHitbox();
	
						go.screenCenter();
						add(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								go.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo'), 0.6);
					case 4:
				}
	
				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		if (FlxG.save.data.songPosition)
			{
				songPosBG = new FlxSprite(0, strumLine.y - 15).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
	
				if (curStage.contains("school") && FlxG.save.data.downscroll)
					songPosBG.y -= 45;

				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
	
				songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				if (!curStage.contains("school"))
					songName.x -= 15;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
				songName.scrollFactor.set();
			}

			if(sectionStart){
				FlxG.sound.music.time = sectionStartTime;
				Conductor.songPosition = sectionStartTime;
				vocals.time = sectionStartTime;
			}
		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)



		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
		iconBop(1);
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			if(sectionStart && daBeats < sectionStartPoint){
				daBeats++;
				continue;
			}

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
		{
			for (i in 0...4)
			{
				// FlxG.log.add(i);
				var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
	
				
	
				switch (curStage)
				{
					case 'school' | 'schoolEvil':
						babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
						babyArrow.animation.add('green', [6]);
						babyArrow.animation.add('red', [7]);
						babyArrow.animation.add('blue', [5]);
						babyArrow.animation.add('purplel', [4]);
	
						babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
						babyArrow.updateHitbox();
						babyArrow.antialiasing = false;
	
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.add('static', [0]);
								babyArrow.animation.add('pressed', [4, 8], 12, false);
								babyArrow.animation.add('confirm', [12, 16], 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.add('static', [1]);
								babyArrow.animation.add('pressed', [5, 9], 12, false);
								babyArrow.animation.add('confirm', [13, 17], 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.add('static', [2]);
								babyArrow.animation.add('pressed', [6, 10], 12, false);
								babyArrow.animation.add('confirm', [14, 18], 12, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.add('static', [3]);
								babyArrow.animation.add('pressed', [7, 11], 12, false);
								babyArrow.animation.add('confirm', [15, 19], 24, false);
						}
	
					default:
						if (SONG.song.toLowerCase() == 'verruckt')
							{
								babyArrow.frames = Paths.getSparrowAtlas('custom-notes');	
							}
							else if (SONG.song.toLowerCase() == 'verruckt-')
								{
									babyArrow.frames = Paths.getSparrowAtlas('TABI_notes');	
								}
							else{
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');}
						if (SONG.song.toLowerCase() == 'verruckt-')
							{
							babyArrow.animation.addByPrefix('green', 'arrowUP');
						    babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						    babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						    babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
							}
							babyArrow.animation.addByPrefix('green', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('purple', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('red', 'arrow static instance 3');
	
						if (FlxG.save.data.antialiasing)
							{
								babyArrow.antialiasing = true;
							}
						
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
						if (curSong.toLowerCase() == 'verruckt-')
							{
								switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT0');
								babyArrow.animation.addByPrefix('pressed', 'left press0', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm0', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN0');
								babyArrow.animation.addByPrefix('pressed', 'down press0', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm0', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP0');
								babyArrow.animation.addByPrefix('pressed', 'up press0', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm0', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT0');
								babyArrow.animation.addByPrefix('pressed', 'right press0', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm0', 24, false);
						}
					}
						else{
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
								babyArrow.animation.addByPrefix('pressed', 'left press instance 1', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm instance 1', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
								babyArrow.animation.addByPrefix('pressed', 'down press instance 1', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm instance 1', 24, false);
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
								babyArrow.animation.addByPrefix('pressed', 'up press instance 1', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm instance 1', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
								babyArrow.animation.addByPrefix('pressed', 'right press instance 1', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm instance 1', 24, false);
						}
					}
				}
	
				
	
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();
	
				if (!isStoryMode)
				{
					babyArrow.y -= 10;
					babyArrow.alpha = 0;
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
	
			
				babyArrow.ID = i;
	
				if (player == 1)
					{
						playerStrums.add(babyArrow);
					}
					else
					{
						cpuStrums.add(babyArrow);
					}
	
				if (FlxG.save.data.midScroll)
				{
						babyArrow.x -= 275;
						if (player != 1) 
					{
						babyArrow.visible = false;
					}
				}
					
				babyArrow.animation.play('static');
				babyArrow.x += 50;
				babyArrow.x += ((FlxG.width / 2) * player);
	
				strumLineNotes.add(babyArrow);
			}
		}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ")", "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		songPositionBar = Conductor.songPosition;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		if (FlxG.keys.justPressed.SEVEN)
			{
				FlxG.switchState(new ChartingState());
			}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);


			scoreTxt.text = "Score:" + 
			songScore + " / Health:" + 
			healthBar.percent + "%" + 
			" / Misses:" + misses + 
			" / Accuracy:" + truncateFloat(accuracy, 2) + "% "
			 + (fc ? "/ FULL COMBO" : misses == 0 ? "/ A" : accuracy <= 75 ? "/ BAD" : "");
		
            scoreTxt.screenCenter(X);

			if (FlxG.save.data.engineWatermarks)
			{songTxt.text = "Song: " + curSong + " - Spring Engine 1.0";
		    songTxt.x = 858;
		    songTxt.y = 0;}
			else
			{songTxt.text = "Song: " + curSong;
		    songTxt.x = 1089;
		    songTxt.y = 11;}

			difficultyTxt.text = difficultyText;
			difficultyTxt.x = 11;
			difficultyTxt.y = 691; 
             
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

             //Disabled because chart editor is buggy
		//if (FlxG.keys.justPressed.)
		//{
		//	#if desktop
		//	DiscordClient.changePresence("Chart Editor", null, null, true);
		//	#end
		//	FlxG.switchState(new ChartingState());
		//}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.80)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.80)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if(FlxG.save.data.newInput)
        {
			if(FlxG.save.data.perfect)
			{
				if (misses == 1)
					{
						health = 0;
					}
			}
		}

		if (startingSong)
			{
				if (startedCountdown)
				{
					Conductor.songPosition += FlxG.elapsed * 1000;
					if (Conductor.songPosition >= 0)
						startSong();
				}
			}
			else
			{
				// Conductor.songPosition = FlxG.sound.music.time;
				Conductor.songPosition += FlxG.elapsed * 1000;
				/*@:privateAccess
				{
					FlxG.sound.music._channel.
				}*/
				songPositionBar = Conductor.songPosition;
	
				if (!paused)
				{
					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;
	
					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
						// Conductor.songPosition += FlxG.elapsed * 1000;
						// trace('MISSED FRAME');
					}
				}
	
				// Conductor.lastSongPos = FlxG.sound.music.time;
			}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'tabi-crazy':
						camFollow.y = dad.getMidpoint().y - 100;
						camFollow.x = dad.getMidpoint().x + 260;
						FlxTween.tween(FlxG.camera, {zoom: 0.8}, (Conductor.stepCrochet * 4 / 2000), {ease: FlxEase.elasticInOut});
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}



		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence(detailsText, "GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ")\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				if (ModCharts.autoStrum && startedCountdown && !inCutscene)
					{ // sex
						strumLine.y = strumLineNotes.members[Std.int(ModCharts.autoStrumNum)].y;
					}
					if (ModCharts.updateNoteVisibilty)
					{
						for (note in 0...strumLineNotes.members.length)
						{
							if (note >= 4)
							{
								strumLineNotes.members[note].visible = true;
							}
							else
							{
								strumLineNotes.members[note].visible = true;
							}
						}
					}
				notes.forEachAlive(function(daNote:Note)
				{	
					if (ModCharts.stickNotes == true)
						{
							var noteNum:Int = 0;
							if (daNote.mustPress)
							{
								noteNum += 4; // set to bfs notes instead
							}
							noteNum += daNote.noteData;
							//daNote.x = strumLineNotes.members[noteNum].x;
						}
						if (daNote.tooLate)
							{
								daNote.active = false;
								daNote.visible = false;
							}
							else
							{
								// mag not be retarded challange(failed instantly)
								if (daNote.mustPress)
								{
									daNote.visible = true;
									daNote.active = true;
								}
								else
								{
									if(FlxG.save.data.midScroll)
										{daNote.visible = false;}
									daNote.active = true;
								}
							}
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;
	
						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
						switch (dad.curCharacter)
						{
							case 'tabi-crazy':
								{
									camGame.shake(0.03, 0.02, null, true);
								}
								case 'araver':
									{if (healthBar.percent == 15)
										{}
										else if (healthBar.percent == 14)
											{}
									else
								   { health -= 0.015;
									if (daNote.isSustainNote)
										{
											health -= 0.01;
										}}
									}
						}
						if (FlxG.save.data.enemieDamage)
							{
								switch(dad.curCharacter)
						        {
						           	default:
						         	health -= 0.025;
						        }
							}
						if (FlxG.save.data.proggresiveDamage)
							{
								curBeat;
								{
									health -= 0.009;
								}
							}
						

						cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
	
						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
	
					if (FlxG.save.data.downscroll)
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
					else
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll)
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							health -= 0.075;
							vocals.volume = 0;
							if (theFunne)
								noteMiss(daNote.noteData);
						}
	
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
			cpuStrums.forEach(function(spr:FlxSprite)
				{
					if (spr.animation.finished)
					{
						spr.animation.play('static');
						spr.centerOffsets();
					}
				});


		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}



	function endSong():Void
		{
			canPause = false;
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			if (SONG.validScore)
			{
				#if !switch
				Highscore.saveScore(SONG.song, songScore, storyDifficulty);
				#end
			}
	
			if (isStoryMode)
			{
				campaignScore += songScore;
	
				storyPlaylist.remove(storyPlaylist[0]);
	
				if (storyPlaylist.length <= 0)
				{	
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
	
					if (StoryMenuState.curWeek == 1)
					{if (FlxG.save.data.language)
						{video.playMP4(Paths.video('verrucktfinalscene-spanish'));}
						else
						{video.playMP4(Paths.video('verrucktfinalscene-english'));}
						video.finishCallback = function()
						{
							FlxG.switchState(new MainMenuState());	
							FlxG.sound.playMusic(Paths.music('freakyMenu'));			
						}}
						else
					FlxG.switchState(new StoryMenuState());

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
	
					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}
	
					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";
	
					if (storyDifficulty == 0)
						difficulty = '-easy';
	
					if (storyDifficulty == 2)
						difficulty = '-hard';
	
					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
	
					if (SONG.song.toLowerCase() == 'verruckt')
					{
						if (isStoryMode)
							{if (FlxG.save.data.language)
								{video.playMP4(Paths.video('verrucktfinalscene-spanish'));}
								else
								{video.playMP4(Paths.video('verrucktfinalscene-english'));}
								video.finishCallback = function()
								{
									LoadingState.loadAndSwitchState(new MainMenuState(), true);
								}}
					}
	
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;
	
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
	
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}

	var endingSong:Bool = false;

	private function popUpScore(daNote:Note):Void
		{
			
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Int = 350;
	
			var daRating:String = "sick";
				
			if (noteDiff > Conductor.safeZoneOffset * 2)
				{
					daRating = 'shit';
					totalNotesHit -= 2;
					ss = false;
					if (theFunne)
						{
							score = -3000;
							combo = 0;
							misses++;
							health -= 0.2;
						}
					shits++;
				}
				else if (noteDiff < Conductor.safeZoneOffset * -2)
				{
					daRating = 'shit';
					totalNotesHit -= 2;
					if (theFunne)
					{
						score = -3000;
						combo = 0;
						misses++;
						health -= 0.2;
					}
					ss = false;
					shits++;
				}
				else if (noteDiff < Conductor.safeZoneOffset * -0.45)
				{
					daRating = 'bad';
					totalNotesHit += 0.2;
					if (theFunne)
					{
						score = -1000;
						health -= 0.03;
					}
					else
						score = 100;
					ss = false;
					bads++;
				}
				else if (noteDiff > Conductor.safeZoneOffset * 0.45)
				{
					daRating = 'bad';
					totalNotesHit += 0.2;
					if (theFunne)
						{
							score = -1000;
							health -= 0.03;
						}
						else
							score = 100;
					ss = false;
					bads++;
				}
				else if (noteDiff < Conductor.safeZoneOffset * -0.25)
				{
					daRating = 'good';
					totalNotesHit += 0.65;
					if (theFunne)
					{
						score = 200;
						//health -= 0.01;
					}
					else
						score = 200;
					ss = false;
					goods++;
				}
				else if (noteDiff > Conductor.safeZoneOffset * 0.25)
				{
					daRating = 'good';
					totalNotesHit += 0.65;
					if (theFunne)
						{
							score = 200;
							//health -= 0.01;
						}
						else
							score = 200;
					ss = false;
					goods++;
				}
			if (daRating == 'sick')
			{
				totalNotesHit += 1;
				if (health < 2)
					health += 0.1;
				sicks++;
			}
	
			
			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += score;
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y += 200;
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
	
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.y += 200;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80 + 200;
	
				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});
	
			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
	
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
			{
				repPresses++;
				boyfriend.holdTimer = 0;
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						// the sorting probably doesn't need to be in here? who cares lol
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{
								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
									if (!inIgnoreList && !theFunne)
										badNoteCheck();
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
								noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
									noteCheck(controlArray, coolNote);
							}
						}
					}
					else // regular notes?
					{	
					noteCheck(controlArray, daNote);
					}
					/* 
						if (controlArray[daNote.noteData])
							goodNoteHit(daNote);
					 */
					// trace(daNote.noteData);
					/* 
						switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
									noteCheck(upP, daNote);
							case 3:
								if (upP || rightP || downP || leftP)
									noteCheck(rightP, daNote);
							case 1:
								if (upP || rightP || downP || leftP)
									noteCheck(downP, daNote);
							case 0:
								if (upP || rightP || downP || leftP)
									noteCheck(leftP, daNote);
						}
					 */
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else if (!theFunne)
				{
					badNoteCheck();
				}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.playAnim('idle');
				}
			}
	
			playerStrums.forEach(function(spr:FlxSprite)
			{
				switch (spr.ID)
				{
					case 2:
						if (upP && spr.animation.curAnim.name != 'confirm')
						{
							spr.animation.play('pressed');
							trace('play');
						}
						if (upR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					case 3:
						if (rightP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (rightR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					case 1:
						if (downP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (downR)
						{
							spr.animation.play('static');
							repReleases++;
						}
					case 0:
						if (leftP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (leftR)
						{
							spr.animation.play('static');
							repReleases++;
						}
				}
				
				if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}

	function updateAccuracy()
		{
			if (misses > 0 || accuracy < 96)
				fc = false;
			else
				fc = true;
			totalPlayed += 1;
			accuracy = totalNotesHit / totalPlayed * 100;
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{ if (controlArray[note.noteData])
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}

					// ANTI MASH CODE FOR THE BOYS

					if (mashing <= getKeyPresses(note) + 1 && mashViolations < 2)
					{
						mashViolations++;
						goodNoteHit(note, (mashing <= getKeyPresses(note) + 1));
					}
					else
					{
						playerStrums.members[note.noteData].animation.play('static');
						trace('mash ' + mashing);
					}

					if (mashing != 0)
						mashing = 0;
				}
			else if (!theFunne)
			{
				badNoteCheck();
			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
		
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	function changeBG():Void
	{
		remove(boyfriend);
		remove(dad);
		randombg = new FlxSprite(Paths.randomImage('BG_', 1, 3, 'shared'));
		randombg.screenCenter();
		randombg.scrollFactor.set(0.9, 0.9);
		chromeValue += 6 / 1000;
		FlxTween.tween(this, { chromeValue: 0 }, 0.15);
		add(randombg);
		add(boyfriend);
		add(dad);
	}

	function restoreBG():Void
		{
			remove(boyfriend);
		    remove(dad);
			remove(gf);
			sky = new FlxSprite(-200, -100);
				sky.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				sky.animation.addByPrefix('idle', 'sky');
				sky.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						sky.antialiasing = true;
					}
				add(sky);
		
				mountain = new FlxSprite(-200, -100);
				mountain.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				mountain.animation.addByPrefix('idle', 'mountain');
				mountain.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						mountain.antialiasing = true;
					}
				add(mountain);
		
				tree0 = new FlxSprite(-200, -100);
				tree0.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				tree0.animation.addByPrefix('idle', 'tree0');
				tree0.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						tree0.antialiasing = true;
					}
				add(tree0);
	
				rock1 = new FlxSprite(-200, -100);
				rock1.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				rock1.animation.addByPrefix('idle', 'rock1');
				rock1.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						rock1.antialiasing = true;
					}
				add(rock1);
		
				rock2 = new FlxSprite(-200, -100);
				rock2.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				rock2.animation.addByPrefix('idle', 'rock2');
				rock2.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						rock2.antialiasing = true;
					}
				add(rock2);
		
				rock3 = new FlxSprite(-200, -100);
				rock3.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				rock3.animation.addByPrefix('idle', 'rock3');
				rock3.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						rock3.antialiasing = true;
					}
				add(rock3);
		
				tree1 = new FlxSprite(-200, -100);
				tree1.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				tree1.animation.addByPrefix('idle', 'tree1');
				tree1.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						tree1.antialiasing = true;
					}
				add(tree1);

				floor = new FlxSprite(-200, -100);
				floor.frames = Paths.getSparrowAtlas('ara/verruckt/BG');
				floor.animation.addByPrefix('idle', 'floor');
				floor.animation.play('idle');
				if (FlxG.save.data.antialiasing)
					{
						floor.antialiasing = true;
					}
				add(floor);
			add(gf);
			add(boyfriend);
			add(dad);
		}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			{
				resyncVocals();
			}

		if (curSong.toLowerCase() == 'nya')
			{
				switch (curStep)
				{
					case 16, 252, 512, 804:
						dad.playAnim('nya', true);
				}
			}

			if (curSong.toLowerCase() == 'verruckt')
				{
                    switch (curStep)
				    {
					case 919, 927, 935, 943, 951, 959, 967, 975, 983, 991, 1047, 1055, 1063, 1071, 1079, 1087, 1095, 1103, 1119, 1111, 1135, 1127, 1139, 1143, 1147, 1151, 1155, 1159, 1163, 1167:
					    remove(randombg);
					case 920, 936, 952, 968, 984, 1048, 1064, 1080, 1096, 1112, 1128, 1140, 1148, 1156, 1164:
						changeBG();
						FlxG.camera.shake(0.004);
						camHUD.shake(0.004);
					case 928, 944, 960, 976, 992, 1056, 1072, 1088, 1104, 1120, 1136, 1144, 1152, 1160, 1168:
						changeBG();
						FlxG.camera.shake(0.004);
						camHUD.shake(0.004);
					case 1169:
					    restoreBG();
						remove(randombg);
						boyfriend.x -= 100;
						boyfriend.y += 100;
		                dad.x += 200;
						dad.y += 100;
						defaultCamZoom = 0.77; 
				    }
				}

		if (curSong == 'Milf')
          {
			  switch (curStep)
			  {
				case 672:
					momT = new FlxTrail(dad, null, 5, 7, 0.3, 0.2);
			        add(momT);

				case 736:
					bfT = new FlxTrail(boyfriend, null, 5, 7, 0.3, 0.2);
			        add(bfT);
					remove(momT);

				case 800:
                    remove(bfT);
			  }
		  }

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}


		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ")", "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (FlxG.save.data.proggresiveDamage)
			{
				health -= 0.019;
			}

		if (curBeat % gfSpeed == 0)
			{
				gf.dance();
				iconBop();
				if (curSong.toLowerCase() == 'verruckt-')
					{
						camGame.shake(0.005);
						camHUD.shake(0.003);
					}
				if (curSong.toLowerCase() == 'verruckt')
					{
						camGame.shake(0.005);
						camHUD.shake(0.003);
						switch(curStep)
						{
							case 656:
								remove(sky);
								remove(gf);
						        remove(mountain);
						        remove(tree0);
						        remove(rock1);
						        remove(rock2);
						        remove(rock3);
						        remove(tree1);
						        remove(floor);
							    changeBG();
						}
					}
			}

					if (curSong.toLowerCase() == 'verruckt')
						{
							switch (curBeat)
							{
								case 164:
									add(glitch);
									boyfriend.x += 100;
									boyfriend.y -= 100;
		                            dad.x -= 200;
									dad.y -= 100;
									defaultCamZoom = 0.65;
								
							}
						}

						if (curSong.toLowerCase() == 'lonely')
							{
								switch (curBeat)
								{
									case 10:
										var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready', 'shared'));
						FlxG.sound.play(Paths.sound('intro2'), 0.6);
						ready.scrollFactor.set(0, 0);
						ready.updateHitbox();
						ready.cameras = [camHUD];

						ready.screenCenter();
						ready.y -= 100;
						add(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								ready.destroy();
							}
						});
						case 13:
							var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready', 'shared'));
							FlxG.sound.play(Paths.sound('intro2'), 0.6);
							ready.scrollFactor.set(0, 0);
							ready.updateHitbox();
							ready.cameras = [camHUD];
	
							ready.screenCenter();
							ready.y -= 100;
							add(ready);
							FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									ready.destroy();
								}
							});
							case 14:
								var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('set', 'shared'));
						FlxG.sound.play(Paths.sound('intro1'), 0.6);
						set.scrollFactor.set(0, 0);
						set.updateHitbox();
						set.cameras = [camHUD];

						set.screenCenter();
						set.y -= 100;
						add(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								set.destroy();
							}
						});
						case 15:
							var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go', 'shared'));
						FlxG.sound.play(Paths.sound('introGo'), 0.6);
						go.scrollFactor.set(0, 0);
						go.updateHitbox();
						go.cameras = [camHUD];

						go.screenCenter();
						go.y -= 100;
						add(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								go.destroy();
							}
						});
								}
							}
		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
			{
				dad.playAnim('cheer', true);
			}
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	function iconBop(?_scale:Float = 1.25, ?_time:Float = 0.2):Void {
		iconP1.iconScale = iconP1.defualtIconScale * _scale;
		iconP2.iconScale = iconP2.defualtIconScale * _scale;

		FlxTween.tween(iconP1, {iconScale: iconP1.defualtIconScale}, _time, {ease: FlxEase.quintOut});
		FlxTween.tween(iconP2, {iconScale: iconP2.defualtIconScale}, _time, {ease: FlxEase.quintOut});
	}

	var curLight:Int = 0;
}