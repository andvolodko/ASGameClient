/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 19.01.13
 * Time: 18:49
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.engine.social.vk {
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

import org.volodko.engine.GLB;
import org.volodko.engine.Module;

public class VkontakteAPI extends Module {

    public var access_token:String;
    public var viewer_id:int;
    public var first_name:String;
    public var last_name:String;
    private var onInit:Function;

    public function VkontakteAPI(onInit:Function)  {
        this.onInit = onInit;
        super();
        init();
    }

    private function init():void {
        var params:Object = GLB.stage.loaderInfo.parameters;
        var api_id:int = params["api_id"];
        var api_secret:String = params["secret"];
        access_token = params["access_token"];
        viewer_id = params["viewer_id"];
        //getUserInfo();
    }

    private function getUserInfo():void {
        query("users.get", "uids="+viewer_id, getUserInfoCallback);
    }

    private function getUserInfoCallback(data:Object):void {
        first_name = data[0]["first_name"];
        last_name = data[0]["last_name"];
        if(onInit != null) onInit();
    }

    private function query(method:String, params:String, callback:Function):void {
    var request:URLRequest = new URLRequest();
    request.url = "https://api.vk.com/method/"+ method + "?"+params+"&access_token=" + access_token;
    //request.method = urlRequestMethod;

    var loader:URLLoader = new URLLoader();
    loader.dataFormat = URLLoaderDataFormat.TEXT;
    loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
    loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
    loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);

    var completeFunction:Function = function (e:Event):void {
        loader.removeEventListener(Event.COMPLETE, completeFunction);
        loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        var resp:Object = String(e.target.data);
        resp = JSON.parse(String(resp));
        if(resp.error) {
            trace("ERROR: "+resp.error);
        } else {
            if(callback != null) callback(resp.response);
        }
    };

    loader.addEventListener(Event.COMPLETE, completeFunction, false, 0, true);

    try {
        loader.load(request);
    }
    catch (error:Error) {
        trace("Unable to load URL");
    }
    //
    }


    private function httpStatusHandler(e:Event):void {
        trace("httpStatusHandler:" + e);
    }

    private function securityErrorHandler(e:Event):void {
        trace("securityErrorHandler:" + e);
    }

    private function ioErrorHandler(e:Event):void {
        trace("ioErrorHandler: " + e);
        trace("ioError Data: " + e.target.data);
    }

}
}
