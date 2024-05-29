package com.capstone.member.entity.recipe;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Entity
@Table(name = "price")
public class PriceEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "p_id")
    private Long pid;

    @Column(name = "product_name")
    private String productName;

    @Column(name = "update_day")
    private String updateDay;

    @Column(name = "price")
    private Long price;

    @Column(name = "price_gram")
    private Long priceGram;

    public PriceEntity(Long pid, String productName, String updateDay, Long price, Long priceGram){
        this.pid = pid;
        this.productName = productName;
        this.updateDay = updateDay;
        this.priceGram = priceGram;
        this.price = price;
    }

    public PriceEntity() {
    }
}
