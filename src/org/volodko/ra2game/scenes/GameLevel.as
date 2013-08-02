/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 07.04.12
 * Time: 3:32
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.ra2game.scenes {
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;

import org.volodko.engine.Engine;
import org.volodko.engine.GLB;
import org.volodko.engine.GroupsVO;
import org.volodko.engine.Scene;
import org.volodko.engine.starling.StarlingDisplay;
import org.volodko.ra2game.network.NetworkLogic;

import starling.display.Image;
import starling.display.Stage;
import starling.textures.Texture;

public class GameLevel extends Scene {

    private var engine:Engine;
    private var starlingDisplay:StarlingDisplay;
    private var stageStar:Stage;

    public function GameLevel() {
        super(null);
    }

    override protected function initialize(e:Event = null):void {
        super.initialize(e);
        //Init vars
        engine = GLB.engine;
        //
        register(signalListener, GroupsVO.SYSTEM);
        //
        startCode();
    }

    private function startCode():void {
        starlingDisplay = StarlingDisplay(engine.getModule(StarlingDisplay));
        stageStar = starlingDisplay.getStage();
        trace("Start level");
        //
        var tileBD:BitmapData = new Tile();
        var tilesBD:BitmapData = new BitmapData(GLB.stage.stageWidth, GLB.stage.stageHeight);
        //
        var renderPoint:Point = new Point();
        for (var yy:int = 0; yy < 20; yy++) {
            for (var xx:int = -20; xx < 20; xx++) {
//                tmpP.x = int((ty - tx) * tileMC.height);
//                tmpP.y = int((ty + tx) * tileH2);
                renderPoint.x = int((yy - xx) * tileBD.height);
                renderPoint.y = int((yy + xx) * (tileBD.height / 2));
                tilesBD.copyPixels(tileBD, tileBD.rect, renderPoint, null, null, true);
            }
        }
        //
        var texture:Texture = Texture.fromBitmapData(tilesBD);
        var image:Image = new Image(texture);
        stageStar.addChild(image);
        //
        addEntity(new NetworkLogic());
    }

    private function signalListener(msg:String, data:Object):void {
        switch (msg) {
            //
        }
    }

}
}