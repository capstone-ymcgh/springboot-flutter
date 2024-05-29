package com.capstone.member.controller.member;

import com.capstone.member.dto.member.MemberDto;
import com.capstone.member.entity.member.MemberEntity;
import com.capstone.member.service.diet.DietService;
import com.capstone.member.service.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.capstone.member.repository.member.MemberRepository;

import java.util.Map;

@RestController
@CrossOrigin
@RequestMapping("/api")
public class MemberController {

    @Autowired
    private MemberService memberService;
    @Autowired
    private MemberRepository memberRepository;
    @Autowired
    private DietService dietService;

    @RequestMapping("/signup")
    public ResponseEntity<String> register(@RequestBody MemberDto user) {
        MemberEntity member = memberService.registerUser(user);
        return ResponseEntity.ok("회원가입 성공"+member.getEmail());
    }
    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody MemberDto user) {
        boolean loginSuccess = memberService.loginUser(user.getEmail(), user.getPassword());
        if (loginSuccess) {
            return ResponseEntity.ok("로그인 성공");
        } else {
            return ResponseEntity.badRequest().body("로그인 실패");
        }
    }
    @GetMapping("/findpassword")
    public ResponseEntity<String> findPassword(@RequestParam String email) {
        if(email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        String password = memberService.findPasswordByEmail(email);
        if (password != null) {
            return ResponseEntity.ok(password);
        } else {
            return ResponseEntity.badRequest().body("비밀번호를 찾지 못했습니다.");
        }
    }
    @GetMapping("/getNickname")
    public ResponseEntity<String> getNicknameByEmail(@RequestParam String email) {
        if(email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        String nickname = memberService.findNicknameByEmail(email);
        if (nickname != null) {
            return ResponseEntity.ok(nickname);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/updateNickname")
    public ResponseEntity<String> updateNicknameByEmail(@RequestBody Map<String, String> requestData) {
        String email = requestData.get("email");
        String newNickname = requestData.get("nickname");

        if (email == null || email.isEmpty() || newNickname == null || newNickname.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        MemberEntity member = memberService.findByEmail(email);
        if (member != null) {
            member.setNickname(newNickname);
            memberRepository.save(member); // 닉네임 업데이트
            return ResponseEntity.ok("닉네임을 성공적으로 변경하였습니다.");
        } else {
            return ResponseEntity.badRequest().body("해당 이메일을 가진 회원을 찾을 수 없습니다.");
        }
    }
    @PutMapping("/updatePassword")
    public ResponseEntity<String> updatePasswordByEmail(@RequestBody Map<String, String> requestData) {
        String email = requestData.get("email");
        String newPassword = requestData.get("password");

        if (email == null || email.isEmpty() || newPassword == null || newPassword.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        MemberEntity member = memberService.findByEmail(email);
        if (member != null) {
            member.setPassword(newPassword);
            memberRepository.save(member); // 비밀번호 업데이트
            return ResponseEntity.ok("비밀번호를 성공적으로 변경하였습니다.");
        } else {
            return ResponseEntity.badRequest().body("해당 이메일을 가진 회원을 찾을 수 없습니다.");
        }
    }
    @DeleteMapping("/deleteAccount")
    public ResponseEntity<String> deleteAccountByEmail(@RequestBody Map<String, String> requestData) {
        String email = requestData.get("email");

        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body("이메일을 제공해야 합니다.");
        }

        MemberEntity member = memberService.findByEmail(email);
        if (member != null) {
            dietService.deleteByEmail(email); // 식단 데이터 삭제
            memberService.delete(member); // 회원 데이터 삭제
            return ResponseEntity.ok("회원 탈퇴가 성공적으로 처리되었습니다.");
        } else {
            return ResponseEntity.badRequest().body("해당 이메일을 가진 회원을 찾을 수 없습니다.");
        }
    }

}
