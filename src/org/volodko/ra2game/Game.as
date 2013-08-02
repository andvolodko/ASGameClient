/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 23.03.12
 * Time: 23:51
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.ra2game {

import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.getTimer;

import org.volodko.engine.Console;
import org.volodko.engine.Engine;
import org.volodko.engine.GLB;
import org.volodko.engine.GroupsVO;
import org.volodko.engine.Keys;
import org.volodko.engine.MsgVO;
import org.volodko.engine.social.vk.VkontakteAPI;
import org.volodko.engine.starling.StarlingDisplay;
import org.volodko.engine.network.NetworkSync;
import org.volodko.engine.utils.stats.StatsModule;
import org.volodko.ra2game.helpers.GameGLB;
import org.volodko.ra2game.scenes.GameLevel;

dynamic public class Game extends Engine{

    //
    public function Game() {
        //---------- Start scene
        super(GameLevel);
        //super(TestScene);
        //super(Menu);
        //super(Map);
        //super(Editor);
    }

    override public function initialize(e:Event = null):void {
        //
        var startTime:Number = getTimer();
        //
        super.initialize(e);
        //--------- Stage params ----------------
        //stage.quality = StageQuality.HIGH;
        stage.quality = StageQuality.HIGH;
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        //stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.frameRate = 60;
        //-------------- Add modules --------------
        addModule(new Keys());
        //
        CONFIG::debug {
            addModule(new StatsModule());
            addModule(new Console());
        }
        //
        addModule(new StarlingDisplay(starlingInited));
        //addModule(new Profiler());
        //
        var endTime:Number = getTimer();
        //
        CONFIG::debug {
            GLB.signals.dispatchSignal(MsgVO.LOG, "Started with no sounds: <b>"+GameGLB.noSounds+"</b>", GroupsVO.DEBUG);
            GLB.signals.dispatchSignal(MsgVO.LOG, "Engine init time: <b>"+((endTime-startTime)/1000)+"</b>", GroupsVO.DEBUG);
        }
    }

    private function starlingInited():void {
        addModule(new VkontakteAPI(null));
        apiInited();
    }

    private function apiInited():void {
        //--------- And at end --------------------
        launchStartState();
        //
//        addModule(new NetworkSync("127.0.0.1",9999));
        addModule(new NetworkSync("test.volodko.org",9999));
    }

}
}
