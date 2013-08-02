/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 24.04.12
 * Time: 19:08
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.ra2game.entities.heroes {
import caurina.transitions.Tweener;

import flash.display.BitmapData;
import flash.events.MouseEvent;

import org.volodko.engine.Entity;
import org.volodko.engine.GLB;
import org.volodko.engine.GroupsVO;
import org.volodko.engine.network.NetMsgVO;
import org.volodko.engine.network.NetworkUpdatable;
import org.volodko.engine.social.vk.VkontakteAPI;
import org.volodko.engine.starling.StarlingDisplay;
import org.volodko.engine.starling.StarlingRender;
import org.volodko.engine.utils.LoDMath;

import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Hero extends Entity {

    private var sortIndex:int;
    private var id:int;
    //
    private var starlingDisplay:StarlingDisplay;
    private var stageStar:Stage;
    //
    [Embed(source="../../../../../../Resources/rock.xml", mimeType="application/octet-stream")]
    private var rockXml:Class;
    [Embed(source="../../../../../../Resources/rock.png")]
    private var rockPng:Class;
    private var mc:MovieClip;
    private var data:Object;
    private var spr:Sprite;

    public function Hero(data:Object) {
        this.data = data;
        super(data.uid);
    }

    override public function init():void {
        super.init();
        //
        addComponent(new StarlingRender(this, sortIndex));
        addComponent(new NetworkUpdatable(this, id));
        //
        initComponents();
        //
        starlingDisplay = StarlingDisplay(GLB.engine.getModule(StarlingDisplay));
        stageStar = starlingDisplay.getStage();
        trace("add hero "+data.name);
        //
        var rocketerBD:BitmapData = new Rock1();
        var textureRock:Texture = Texture.fromBitmapData(rocketerBD);

        //
        var rockXml:XML = XML(new rockXml());
        var rockTex:Texture = Texture.fromBitmap(new rockPng());
        var rockAtlas:TextureAtlas = new TextureAtlas(rockTex,rockXml);

        mc = new MovieClip(rockAtlas.getTextures("attack1"),15);
        Starling.juggler.add(mc);
        //
        var tfName:TextField = new TextField(200,20, data.name);
        spr = new Sprite();
        spr.addChild(mc);
        spr.addChild(tfName);
        spr.x = data.x;
        spr.y = data.y;
        stageStar.addChild(spr);
        //
        GLB.stage.addEventListener(MouseEvent.CLICK, onClick);
        GLB.stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
    }

    private function onRightClick(event:MouseEvent):void {
        heroAttack(event.stageX, event.stageY);
    }

    private function onClick(event:MouseEvent):void {
        moveHero(event.stageX, event.stageY);
    }

    private function moveHero(xp:Number, yp:Number):void {
        //Login
        var moveData:Object = {
            cmd:NetMsgVO.CMD_MOVE_ENTITY,
            data:{
                id:data.uid,
                x:xp,
                y:yp
            }
        };
        GLB.signals.dispatch(NetMsgVO.DATA_SEND, moveData, GroupsVO.NETWORK);
    }


    private function heroAttack(xp:Number, yp:Number):void {
        //Login
        var angle:Number = LoDMath.angleBetween(spr.x, spr.y, xp, yp);
        var attackData:Object = {
            cmd:NetMsgVO.CMD_ATTACK_ENTITY,
            data:{
                id:data.uid,
                x:xp,
                y:yp,
                a:angle
            }
        };
        GLB.signals.dispatch(NetMsgVO.DATA_SEND, attackData, GroupsVO.NETWORK);
    }


    public function setPos(x:int, y:int):void {
        Tweener.addTween(spr, {time:3, x:x,  y:y});
    }

    override public function remove():void {
        super.remove();
        stageStar.removeChild(spr);
        GLB.stage.removeEventListener(MouseEvent.CLICK, onClick);
        GLB.stage.removeEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
    }

}
}
