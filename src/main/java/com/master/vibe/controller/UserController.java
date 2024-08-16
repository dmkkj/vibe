package com.master.vibe.controller;

import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.master.vibe.model.dto.UserLikeTagDTO;
import com.master.vibe.model.vo.User;
import com.master.vibe.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

	@Autowired
	private UserService userService;

	// 테스트 페이지 연결
	@GetMapping("/test")
	public String testPage() {
		return "test/test";
	}

	@GetMapping("/userTest")
	public String userTest() {
		return "test/userTest";
	}

	// 메인페이지 연결
	@GetMapping("/")
	public String index() {
		return "index";
	}

	// 회원가입
	@GetMapping("/registerUser")
	public String register() {
		return "user/registerUser";
	}

	@PostMapping("/registerUser")
	public String register(User user, String birthDay) {
		try {
			user.setUserBirth(new SimpleDateFormat("yyyy-MM-dd").parse(birthDay));
		} catch (Exception e) {}

		userService.register(user);
		return "redirect:/";
	}

	// 로그인
	@GetMapping("/login")
	public String login() {
		return "user/login";
	}

	@PostMapping("login")
	public String login(User user, HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		User u = userService.login(user);

		// 아이디 / 비밀번호 조회 실패
		if (u == null) {
			return "user/login_fail_empty_user";
		}
		// 탈퇴한 회원
		if (u.getUserEntYn() == 'Y') {
			model.addAttribute("rejoinDate", userService.rejoinDate(user.getUserEmail()));
			return "user/login_fail_deleteUser";
		}
		// 정상 회원
		session.setAttribute("user", u);
		return "index";
		
	}
	
	// 계정 찾기 페이지로 이동
	@GetMapping("/findUser")
	public String findUser() {
		return "user/findUser";
	}
	// 계정 찾기
	@PostMapping("findUser")
	public String findUserID(User user, String birthDay, Model model) {
		try {
			user.setUserBirth(new SimpleDateFormat("yyyy-MM-dd").parse(birthDay));
		} catch (Exception e) {}
		
		if(user.getUserEmail() == null) { // userEmail이 null 이면 아이디 찾기
			model.addAttribute("userEmail", userService.findUserID(user).getUserEmail());
			return "user/showUserID";
		}else {
			model.addAttribute("user", userService.findUserPWD(user));
			return "user/showUserPWD";
		}
	}
	// 비밀번호 수정
	@PostMapping("updateUserPWD")
	public String updateUserPWD(User user) {
		userService.updateUserPWD(user);
		return "user/login";
	}

	// 로그아웃
	@GetMapping("logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("user") != null) session.invalidate();
		
		return "redirect:/";
	}

	// 마이페이지
	@GetMapping("mypage")
	public String mypage() {
		return "user/mypage";
	}

	// 회원 수정
	@GetMapping("updateUser")
	public String updateUser() {
		return "user/updateUser";
	}

	@PostMapping("updateUser")
	public String updateUser(User user, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User u = (User) session.getAttribute("user"); // 현재 접속중인 유저 정보
		
		// 변경할 정보들을 현재접속한 유저 정보에 담아서 서비스로 처리
		u.setUserNickname(user.getUserNickname());
		u.setUserPassword(user.getUserPassword());
		u.setUserPhone(user.getUserPhone());
		
		if (userService.updateUser(u) != null) {
			session.setAttribute("user", u); // 변경된 정보로 session에 다시 담기
			return "user/mypage";
		} 
		return "test/userTest";
	}

	// 회원 탈퇴
	@GetMapping("deleteUser")
	public String deleteUser() {
		return "user/deleteUser";
	}

	@PostMapping("deleteUser")
	public String deleteUser(String userPassword, HttpServletRequest request) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");

		if (userPassword.equals(user.getUserPassword())) {
			userService.deleteUser(user.getUserEmail());

			if (session.getAttribute("user") != null)
				session.invalidate();
			return "index";
		}

		return "user/mypage";
	}

	// join
	// 내가 좋아요한 태그
	@GetMapping("userLikeTag")
    public String userLikeTag(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            List<UserLikeTagDTO> list = userService.userLikeTag(user.getUserEmail());
            System.out.println(list.isEmpty());
            model.addAttribute("likeTagList", list);
            return "user/userLikeTag";
        }
        return "user/login";
    }
	
	// 내 프로필 공유하기
	@GetMapping("shareMyProfile")
	public String shareMyProfile() {
		return "user/shareMyProfile";
	}
	
	// 로그인 회원 음악 듣기
	@GetMapping("musicListen")
	public String musicListen(HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();
		Object token = session.getAttribute("accessToken");
		model.addAttribute("token", token);
		return "music/musicListen";
	}
	
}
