import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Store } from '../stores/store.entity';
import { ProductController } from './product.controller';
import { ProductService } from './product.service';
import { Product } from './product.entity';
import { UserModule } from 'src/users/user.module';
import { StoreModule } from 'src/stores/store.modules';

@Module({
  imports: [TypeOrmModule.forFeature([Product, Store]), UserModule, StoreModule],
  providers: [ProductService],
  controllers: [ProductController],
  exports: [ProductModule],
})
export class ProductModule {}
