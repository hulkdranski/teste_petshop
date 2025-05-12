import { Repository } from 'typeorm';
import { Store } from './store.entity';
import { CreateStoreDto } from './dto/create-store.dto';
export declare class StoreService {
    private readonly storeRepository;
    constructor(storeRepository: Repository<Store>);
    createStore(createStoreDto: CreateStoreDto): Promise<Store>;
    getAllPlaceIds(): Promise<string[]>;
}
