import { Product } from '../products/product.entity';
export declare class Store {
    id: number;
    placeid: string;
    cnpj: string;
    firebaseuid: string;
    products: Product[];
}
