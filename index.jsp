<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FilenameFilter"%>
<%@ page import="java.net.URLDecoder"%>
<%
    // 应用路径
    String contextPath = request.getContextPath();

    // 请求的资源目录，根目录对应服务器的当前应用路径
    String requestPath =  request.getParameter("path");

    if (requestPath == null) requestPath = "/";
    if (!requestPath.endsWith("/")) requestPath += "/";
    
    // 资源上级目录，如不存在上级目录，则为null
    String parentPath = new File(requestPath).getParent();
    requestPath = URLDecoder.decode(requestPath, "UTF-8");
    // 服务器与资源目录对应的真实决定路径, getRealPath如果路径已经存在，但是是文件而非预期目录，会产生null值
    String path = request.getSession().getServletContext().getRealPath("/") + requestPath;

    File directory = new File(path);
    if (!directory.exists() || directory.isFile()) {
        response.sendError(404, "请求的资源目录'"+ requestPath +"'不存在");
        return;
    }

    // 获取资源目录下的文件资源
    File[] files = directory.listFiles(new FilenameFilter(){
        public boolean accept(File dir, String name) {
            File file = new File(dir, name);
            if (file.isDirectory()) return true;
            String[] exts = {".mp4", ".m3u8", ".mov", ".webp"};
            for (String ext: exts) {
                if (name.toLowerCase().endsWith(ext)) return true;
            }
            return false;
        }
    });
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>Movie</title>
</head>
<body>

<h1>
    <%
    out.println("Index: " + requestPath);
    %>
</h1>

<div class="file">
<%
    out.println("Your IP: " + request.getRemoteAddr());
%></br>

<% 
    // 上级目录只有非根目录显示
    if (parentPath != null ) {
        String parentHref =  parentPath.equals("/")?"." : "?path=" + parentPath;
        %>
            <a href=".">
                返回根目录
            </a><br />
            <a href="<%= parentHref %>">
                返回上级目录
            </a><br />
        <% 
    } 
%>

<!-- 当前目录资源 -->
<% 
    for (File f: files){
        String href = f.isFile() ? "player.jsp?path=" + requestPath + f.getName() : "?path="+ requestPath  + f.getName();
        String target = f.isFile() ? "_Blank" : "";
        %>
        <a href="<%= href %>" target="<%= target %>">
            <% out.println(f.getName()); %>
        </a><br />
        <% 
    } 
%>
</div>
<style>
    .file {
        font-size: large;
    }
</style>
</body>
</html>