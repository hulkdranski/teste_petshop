import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { Product } from './product.entity';
export declare class ProductController {
    private readonly productService;
    constructor(productService: ProductService);
    createProduct(createProductDto: CreateProductDto): Promise<any>;
    findAll(): Promise<Product[]>;
    updateProduct(id: number, updateProductDto: Partial<Product>): Promise<Product>;
    getProductsByUser(firebaseuid: string): Promise<Product[]>;
}
