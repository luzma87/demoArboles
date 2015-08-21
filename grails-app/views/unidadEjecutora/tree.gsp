<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 20/08/15
  Time: 12:49 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Árboles</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="unidadEjecutora" action="index" class="btn btn-default">
                    <i class="fa fa-building"></i> Unidades ejecutoras
                </g:link>
                <g:link controller="persona" action="index" class="btn btn-default">
                    <i class="fa fa-users"></i> Personas
                </g:link>
            </div>
        </div>

        <p>
            Utilizando <a href="http://www.jstree.com/" target="_blank">Jstree</a>
        </p>
        <ul class="fa-ul">
            <li>
                <g:link action="treeEstatico">
                    <i class="fa-li fa fa-play-circle"></i>
                    Estático
                </g:link>
            </li>
            <li>
                <g:link action="treeAjax">
                    <i class="fa-li fa fa-play-circle"></i>
                    Con Ajax
                </g:link>
            </li>
        </ul>

    </body>
</html>