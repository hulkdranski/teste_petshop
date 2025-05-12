import { Repository } from 'typeorm';
import { Product } from './product.entity';
import { Store } from '../stores/store.entity';
import { User } from '../users/user.entity';
import { CreateProductDto } from './dto/create-product.dto';
export declare class ProductService {
    private readonly productRepository;
    private storeRepository;
    private readonly userRepository;
    constructor(productRepository: Repository<Product>, storeRepository: Repository<Store>, userRepository: Repository<User>);
    createProduct(createProductDto: CreateProductDto): Promise<Product>;
    findAll(): Promise<Product[]>;
    updateProduct(id: number, updateProductDto: Partial<Product>): Promise<Product>;
    getProductsByFirebaseUid(firebaseuid: string): Promise<Product[]>;
}
