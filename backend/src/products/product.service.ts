import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './product.entity';
import { Store } from '../stores/store.entity';
import { User } from '../users/user.entity';
import { CreateProductDto } from './dto/create-product.dto';

@Injectable()
export class ProductService {
    constructor(
        @InjectRepository(Product)
        private readonly productRepository: Repository<Product>,

        @InjectRepository(Store)
        private storeRepository: Repository<Store>,

        @InjectRepository(User)
        private readonly userRepository: Repository<User>
      ) {}

    async createProduct(createProductDto: CreateProductDto): Promise<Product> {
      const { nome, descricao, preco, link, firebaseuid } = createProductDto;
  
      const store = await this.storeRepository.findOne({ where: { firebaseuid } });
      if (!store) {
        throw new NotFoundException('Loja não encontrada para esse usuário.');
      }
    
        const product = this.productRepository.create({
          nome,
          descricao,
          preco,
          link,
          store,
        });
    
        return this.productRepository.save(product);
      }

    async findAll(): Promise<Product[]> {
      return this.productRepository.find();
    }

    async updateProduct(id: number, updateProductDto: Partial<Product>): Promise<Product> {
      const product = await this.productRepository.findOne({ where: { id } });
    
      if (!product) {
        throw new NotFoundException(`Produto com ID ${id} não encontrado`);
      }
    
      const updated = Object.assign(product, updateProductDto);
      return this.productRepository.save(updated);
    }

    async getProductsByFirebaseUid(firebaseuid: string): Promise<Product[]> {
      const store = await this.storeRepository.findOne({
        where: { firebaseuid },
      });
  
      if (!store) {
        throw new NotFoundException('Loja não encontrada para este usuário');
      }
  
      return this.productRepository.find({
        where: { store: { id: store.id } },
        relations: ['store'],
      });
    }
}


