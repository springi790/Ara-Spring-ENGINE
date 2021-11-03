package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bf:FlxSprite;
	var bf2:FlxSprite;
	var bfserious:FlxSprite;
	var bfscared:FlxSprite;

	var gf:FlxSprite;
	var gfscared:FlxSprite;
	var gfblushed:FlxSprite;
	var gfsuperblushed:FlxSprite;
	var gfshouting:FlxSprite;
	var gfcrying:FlxSprite;
	var gfbeware:FlxSprite;
	var gfhappy:FlxSprite;

	var aranormal:FlxSprite;
	var aranya:FlxSprite;
	var araverruckt:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(8, 426);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			case 'lonely' | 'nya' | 'verruckt':
			{
				switch (curCharacter)
				{
					case 'bf':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/bfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'bfscared':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/bfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'bf2':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/bfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'bfserious':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/bfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'aranormal':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/arabox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'aranya':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/arabox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'araverruckt':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/arabox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gf':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gfblushed':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gfsuperblushed':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gfcrying':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gfbeware':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gfscared':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gfhappy':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);

				case 'gfshouting':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('ara/gfbox', 'shared');
				box.animation.addByPrefix('normalOpen', 'TextBox', 24, false);
				box.animation.addByIndices('normal', 'TextBox', [11], "", 24);
				}
			}
				
			
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		bf = new FlxSprite(113, 506);
		bf.frames = Paths.getSparrowAtlas('ara/ports2');
		bf.animation.addByPrefix('enter', 'bfnormal', 24, false);
		bf.scrollFactor.set();
		add(bf);
		bf.visible = false;

		bf2 = new FlxSprite(113, 506);
		bf2.frames = Paths.getSparrowAtlas('ara/ports2');
		bf2.animation.addByPrefix('enter', 'bf2', 24, false);
		bf2.scrollFactor.set();
		add(bf2);
		bf2.visible = false;

		bfserious = new FlxSprite(113, 506);
		bfserious.frames = Paths.getSparrowAtlas('ara/ports2');
		bfserious.animation.addByPrefix('enter', 'bfserious', 24, false);
		bfserious.scrollFactor.set();
		add(bfserious);
		bfserious.visible = false;

		bfscared = new FlxSprite(113, 506);
		bfscared.frames = Paths.getSparrowAtlas('ara/ports2');
		bfscared.animation.addByPrefix('enter', 'bfscared', 24, false);
		bfscared.scrollFactor.set();
		add(bfscared);
		bfscared.visible = false;

		aranormal = new FlxSprite(113, 506);
		aranormal.frames = Paths.getSparrowAtlas('ara/ports2');
		aranormal.animation.addByPrefix('enter', 'aranormal', 24, false);
		aranormal.scrollFactor.set();
		add(aranormal);
		aranormal.visible = false;

		aranya = new FlxSprite(113, 506);
		aranya.frames = Paths.getSparrowAtlas('ara/ports2');
		aranya.animation.addByPrefix('enter', 'aranya', 24, false);
		aranya.scrollFactor.set();
		add(aranya);
		aranya.visible = false;

		araverruckt = new FlxSprite(113, 506);
		araverruckt.frames = Paths.getSparrowAtlas('ara/ports2');
		araverruckt.animation.addByPrefix('enter', 'araverruckt', 24, false);
		araverruckt.scrollFactor.set();
		add(araverruckt);
		araverruckt.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				bf.visible = false;
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('enter');
				}
			case 'bf2':
	            bf.visible = false;
				if (!bf2.visible)
				{
					bf2.visible = true;
					bf2.animation.play('enter');
				}
			case 'bfscared':
	            bf.visible = false;
				if (!bf2.visible)
				{
					bf2.visible = true;
					bf2.animation.play('enter');
				}
			case 'bfserious':
	            bf.visible = false;
				if (!bfserious.visible)
				{
					bfserious.visible = true;
					bfserious.animation.play('enter');
				}
			case 'gf':
	            bf.visible = false;
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('enter');
				}
				case 'gfcrying':
	            bf.visible = false;
				if (!gfcrying.visible)
				{
					gfcrying.visible = true;
					gfcrying.animation.play('enter');
				}
				case 'gfshouting':
	            bf.visible = false;
				if (!gfshouting.visible)
				{
					gfshouting.visible = true;
					gfshouting.animation.play('enter');
				}
				case 'gfblushed':
	            bf.visible = false;
				if (!gfblushed.visible)
				{
					gfblushed.visible = true;
					gfblushed.animation.play('enter');
				}
				case 'gfsuperblushed':
	            bf.visible = false;
				if (!gfsuperblushed.visible)
				{
					gfsuperblushed.visible = true;
					gfsuperblushed.animation.play('enter');
				}
				case 'gfhappy':
	            bf.visible = false;
				if (!gfhappy.visible)
				{
					gfhappy.visible = true;
					gfhappy.animation.play('enter');
				}
				case 'gfbeware':
	            bf.visible = false;
				if (!gfbeware.visible)
				{
					gfbeware.visible = true;
					gfbeware.animation.play('enter');
				}
				case 'aranormal':
	            bf.visible = false;
				if (!aranormal.visible)
				{
					aranormal.visible = true;
					aranormal.animation.play('enter');
				}
				case 'aranya':
	            bf.visible = false;
				if (!aranya.visible)
				{
					aranya.visible = true;
					aranya.animation.play('enter');
				}
				case 'araverruckt':
	            bf.visible = false;
				if (!araverruckt.visible)
				{
					araverruckt.visible = true;
					araverruckt.animation.play('enter');
				}
				
				
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
