import { CreatePetDto } from './dto/create-pet.dto';
import { PetService } from './pet.service';
export declare class PetController {
    private readonly petService;
    constructor(petService: PetService);
    createPet(createPetDto: CreatePetDto, request: any): Promise<any>;
    getPet(body: {
        firebaseuid: string;
    }): Promise<import("./pet.entity").Pet[]>;
}
