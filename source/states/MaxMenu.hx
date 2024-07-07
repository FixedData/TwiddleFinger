package states;

import hxvlc.util.Handle;
import backend.Song;
import backend.Highscore;
import options.OptionsState;




class MaxMenu extends MusicBeatState
{
    var optionNow:Bool = false;

    var startButton:FlxSprite;
    var optionsButton:FlxSprite;


    var face:FlxSprite;
    var eye:FlxSprite;
    

    var group:Array<FlxSprite> = [];

    static var inited=false;
    function init(){
        if (inited) return;
        inited = true;
        Handle.init();

        #if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		Highscore.load();

    }

    override function create() {

        init();
        super.create();

        FlxG.sound.playMusic(Paths.music('menu'),0.1);

        FlxG.mouse.visible = false;

        face = new FlxSprite().loadGraphic(Paths.image('hisface'));
        face.screenCenter();
        add(face);
        face.alpha = 0;

        eye = new FlxSprite().loadGraphic(Paths.image('eye'));
        eye.screenCenter();
        add(eye);
        eye.alpha = 0;

        var t = new FlxText(0,20,FlxG.width,'MAX DESIGN PRO',48);
        t.font = Paths.font('Knicknack Regular.otf');
        t.color = 0xFF242320;
        t.alignment = CENTER;
        add(t);
        group.push(t);


        var f = new FlxSprite(0,t.y + t.height).makeGraphic(1,1,0xFF242320);
        f.scale.set(FlxG.width,5);
        f.updateHitbox();
        add(f);
        group.push(f);

        var t = new FlxText(0,0,FlxG.width,'MAX DESIGN PRO',48);
        t.font = Paths.font('Knicknack Regular.otf');
        t.screenCenter(Y);
        t.y -= 200;
        t.alignment = CENTER;
        add(t);
        group.push(t);

        startButton = new FlxSprite(-50 + -140);
        startButton.frames = Paths.getSparrowAtlas('buttons');
        startButton.animation.addByPrefix('i','start_s');
        startButton.animation.addByPrefix('s','start_i');
        startButton.animation.play('s');
        add(startButton);
        group.push(startButton);

        optionsButton = new FlxSprite(-50 + -140);
        optionsButton.frames = Paths.getSparrowAtlas('buttons');
        optionsButton.animation.addByPrefix('i','options_s');
        optionsButton.animation.addByPrefix('s','options_i');
        optionsButton.animation.play('i');
        add(optionsButton);
        group.push(optionsButton);

    }

    override function update(elapsed:Float) {
        if (controls.UI_LEFT_P || controls.UI_RIGHT_P) change();
        if (controls.ACCEPT) {
            if (optionNow) {
                FlxG.switchState(new OptionsState());
            }
            else {
                for (i in group) {
                    i.visible = false;
                }
                FlxG.sound.music.volume = 0;
                FlxTimer.wait(2, ()->{
                    FlxTween.tween(face, {alpha: 1},2).then(
                        FlxTween.tween(eye, {alpha: 1},0.7, {startDelay: 2})
                    ).then(
                        FlxTween.tween(face, {alpha: 1},2, {onComplete: Void->{
                            eye.visible = face.visible = false;
                            Difficulty.resetList();
                            var formatedSong:String = Paths.formatToSongPath('twiddlefinger');
                            var diffFormatting:String = Highscore.formatSong(formatedSong, 1);

                            PlayState.SONG = Song.loadFromJson(diffFormatting, formatedSong);
                            PlayState.isStoryMode = false;
                            PlayState.storyDifficulty = 1;
                            LoadingState.loadAndSwitchState(new PlayState());
                        }})
                    );
                });



                //FlxG.switchState(new PlayState());
            }
        }
        super.update(elapsed);
    }


    function change() {
        optionNow = !optionNow;

        if (optionNow) {
            startButton.animation.play('i');
            optionsButton.animation.play('s');
        }
        else {
            startButton.animation.play('s');
            optionsButton.animation.play('i');
        }

    }
}