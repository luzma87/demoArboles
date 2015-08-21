<%@ page import="demoArboles.UnidadEjecutora" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!unidadEjecutoraInstance}">
    <elm:message tipo="notFound" contenido="No se encontró el UnidadEjecutora solicitado" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmUnidadEjecutora" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${unidadEjecutoraInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'tipoInstitucion', 'error')} required">
            <span class="grupo">
                <label for="tipoInstitucion" class="col-md-2 control-label">
                    Tipo Institucion
                </label>
                <div class="col-md-6">
                    <g:select id="tipoInstitucion" name="tipoInstitucion.id" from="${demoArboles.TipoInstitucion.list()}" optionKey="id" required="" value="${unidadEjecutoraInstance?.tipoInstitucion?.id}" class="many-to-one form-control input-sm"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="6" class="form-control input-sm unique noEspacios" value="${unidadEjecutoraInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'padre', 'error')} ">
            <span class="grupo">
                <label for="padre" class="col-md-2 control-label">
                    Padre
                </label>
                <div class="col-md-6">
                    <g:select id="padre" name="padre.id" from="${demoArboles.UnidadEjecutora.list()}" optionKey="id" value="${unidadEjecutoraInstance?.padre?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: unidadEjecutoraInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" maxlength="127" required="" class="form-control input-sm required" value="${unidadEjecutoraInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmUnidadEjecutora").validate({
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
                
                codigo: {
                    remote: {
                        url: "${createLink(controller: 'UnidadEjecutora', action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${unidadEjecutoraInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                codigo: {
                    remote: "Ya existe Codigo"
                }
                
            }
            
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormUnidadEjecutora();
                return false;
            }
            return true;
        });
    </script>

</g:else>