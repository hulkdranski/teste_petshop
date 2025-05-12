import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Store } from '../stores/store.entity';

@Entity("products")
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: true })
  nome: string;

  @Column({ nullable: true })
  descricao: string;

  @Column('decimal', { precision: 10, scale: 2 , nullable: true})
  preco: number;

  @Column({ nullable: true })
  link: string;

  @ManyToOne(() => Store, store => store.products)
  store: Store;
}
