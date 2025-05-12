import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity("users")
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'firebaseuid', unique: true })
  firebaseuid: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  cpf: string;

  @Column({ nullable: true })
  address: string;

  @Column({ default: false })
  isseller: boolean;
}
