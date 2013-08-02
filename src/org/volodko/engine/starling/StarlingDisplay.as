/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 23.12.12
 * Time: 0:18
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.engine.starling {
import org.volodko.engine.*;

import starling.core.Starling;
import starling.display.Sprite;
import starling.display.Stage;

public class StarlingDisplay extends Module {

    static public var INIT_CALLBACK:Function;
    
    private var starling:Starling;

    public function StarlingDisplay(onInit:Function) {
        INIT_CALLBACK = onInit;
        super();
        init();
    }

    private function init():void {
        starling = new Starling(StarlingSprite, GLB.stage);
        //starling.showStats = true;
        starling.antiAliasing = 1;
        starling.start();
    }


    public function getStage():Stage {
        return starling.stage;
    }
}
}

import org.volodko.engine.GLB;
import org.volodko.engine.GroupsVO;
import org.volodko.engine.MsgVO;
import org.volodko.engine.starling.StarlingDisplay;

import starling.display.Sprite;

class StarlingSprite extends Sprite {
    public function StarlingSprite() {
        if(StarlingDisplay.INIT_CALLBACK != null) StarlingDisplay.INIT_CALLBACK();
        GLB.signals.dispatchSignal(MsgVO.STARLING_START, null, GroupsVO.SYSTEM);
    }
}