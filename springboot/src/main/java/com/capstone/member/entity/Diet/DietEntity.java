package com.capstone.member.entity.Diet;


import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name ="diet")
public class DietEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "email")
    private String email;
    @Column(name = "title")
    private String title;
    @Column(name = "texts")
    private String texts;
    @Column(name = "selecteddates")
    private String selectedDates;

    // Getters and setters
}
