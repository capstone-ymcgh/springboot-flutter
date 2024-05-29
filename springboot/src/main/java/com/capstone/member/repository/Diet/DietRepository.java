package com.capstone.member.repository.Diet;

import com.capstone.member.entity.Diet.DietEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DietRepository extends JpaRepository<DietEntity, Long> {
    List<DietEntity> findByEmail(String email);

    void deleteByEmail(String email);
}
