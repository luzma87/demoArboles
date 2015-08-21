
<%@ page import="demoArboles.TipoInstitucion" %>

<g:if test="${!tipoInstitucionInstance}">
    <elm:message tipo="notFound" contenido="No se encontró el TipoInstitucion solicitado" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${tipoInstitucionInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoInstitucionInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${tipoInstitucionInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoInstitucionInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>