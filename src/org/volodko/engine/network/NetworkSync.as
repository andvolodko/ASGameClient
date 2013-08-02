/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 27.12.12
 * Time: 20:23
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.engine.network {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.system.Security;

import org.volodko.engine.GLB;
import org.volodko.engine.GroupsVO;

import org.volodko.engine.Module;
import org.volodko.engine.MsgVO;

public class NetworkSync extends Module {

    private var server:String;
    private var port:uint;
    private var socket:Socket;

    public function NetworkSync(server:String, port:uint) {
        this.server = server;
        this.port = port;
        super();
        init();
    }

    private function init():void {
        register(signalListener, GroupsVO.NETWORK);
        connect();
    }

    public function connect():Boolean {
        Security.allowDomain("*");
        Security.loadPolicyFile("xmlsocket://" + server + ":" + int(port + 1));
        //
        this.socket = new Socket();
        this.socket.addEventListener(Event.CONNECT, socketConnect);
        this.socket.addEventListener(Event.CLOSE, socketClose);
        this.socket.addEventListener(IOErrorEvent.IO_ERROR, socketError);
        this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
        this.socket.addEventListener(ProgressEvent.SOCKET_DATA, socketData);

        try {
            this.socket.connect(server, port);
        }
        catch (e:Error) {
            trace("Error on connect: " + e);
            CONFIG::debug {
                GLB.signals.dispatchSignal(MsgVO.LOG, "Error on connect: " + e, GroupsVO.DEBUG);
            }
            return false;
        }

        return true;
    }

    public function sendMessage(msg:String):void {
        if(!socket.connected) {
            trace("Socket not connected, cannot sendMessage");
            CONFIG::debug {
                GLB.signals.dispatchSignal(MsgVO.LOG, "Socket not connected, cannot sendMessage", GroupsVO.DEBUG);
            }
            return;
        }
        try {
            this.socket.writeUTFBytes(msg + "\n");
            this.socket.flush();
            trace("Message sent: " + msg);
            CONFIG::debug {
                GLB.signals.dispatchSignal(MsgVO.LOG, "Message sent: " + msg, GroupsVO.DEBUG);
            }
        }
        catch(e:Error) {
            trace("Error sending data: " + e);
        }
    }

    private function socketConnect(event:Event):void {
        trace("Connected: " + event);
        CONFIG::debug {
            GLB.signals.dispatchSignal(MsgVO.LOG, "Connected: " + event, GroupsVO.DEBUG);
        }
        //sendMessage("");
        GLB.signals.dispatch(NetMsgVO.CONNECTED, null, GroupsVO.NETWORK);
    }

    private function socketData(event:ProgressEvent):void {
        var dataStr:String = this.socket.readUTFBytes(this.socket.bytesAvailable);
        var dataObj:Object = JSON.parse(dataStr);
        trace("Receiving data: " + dataStr);
        CONFIG::debug {
            GLB.signals.dispatchSignal(MsgVO.LOG, "Receiving data: " + dataStr, GroupsVO.DEBUG);
        }
        if(!dataObj.error) {
            GLB.signals.dispatch(NetMsgVO.DATA_RECEIVE, dataObj, GroupsVO.NETWORK);
        } else {
            //TODO Errors check
        }
    }

    private function socketClose(event:Event):void {
        trace("Connection closed: " + event);
        trace("Connection lost." + "\n");
        CONFIG::debug {
            GLB.signals.dispatchSignal(MsgVO.LOG, "Connection closed: " + event, GroupsVO.DEBUG);
        }
    }

    private function socketError(event:IOErrorEvent):void {
        trace("Socket error: " + event);
        CONFIG::debug {
            GLB.signals.dispatchSignal(MsgVO.LOG, "Socket error: " + event, GroupsVO.DEBUG);
        }
    }

    private function securityError(event:SecurityErrorEvent):void {
        trace("Security error: " + event);
        CONFIG::debug {
            GLB.signals.dispatchSignal(MsgVO.LOG, "Security error: " + event, GroupsVO.DEBUG);
        }
    }

    private function signalListener(msg:String, data:Object):void {
        switch(msg) {
            case NetMsgVO.DATA_SEND:
                sendMessage(JSON.stringify(data));
                break;
        }
    }

}
}
