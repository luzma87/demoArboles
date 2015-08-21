package demoArboles

import org.springframework.dao.DataIntegrityViolationException
//Descomentar aqui y en la declaracion de la clase para poner el shield
//import demoArboles.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de TipoInstitucion
 */
class TipoInstitucionController /*extends Shield*/ {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que muestra la lista de elementos
     * @return tipoInstitucionInstanceList: la lista de elementos filtrados, tipoInstitucionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def index() {
        def tipoInstitucionInstanceList = getList(params, false)
        def tipoInstitucionInstanceCount = getList(params, true).size()
        return [tipoInstitucionInstanceList: tipoInstitucionInstanceList, tipoInstitucionInstanceCount: tipoInstitucionInstanceCount]
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    public List<TipoInstitucion> getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = TipoInstitucion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = TipoInstitucion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return tipoInstitucionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def tipoInstitucionInstance = TipoInstitucion.get(params.id)
            if(!tipoInstitucionInstance) {
                render "ERROR*No se encontró TipoInstitucion."
                return
            }
            return [tipoInstitucionInstance: tipoInstitucionInstance]
        } else {
            render "ERROR*No se encontró TipoInstitucion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return tipoInstitucionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def tipoInstitucionInstance = new TipoInstitucion()
        if(params.id) {
            tipoInstitucionInstance = TipoInstitucion.get(params.id)
            if(!tipoInstitucionInstance) {
                render "ERROR*No se encontró TipoInstitucion."
                return
            }
        }
        tipoInstitucionInstance.properties = params
        return [tipoInstitucionInstance: tipoInstitucionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def tipoInstitucionInstance = new TipoInstitucion()
        if(params.id) {
            tipoInstitucionInstance = TipoInstitucion.get(params.id)
            if(!tipoInstitucionInstance) {
                render "ERROR*No se encontró TipoInstitucion."
                return
            }
        }
        tipoInstitucionInstance.properties = params
        if(!tipoInstitucionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar TipoInstitucion: " + renderErrors(bean: tipoInstitucionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de TipoInstitucion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def tipoInstitucionInstance = TipoInstitucion.get(params.id)
            if (!tipoInstitucionInstance) {
                render "ERROR*No se encontró TipoInstitucion."
                return
            }
            try {
                tipoInstitucionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de TipoInstitucion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar TipoInstitucion"
                return
            }
        } else {
            render "ERROR*No se encontró TipoInstitucion."
            return
        }
    } //delete para eliminar via ajax
    
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = TipoInstitucion.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render TipoInstitucion.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render TipoInstitucion.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
        
}
