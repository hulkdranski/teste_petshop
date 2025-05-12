import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';

@Entity("pets")
export class Pet {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ nullable: true })
  raca: string;

  @Column({ nullable: true })
  idade: string;

  @Column({ nullable: true })
  sexo: string;

  @Column({ nullable: true })
  obs: string;

  @Column({ nullable: true })
  firebaseuid: string;
}
