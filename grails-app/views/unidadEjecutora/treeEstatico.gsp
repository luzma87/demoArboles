<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 20/08/15
  Time: 12:54 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">

        <script src="${resource(dir: 'js/plugins/jstree-3.2.0/dist', file: 'jstree.min.js')}"></script>
        <link href="${resource(dir: 'js/plugins/jstree-3.2.0/dist/themes/default', file: 'style.min.css')}" rel="stylesheet">

        <script src="${resource(dir: 'js/plugins/syntaxhighlighter_3.0.83/scripts', file: 'shCore.js')}"></script>
        <script src="${resource(dir: 'js/plugins/syntaxhighlighter_3.0.83/scripts', file: 'shBrushGroovy.js')}"></script>
        <script src="${resource(dir: 'js/plugins/syntaxhighlighter_3.0.83/scripts', file: 'shBrushJScript.js')}"></script>
        <script src="${resource(dir: 'js/plugins/syntaxhighlighter_3.0.83/scripts', file: 'shBrushXml.js')}"></script>
        <script src="${resource(dir: 'js/plugins/syntaxhighlighter_3.0.83/scripts', file: 'shBrushCss.js')}"></script>

        <link href="${resource(dir: 'js/plugins/syntaxhighlighter_3.0.83/styles', file: 'shCore.css')}" rel="stylesheet">
        <link href="${resource(dir: 'js/plugins/syntaxhighlighter_3.0.83/styles', file: 'shThemeMidnight.css')}" rel="stylesheet">

        <title>Árboles</title>

        <style type="text/css">
            #divInfo {
                max-height : 330px;
                overflow   : auto;
            }

            #jstree {
                margin-bottom : 50px;
                max-height    : 500px;
                overflow      : auto;
            }

            .jstree-search {
                color       : #000 !important;
                font-weight : normal !important;
                font-style  : italic !important;
                background  : #f7ea57 !important;
            }

            .jstree-search.jstree-clicked {
                font-weight : bold !important;
            }
        </style>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="unidadEjecutora" action="tree" class="btn btn-default">
                    <i class="fa fa-sitemap"></i> Árboles
                </g:link>
                <g:link controller="unidadEjecutora" action="index" class="btn btn-default">
                    <i class="fa fa-building"></i> Unidades ejecutoras
                </g:link>
                <g:link controller="persona" action="index" class="btn btn-default">
                    <i class="fa fa-users"></i> Personas
                </g:link>
            </div>
        </div>

        <div class="well" id="divInfo">
            <h4>JsTree estático</h4>
            <p>
                El árbol se carga todo de una sola vez, se puede seleccionar que nodos comienzan abiertos, la búsqueda es local (js).
            </p>

            <p>
                Se puede ocultar el contenedor del árbol mientras éste se carga y mostrarlo únicamente cuando el árbol termine de generarse.
                Para esto se utiliza el evento <code>loaded.jstree</code>
            </p>

            <p>
                Para tener tipos de nodos con íconos diferentes se utiliza el plugin <code>types</code>. A continuación se configuran los tipos con su ícono correspondiente.
            Cada nodo debe tener un tipo especificado, sino toma el ícono del tipo <code>default</code>
                (<code>&lt;li data-jstree="{'type'='usuario'}"&gt;Nodo de tipo usuario&lt;/li&gt;</code>).
            </p>

            <p>
                Para que el árbol mantenga su estado entre recargas se utiliza el plugin <code>state</code>.
            Si se usan varios árboles se debe cambiar la opción <code>key</code> para que tengan estado independientes.
            </p>

            <p>
                Para el click derecho se utiliza el plugin <code>contextmenu</code>, con la función <code>createContextMenu</code> para generar opciones
            diferentes según el estado, tipo u otras opciones definidas en cada nodo. Esta función recibe como parámetro el nodo en el cual se hizo click y debe retornar
            los ítems que se van a mostrar en el menú.
            </p>

            <p>
                Para la búsqueda se utiliza el plugin <code>search</code>. A continuación se utiliza el método <code>$("#jstree").jstree(true).search("texto a buscar");</code>
                para realizar la búsqueda. Se puede ejecutar código una vez terminada la búsqueda utilizando el evento <code>search.jstree</code>
            </p>

            <p>
                Código completo del ejemplo a continuación:
            </p>

            <p>Groovy</p>
            <pre class="brush: groovy">
def treeEstatico() {
    def html = "&lt;ul&gt;"
    def type = "root"       // tipo de nodo: para el ícono
    def opened = true       // marca el nodo como abierto (true) o cerrado (false)
    def selected = false    // marca el nodo como seleccionado (true) o no (false)
    def disabled = false    // marca el nodo como desabilitado (true) o no (false).
                            // Cuando está deshabilitado no se puede hacer click ni seleccionar
    def id = "root"

    def dataJstree = "\"opened\": &dollar;opened, \"selected\": &dollar;selected, \"disabled\": &dollar;disabled, \"type\": \"&dollar;type\""
    html += "&lt;li id='&dollar;id' data-jstree='{&dollar;dataJstree}'&gt;"
    html += "Unidades ejecutoras y usuarios"
    html += "&lt;ul&gt;"
    UnidadEjecutora.findAllByPadreIsNull([sort: 'nombre']).each { ue -&gt;
        html += makeTreeEstatico(ue)
    }
    def prsn = Persona.findAllByUnidadIsNull()
    if (prsn.size() &gt; 0) {
        type = "sinUnidad"
        opened = false
        selected = false
        disabled = false
        id = "noUE"

        dataJstree = "\"opened\": &dollar;opened, \"selected\": &dollar;selected, \"disabled\": &dollar;disabled, \"type\": \"&dollar;type\""
        html += "&lt;li id='&dollar;id' data-jstree='{&dollar;dataJstree}'&gt;"
        html += "Usuarios sin unidad ejecutora"
        html += "&lt;ul&gt;"
        prsn.each { usu -&gt;
            type = "usuario"
            if (usu.esDirector) {
                type = "director"
            } else if (usu.esJefe) {
                type = "jefe"
            }
            selected = false
            disabled = false
            id = "usu_" + usu.id

            dataJstree = "\"selected\": &dollar;selected, \"disabled\": &dollar;disabled, \"type\": \"&dollar;type\""
            html += "&lt;li id='&dollar;id' data-jstree='{&dollar;dataJstree}'&gt;"
            html += usu.labelArbol
            html += "&lt;/li&gt;"
        }
        html += "&lt;/ul&gt;"
    }
    html += "&lt;/ul&gt;"
    html += "&lt;/li&gt;"
    html += "&lt;/ul&gt;"
    return [tree: html]
}

/**
  * Función recursiva que genera el árbol completo, con unidades y usuarios
  */
private String makeTreeEstatico(UnidadEjecutora ue) {
    def html = ""

    def unidadesHijas = UnidadEjecutora.findAllByPadre(ue, [sort: 'nombre'])
    def usuarios = Persona.findAllByUnidad(ue, [sort: 'apellido'])

    def abiertos = ["343", "AI", "9999", "GGGGG"]
    def seleccionado = "343"

    def type = "u_" + ue.tipoInstitucion.codigo
    def opened = false
    def selected = false
    def disabled = false
    def id = "ue_" + ue.id
    if (abiertos.contains(ue.codigo)) {
        opened = true
    }
    if (seleccionado == ue.codigo) {
        selected = true
    }
    def clase = ""
    if (unidadesHijas.size() &gt; 0 || usuarios.size() &gt; 0) {
        clase += " tieneHijos"
    }

    def dataJstree = "\"opened\": &dollar;opened, \"selected\": &dollar;selected, \"disabled\": &dollar;disabled, \"type\": \"&dollar;type\""
    html += "&lt;li id='&dollar;id' class='&dollar;clase' data-jstree='{&dollar;dataJstree}'&gt;"
    html += ue.labelArbol
    if (unidadesHijas.size() &gt; 0 || usuarios.size() &gt; 0) {
        html += "&lt;ul&gt;"
        unidadesHijas.each { hijo -&gt;
            html += makeTreeEstatico(hijo)
        }
        usuarios.each { usu -&gt;
            type = "usuario"
            if (usu.esDirector) {
                type = "director"
            } else if (usu.esJefe) {
                type = "jefe"
            }
            selected = false
            disabled = false
            id = "usu_" + usu.id
            dataJstree = "\"selected\": &dollar;selected, \"disabled\": &dollar;disabled, \"type\": \"&dollar;type\""
            html += "&lt;li id='&dollar;id' data-jstree='{&dollar;dataJstree}'&gt;"
            html += usu.labelArbol
            html += "&lt;/li&gt;"
        }
        html += "&lt;/ul&gt;"
    }
    html += "&lt;/li&gt;"
    return html
}
            </pre>

            <p>Imports necesarios</p>
            <pre class="brush:html">
&lt;script src="&dollar;{resource(dir: 'js/plugins/jstree-3.2.0/dist', file: 'jstree.min.js')}"&gt;&lt;/script&gt;
&lt;link href="&dollar;{resource(dir: 'js/plugins/jstree-3.2.0/dist/themes/default', file: 'style.min.css')}" rel="stylesheet"&gt;
            </pre>

            <p>CSS</p>
            <pre class="brush: css">
/* contenedor del árbol. Tiene un max height y overflow auto para que la búsqueda pueda hacer scroll. Si se quita esto
 * se debe modificar el código de la búsqueda para que haga scroll el body
 */
#jstree {
    margin-bottom : 50px;
    max-height    : 500px;
    overflow      : auto;
}

/* la clase para los resultados de la búsqueda */
.jstree-search {
    color       : #000 !important;
    font-weight : normal !important;
    font-style  : italic !important;
    background  : #f7ea57 !important;
}

/* la clase para el resultado seleccionado de la búsqueda (puede ser con click del mouse o con los botones de
 * selección de resultado de búsqeda
 */
.jstree-search.jstree-clicked {
    font-weight : bold !important;
}
            </pre>

            <p>HTML</p>
            <pre class="brush: html">
&lt;!-- Barra para búsqueda, resultado y leyenda --&gt;
&lt;div class="row" style="margin-bottom: 10px;"&gt;
    &lt;div class="col-md-2"&gt;
        &lt;div class="input-group input-group-sm"&gt;
            &lt;g:textField name="txtSearchArbol" class="form-control input-sm" placeholder="Buscador"/&gt;
            &lt;span class="input-group-btn"&gt;
                &lt;a href="#" id="btnSearchArbol" class="btn btn-sm btn-info"&gt;
                    &lt;i class="fa fa-search"&gt;&lt;/i&gt;&nbsp;
                &lt;/a&gt;
            &lt;/span&gt;
        &lt;/div&gt;
    &lt;/div&gt;

    &lt;div class="col-md-3 hidden" id="divSearchRes"&gt;
        &lt;span id="spanSearchRes"&gt;
            n resultados
        &lt;/span&gt;

        &lt;div class="btn-group"&gt;
            &lt;a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente"&gt;
                &lt;i class="fa fa-chevron-down"&gt;&lt;/i&gt;&nbsp;
            &lt;/a&gt;
            &lt;a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior"&gt;
                &lt;i class="fa fa-chevron-up"&gt;&lt;/i&gt;&nbsp;
            &lt;/a&gt;
            &lt;a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda"&gt;
                &lt;i class="fa fa-close"&gt;&lt;/i&gt;&nbsp;
            &lt;/a&gt;
        &lt;/div&gt;
    &lt;/div&gt;

    &lt;div class="col-md-1"&gt;
        &lt;div class="btn-group"&gt;
            &lt;a href="#" class="btn btn-xs btn-default" id="btnCollapseAll" title="Cerrar todos los nodos"&gt;
                &lt;i class="fa fa-minus-square-o"&gt;&lt;/i&gt;&nbsp;
            &lt;/a&gt;
            &lt;a href="#" class="btn btn-xs btn-default" id="btnExpandAll" title="Abrir todos los nodos"&gt;
                &lt;i class="fa fa-plus-square"&gt;&lt;/i&gt;&nbsp;
            &lt;/a&gt;
        &lt;/div&gt;
    &lt;/div&gt;

    &lt;div class="col-md-4 text-right pull-right"&gt;
        &lt;i class="fa fa-user text-info"&gt;&lt;/i&gt; Usuario
        &lt;i class="fa fa-user-secret text-warning"&gt;&lt;/i&gt; Director
        &lt;i class="fa fa-user-secret text-danger"&gt;&lt;/i&gt; Gerente
    &lt;/div&gt;
&lt;/div&gt;

&lt;div id="loading"&gt;
    &lt;h2&gt;
        &lt;i class="fa fa-spinner fa-2x fa-pulse"&gt;&lt;/i&gt;
        Cargando... Por favor espere
    &lt;/h2&gt;
&lt;/div&gt;

&lt;div id="jstree" class="hidden"&gt;
    &dollar;{raw(tree)}
&lt;/div&gt;</pre>

            <p>Javascript</p>
            <pre class="brush: js">
var searchRes = [];                 //para guardar los resultados de la búsqueda
var posSearchShow = 0;              //para guardar la posición seleccionada actualmente
var $treeContainer = $('#jstree');  //el contenedor de árbol

/**
  * Función para crear/editar unidades: debe cargar el formulario correcto con ajax y
  * guardar los datos con el botón guardar.
  * Refrescar la página para mostrar los cambios en el árbol.
  */
function createEditUnidad(id) {
    var title = id ? "Editar" : "Crear";
    var b = bootbox.dialog({
        id      : "dlgCreateEditUnidad",
        title   : title + " Unidad Ejecutora",
        class   : "modal-lg",
        message : "Aquí va el formulario para crear/editar la unidad ejecutora",
        buttons : {
            cancelar : {
                label     : "Cancelar",
                className : "btn-primary",
                callback  : function () {
                }
            }, //cancelar
            guardar  : {
                id        : "btnSave",
                label     : "&lt;i class='fa fa-save'&gt;&lt;/i&gt; Guardar",
                className : "btn-success",
                callback  : function () {
                } //callback
            } //guardar
        } //buttons
    }); //dialog
    setTimeout(function () {
        b.find(".form-control").first().focus(); //selecciona el primer input
    }, 500);
}

/**
  * Función para eliminar unidades: después de la confirmación elimina la unidad correspondiente.
  * Refrescar la página para mostrar los cambios en el árbol.
  */
function deleteUnidad(id) {
    bootbox.confirm("¿Está seguro de querer eliminar esta unidad ejecutora? Esta acción no se puede deshacer.",
        function (res) {
            if (res) {
                bootbox.alert("Aqui elimina la ue");
            }
    });
}

/**
  * Función para crear/editar usuarios: debe cargar el formulario correcto con ajax y
  * guardar los datos con el botón guardar.
  * Refrescar la página para mostrar los cambios en el árbol.
  */
function createEditUsuario(id) {
    var title = id ? "Editar" : "Crear";
    var b = bootbox.dialog({
        id      : "dlgCreateEditUsuario",
        title   : title + " Usuario",
        class   : "modal-lg",
        message : "Aquí va el formulario para crear/editar el usuario",
        buttons : {
            cancelar : {
                label     : "Cancelar",
                className : "btn-primary",
                callback  : function () {
                }
            },
            guardar  : {
                id        : "btnSave",
                label     : "&lt;i class='fa fa-save'&gt;&lt;/i&gt; Guardar",
                className : "btn-success",
                callback  : function () {
                } //callback
            } //guardar
        } //buttons
    }); //dialog
    setTimeout(function () {
        b.find(".form-control").first().focus()
    }, 500);
}

/**
  * Función para eliminar usuarios: después de la confirmación elimina el usuario correspondiente.
  * Refrescar la página para mostrar los cambios en el árbol.
  */
function deleteUsuario(id) {
    bootbox.confirm("¿Está seguro de querer eliminar este usuario? Esta acción no se puede deshacer.",
        function (res) {
            if (res) {
                bootbox.alert("Aqui elimina el usuario");
            }
    });
}

/**
  * Función que ejecuta la búsqueda en el árbol.
  */
function searchArbol() {
    var v = $.trim($('#txtSearchArbol').val());
    $treeContainer.jstree(true).search(v);
}

/**
  * Función que mueve la barra de scroll para mostrar un nodo en particular
  */
function scrollToNode($scrollTo) {
    $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
    scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
    });
}

/**
  * Función que mueve la barra de scroll para mostrar el nodo root
  */
function scrollToRoot() {
    var $scrollTo = $("#root");
    scrollToNode($scrollTo);
}

/**
  * Función que mueve la barra de scroll para mostrar el nodo correspondiente de la búsqueda
  */
function scrollToSearchRes() {
    var $scrollTo = $(searchRes[posSearchShow]);
    $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
    scrollToNode($scrollTo);
}

/**
  * Función que crea el menú contextual para cada nodo
  */
function createContextMenu(node) {
    var nodeStrId = node.id;                    //el id del nodo (ej. usu_15)
    var $node = $("#" + nodeStrId);             //el objeto jQuery del nodo
    var nodeId = nodeStrId.split("_")[1];       //el id del objeto que representa el nodo (ej. 15)
    var nodeType = $node.data("jstree").type;   //el tipo de nodo

    var nodeText = $node.children("a").first().text();  //el texto del nodo

    // Diferentes características del nodo según el tipo o la clase que tiene
    var esRoot = nodeType == "root";
    var esUnidad = nodeType.startsWith("u_");
    var esUsuario = nodeType == "usuario";
    var esJefe = nodeType == "jefe";
    var esDirector = nodeType == "director";

    var tieneHijos = $node.hasClass("tieneHijos");

    // los ítems que se van a mostrar para este nodo
    var items = {};

    var crearUnidad = {
        label  : "Crear Unidad Ejecutora",
        icon   : "fa fa-home text-success",
        action : function () {
            createEditUnidad(null, nodeId);
        }
    };
    var editarUnidad = {
        label  : "Editar Unidad Ejecutora",
        icon   : "fa fa-home text-info",
        action : function () {
            createEditUnidad(nodeId, null);
        }
    };
    var eliminarUnidad = {
        label  : "Eliminar Unidad Ejecutora",
        icon   : "fa fa-home text-danger",
        action : function () {
            deleteUnidad(nodeId);
        }
    };

    var crearUsu = {
        label  : "Crear Usuario",
        icon   : "fa fa-user text-success",
        action : function () {
            createEditUsuario(null, nodeId);
        }
    };
    var editarUsu = {
        label  : "Editar Usuario",
        icon   : "fa fa-user text-info",
        action : function () {
            createEditUsuario(nodeId, null);
        }
    };
    var eliminarUsu = {
        label  : "Eliminar Usuario",
        icon   : "fa fa-user text-danger",
        action : function () {
            deleteUsuario(null, nodeId);
        }
    };

    if (esRoot) {
        items.crearUnidad = crearUnidad;
    }
    if (esUnidad) {
        items.crearUnidad = crearUnidad;
        items.editarUnidad = editarUnidad;
        if (!tieneHijos) {
            items.eliminarUnidad = eliminarUnidad;
        }
        crearUsu.separator_before = true;
        items.crearUsu = crearUsu;
    }
    if (esUsuario || esJefe || esDirector) {
        items.crearUsu = crearUsu;
        items.editarUsu = editarUsu;
        eliminarUsu.separator_before = true;
        items.eliminarUsu = eliminarUsu;
    }

    return items;
}

$(function () {
    $treeContainer.on("loaded.jstree", function () {
        // cuando termina de cargar el árbol oculta el div 'loading' y muestra el contenedor del árbol
        $("#loading").hide();
        $treeContainer.removeClass("hidden");
    }).on("search.jstree", function (event, res) {
        // cuando se ejecuta la búsqueda guarda en las varialbes correspondientes los nodos resultado
        // y la cantidad; selecciona el 1r resultado
        searchRes = res.nodes;
        var cantRes = searchRes.length;
        posSearchShow = 0;
        $("#divSearchRes").removeClass("hidden");
        $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
        scrollToSearchRes();
    }).jstree({
        plugins     : ["state", "types", "contextmenu", "search"],
        core        : {
            multiple : false,      //no permite seleccionar más de un nodo a la vez
            themes   : {
                variant : "small", //hace q el árbol sea más compacto
                dots    : true,    //muestra los puntos
                stripes : true     //muestra bandas de colores
            }
        },
        state       : {
            key : "arbol1"
        },
        contextmenu : {
            show_at_node : false,               // muestra el menú donde se hizo click,
                                                // no alineado a la izquierda con el ícono
            items        : createContextMenu
        },
        search      : {},
        types       : {
            'default'   : {
                icon : "fa fa-folder-open"
            },
            'usuario'   : {
                icon : "fa fa-user text-info"
            },
            'jefe'      : {
                icon : "fa fa-user-secret text-danger"
            },
            'director'  : {
                icon : "fa fa-user-secret text-warning"
            },
            'sinUnidad' : {
                icon : "fa fa-folder"
            },
            'u_1'       : {
                icon : 'fa fa-hospital-o'
            },
            'u_2'       : {
                icon : 'fa fa-building'
            },
            'u_3'       : {
                icon : 'fa fa-building-o'
            },
            'u_4'       : {
                icon : 'fa fa-home'
            }
        }
    });

    $("#btnExpandAll").click(function () {
        // expande todos los nodos
        $treeContainer.jstree("open_all");
        scrollToRoot();
        return false;
    });

    $("#btnCollapseAll").click(function () {
        // contrae todos los nodos
        $treeContainer.jstree("close_all");
        scrollToRoot();
        return false;
    });

    $("#btnSearchArbol").click(function () {
        searchArbol();
        return false;
    });

    $("#txtSearchArbol").keyup(function (ev) {
        if (ev.keyCode == 13) {
            searchArbol();
        }
    });

    $("#btnPrevSearch").click(function () {
        // navega al resultado anterior de la búsqueda
        if (posSearchShow &gt; 0) {
            posSearchShow--;
        } else {
            posSearchShow = searchRes.length - 1;
        }
        scrollToSearchRes();
        return false;
    });

    $("#btnNextSearch").click(function () {
        // navega al siguiente resultado de la búsqueda
        if (posSearchShow &lt; searchRes.length - 1) {
            posSearchShow++;
        } else {
            posSearchShow = 0;
        }
        scrollToSearchRes();
        return false;
    });

    $("#btnClearSearch").click(function () {
        // borra los resultados de la búsqueda y devuleve el árbol a su estado anterior
        $treeContainer.jstree("clear_search");
        $("#txtSearchArbol").val("");
        posSearchShow = 0;
        searchRes = [];
        scrollToRoot();
        $("#divSearchRes").addClass("hidden");
        $("#spanSearchRes").text("");
    });
});</pre>
        </div>

        <div class="row" style="margin-bottom: 10px;">
            <div class="col-md-2">
                <div class="input-group input-group-sm">
                    <g:textField name="txtSearchArbol" class="form-control input-sm" placeholder="Buscador"/>
                    <span class="input-group-btn">
                        <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                            <i class="fa fa-search"></i>&nbsp;
                        </a>
                    </span>
                </div><!-- /input-group -->
            </div>

            <div class="col-md-3 hidden" id="divSearchRes">
                <span id="spanSearchRes">
                    n resultados
                </span>

                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente">
                        <i class="fa fa-chevron-down"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior">
                        <i class="fa fa-chevron-up"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda">
                        <i class="fa fa-close"></i>&nbsp;
                    </a>
                </div>
            </div>

            <div class="col-md-1">
                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnCollapseAll" title="Cerrar todos los nodos">
                        <i class="fa fa-minus-square-o"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnExpandAll" title="Abrir todos los nodos">
                        <i class="fa fa-plus-square"></i>&nbsp;
                    </a>
                </div>
            </div>

            <div class="col-md-4 text-right pull-right">
                <i class="fa fa-user text-info"></i> Usuario
                <i class="fa fa-user-secret text-warning"></i> Director
                <i class="fa fa-user-secret text-danger"></i> Gerente
            </div>
        </div>

        <div id="loading">
            <h2>
                <i class="fa fa-spinner fa-2x fa-pulse"></i>
                Cargando... Por favor espere
            </h2>
        </div>

        <div id="jstree" class="hidden">
            ${raw(tree)}
        </div>

        <script type="text/javascript">
            var searchRes = [];
            var posSearchShow = 0;
            var $treeContainer = $('#jstree');

            function createEditUnidad(id) {
                var title = id ? "Editar" : "Crear";
                var b = bootbox.dialog({
                    id      : "dlgCreateEditUnidad",
                    title   : title + " Unidad Ejecutora",
                    class   : "modal-lg",
                    message : "Aquí va el formulario para crear/editar la unidad ejecutora",
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            }

            function deleteUnidad(id) {
                bootbox.confirm("¿Está seguro de querer eliminar esta unidad ejecutora? Esta acción no se puede deshacer.", function (res) {
                    if (res) {
                        bootbox.alert("Aqui elimina la ue");
                    }
                });
            }

            function createEditUsuario(id) {
                var title = id ? "Editar" : "Crear";
                var b = bootbox.dialog({
                    id      : "dlgCreateEditUsuario",
                    title   : title + " Usuario",
                    class   : "modal-lg",
                    message : "Aquí va el formulario para crear/editar el usuario",
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            }

            function deleteUsuario(id) {
                bootbox.confirm("¿Está seguro de querer eliminar este usuario? Esta acción no se puede deshacer.", function (res) {
                    if (res) {
                        bootbox.alert("Aqui elimina el usuario");
                    }
                });
            }

            function searchArbol() {
                var v = $.trim($('#txtSearchArbol').val());
                $treeContainer.jstree(true).search(v);
            }

            function scrollToNode($scrollTo) {
                $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                    scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
                });
            }

            function scrollToRoot() {
                var $scrollTo = $("#root");
                scrollToNode($scrollTo);
            }

            function scrollToSearchRes() {
                var $scrollTo = $(searchRes[posSearchShow]);
                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
                scrollToNode($scrollTo);
            }

            function createContextMenu(node) {
                var nodeStrId = node.id;
                var $node = $("#" + nodeStrId);
                var nodeId = nodeStrId.split("_")[1];
                var nodeType = $node.data("jstree").type;

                var nodeText = $node.children("a").first().text();

                var esRoot = nodeType == "root";
                var esUnidad = nodeType.startsWith("u_");
                var esUsuario = nodeType == "usuario";
                var esJefe = nodeType == "jefe";
                var esDirector = nodeType == "director";

                var tieneHijos = $node.hasClass("tieneHijos");

                var items = {};

                var crearUnidad = {
                    label  : "Crear Unidad Ejecutora",
                    icon   : "fa fa-home text-success",
                    action : function () {
                        createEditUnidad(null, nodeId);
                    }
                };
                var editarUnidad = {
                    label  : "Editar Unidad Ejecutora",
                    icon   : "fa fa-home text-info",
                    action : function () {
                        createEditUnidad(nodeId, null);
                    }
                };
                var eliminarUnidad = {
                    label  : "Eliminar Unidad Ejecutora",
                    icon   : "fa fa-home text-danger",
                    action : function () {
                        deleteUnidad(nodeId);
                    }
                };

                var crearUsu = {
                    label  : "Crear Usuario",
                    icon   : "fa fa-user text-success",
                    action : function () {
                        createEditUsuario(null, nodeId);
                    }
                };
                var editarUsu = {
                    label  : "Editar Usuario",
                    icon   : "fa fa-user text-info",
                    action : function () {
                        createEditUsuario(nodeId, null);
                    }
                };
                var eliminarUsu = {
                    label  : "Eliminar Usuario",
                    icon   : "fa fa-user text-danger",
                    action : function () {
                        deleteUsuario(null, nodeId);
                    }
                };

                if (esRoot) {
                    items.crearUnidad = crearUnidad;
                }
                if (esUnidad) {
                    items.crearUnidad = crearUnidad;
                    items.editarUnidad = editarUnidad;
                    if (!tieneHijos) {
                        items.eliminarUnidad = eliminarUnidad;
                    }
                    crearUsu.separator_before = true;
                    items.crearUsu = crearUsu;
                }
                if (esUsuario || esJefe || esDirector) {
                    items.crearUsu = crearUsu;
                    items.editarUsu = editarUsu;
                    eliminarUsu.separator_before = true;
                    items.eliminarUsu = eliminarUsu;
                }

                return items;
            }

            $(function () {

                SyntaxHighlighter.all();

                $treeContainer.on("loaded.jstree", function () {
                    $("#loading").hide();
                    $treeContainer.removeClass("hidden");
                }).on("search.jstree", function (event, res) {
                    searchRes = res.nodes;
                    var cantRes = searchRes.length;
                    posSearchShow = 0;
                    $("#divSearchRes").removeClass("hidden");
                    $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                    scrollToSearchRes();
                }).jstree({
                    plugins     : ["state", "types", "contextmenu", "search"],
                    core        : {
                        multiple : false,
                        themes   : {
                            variant : "small",
                            dots    : true,
                            stripes : true
                        }
                    },
                    state       : {
                        key : "arbol1"
                    },
                    contextmenu : {
                        show_at_node : false,
                        items        : createContextMenu
                    },
                    search      : {},
                    types       : {
                        'default'   : {
                            icon : "fa fa-folder-open"
                        },
                        'usuario'   : {
                            icon : "fa fa-user text-info"
                        },
                        'jefe'      : {
                            icon : "fa fa-user-secret text-danger"
                        },
                        'director'  : {
                            icon : "fa fa-user-secret text-warning"
                        },
                        'sinUnidad' : {
                            icon : "fa fa-folder"
                        },
                        'u_1'       : {
                            icon : 'fa fa-hospital-o'
                        },
                        'u_2'       : {
                            icon : 'fa fa-building'
                        },
                        'u_3'       : {
                            icon : 'fa fa-building-o'
                        },
                        'u_4'       : {
                            icon : 'fa fa-home'
                        }
                    }
                });

                $("#btnExpandAll").click(function () {
                    $treeContainer.jstree("open_all");
                    scrollToRoot();
                    return false;

                });

                $("#btnCollapseAll").click(function () {
                    $treeContainer.jstree("close_all");
                    scrollToRoot();
                    return false;
                });

                $("#btnSearchArbol").click(function () {
                    searchArbol();
                    return false;
                });

                $("#txtSearchArbol").keyup(function (ev) {
                    if (ev.keyCode == 13) {
                        searchArbol();
                    }
                });

                $("#btnPrevSearch").click(function () {
                    if (posSearchShow > 0) {
                        posSearchShow--;
                    } else {
                        posSearchShow = searchRes.length - 1;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnNextSearch").click(function () {
                    if (posSearchShow < searchRes.length - 1) {
                        posSearchShow++;
                    } else {
                        posSearchShow = 0;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnClearSearch").click(function () {
                    $treeContainer.jstree("clear_search");
                    $("#txtSearchArbol").val("");
                    posSearchShow = 0;
                    searchRes = [];
                    scrollToRoot();
                    $("#divSearchRes").addClass("hidden");
                    $("#spanSearchRes").text("");
                });
            });
        </script>

    </body>
</html>