import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import { UpdateProfileDto } from './dto/update-profile.dto';

export class UsersModule {}

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async createProfile(updateProfileDto: UpdateProfileDto): Promise<User> {
    const { firebaseuid, name, cpf, address } = updateProfileDto;
  
    let user = await this.userRepository.findOne({ where: { firebaseuid } });
    
    if (user) {
      user.name = user.name ?? name;
      user.cpf = user.cpf ?? cpf;
      user.address = user.address ?? address;

      console.log(`Usuario existe, atualizando dados ${name}, ${cpf}, ${address}`);
    } else {
      user = this.userRepository.create({
        firebaseuid,
        name,
        cpf,
        address,
      });
    }
  
    return await this.userRepository.save(user);
  }

  async findByFirebaseUid(firebaseuid: string): Promise<User | null> {
    console.log('Firebaseuid user.service: ', firebaseuid)
    const user = await this.userRepository.findOne({
      where: {
        firebaseuid: firebaseuid,
      },
    });
    console.log('Usuário encontrado:', user);
    return user;
  }

  async setUserAsSeller(userId: number): Promise<User> {
    const user = await this.userRepository.findOneBy({ id: userId });
    console.log('usuario encontrado com o id que foi passado no controller: ' + user)
    if (!user) throw new Error('Usuário não encontrado');

    user.isseller = true;
    return this.userRepository.save(user);
  }

}