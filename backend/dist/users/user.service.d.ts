import { Repository } from 'typeorm';
import { User } from './user.entity';
import { UpdateProfileDto } from './dto/update-profile.dto';
export declare class UsersModule {
}
export declare class UserService {
    private readonly userRepository;
    constructor(userRepository: Repository<User>);
    createProfile(updateProfileDto: UpdateProfileDto): Promise<User>;
    findByFirebaseUid(firebaseuid: string): Promise<User | null>;
    setUserAsSeller(userId: number): Promise<User>;
}
