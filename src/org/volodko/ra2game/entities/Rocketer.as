/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 07.01.13
 * Time: 20:31
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.ra2game.entities {
import caurina.transitions.Tweener;

import flash.display.BitmapData;
import flash.events.MouseEvent;

import org.volodko.engine.Entity;
import org.volodko.engine.GLB;
import org.volodko.engine.network.NetworkUpdatable;
import org.volodko.engine.starling.StarlingDisplay;
import org.volodko.engine.starling.StarlingRender;

import starling.core.Starling;

import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.display.Stage;
import starling.text.TextField;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Rocketer extends Entity {

    private var sortIndex:int;
    private var id:int;
    //
    private var starlingDisplay:StarlingDisplay;
    private var stageStar:Stage;
    //
    [Embed(source="../../../../../Resources/rock.xml", mimeType="application/octet-stream")]
    private var rockXml:Class;
    [Embed(source="../../../../../Resources/rock.png")]
    private var rockPng:Class;
    private var mc:MovieClip;
    private var data:Object;
    private var spr:Sprite;

    public function Rocketer(data:Object) {
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
        trace("add rocketer "+data.name);
        //
        var rocketerBD:BitmapData = new Rock1();
        var textureRock:Texture = Texture.fromBitmapData(rocketerBD);

        //
        var rockXml:XML = XML(new rockXml());
        var rockTex:Texture = Texture.fromBitmap(new rockPng());
        var rockAtlas:TextureAtlas = new TextureAtlas(rockTex,rockXml);

        mc = new MovieClip(rockAtlas.getTextures("attack1"),15);
        Starling.juggler.add(mc);

        var tfName:TextField = new TextField(200,20, data.name);
        spr = new Sprite();
        spr.addChild(mc);
        spr.addChild(tfName);
        spr.x = data.x;
        spr.y = data.y;
        stageStar.addChild(spr);
                
    }

    public function setPos(x:int, y:int):void {
        Tweener.addTween(spr, {time:3, x:x,  y:y});
    }


    override public function remove():void {
        super.remove();
        stageStar.removeChild(spr);
    }
}
}
