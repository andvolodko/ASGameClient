/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 07.01.13
 * Time: 20:48
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.engine.network {
import org.osmf.net.NetClient;
import org.volodko.engine.Component;
import org.volodko.engine.Entity;
import org.volodko.engine.GLB;
import org.volodko.engine.GroupsVO;
import org.volodko.engine.MsgVO;
import org.volodko.ra2game.entities.Rocketer;

public class NetworkUpdatable extends Component {
    
    private var id:int;
    
    public function NetworkUpdatable(entity:Entity, id:int) {
        this.id = id;
        super(entity);
    }


    override public function init():void {
        super.init();
        //
        register(signalListener, GroupsVO.NETWORK);
    }

    private function signalListener(msg:String, data:Object):void {
        switch (msg) {
            case NetMsgVO.UID_UPDATE:
                    if(data.uid == entity.getUID()) {
                        Object(entity).setPos(data.x, data.y);
                    }
                break;
        }
    }
    
}
}
