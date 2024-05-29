package com.capstone.member.service.recipe;

import com.capstone.member.entity.recipe.IngredientEntity;
import com.capstone.member.entity.recipe.PriceEntity;
import com.capstone.member.entity.recipe.RecipeEntity;
import com.capstone.member.repository.recipe.IngredientRepository;
import com.capstone.member.repository.recipe.PriceRepository;
import com.capstone.member.repository.recipe.RecipeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DecimalFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.*;

@Service
public class RecipeService {

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private PriceRepository priceRepository;


    // 식단을 추천해 주는 함수
    public Map<String, Object> recommendMonthlyMealPlan(LocalDate selectedDate, int div, int servings) {
        List<Map<String, Object>> monthlyMealPlan = new ArrayList<>(); // 월별 식단을 담을 리스트
        double totalMonthlyPrice = 0; // 전체 식단의 총 가격을 담을 변수
        int daysInMonth = selectedDate.lengthOfMonth(); // 선택한 날짜의 해당 월의 일 수 가져오기

        for (int i = 1; i <= daysInMonth; i++) {
            LocalDate currentDate = selectedDate.withDayOfMonth(i);
            if (isWeekday(currentDate)) { // 주말 및 공휴일이 아닌 경우에만 처리
                List<RecipeEntity> dailyRecipes = getRandomRecipesByCategory(); // 하루에 6가지 추천
                while (!validateNutritionalComposition(dailyRecipes, div)) {
                    dailyRecipes = getRandomRecipesByCategory(); // 영양소 조건을 만족하지 못하면 다시 추천
                }

                List<List<String>> dailyMealPlan = convertToTitleListWithNutritionalInfo(dailyRecipes); // 출력으로 메뉴명과 영양성분만 표시해주는 함수
                double totalPrice = calculateTotalPrice(dailyRecipes) * servings; // 인분 수를 반영하여 총 가격 계산
                totalMonthlyPrice += totalPrice; // 월별 총 가격에 추가

                Map<String, Object> dailyMealPlanWithPrice = new HashMap<>();
                dailyMealPlanWithPrice.put("date",currentDate);
                dailyMealPlanWithPrice.put("mealPlan", dailyMealPlan);
                dailyMealPlanWithPrice.put("totalPrice", formatPrice(totalPrice)); // 가격 형식 변환
                //dailyMealPlanWithPrice.put("servings", servings); // 인분 수 추가
                monthlyMealPlan.add(dailyMealPlanWithPrice);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("monthlyMealPlan", monthlyMealPlan);
       // result.put("totalMonthlyPrice", formatPrice(totalMonthlyPrice)); // 월별 총 가격도 가격 형식 변환

        return result;
    }


    // 가격을 형식에 맞게 변환하는 메서드
    private String formatPrice(double price) {
        DecimalFormat decimalFormat = new DecimalFormat("###,###원");
        return decimalFormat.format(price);
    }

    // 주말 및 공휴일 여부를 확인하는 메서드
    private boolean isWeekday(LocalDate date) {
        DayOfWeek dayOfWeek = date.getDayOfWeek();
        return dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY;
    }

    // 레시피 별 총 가격 계산 함수
    private double calculateTotalPrice(List<RecipeEntity> recipes) {
        double totalPrice = 0;

        for (RecipeEntity recipe : recipes) {
            List<IngredientEntity> ingredients = ingredientRepository.findByRid(recipe.getRid());

            for (IngredientEntity ingredient : ingredients) {
                List<PriceEntity> prices = priceRepository.findAllByProductName(ingredient.getIngName());

                for (PriceEntity price : prices) {
                    double ingredientAmount = Double.parseDouble(ingredient.getIngAmount());
                    double pricePerGram = price.getPriceGram();
                    totalPrice += ingredientAmount * pricePerGram;
                }
            }
        }

        return totalPrice;
    }

    // 각 카테고리에서 랜덤한 레시피를 선택하는 함수
    private List<RecipeEntity> getRandomRecipesByCategory() {
        List<RecipeEntity> allRecipes = recipeRepository.findAll();
        Map<String, RecipeEntity> categoryMap = new LinkedHashMap<>(); // 카테고리별 식단을 저장할 맵

        // 각 카테고리에서 랜덤하게 레시피 선택
        categoryMap.put("밥", getRandomRecipeByCategory(allRecipes, "밥"));
        categoryMap.put("국&찌개", getRandomRecipeByCategory(allRecipes, "국&찌개"));
        categoryMap.put("일품", getRandomRecipeByCategory(allRecipes, "일품"));
        categoryMap.put("반찬", getRandomRecipeByCategory(allRecipes, "반찬"));
        categoryMap.put("나물/샐러드", getRandomRecipeByCategory(allRecipes, "나물/샐러드"));
        categoryMap.put("김치", getRandomRecipeByCategory(allRecipes, "김치"));

        return new ArrayList<>(categoryMap.values());
    }

    // 카테고리 내에서 메뉴를 추천해 줄 함수
    private RecipeEntity getRandomRecipeByCategory(List<RecipeEntity> recipes, String category) {
        List<RecipeEntity> categoryRecipes = new ArrayList<>(); // 카테고리별 레시피를 담을 리스트
        for (RecipeEntity recipe : recipes) {
            if (recipe.getCategory().equals(category)) { // 주어진 카테고리와 동일한 카테고리의 레시피만 추가
                categoryRecipes.add(recipe);
            }
        }
        if (categoryRecipes.isEmpty()) {
            return null;
        }
        return categoryRecipes.get(new Random().nextInt(categoryRecipes.size())); // 리스트 내에서 랜덤하게 1가지 선택해서 리턴
    }

    // 해당 식단의 영양성분이 기준에 충족되는지 확인하는 함수
    private boolean validateNutritionalComposition(List<RecipeEntity> recipes, int div) {
        double totalCalories = 0;
        double totalCarbohydrates = 0;
        double totalProteins = 0;
        double totalFats = 0;

        for (RecipeEntity recipe : recipes) { // 각 메뉴별 칼로리, 탄수화물, 단백질, 지방 값 합산
            totalCalories += Double.parseDouble(recipe.getEng());
            totalCarbohydrates += Double.parseDouble(recipe.getCar());
            totalProteins += Double.parseDouble(recipe.getPro());
            totalFats += Double.parseDouble(recipe.getFat());
        }

        // 열량 조건 검사
        if(div == 0){ // 일반적인 성인 기준
            if (totalCalories <= 650 || totalCalories >= 750) {
                return false;
            }
        } else { // 중/고등학교 학생 기준
            if (totalCalories <= 850 || totalCalories >= 900) {
                return false;
            }
        }

        // 탄수화물 조건 검사 (전체 칼로리의 65% 이하)
        double carbPercentage = (totalCarbohydrates / totalCalories) * 100;
        if (carbPercentage >= 65) {
            return false;
        }

        // 단백질 조건 검사 (전체 칼로리의 20% 이하)
        double proteinPercentage = (totalProteins / totalCalories) * 100;
        if (proteinPercentage >= 20) {
            return false;
        }

        // 지방 조건 검사 (전체 칼로리의 30% 이하)
        double fatPercentage = (totalFats / totalCalories) * 100;
        if (fatPercentage >= 30) {
            return false;
        }

        return true;
    }

    // 출력 형식이 제목 + 영양성분만 출력되게 수정해주는 함수
    private List<List<String>> convertToTitleListWithNutritionalInfo(List<RecipeEntity> recipes) {
        List<List<String>> mealPlan = new ArrayList<>();
        double totalCalories = 0;
        double totalCarbohydrates = 0;
        double totalProteins = 0;
        double totalFats = 0;

        for (RecipeEntity recipe : recipes) {
            totalCalories += Double.parseDouble(recipe.getEng());
            totalCarbohydrates += Double.parseDouble(recipe.getCar());
            totalProteins += Double.parseDouble(recipe.getPro());
            totalFats += Double.parseDouble(recipe.getFat());

            mealPlan.add(Collections.singletonList(formatRecipeWithNutritionalInfo(recipe)));
        }

       // mealPlan.add(Collections.singletonList(formatNutritionalInfo(totalCalories, totalCarbohydrates, totalProteins, totalFats)));

        return mealPlan;
    }

    // 각 메뉴별 메뉴명 및 영양성분 출력 함수
   /* private String formatRecipeWithNutritionalInfo(RecipeEntity recipe) {
        return String.format("%s: %s (열량: %.1fkcal, 탄수화물: %.1fg, 단백질: %.1fg, 지방: %.1fg)",
                recipe.getCategory(), recipe.getTitle(), Double.parseDouble(recipe.getEng()),
                Double.parseDouble(recipe.getCar()), Double.parseDouble(recipe.getPro()), Double.parseDouble(recipe.getFat()));
    }*/
    private String formatRecipeWithNutritionalInfo(RecipeEntity recipe) {
        return String.format("%s: %s",
                recipe.getCategory(), recipe.getTitle());
    }

    // 식단의 영양성분 출력 함수
    private String formatNutritionalInfo(double totalCalories, double totalCarbohydrates, double totalProteins, double totalFats) {
        return String.format("총 열량: %.1fkcal, 탄수화물: %.1fg, 단백질: %.1fg, 지방: %.1fg",
                totalCalories, totalCarbohydrates, totalProteins, totalFats);
    }
}

