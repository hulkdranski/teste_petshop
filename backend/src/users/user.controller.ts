import { Body, Controller, UseGuards, Post, Patch, NotFoundException, Param, ParseIntPipe } from '@nestjs/common';
import { UserService } from './user.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { AuthGuard } from '../auth/guards/auth.guard';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('create')
  async createProfile(@Body() updateProfileDto: UpdateProfileDto): Promise<any> {
    const user = await this.userService.createProfile(updateProfileDto);
    return { message: 'Perfil criado com sucesso!', user };
  }

  @Post('get-user')
  async getUser(@Body() body: {firebaseuid: string}) {
    const firebaseuid = body.firebaseuid;
    console.log("AAAAAAAAAAAAAAAAA",firebaseuid);
    const user = await this.userService.findByFirebaseUid(firebaseuid);
    if (!user) {
      throw new NotFoundException('Usuário não encontrado.');
    }
    console.log('Firebaseuid user.controller: ', body.firebaseuid)
    console.log("usuario encontrado no user.controller", user);
    return user;
  }

  @Patch(':id/set-seller')
  setUserAsSeller(@Param('id', ParseIntPipe) id: number) {
    return this.userService.setUserAsSeller(id);
  }
}


