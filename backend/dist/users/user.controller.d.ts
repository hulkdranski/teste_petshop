import { UserService } from './user.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
export declare class UserController {
    private readonly userService;
    constructor(userService: UserService);
    createProfile(updateProfileDto: UpdateProfileDto): Promise<any>;
    getUser(body: {
        firebaseuid: string;
    }): Promise<import("./user.entity").User>;
    setUserAsSeller(id: number): Promise<import("./user.entity").User>;
}
