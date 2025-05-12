import { Body, Controller, NotFoundException, Post, Req } from '@nestjs/common';
import { CreatePetDto } from './dto/create-pet.dto';
import { PetService } from './pet.service';

@Controller('pets')
export class PetController {
  constructor(private readonly petService: PetService) {}
  @Post('create')
  async createPet(@Body() createPetDto: CreatePetDto, @Req() request: any): Promise<any> {
    const pet = await this.petService.createPet(createPetDto);
    console.log(createPetDto);
    return { message: 'Pet cadastrado com sucesso!', pet };
  }

    @Post('get-data')
    async getPet(@Body() body: {firebaseuid: string}) {
      const firebaseuid = body.firebaseuid;
      const pets = await this.petService.findByFirebaseUid(firebaseuid);
      if (pets.length === 0) {
        throw new NotFoundException('Este usuário não possui um pet.');
      }
      return pets;
    }
}


