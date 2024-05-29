package com.capstone.member.controller.recipe;

import com.capstone.member.service.recipe.RecipeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;

@Controller
public class RecipeController {

    @Autowired
    private RecipeService recipeService;

    @GetMapping("/meal-plan")
    public String showMealPlanForm() {
        return "recipe_meal_plan"; // 식단 생성 폼을 나타내는 HTML 템플릿의 이름을 반환합니다.
    }

    @GetMapping("/generate-meal-plan")
    @ResponseBody
    public Map<String, Object> generateMealPlan(@RequestParam(required = false) String month,
                                                @RequestParam(required = false, defaultValue = "0") int div,
                                                @RequestParam(required = false, defaultValue = "1") int serving) {
        LocalDate selectedDate = (month != null) ? LocalDate.parse(month) : LocalDate.now();
        return recipeService.recommendMonthlyMealPlan(selectedDate, div, serving);
    }

}



