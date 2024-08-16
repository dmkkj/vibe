<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Results</title>
</head>
<body>

	<h1>검색 결과</h1>
	<h2>${ageGroup}</h2>
	<c:forEach var="playlist" items="${playListRankingOnAgeGroup}">
		<div>
			<img src="${playlist.plImg}" alt="Playlist Image"
				style="width: 150px; height: 150px;">
			<h2>${playlist.plTitle}</h2>
			<p>작성자: ${playlist.user.userNickname}</p>
			<p>${ageGroup}의 좋아요 수: ${playlist.likeCount}</p>
		</div>
		<hr>
	</c:forEach>
</body>