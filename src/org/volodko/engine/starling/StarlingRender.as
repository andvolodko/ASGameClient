/**
 * Created by IntelliJ IDEA.
 * User: Andrey
 * Date: 27.12.12
 * Time: 22:20
 * To change this template use File | Settings | File Templates.
 */
package org.volodko.engine.starling {
import org.volodko.engine.Component;
import org.volodko.engine.Entity;

public class StarlingRender extends Component {

    private var sortIndex:int;

    public function StarlingRender(entityLoc:Entity, sortIndex:int) {
        this.sortIndex = sortIndex;
        super(entityLoc);
    }
}
}
