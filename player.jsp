<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.io.File"%>
<%@ page import="java.net.URLDecoder"%>
<%
    String resourcePath = request.getParameter("path");
    String contextPath = request.getContextPath();
    if (resourcePath == null) {
        response.sendError(403, "非法请求");
        return;
    }
    String type = null;
    if (resourcePath.toLowerCase().endsWith(".mp4")) {
        type = "video/mp4";
    } else if (resourcePath.toLowerCase().endsWith(".m3u8")) {
        type = "application/x-mpegURL";
    }
    else {
        response.sendError(403, "不支持的视频格式");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title><% out.println(new File(resourcePath).getName());  %></title>
<link href="https://vjs.zencdn.net/7.4.1/video-js.css" rel="stylesheet">
<script src='https://vjs.zencdn.net/7.4.1/video.min.js'></script>
<script src="https://cdn.bootcdn.net/ajax/libs/videojs-contrib-hls/5.15.0/videojs-contrib-hls.min.js"></script>
</head>
<body>
<div>
    <video id="myMovie" class="video-js vjs-default-skin" >
        <source id="source" src="<%= contextPath + resourcePath %>" type="<%= type %>" />
      </video>
</div>
<script>
    var myMovie = videojs('myMovie', {
      loop: true,
      controls: true,
      preload: 'auto',
      autoplay: false,
      muted: true,
      language: "zh-CN",
      fluid: true,
    })
  </script>
</body>