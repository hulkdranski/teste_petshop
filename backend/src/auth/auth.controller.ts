import { Body, Controller, Put, UseGuards, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UserService } from '../users/user.service';
import { UpdateProfileDto } from '../users/dto/update-profile.dto';
import { AuthGuard } from './guards/auth.guard';

@Controller('auth')
export class AuthController {
}
