/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 07.01.13
 * Time: 1:13
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.engine.network {
public class NetMsgVO {

    public static const CONNECTED:String = "CONNECTED";
    //
    public static const LOGIN:String = "LOGIN";
    public static const DATA_RECEIVE:String = "DATA_RECEIVE";
    public static const DATA_SEND:String = "DATA_SEND";
    //Commands to server
    public static const CMD_LOGIN:String = "login";
    public static const CMD_UPDATE_ENTITIES:String = "ue";
    public static const CMD_ADD_ENTITY:String = "ae";
    public static const CMD_MOVE_ENTITY:String = "me";
    public static const CMD_ATTACK_ENTITY:String = "ate";
    public static const CMD_REMOVE_ENTITY:String = "re";
    //Responses from server
    public static const RESPONSE_OK:String = "ok";

    //For entites
    public static const UID_UPDATE:String = "UID_UPDATE";

    public function NetMsgVO() {
    }
}
}
