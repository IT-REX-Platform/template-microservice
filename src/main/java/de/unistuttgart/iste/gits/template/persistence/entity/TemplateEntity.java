package de.unistuttgart.iste.gits.template.persistence.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity(name = "Template")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TemplateEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @Column(nullable = false, length = 255)
    private String name;

}
