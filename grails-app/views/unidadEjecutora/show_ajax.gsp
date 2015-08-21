
<%@ page import="demoArboles.UnidadEjecutora" %>

<g:if test="${!unidadEjecutoraInstance}">
    <elm:message tipo="notFound" contenido="No se encontró el UnidadEjecutora solicitado" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${unidadEjecutoraInstance?.tipoInstitucion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo Institucion
                </div>
                
                <div class="col-md-4">
                    ${unidadEjecutoraInstance?.tipoInstitucion?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${unidadEjecutoraInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${unidadEjecutoraInstance?.padre}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Padre
                </div>
                
                <div class="col-md-4">
                    ${unidadEjecutoraInstance?.padre?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${unidadEjecutoraInstance?.nombre}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Nombre
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>