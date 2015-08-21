<%@ page import="demoArboles.Persona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!personaInstance}">
    <elm:message tipo="notFound" contenido="No se encontró el Persona solicitado" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmPersona" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${personaInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" maxlength="40" pattern="${personaInstance.constraints.nombre.matches}" required="" class="form-control input-sm required" value="${personaInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'apellido', 'error')} required">
            <span class="grupo">
                <label for="apellido" class="col-md-2 control-label">
                    Apellido
                </label>
                <div class="col-md-6">
                    <g:textField name="apellido" maxlength="40" pattern="${personaInstance.constraints.apellido.matches}" required="" class="form-control input-sm required" value="${personaInstance?.apellido}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'login', 'error')} ">
            <span class="grupo">
                <label for="login" class="col-md-2 control-label">
                    Login
                </label>
                <div class="col-md-6">
                    <g:textField name="login" maxlength="15" pattern="${personaInstance.constraints.login.matches}" class="form-control input-sm unique noEspacios" value="${personaInstance?.login}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'password', 'error')} ">
            <span class="grupo">
                <label for="password" class="col-md-2 control-label">
                    Password
                </label>
                <div class="col-md-6">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-lock"></i></span><g:field type="password" name="password" maxlength="64" pattern="${personaInstance.constraints.password.matches}" class="form-control input-sm" value="${personaInstance?.password}"/></div>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'estaActivo', 'error')} required">
            <span class="grupo">
                <label for="estaActivo" class="col-md-2 control-label">
                    Esta Activo
                </label>
                <div class="col-md-2">
                    <g:select name="estaActivo" from="${personaInstance.constraints.estaActivo.inList}" required="" class="inList form-control input-sm required" value="${fieldValue(bean: personaInstance, field: 'estaActivo')}" valueMessagePrefix="persona.estaActivo"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'unidad', 'error')} ">
            <span class="grupo">
                <label for="unidad" class="col-md-2 control-label">
                    Unidad
                </label>
                <div class="col-md-6">
                    <g:select id="unidad" name="unidad.id" from="${demoArboles.UnidadEjecutora.list()}" optionKey="id" value="${personaInstance?.unidad?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cargo', 'error')} ">
            <span class="grupo">
                <label for="cargo" class="col-md-2 control-label">
                    Cargo
                </label>
                <div class="col-md-6">
                    <g:textArea name="cargo" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${personaInstance?.cargo}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmPersona").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }
            
            , rules          : {
                
                login: {
                    remote: {
                        url: "${createLink(controller: 'Persona', action: 'validar_unique_login_ajax')}",
                        type: "post",
                        data: {
                            id: "${personaInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                login: {
                    remote: "Ya existe Login"
                }
                
            }
            
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormPersona();
                return false;
            }
            return true;
        });
    </script>

</g:else>