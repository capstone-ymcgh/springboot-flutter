package com.capstone.member.dto.member;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberDto {
    private String email;
    private String nickname;
    private String password;
    private String usertype;
    private String businesscode;
    private String imagepath;
}
