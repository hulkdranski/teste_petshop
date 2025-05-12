import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';
import { Product } from '../products/product.entity';

@Entity("stores")
export class Store {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  placeid: string;

  @Column({ nullable: true })
  cnpj: string;

  @Column({ nullable: true })
  firebaseuid: string;

  @OneToMany(() => Product, product => product.store)
  products: Product[];
}
