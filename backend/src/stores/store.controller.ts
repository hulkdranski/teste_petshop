import { Body, Controller, Post, Req, Get, Query } from '@nestjs/common';
import { CreateStoreDto } from './dto/create-store.dto';
import { StoreService } from './store.service';
import { UserService } from 'src/users/user.service';

@Controller('store')
export class StoreController {
  constructor(private readonly storeService: StoreService,
  private readonly userService: UserService) {}

  @Post('create')
    async createStore(@Body() createStoreDto: CreateStoreDto): Promise<any> {
      const store = await this.storeService.createStore(createStoreDto);
      const firebaseuid = createStoreDto.firebaseuid!;
      
      console.log('loja criada: ' + store);

      if (store) {
        const user = await this.userService.findByFirebaseUid(firebaseuid);

        if (user) {
          await this.userService.setUserAsSeller(user.id);
          console.log('user id encontrado pelo firebaseuid: ' + user.id);
        } else {
          console.log('Usuário não encontrado com firebaseuid: ' + createStoreDto.firebaseuid);
        }

        return {
          message: 'Loja cadastrada com sucesso!',
          store,
        };
      }

      return {
        message: 'Erro ao cadastrar loja.',
      };
    }

  @Get('get-data')
    async getAllPlaceIds(): Promise<string[]> {

      return this.storeService.getAllPlaceIds();
    }
}


