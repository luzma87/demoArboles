
<%@ page import="demoArboles.Persona" %>

<g:if test="${!personaInstance}">
    <elm:message tipo="notFound" contenido="No se encontró el Persona solicitado" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${personaInstance?.nombre}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Nombre
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="nombre"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${personaInstance?.apellido}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Apellido
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="apellido"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${personaInstance?.login}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Login
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="login"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${personaInstance?.estaActivo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Esta Activo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="estaActivo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${personaInstance?.unidad}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Unidad
                </div>
                
                <div class="col-md-4">
                    ${personaInstance?.unidad?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${personaInstance?.cargo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Cargo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${personaInstance}" field="cargo"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>