package com.capstone.member.controller.Diet;

import com.capstone.member.dto.Diet.DietDto;
import com.capstone.member.entity.Diet.DietEntity;
import com.capstone.member.repository.Diet.DietRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class DietController {

    @Autowired
    private DietRepository dietRepository;

    @PostMapping("/api/diet/save")
    public ResponseEntity<String> saveDiet(@RequestBody DietDto request) {
        try {
            DietEntity diet = new DietEntity();
            diet.setEmail(request.getEmail());
            diet.setTitle(request.getTitle());
            diet.setTexts(request.getTexts());
            diet.setSelectedDates(request.getSelectedDates());
            dietRepository.save(diet);
            return new ResponseEntity<>("Diet saved successfully.", HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to save diet.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/api/diet/{email}")
    public ResponseEntity<List<DietEntity>> getDietsByEmail(@PathVariable String email) {
        try {
            List<DietEntity> diets = dietRepository.findByEmail(email);
            if (diets.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            return new ResponseEntity<>(diets, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
