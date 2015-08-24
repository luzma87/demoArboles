package demoArboles

import groovy.json.JsonBuilder
import org.springframework.dao.DataIntegrityViolationException

//Descomentar aqui y en la declaracion de la clase para poner el shield
//import demoArboles.seguridad.Shield

/**
 * Controlador que muestra las pantallas de manejo de UnidadEjecutora
 */
class UnidadEjecutoraController /*extends Shield*/ {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que muestra la lista de elementos
     * @return unidadEjecutoraInstanceList: la lista de elementos filtrados, unidadEjecutoraInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def index() {
        def unidadEjecutoraInstanceList = getList(params, false)
        def unidadEjecutoraInstanceCount = getList(params, true).size()
        return [unidadEjecutoraInstanceList: unidadEjecutoraInstanceList, unidadEjecutoraInstanceCount: unidadEjecutoraInstanceCount]
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    public List<UnidadEjecutora> getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = UnidadEjecutora.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                }
            }
        } else {
            list = UnidadEjecutora.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return unidadEjecutoraInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró UnidadEjecutora."
                return
            }
            return [unidadEjecutoraInstance: unidadEjecutoraInstance]
        } else {
            render "ERROR*No se encontró UnidadEjecutora."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return unidadEjecutoraInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def unidadEjecutoraInstance = new UnidadEjecutora()
        if (params.id) {
            unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró UnidadEjecutora."
                return
            }
        }
        unidadEjecutoraInstance.properties = params
        return [unidadEjecutoraInstance: unidadEjecutoraInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def unidadEjecutoraInstance = new UnidadEjecutora()
        if (params.id) {
            unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró UnidadEjecutora."
                return
            }
        }
        unidadEjecutoraInstance.properties = params
        if (!unidadEjecutoraInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar UnidadEjecutora: " + renderErrors(bean: unidadEjecutoraInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de UnidadEjecutora exitosa."
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró UnidadEjecutora."
                return
            }
            try {
                unidadEjecutoraInstance.delete(flush: true)
                render "SUCCESS*Eliminación de UnidadEjecutora exitosa."
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar UnidadEjecutora"
            }
        } else {
            render "ERROR*No se encontró UnidadEjecutora."
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = UnidadEjecutora.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
            } else {
                render UnidadEjecutora.countByCodigoIlike(params.codigo) == 0
            }
        } else {
            render UnidadEjecutora.countByCodigoIlike(params.codigo) == 0
        }
    }


    def tree() {

    }

    def treeEstatico() {
        def html = "<ul>"
        def type = "root"
        def opened = true
        def selected = false
        def disabled = false
        def nodeId = "root"

        def dataJstree = "\"opened\": $opened, \"selected\": $selected, \"disabled\": $disabled, \"type\": \"$type\""
        html += "<li id='$nodeId' data-jstree='{$dataJstree}'>"
        html += "Unidades ejecutoras y usuarios"
        html += "<ul>"
        UnidadEjecutora.findAllByPadreIsNull([sort: 'nombre']).each { ue ->
            html += makeTreeEstatico(ue)
        }
        def prsn = Persona.findAllByUnidadIsNull()
        if (prsn.size() > 0) {
            type = "sinUnidad"
            opened = false
            selected = false
            disabled = false
            nodeId = "noUE"

            dataJstree = "\"opened\": $opened, \"selected\": $selected, \"disabled\": $disabled, \"type\": \"$type\""
            html += "<li id='$nodeId' data-jstree='{$dataJstree}'>"
            html += "Usuarios sin unidad ejecutora"
            html += "<ul>"
            prsn.each { usu ->
                type = "usuario"
                if (usu.esDirector) {
                    type = "director"
                } else if (usu.esJefe) {
                    type = "jefe"
                }
                selected = false
                disabled = false
                nodeId = "usu_" + usu.id

                dataJstree = "\"selected\": $selected, \"disabled\": $disabled, \"type\": \"$type\""
                html += "<li id='$nodeId' data-jstree='{$dataJstree}'>"
                html += usu.labelArbol
                html += "</li>"
            }
            html += "</ul>"
        }
        html += "</ul>"
        html += "</li>"
        html += "</ul>"
        return [tree: html]
    }

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
        def nodeId = "ue_" + ue.id
        if (abiertos.contains(ue.codigo)) {
            opened = true
        }
        if (seleccionado == ue.codigo) {
            selected = true
        }
        def clase = ""
        if (unidadesHijas.size() > 0 || usuarios.size() > 0) {
            clase += " tieneHijos"
        }

        def dataJstree = "\"opened\": $opened, \"selected\": $selected, \"disabled\": $disabled, \"type\": \"$type\""
        html += "<li id='$nodeId' class='$clase' data-jstree='{$dataJstree}'>"
        html += ue.labelArbol
        if (unidadesHijas.size() > 0 || usuarios.size() > 0) {
            html += "<ul>"
            unidadesHijas.each { hijo ->
                html += makeTreeEstatico(hijo)
            }
            usuarios.each { usu ->
                type = "usuario"
                if (usu.esDirector) {
                    type = "director"
                } else if (usu.esJefe) {
                    type = "jefe"
                }
                selected = false
                disabled = false
                nodeId = "usu_" + usu.id
                dataJstree = "\"selected\": $selected, \"disabled\": $disabled, \"type\": \"$type\""
                html += "<li id='$nodeId' data-jstree='{$dataJstree}'>"
                html += usu.labelArbol
                html += "</li>"
            }
            html += "</ul>"
        }
        html += "</li>"
        return html
    }


    def treeAjax() {

    }

    def loadTreePart_ajax() {
        render(makeTreeNode(params))
    }

    private static String makeTreeNode(params) {
        def html = ""
        def id = params.id

        def hijos = []

        def type = ""
        def opened = false
        def selected = false
        def disabled = false
        def children = false
        def nodeId = ""
        def clase = ""
        def label = ""

        if (id == "#") {
            // aún no hay nada en el árbol, se debe crear el primer nodo raíz (root)
            def cantUnidadesHijas = UnidadEjecutora.countByPadreIsNull([sort: "nombre"])
            if (cantUnidadesHijas > 0) {
                clase = "tieneHijos jstree-closed"
                type = "root"
                nodeId = "root"
                opened = true
                selected = false
                disabled = false
                children = true
                label = "Unidades ejecutoras y usuarios"
            }

            def dataJstree = "\"opened\": $opened, \"children\": $children, \"selected\": $selected, \"disabled\": $disabled, \"type\": \"$type\""
            html += "<li id='$nodeId' class='$clase' data-jstree='{$dataJstree}'>"
            html += label
            html += "</li>"
            if (clase == "") {
                html = ""
            }
        } else if (id == "root") {
            // se deben cargar las unidades sin padre (y 'sin unidad' de ser necesario)
            hijos = UnidadEjecutora.findAllByPadreIsNull([sort: 'nombre'])
        } else {
            // se quiere abrir una unidad, se deben cargan las unidades hijas y los usuarios
            def parts = id.toString().split("_")
            def node_id = parts[1].toString().toLong()
            def padre = UnidadEjecutora.get(node_id)
            if (padre) {
                hijos = []
                hijos += UnidadEjecutora.findAllByPadre(padre, [sort: "nombre"])
                hijos += Persona.findAllByUnidad(padre, [sort: "nombre"])
            }
        }

        if (html == "" && hijos.size() > 0) {
            // solo se dibujan los hijos si la variable html está vacía (sino ya dibujó el root)
            // y si la cantidad de hijos es mayor a 0 (sino no hay nada que aumentar al árbol)

            def abiertos = ["343", "AI", "9999", "GGGGG"]
            def seleccionado = "343"

            html += "<ul>"

            hijos.each { hijo ->
                clase = ""
                opened = false
                selected = false
                disabled = false
                children = false
                // aquí iteramos en los hijos, que pueden ser de tipo UnidadEjecutora o Persona
                if (hijo instanceof UnidadEjecutora) {
                    def cantHijos = UnidadEjecutora.countByPadre(hijo)
                    cantHijos += Persona.countByUnidad(hijo)

                    type = "u_" + hijo.tipoInstitucion.codigo
                    label = hijo.labelArbol
                    nodeId = "ue_" + hijo.id
                    if (abiertos.contains(hijo.codigo)) {
                        opened = true
                    }
                    if (seleccionado == hijo.codigo) {
                        selected = true
                    }
                    if (cantHijos > 0) {
                        clase = " tieneHijos jstree-closed"
                        children = true
                    }
                } else if (hijo instanceof Persona) {
                    type = "usuario"
                    if (hijo.esDirector) {
                        type = "director"
                    } else if (hijo.esJefe) {
                        type = "jefe"
                    }
                    nodeId = "usu_" + hijo.id
                    label = hijo.labelArbol
                }
                def dataJstree = "\"opened\": $opened, \"children\": $children, \"selected\": $selected, \"disabled\": $disabled, \"type\": \"$type\""
                html += "<li class='$clase' id='$nodeId' data-jstree='{$dataJstree}'>"
                html += label
                html += "</li>"
            }
            html += "</ul>"
        }
        return html
    }

    def arbolSearch_ajax() {
        def search = params.str.trim()
        def nodosAbrir = [:]
        // busco las unidades que coinciden con la búsqueda
        def unidadesMatch = UnidadEjecutora.withCriteria {
            or {
                ilike("nombre", "%$search%")
                ilike("codigo", "%$search%")
            }
        }
        // busco los usuarios que coinciden con la búsqueda
        def usuariosMatch = Persona.withCriteria {
            or {
                ilike("nombre", "%$search%")
                ilike("login", "%$search%")
            }
        }
        // para cada unidad voy recorriendo los padres y agregándolos a la lista de nodos que se tienen
        // que abrir, junto con la cantidad de iteraciones que tomó encontrar cada nodo
        // guardo solamente la mayor cantidad de iteraciones para cada nodo.
        // esto permite después ordenar los nodos en el orden que tienen que abrirse en el árbol
        // para mostrar los resultados encontrados
        unidadesMatch.each { ue ->
            def padre = ue.padre
            def c = 0
            while (padre) {
                def id = "#ue_" + padre.id
                if (!nodosAbrir[id] || nodosAbrir[id] < c) {
                    nodosAbrir[id] = c
                }
                c++
                padre = padre.padre
            }
        }
        // para cada usuario agrego la unidad correspondiente en la lista de nodos que se tienen que abrir
        // después de las unidades porque siempre los usuarios van a ser las últimas hojas del árbol
        usuariosMatch.each { usu ->
            def id = "#ue_" + usu.unidadId
            if (!nodosAbrir[id]) {
                nodosAbrir[id] = 0
            }
        }
        // los últimos nodos en abrirse son los que se encontraron primero (orden 0) por lo que el ordenamiento
        // es decendiente
        nodosAbrir = nodosAbrir.sort { -it.value }
        def json = new JsonBuilder(nodosAbrir.keySet())
        render json
    }

}
