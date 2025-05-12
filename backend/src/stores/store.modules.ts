import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../users/user.entity';
import { StoreController } from './store.controller';
import { StoreService } from './store.service';
import { Store } from './store.entity';
import { UserModule } from 'src/users/user.module';

@Module({
  imports: [TypeOrmModule.forFeature([Store, User]), UserModule],
  providers: [StoreService],
  controllers: [StoreController],
  exports: [StoreModule, TypeOrmModule],
})
export class StoreModule {}
