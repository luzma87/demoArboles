<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <title><g:layoutTitle default="demo Arboles"/></title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <imp:favicon/>
        <imp:js/>
        <imp:plugins/>
        <imp:customJs/>

        <imp:spinners/>

        <imp:css/>

        <g:layoutHead/>
        <script type="text/javascript">
            var index = 1041;
            function bringToTop(element) {
//        console.log("btt",element)
                element.css({"zIndex" : index})
                index++;
            }
            function bringToTopCustom(element, zIndex) {
//        console.log("btt2",element,zIndex)
                element.css({"zIndex" : zIndex})
            }
        </script>
        <style type="text/css">

        </style>
    </head>

    <body>
        <mn:menu title="${g.layoutTitle(default: 'Vesta')}"/>

        <div class="container" id="mass-container" style="position: relative">
            <g:layoutBody/>
        </div>

        <script type="application/javascript">
            function buscarMenu() {
                var search = $.trim($("#txtSearchMenu").val());
                if (search != "") {
                    openLoader("Buscando...");
                    location.href = "${createLink(controller:'inicio', action: 'busquedaMenu')}?search=" + search;
                }
            }
            $(function () {
                $("#btnSearchMenu").click(function () {
                    buscarMenu();
                    return false;
                });
                $("#txtSearchMenu").keyup(function (ev) {
                    if (ev.keyCode == 13) {
                        buscarMenu();
                    }
                });

//                console.log($("html"))
//                console.log($(".jstree"))
//                console.log($("html").not(".jstree"))

//                para el context menu deshabilita el click derecho en las paginas
                $("body").contextMenu({
                    ignore : $(".jstree"),
                    items  : {
                        header : {
                            label  : "Sin acciones",
                            header : true
                        }
                    }
                });

            });
        </script>

    </body>
</html>
