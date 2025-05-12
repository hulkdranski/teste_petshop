import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Store } from './store.entity';
import { CreateStoreDto } from './dto/create-store.dto';

@Injectable()
export class StoreService {
    constructor(
        @InjectRepository(Store)
        private readonly storeRepository: Repository<Store>,
    
      ) {}

  async createStore(createStoreDto: CreateStoreDto): Promise<Store>{ 
      const store = this.storeRepository.create({
        placeid: createStoreDto.placeid,
        cnpj: createStoreDto.cnpj,
        firebaseuid: createStoreDto.firebaseuid,
      });
  
      return this.storeRepository.save(store);
    }

  async getAllPlaceIds(): Promise<string[]> {
    const stores = await this.storeRepository.find({
      select: ['placeid'],
    });
    return stores.map(store => store.placeid);
  }
    
}
