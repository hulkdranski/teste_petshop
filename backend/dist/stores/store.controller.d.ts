import { CreateStoreDto } from './dto/create-store.dto';
import { StoreService } from './store.service';
import { UserService } from 'src/users/user.service';
export declare class StoreController {
    private readonly storeService;
    private readonly userService;
    constructor(storeService: StoreService, userService: UserService);
    createStore(createStoreDto: CreateStoreDto): Promise<any>;
    getAllPlaceIds(): Promise<string[]>;
}
