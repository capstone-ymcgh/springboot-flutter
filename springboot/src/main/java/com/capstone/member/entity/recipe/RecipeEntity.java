package com.capstone.member.entity.recipe;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;


@Setter
@Getter
@Entity
@Table(name = "recipe")
public class RecipeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "r_id")
    private Long rid;

    @Column(name = "title")
    private String title;

    @Column(name = "category")
    private String category;

    @Column(name = "eng")
    private String eng;

    @Column(name = "car")
    private String car;

    @Column(name = "pro")
    private String pro;

    @Column(name = "fat")
    private String fat;

    @Column(name = "na")
    private String na;

    @Column(name = "image")
    private String image;

    public RecipeEntity(Long rid, String title, String category, String eng, String car, String pro, String fat, String na, String image){
        this.rid = rid;
        this.title = title;
        this.category = category;
        this.eng = eng;
        this.car = car;
        this.pro = pro;
        this.fat = fat;
        this.na = na;
        this.image = image;
    }

    public RecipeEntity() {

    }

}
