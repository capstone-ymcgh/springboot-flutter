package com.capstone.member.repository.recipe;

import com.capstone.member.entity.recipe.PriceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PriceRepository extends JpaRepository<PriceEntity, Long> {
    List<PriceEntity> findAllByProductName(String productName);
}
