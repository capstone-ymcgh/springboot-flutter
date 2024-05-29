package com.capstone.member.entity.recipe;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Entity
@Table(name = "ingredients")
public class IngredientEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ing_id")
    private Long ingid;

    @Column(name = "r_id")
    private Long rid;

    @Column(name = "ing_name")
    private String ingName;

    @Column(name = "ing_amount")
    private String ingAmount;

    public IngredientEntity(Long ingid, Long rid, String ingName, String ingAmount) {
        this.ingid = ingid;
        this.rid = rid;
        this.ingName = ingName;
        this.ingAmount = ingAmount;
    }

    public IngredientEntity() {
    }
}
