package com.capstone.member.service.member;

import com.capstone.member.dto.member.MemberDto;
import com.capstone.member.entity.member.MemberEntity;
import com.capstone.member.repository.member.MemberRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberService {

    @Autowired
    private MemberRepository memberRepository;

    public MemberEntity registerUser(MemberDto memberDto) {
        // 이메일 중복 검사
        if (memberRepository.findByEmail(memberDto.getEmail()) != null) {
            throw new RuntimeException("이미 사용 중인 이메일입니다.");
        }

        // 회원 정보 저장
        MemberEntity memberEntity = new MemberEntity();
        memberEntity.setEmail(memberDto.getEmail());
        memberEntity.setNickname(memberDto.getNickname());
        memberEntity.setPassword(memberDto.getPassword());
        memberEntity.setUsertype(memberDto.getUsertype());
        memberEntity.setBusinesscode(memberDto.getBusinesscode());

        return memberRepository.save(memberEntity);
    }

    public MemberEntity findByEmail(String email) {
        // 이메일을 통해 회원 정보 조회
        return memberRepository.findByEmail(email);
    }
    public boolean loginUser(String email, String password) {
        // 이메일과 비밀번호를 사용하여 회원 로그인을 시도합니다.
        MemberEntity member = memberRepository.findByEmail(email);

        // 회원이 존재하고 비밀번호가 일치하는 경우 로그인 성공
        if (member != null && member.getPassword().equals(password)) {
            return true;
        } else {
            return false;
        }
    }

    public String findPasswordByEmail(String email) {
        String trimmedEmail = email.trim(); // 앞뒤 공백 제거
        MemberEntity member = memberRepository.findByEmail(trimmedEmail);
        if (member != null) {
            return member.getPassword();
        } else {
            return null;
        }
    }
    public String findNicknameByEmail(String email) {
        MemberEntity member = memberRepository.findByEmail(email);
        if (member != null) {
            return member.getNickname();
        } else {
            return null;
        }
    }
    public String findImageByEmail(String email){
        MemberEntity member = memberRepository.findByEmail(email);
        if (member != null) {
            return member.getImagepath();
        } else {
            return null;
        }
    }
    public void delete(MemberEntity member) {
        memberRepository.delete(member);
    }
}
