import { Repository } from 'typeorm';
import { Pet } from './pet.entity';
import { CreatePetDto } from './dto/create-pet.dto';
import { User } from '../users/user.entity';
export declare class PetService {
    private readonly petRepository;
    private readonly userRepository;
    constructor(petRepository: Repository<Pet>, userRepository: Repository<User>);
    createPet(createPetDto: CreatePetDto): Promise<Pet>;
    findByFirebaseUid(firebaseuid: string): Promise<Pet[]>;
}
