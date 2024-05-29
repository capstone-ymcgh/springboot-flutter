package com.capstone.member.repository.recipe;

import com.capstone.member.entity.recipe.IngredientEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IngredientRepository extends JpaRepository<IngredientEntity, Long> {
    List<IngredientEntity> findByRid(Long rid);
}
