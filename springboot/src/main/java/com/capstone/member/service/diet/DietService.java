package com.capstone.member.service.diet;

import com.capstone.member.repository.Diet.DietRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DietService {

    @Autowired
    private DietRepository dietRepository;
    @Transactional
    public void deleteByEmail(String email) {
        dietRepository.deleteByEmail(email);
    }
}
