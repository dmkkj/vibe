package mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.master.vibe.model.dto.SearchDTO;
import com.master.vibe.model.vo.Playlist;

@Mapper
public interface PlaylistTagMapper {
	
	List<Playlist> searchPlaylist(SearchDTO dto); // 플리제목 검색, 태그 검색
	
//	service에서 호출은 하나 호출하는 controller가 없음
//	List<Playlist> getPlaylistsByTag(String tagCode);
}
