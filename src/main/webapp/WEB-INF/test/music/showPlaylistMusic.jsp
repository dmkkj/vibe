<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>플레이리스트 곡 조회</h1>
	<table>
		<tr>
			<th>앨범커버</th>
			<th>곡명</th>
			<th>아티스트명</th>
			<th>앨범명</th>
		</tr>
		<c:forEach items="${musicList }" var="music">
			<tr>
				<td><img src="${music.albumUrl }" style="width: 100px"></td>
				<td>${music.musicTitle }</td>
				<td>${music.artistName }</td>
				<td>${music.albumName }</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>