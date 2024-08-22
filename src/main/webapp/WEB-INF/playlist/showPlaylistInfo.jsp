<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://kit.fontawesome.com/df04184d5c.js" crossorigin="anonymous"></script>
<title>플레이리스트 곡 조회</title>
<style>
/* a 태그 */
td a {
    cursor: pointer;
    text-decoration: none;
    color: black;
}
</style>
<style>
/* 임시로 설정해놓은 것 */
/* 플리 제작자 영역*/
.container {
	display: flex;
	align-items: center; /* 세로 방향 중앙 정렬 */
	margin-bottom: 20px;
}
.container img {
	border-radius: 50%;
	height: 30px;
	margin-right: 5px;
}
.container .myNick {
	margin: 0; /* 기본 마진 제거 */
	font-size: 14px;
}
</style>
<script>
	// 플레이리스트 삭제 클릭 시 바로 삭제되는 것 alert으로 방지
	function confirmDelete(event, url) {
		event.preventDefault(); // 링크 클릭 기본 동작 방지
		if (confirm('[${playlist.plTitle}] 플레이리스트를 삭제하시겠습니까?')) {
			window.location.href = url; // 확인 클릭 시 삭제 URL로 이동
		}
	}
	
	// [곡 삭제] 버튼 클릭 시 삭제할 곡이 있는지(체크된 곡이 있는지) 확인
	function checkForSelectedMusic(event) {
		const checkbox = document.querySelectorAll('input[name="selectedDeleteMusic"]:checked');
		if(checkbox.length === 0) {
			event.preventDefault(); // 폼 제출(삭제) 방지
			alert('삭제할 곡이 없습니다. 확인해 주세요.');
		}
	}
	
	// 페이지 로드 시 스크롤 위치 복원
	window.addEventListener('load', () => {
		// 페이지가 다른 페이지에서 왔는지 확인
		const isHistoryState = window.history.state && window.history.state.scrollRestoration;

		if (isHistoryState) {
			const scrollPosition = sessionStorage.getItem('scrollPosition');
			if (scrollPosition !== null) {
				window.scrollTo(0, parseInt(scrollPosition, 10));
				sessionStorage.removeItem('scrollPosition'); // 위치 복원 후 제거
			} else {
				// 처음 로드할 때는 페이지 상단으로 이동
				window.scrollTo(0, 0);
			}
		}
	});
	
	// 페이지를 떠나기 전 스크롤 위치 저장
	window.addEventListener('beforeunload', () => {
		sessionStorage.setItem('scrollPosition', window.scrollY);
		// 상태를 history에 저장
        window.history.replaceState({scrollRestoration: true}, null);
	});
	
	<!-- 플레이리스트 링크 공유 -->
	async function onClickCopyLink() {
		const link = window.location.href;
		await
		navigator.clipboard.writeText(link);
		window.alert('클립보드에 링크가 복사되었습니다.');
	}

	document.getElementById("link-copy-icon").addEventListener("click", onClickCopyLink);
</script>
</head>
<body>
    <h3>플레이리스트 곡 조회</h3>
    <img src="${playlist.plImg}" style="width: 200px;">
    <a href="myPlaylist">목록</a>
    <h1>${playlist.plTitle }</h1>
    <br>

    <c:if test="${user.userEmail eq playlist.user.userEmail}">
        <a href="addMusic?plCode=${playlist.plCode }">곡 추가</a>
        <a href="deletePlaylist?plCode=${playlist.plCode }">플레이리스트 삭제</a>
        <a href="updatePlaylist?plCode=${playlist.plCode }">플레이리스트 수정</a>
    </c:if>

    <h4>태그 :</h4>
    <ul>
        <c:forEach items="${tagList}" var="tag">
            <li>${tag}</li>
        </c:forEach>
    </ul>

    <form action="deleteMusicFromPlaylist" method="post">
        <input type="hidden" name="plCode" value="${playlist.plCode}">
        <table>
            <i id="link-copy-icon" class="fa-solid fa-link">링크 공유하기</i>
            <tr>
                <th>선택</th>
                <th>앨범커버</th>
                <th>곡명</th>
                <th>아티스트명</th>
                <th>앨범명</th>
            </tr>
            <c:forEach items="${musicList}" var="music" varStatus="status">
                <tr>
                    <td><input type="checkbox" name="selectedDeleteMusic" value="${music.id}"></td>
                    <td><a href="musicDetail?musicId=${music.id}"><img src="${music.albumUrl}" style="width: 100px"></a></td>
                    <td><a href="musicDetail?musicId=${music.id}">${music.musicTitle}</a></td>
                    <td><a href="musicDetail?musicId=${music.id}">${music.artistName}</a></td>
                    <td><a href="musicDetail?musicId=${music.id}">${music.albumName}</a></td>
                    <td><a href="#" onclick="playMusic('${music.id}')">재생하기</a></td>
                </tr>
            </c:forEach>
        </table>
        <button type="submit">곡 삭제</button>
    </form>

    <!-- 플레이어가 표시될 위치 -->
    <div id="playerContainer" style="margin-top: 20px;">
        <iframe id="main_frame" src="" width="300" height="380" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>
    </div>

    <script>
        // 곡을 재생하는 함수 (전역 범위에서 정의)
        function playMusic(trackId) {
            const iframe = document.getElementById("main_frame");
            iframe.src = "https://open.spotify.com/embed/track/" + trackId;
        }

        async function onClickCopyLink() {
            const link = window.location.href;
            await navigator.clipboard.writeText(link);
            window.alert('클립보드에 링크가 복사되었습니다.');
        }

        window.onload = function() {
            document.getElementById("link-copy-icon").addEventListener("click", onClickCopyLink);

            // 곡 정보를 배열로 준비합니다.
            const tracks = [
                <c:forEach items="${musicList}" var="music" varStatus="status">
                    {
                        id: '${music.id}',
                        title: '${music.musicTitle}',
                        artist: '${music.artistName}',
                        duration: 180000 // 예시로 3분 (밀리초로 표시)
                    }
                    <c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];

            let currentTrackIndex = 0;

            // 자동 재생 로직
            function playNextTrack() {
                if (currentTrackIndex < tracks.length) {
                    playMusic(tracks[currentTrackIndex].id);
                    const trackDuration = tracks[currentTrackIndex].duration;
                    currentTrackIndex++;

                    // 곡의 길이만큼 대기한 후 다음 곡 재생
                    setTimeout(playNextTrack, trackDuration);
                }
            }

            // 첫 곡 재생
            playNextTrack();
        };
    </script>
</body>
</html>