package demoArboles

class MenuTagLib {
//    static defaultEncodeAs = 'html'
    //static encodeAsForTags = [tagName: 'raw']

    static namespace = 'mn'

    def menu = { attrs ->
        def strItems = ""
        if (!attrs.title) {
            attrs.title = "Vesta"
        }

        def items = [
                "Tipo Institución": ["Lista", createLink(controller: 'tipoInstitucion', action: 'index')],
                "Unidad Ejecutora": ["Lista", createLink(controller: 'unidadEjecutora', action: 'index')],
                "Persona"         : ["Lista", createLink(controller: 'persona', action: 'index')],
                "Árboles"         : ["Inicio", createLink(controller: 'unidadEjecutora', action: 'tree'),
                                     "Estático", createLink(controller: 'unidadEjecutora', action: 'treeEstatico'),
                                     "Ajax", createLink(controller: 'unidadEjecutora', action: 'treeAjax')],
        ]

        items.each { item ->
            strItems += '<li class="dropdown">'
            strItems += '<a href="#" class="dropdown-toggle" data-toggle="dropdown">' + item.key + '<b class="caret"></b></a>'
            strItems += '<ul class="dropdown-menu">'

            (item.value.size() / 2).toInteger().times {
                strItems += '<li><a href="' + item.value[it * 2 + 1] + '">' + item.value[it * 2] + '</a></li>'
            }
            strItems += '</ul>'
            strItems += '</li>'
        }

        def html = "<nav class=\"navbar navbar-inverse navbar-fixed-top\" role=\"navigation\">"

        html += "<div class=\"container-fluid\">"

        // Brand and toggle get grouped for better mobile display
        html += '<div class="navbar-header">'
        html += '<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">'
        html += '<span class="sr-only">Toggle navigation</span>'
        html += '<span class="icon-bar"></span>'
        html += '<span class="icon-bar"></span>'
        html += '<span class="icon-bar"></span>'
        html += '</button>'
        html += "<a class='navbar-brand navbar-logo' href='${createLink(uri: '/')}'>Demo árboles</a>"
        html += '</div>'

        // Collect the nav links, forms, and other content for toggling
        html += '<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">'
        html += '<ul class="nav navbar-nav">'
        html += strItems
        html += '</ul>'

        html += '</div><!-- /.navbar-collapse -->'

        html += "</div>"

        html += "</nav>"

        out << html
    }

}
