package export.release.windows.bin.mods.stages;



import backend.ClientPrefs;
import backend.CrossUtil;
import flixel.addons.display.FlxRuntimeShader;
import flixel.text.FlxText;
import backend.Conductor;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.math.FlxMath;
import objects.AttachedSprite;
import psychlua.LuaUtils;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import objects.PsychVideoSprite;

var fireVideo:PsychVideoSprite;
var videoGood:PsychVideoSprite;
var videoBad:PsychVideoSprite;
var finaleBad:PsychVideoSprite;
var finaleGood:PsychVideoSprite;

var shader:FlxRuntimeShader;

var tiktokCam:FlxCamera;

var helpBarT:FlxSprite;
var helpBarB:FlxSprite;
var helpMeButton;
var helpButtonAllowedToScale:Bool = false;
var helpButtonClickCap:Int = 75;
var helpButtonCount:Int = 0;


var subtitles:FlxText;

var helpMeMode:Bool = false;
var succeededHelping:Bool = false;

var batteryBar:FlxSprite;
var batteryColor:FlxSprite;

var scale = 2.25;

var fakeBG:FlxSprite;


var mainBG:Array<FlxSprite> = [];

var zoomTween:FlxTween;
var shaderTweens:Array<FlxTween> = [];

var bfOGPos:Array<Float> = [];

var goodImage:FlxSprite;
var badImage:FlxSprite;

function generateBG() {
    var sky = new FlxSprite();
    sky.frames = Paths.getSparrowAtlas('bgasset');
    sky.animation.addByPrefix('i','sky');
    sky.animation.play('i');
    addBehindDad(sky);
    sky.antialiasing = ClientPrefs.data.antialiasing;
    sky.scale.set(scale,scale);
    sky.updateHitbox();
    mainBG.push(sky);

    var t = new FlxSprite();
    t.frames = Paths.getSparrowAtlas('bgasset');
    t.animation.addByPrefix('i','bg1');
    t.animation.play('i');
    addBehindDad(t);
    t.antialiasing = ClientPrefs.data.antialiasing;
    t.scale.set(scale,scale);
    t.updateHitbox();
    mainBG.push(t);

    var t = new FlxSprite();
    t.frames = Paths.getSparrowAtlas('bgasset');
    t.animation.addByPrefix('i','bg2');
    t.animation.play('i');
    addBehindDad(t);
    t.antialiasing = ClientPrefs.data.antialiasing;
    t.scale.set(scale,scale);
    t.updateHitbox();
    mainBG.push(t);

    var t = new FlxSprite();
    t.frames = Paths.getSparrowAtlas('bgasset');
    t.animation.addByPrefix('i','bg3');
    t.animation.play('i');
    addBehindDad(t);
    t.antialiasing = ClientPrefs.data.antialiasing;
    t.scale.set(scale,scale);
    t.updateHitbox();
    mainBG.push(t);


    var t = new FlxSprite(-1200,400);
    t.frames = Paths.getSparrowAtlas('bgasset');
    t.animation.addByPrefix('i','tree');
    t.animation.play('i');
    add(t);
    t.antialiasing = ClientPrefs.data.antialiasing;
    t.scale.set(scale,scale);
    t.updateHitbox();
    t.scrollFactor.set(1.2,1.2);
    t.alpha = 0.9;
    mainBG.push(t);

    var t = new FlxSprite(4000,400);
    t.frames = Paths.getSparrowAtlas('bgasset');
    t.animation.addByPrefix('i','tree');
    t.animation.play('i');
    add(t);
    t.antialiasing = ClientPrefs.data.antialiasing;
    t.scale.set(scale,scale);
    t.updateHitbox();
    t.scrollFactor.set(1.2,1.2);
    t.alpha = 0.9;
    mainBG.push(t);

}

function onCreate() {

    tiktokCam = new FlxCamera();
    tiktokCam.bgColor = 0x0;
    CrossUtil.insertFlxCamera(1,tiktokCam);

    generateBG();

    game.addCharacterToList('nugget',0);
    game.addCharacterToList('nugget_hat',0);
    game.addCharacterToList('maxpro',1);

    game.addCharacterToList('rednughat',0);
    game.addCharacterToList('rednugget',0);
    game.addCharacterToList('redmax',1);
    

    fakeBG = new FlxSprite().loadGraphic(Paths.image('og'));
    fakeBG.scale.set(1.75,1.75);
    fakeBG.updateHitbox();
    fakeBG.setPosition(2000,1200);
    fakeBG.antialiasing = true;
    addBehindDad(fakeBG);

    shader = game.createRuntimeShader('scary');
    shader.setFloat('strength',1);
    shader.setFloat('darkness',0.0);
    addShader(shader);

    fireVideo = new PsychVideoSprite();
    fireVideo.load(Paths.video('fire'), [PsychVideoSprite.muted,PsychVideoSprite.looping]);
    fireVideo.addCallback('onFormat',()->{
        fireVideo.setGraphicSize(mainBG[0].width);
        fireVideo.updateHitbox();
        fireVideo.blend = BlendMode.ADD;
        fireVideo.alpha = 0.3;
    });
    fireVideo.scrollFactor.set(1.1,1.1);
    add(fireVideo);
    fireVideo.antialiasing = ClientPrefs.data.antialiasing;

    videoBad = new PsychVideoSprite();
    videoBad.load(Paths.video('lyrics_bad'), [PsychVideoSprite.muted]);

    videoGood = new PsychVideoSprite();
    videoGood.load(Paths.video('lyrics_good'), [PsychVideoSprite.muted]);

    finaleBad = new PsychVideoSprite();
    finaleBad.load(Paths.video('bad_finale'), [PsychVideoSprite.muted]);

    finaleGood = new PsychVideoSprite();
    finaleGood.load(Paths.video('good_finale'), [PsychVideoSprite.muted]);

    for (i in [finaleBad,finaleGood]) {
        i.addCallback('onFormat',()->{
            i.setGraphicSize(FlxG.width);
            i.updateHitbox();
            i.screenCenter();
            tiktokCam.bgColor = 0xFF000000;
        });
        //maybe remove
        i.addCallback('onEnd',()->{
            tiktokCam.bgColor = 0x0;
        });
        i.cameras=[tiktokCam];
        i.antialiasing = ClientPrefs.data.antialiasing;
        add(i);
    }
    finaleGood.addCallback('onEnd',()->{
        game.triggerEvent('Change Character','bf','nugget_hat',Conductor.songPosition);
        game.triggerEvent('Change Character','dad','maxpro',Conductor.songPosition);
        game.isCameraOnForcedPos = false;
        FlxG.camera.snapToTarget();
        fireVideo.restart([PsychVideoSprite.muted]);
        fireVideo.alpha = 0.3;
        tiktokCam.bgColor = 0x0;
        game.dad.alpha = 1;

        for (i in mainBG) i.alpha = 1;
        FlxG.camera.flash(FlxColor.RED,0.5);
    });

    finaleBad.addCallback('onEnd',()->{
        tiktokCam.bgColor = 0xFF000000;
    });

    for (i in [videoGood,videoBad]) {
        i.addCallback('onEnd',()->{
            game.camOther.flash(); 
            for (i in game.playerStrums) i.alpha = 1;
            for (i in game.uiGroup) i.alpha = 1;
            tiktokCam.bgColor = 0x0;
            game.triggerEvent('','redMode','',Conductor.songPosition);


        });
        i.addCallback('onFormat',()->{
            i.setGraphicSize(FlxG.width);
            i.updateHitbox();
            i.screenCenter();
        });
        i.cameras=[tiktokCam];
        i.antialiasing = ClientPrefs.data.antialiasing;
        add(i);
    }




}

function setupHUD() {
    game.showCombo = false;
    game.showRating = false;
    game.showComboNum = false;


    for (i in opponentStrums) {
        i.x = -1000;
    }
    for (i in [game.healthBar,game.scoreTxt,game.timeBar,game.timeTxt]) i.visible = false;

    game.defaultHUDZoom = 0.8;
    game.camHUD.zoom = 0.8;

    for (i in playerStrums) {
        if (ClientPrefs.data.downScroll) {
            i.y += 100;
        }
        else {
            i.y += -100;
        }

    }

    batteryBar = new FlxSprite().loadGraphic(Paths.image('hpbar'));
    batteryBar.screenCenter(FlxAxes.X);

    if (ClientPrefs.data.downScroll) {
        batteryBar.y = -50;
    }
    else {
        batteryBar.y = FlxG.height - batteryBar.height + 50;
    }
    batteryBar.antialiasing = true;
    game.uiGroup.insert(game.uiGroup.members.indexOf(game.iconP1),batteryBar);

    batteryColor = new FlxSprite().loadGraphic(Paths.image('barwhiteohio'));
    batteryColor.screenCenter(FlxAxes.X);
    batteryColor.y = FlxG.height - batteryBar.height + 50;
    batteryColor.setPosition(batteryBar.x + 22,batteryBar.y +  47);
    batteryColor.color = getColor();
    batteryColor.antialiasing = true;
    game.uiGroup.insert(game.uiGroup.members.indexOf(game.iconP1),batteryColor);

    game.updateIconsScale = (elapsed)->{game.iconP1.scale.set(1,1);game.iconP2.scale.set(1,1);}
    game.updateIconsPosition = ()->{
        game.iconP2.x = batteryBar.x - game.iconP2.width + 55;
        game.iconP1.x = batteryBar.x + batteryBar.width - 25;

        game.iconP1.y = batteryBar.y + (batteryBar.height - game.iconP1.height)/2 + 25;
        game.iconP2.y = batteryBar.y + (batteryBar.height - game.iconP2.height)/2 + 30;
    }


}
function onCreatePost() {

    setupHUD();
    game.camOffset = 25;

    cacheHelpMe();

    bfOGPos = [boyfriend.x,boyfriend.y];
    boyfriend.x -= 700;
    for (i in mainBG) i.alpha = 0.01;

    introCam();

    subtitles = new FlxText(0,0, FlxG.width,'',48);
    subtitles.font = Paths.font('mottrfmn.ttf');
    subtitles.y = FlxG.height - subtitles.height - 15;
    subtitles.alignment = 'center';
    add(subtitles);
    subtitles.cameras = [tiktokCam];

    goodImage = new FlxSprite().loadGraphic(Paths.image('goodEND'));
    add(goodImage);
    goodImage.cameras = [game.camOther];
    goodImage.alpha = 0;
    goodImage.setGraphicSize(0,FlxG.height);
    goodImage.updateHitbox();
    goodImage.screenCenter();

    
    badImage = new FlxSprite().loadGraphic(Paths.image('badEND'));
    add(badImage);
    badImage.cameras = [game.camOther];
    badImage.alpha = 0;
    badImage.setGraphicSize(0,FlxG.height);
    badImage.updateHitbox();
    badImage.screenCenter();
}


function onUpdatePost(elapsed) {

    if (helpMeMode && FlxG.mouse.overlaps(helpMeButton,game.camHUD) && FlxG.mouse.justPressed) {
        helpButtonCount++;
        helpMeButton.scale.set(0.375,0.375);
        //debugPrint('clickCOunt:' + helpButtonCount);
        FlxG.camera.shake(0.0025);
        
    } 

    if (helpButtonAllowedToScale) {
        var s = FlxMath.lerp(helpMeButton.scale.x, 0.35,1 - Math.exp(-elapsed * 6));
        helpMeButton.scale.set(s,s);
    }
}


function getColor() {
    if (health >= 2) return 0xFF21EF36;
    else if (health >= 1.5) return 0xFF92EF58;
    else if (health >= 1) return 0xFFF1DB5C;
    else if (health >= 0.5) return 0xFFCA5427;
    else return 0xFFCD3323;
}
//move into a uhhhh onnote miss and press
function onRecalculateRating() {
    if (batteryColor != null)
        batteryColor.color = getColor();
}


function startHelping() {
    helpMeMode = true;
    game.isCameraOnForcedPos = true;
    FlxG.mouse.visible = true;

    boyfriend.stunned = true;
    boyfriend.playAnim('WHAT');

    for (i in game.uiGroup) {
        FlxTween.tween(i, {alpha: 0},1);
    }

    for (i in game.playerStrums) {
        FlxTween.tween(i, {alpha: 0},1);
    }

    FlxTween.tween(helpBarT, {alpha: 1},2,{startDelay: 1});
    FlxTween.tween(helpBarB, {alpha: 1},2,{startDelay: 1});
    FlxTween.tween(helpMeButton.scale, {x: 0.35, y: 0.35},0.7,{startDelay: 1, ease: FlxEase.backOut, onComplete: Void->{
        helpButtonAllowedToScale = true;
    }});

    var x = boyfriend.getMidpoint().x - 100;
    x -= boyfriend.cameraPosition[0] - game.boyfriendCameraOffset[0];
    var y = boyfriend.getMidpoint().y - 100;
    y += boyfriend.cameraPosition[1] + game.boyfriendCameraOffset[1];
    FlxTween.tween(game.camFollow, {x: x + 400, y: y},0.25, {ease: FlxEase.quadOut});

    if (zoomTween != null) zoomTween.cancel();
}

function judgeHelp() {
    helpMeMode = false;
    if (helpButtonCount >= helpButtonClickCap) {
        succeededHelping = true;
    }

    if (succeededHelping) {
        game.triggerEvent('Change Character','bf','nugget_hat',Conductor.songPosition);
        boyfriend.playAnim('hatapear');
        boyfriend.stunned = true;
    }
    FlxTween.tween(helpMeButton.scale, {x: 0.0, y: 0.0},0.7,{ease: FlxEase.backIn, onComplete: Void->{
        helpButtonAllowedToScale = false;
    }});

}

function cacheHelpMe() {

    helpBarT = new FlxSprite().makeGraphic(1,1,FlxColor.BLACK);
    helpBarT.scale.set(FlxG.width/3,FlxG.height);
    helpBarT.updateHitbox();
    addBehindDad(helpBarT);
    helpBarT.cameras = [tiktokCam];

    
    helpBarB = new FlxSprite(FlxG.width - (FlxG.width/3)).makeGraphic(1,1,FlxColor.BLACK);
    helpBarB.scale.set((FlxG.width/3),FlxG.height);
    helpBarB.updateHitbox();
    addBehindDad(helpBarB);
    helpBarB.cameras = [tiktokCam];

    // helpBarT.alpha = 0;
    // helpBarB.alpha = 0;

    helpMeButton = new FlxSprite(0,50).loadGraphic(Paths.image('here2'));
    helpMeButton.scale.set(0.35,0.35);
    helpMeButton.updateHitbox();
    helpMeButton.screenCenter(FlxAxes.X);
    add(helpMeButton);
    helpMeButton.cameras = [camHUD];
    helpMeButton.antialiasing = true;
    helpMeButton.scale.set();

}

function introCam() {
    game.camHUD.alpha = 0;

    game.isCameraOnForcedPos = true;
    FlxG.camera.zoom += 0.5;
    game.camFollow.y += 100;
    game.camFollow.x += 300 - 700;
    FlxG.camera.snapToTarget();
    FlxG.camera.fade(FlxColor.BLACK,0);
}

function onSongStart() {
    var time = 1.5;
    FlxG.camera.fade(FlxColor.BLACK,time,true);
    FlxTween.tween(game.camHUD, {alpha: 1},time -0.25, {ease: FlxEase.sineOut,startDelay: 0.25});

    zoomTween = FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.1},time, {ease: FlxEase.circIn});

    FlxTween.tween(game.camFollow, {x: game.camFollow.x - 700, y: game.camFollow.y - 100},time, {ease: FlxEase.circIn});
}

function onDestroy() {
    if (fireVideo != null) fireVideo.destroy();
    if (videoGood != null) videoGood.destroy();
    if (videoBad != null) videoBad.destroy();
    if (finaleBad != null) finaleBad.destroy();
    if (finaleGood != null) finaleGood.destroy();
}

function onEvent(ev,v1,v2,time) {

    if (ev == '') {
        switch (v1) {
            case 'fadeIMG':
                if (succeededHelping) {
                    FlxTween.tween(goodImage, {alpha: 1},4);
                }
                else {
                    game.camHUD.visible = false;
                    FlxTween.tween(badImage, {alpha: 1},4);
                }
            case 'panCenter':
                game.isCameraOnForcedPos = true;
                FlxTween.tween(game.camFollow, {x: mainBG[0].x + (mainBG[0].width)/2},1.2, {ease: FlxEase.sineInOut});
                if (zoomTween != null) zoomTween.cancel();  

                zoomTween = FlxTween.num(FlxG.camera.zoom,0.38,1.2,{ease: FlxEase.sineInOut},(f)->{
                    game.defaultCamZoom = f;
                    FlxG.camera.zoom = f;
                    game.camZooming = false;
                });

            case 'panUP':
                game.isCameraOnForcedPos = true;
                FlxTween.tween(camFollow, {y: camFollow.y - 500},1.2, {ease: FlxEase.sineIn});
                game.camHUD.fade(FlxColor.BLACK,1);
            case 'bringnotes':
                for (i in playerStrums) {
                    FlxTween.tween(i, {alpha: 1},0.7);
                }
            case 'begin':
                FlxTween.cancelTweensOf(game.camFollow);
                if (zoomTween != null) zoomTween.cancel();
                game.isCameraOnForcedPos = false;
                game.camZooming = true;
            
            case 'redMode':
                fireVideo.alpha = 0;
                fireVideo.stop();
                mainBG[0].alpha = 0.2;
                for (i in 0...mainBG.length) {
                    if (i != 0) mainBG[i].alpha = 0;
                }
                for (i in game.uiGroup) i.visible = false;
                // succeededHelping = true;
                var name = 'rednugget';
                if (succeededHelping) name = 'rednughat';

                game.triggerEvent('Change Character','bf',name,Conductor.songPosition);
                game.triggerEvent('Change Character','dad','redmax',Conductor.songPosition);

                game.dad.x += 400;
                game.boyfriend.x += -1100;
                game.boyfriend.y += 500;
                game.isCameraOnForcedPos = true;
                game.camFollow.x = game.dad.x + 415;
                game.camFollow.y = game.dad.y + 300;
                FlxG.camera.snapToTarget();
                if (succeededHelping) {
                    game.dad.alpha = 0;
                }
                else {
                    game.dad.alpha = 0.5;
                    game.boyfriend.x += 75;
                }
            case 'playGoodVid':
                if (succeededHelping)
                    finaleGood.play();
            case 'playBadVid':
                if (!succeededHelping)
                    finaleBad.play();
            case 'fire':
                shader.setFloat('strength',4);
                shader.setFloat('darkness',0.6);
                fireVideo.play();
                FlxG.camera.flash(FlxColor.RED,0.4);
                FlxG.camera.zoom += 0.2;
            case 'cutscene':
                tiktokCam.bgColor = 0xFF000000;
                boyfriend.stunned = false;
                helpBarT.visible = helpBarB.visible = helpMeButton.visible = false;
                game.isCameraOnForcedPos = false;
                if (succeededHelping)
                    videoGood.play();
                else 
                    videoBad.play();
            case 'tweenIn':
                game.camZooming = false;
                tweenShader(3,0.3,(22.27 - 21.03),'cubeinout');
                FlxTween.tween(boyfriend, {x: boyfriend.x + 700},(22.27 - 21.03), {ease: FlxEase.cubeOut});
                FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3},(22.27 - 21.03), {ease: FlxEase.cubeInOut});
                FlxTween.tween(game.camHUD, {alpha: 0.5},(22.27 - 21.03), {ease: FlxEase.cubeInOut});
                FlxTween.tween(fakeBG, {alpha: 0},(22.27 - 21.03)+ 0.1);
                FlxTween.tween(helpBarT, {x: -helpBarT.width},(22.27 - 21.03) + 0.1);
                FlxTween.tween(helpBarB, {x: FlxG.width},(22.27 - 21.03) + 0.1, {onComplete: Void->{
                    helpBarT.x = 0;
                    helpBarB.x = FlxG.width - helpBarB.width;
                    helpBarT.alpha = 0;
                    helpBarB.alpha = 0;
                }});

            case 'tweenOut1':
                game.triggerEvent('Change Character','bf','nugget',Conductor.songPosition);
                game.triggerEvent('Change Character','dad','maxpro',Conductor.songPosition);

                for (i in mainBG) i.alpha = 1;


                tweenShader(1,0,0.15,'');
                game.defaultCamZoom = 0.4;
                FlxTween.cancelTweensOf(game.camHUD);
                FlxTween.tween(game.camHUD, {alpha: 1},0.15, {ease: FlxEase.cubeOut});
                FlxTween.tween(FlxG.camera, {zoom: game.defaultCamZoom},0.15, {ease: FlxEase.cubeOut});
            case 'subs':
  
                subtitles.text = v2;
            case 'helpMe':
                startHelping();
            case 'judge':
                judgeHelp();
            
        }

    }

    switch (ev) {
        case 'infryzoom':
            if (zoomTween != null) zoomTween.cancel();  

            zoomTween = FlxTween.num(FlxG.camera.zoom,Std.parseFloat(v1),Std.parseFloat(v2),{ease: FlxEase.cubeOut,onComplete: Void->{
                game.camZooming = true;
            }},(f)->{
                game.defaultCamZoom = f;
                FlxG.camera.zoom = f;
                game.camZooming = false;
            });
        case 'zoom':
            if (zoomTween != null) zoomTween.cancel();
            var split = v1.split(',');
            FlxTween.tween(FlxG.camera, {zoom: Std.parseFloat(split[0])},Std.parseFloat(split[1]), {ease: LuaUtils.getTweenEaseByString(v2), onUpdate: (f)->{
                game.defaultCamZoom = f;
            }});
        case 'tweenShader':
            var vals = v1.split(',');
            tweenShader(Std.parseFloat(vals[0]),Std.parseFloat(vals[1]),Std.parseFloat(vals[2]),v2);  

    }
}


function tweenShader(strength:Float = 1,darkness:Float = 0,time:Float = 0,ease:String = '') {
    if (shaderTweens[0] != null)
        shaderTweens[0].cancel();
    if (shaderTweens[1] != null)
        shaderTweens[1].cancel();

    shaderTweens[0] = FlxTween.num(shader.getFloat('darkness'),darkness,time, {ease: LuaUtils.getTweenEaseByString(ease)}, (f)->{
        shader.setFloat('darkness',f);
    });

    shaderTweens[1] = FlxTween.num(shader.getFloat('strength'),strength,time, {ease: LuaUtils.getTweenEaseByString(ease)}, (f)->{
        shader.setFloat('strength',f);
    });
}