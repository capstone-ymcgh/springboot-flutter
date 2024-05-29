package com.capstone.member.repository.recipe;

import com.capstone.member.entity.recipe.RecipeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecipeRepository extends JpaRepository<RecipeEntity, Long> {
    List<RecipeEntity> findByCategory(String category);
}
