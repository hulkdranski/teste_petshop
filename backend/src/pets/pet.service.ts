import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Pet } from './pet.entity';
import { CreatePetDto } from './dto/create-pet.dto';
import { User } from '../users/user.entity';

@Injectable()
export class PetService {
  constructor(
    @InjectRepository(Pet)
    private readonly petRepository: Repository<Pet>,

    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async createPet(createPetDto: CreatePetDto): Promise<Pet>{
    const pet = this.petRepository.create({
      name: createPetDto.name,
      raca: createPetDto.raca,
      idade: createPetDto.idade,
      sexo: createPetDto.sexo,
      obs: createPetDto.obs,
      firebaseuid: createPetDto.firebaseuid,
    });

    return this.petRepository.save(pet);
  }

  async findByFirebaseUid(firebaseuid: string): Promise<Pet[]> {
    console.log('Firebaseuid pet.service: ', firebaseuid)
    const pet = await this.petRepository.find({
      where: {
        firebaseuid: firebaseuid,
      },
    });
    console.log('pet(s) encontrado(s):', pet);
    return pet;
  }
  
}
