/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 07.01.13
 * Time: 1:17
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.ra2game.network {
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

import org.volodko.engine.Entity;

import org.volodko.engine.Entity;
import org.volodko.engine.GLB;
import org.volodko.engine.GroupsVO;
import org.volodko.engine.MsgVO;
import org.volodko.engine.network.NetMsgVO;
import org.volodko.engine.social.vk.VkontakteAPI;
import org.volodko.ra2game.entities.Rocketer;
import org.volodko.ra2game.entities.heroes.Hero;
import org.volodko.ra2game.helpers.TypesVO;

public class NetworkLogic extends Entity {

    private var timer:Timer;
    private var pingStart:int;
    private var pingEnd:int;
    private var vk:VkontakteAPI;

    public function NetworkLogic() {
        super();
    }


    override public function init():void {
        super.init();
        //
        initComponents();
        //
        vk = GLB.engine.getModule(VkontakteAPI) as VkontakteAPI;
        //
        trace("NetworkLogic started");
        register(signalListener, GroupsVO.NETWORK);
        //
        timer = new Timer(1000);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    private function onTimer(event:TimerEvent):void {
        startLogin();
    }

    private function signalListener(msg:String, data:Object):void {
        switch (msg) {

            case NetMsgVO.CONNECTED:
                    //timer.start();
                    pingStart = getTimer();
                    startLogin();
                break;

            case NetMsgVO.DATA_RECEIVE:
                switch (data.cmd) {
                    case NetMsgVO.CMD_LOGIN:
                        if (data.data && !data.data.error) {
                            pingEnd = getTimer();
                            var ping:int = pingEnd - pingStart;
                            CONFIG::debug {
                                GLB.signals.dispatchSignal(MsgVO.LOG, "Ping: "+ping, GroupsVO.DEBUG);
                            }
                            vk.first_name = data.data.first;
                            vk.last_name = data.data.last;
                            //Update units
                            updateEntities();
                        } else {
                            //TODO Login error handle
                        }
                        break;
                    case NetMsgVO.CMD_UPDATE_ENTITIES:
                        if (data.data) {
                            //Update units
                            updateEntitiesOk(data.data);
                        } else {
                            //TODO Login error handle
                        }
                        break;
                    case NetMsgVO.CMD_ADD_ENTITY:
                        if (data.data) {
                            updateEntity(data.data)
                        } else {
                            //TODO Login error handle
                        }
                        break;
                    case NetMsgVO.CMD_REMOVE_ENTITY:
                        if (data.data) {
                            GLB.engine.removeEntityById(int(data.data));
                        } else {
                            //TODO Login error handle
                        }
                        break;
                }
                break;

        }
    }

    private function startLogin():void {
        //Login
        var loginData:Object = {
            cmd:NetMsgVO.CMD_LOGIN,
            data:{
                id:vk.viewer_id,
                token:vk.access_token
            }
        }; //TODO Login data add
        GLB.signals.dispatch(NetMsgVO.DATA_SEND, loginData, GroupsVO.NETWORK);
    }

    private function updateEntities():void {
        var updateData:Object = {
            cmd:NetMsgVO.CMD_UPDATE_ENTITIES,
            data:""
        };
        GLB.signals.dispatch(NetMsgVO.DATA_SEND, updateData, GroupsVO.NETWORK);
    }

    private function updateEntitiesOk(unitsData:Object):void {
        
        for each (var entity:Object in unitsData) {
            updateEntity(entity);
        }    
    }

    private function updateEntity(entity:Object):void {
        if(!GLB.engine.haveEntityWithUID(entity.uid)) {
            //Create new entity
            switch(entity.type) {
                case TypesVO.ROCK:
                    GLB.engine.addEntity(new Rocketer(entity));
                    break;
                case TypesVO.HERO:
                    GLB.engine.addEntity(new Hero(entity));
                    break;
            }
        } else {
            //Update existing
            GLB.signals.dispatch(NetMsgVO.UID_UPDATE, entity, GroupsVO.NETWORK);
        }
    }

}
}
