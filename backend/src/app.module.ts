import { HttpModule } from '@nestjs/axios';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './users/user.module';
import { PetModule } from './pets/pet.modules';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Pet } from './pets/pet.entity';
import { User } from './users/user.entity';
import { Store } from './stores/store.entity';
import { Product } from './products/product.entity';
import { StoreModule } from './stores/store.modules';
import { ProductModule } from './products/product.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres', 
      password: 'admin',    
      database: 'saas_petshop',
      entities: [User, Pet, Store, Product],        
      synchronize: true,      
    }),
    HttpModule,
    UserModule,
    PetModule,
    StoreModule,
    ProductModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
