
<%@ page import="janus.SubPresupuesto" %>

<div id="show-subPresupuesto" class="span6" role="main">

    <form class="form-horizontal">
    
    <g:if test="${subPresupuestoInstance?.tipo}">
        <div class="control-group">
            <div>
                <span id="tipo-label" class="control-label label label-inverse">
                    Tipo
                </span>
            </div>
            <div class="controls">
        
                <span aria-labelledby="tipo-label">
                    <g:fieldValue bean="${subPresupuestoInstance}" field="tipo"/>
                </span>
        
            </div>
        </div>
    </g:if>
    
    <g:if test="${subPresupuestoInstance?.descripcion}">
        <div class="control-group span4">
            <div>
                <span id="descripcion-label" class="control-label label label-inverse span1">
                    Descripcion
                </span>
            </div>
            <div class="controls">
        
                <span aria-labelledby="descripcion-label span3">
                    <g:fieldValue bean="${subPresupuestoInstance}" field="descripcion"/>
                </span>
        
            </div>
        </div>
    </g:if>
    
    </form>
</div>
