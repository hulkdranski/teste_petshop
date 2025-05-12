"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserService = exports.UsersModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("./user.entity");
class UsersModule {
}
exports.UsersModule = UsersModule;
let UserService = class UserService {
    userRepository;
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async createProfile(updateProfileDto) {
        const { firebaseuid, name, cpf, address } = updateProfileDto;
        let user = await this.userRepository.findOne({ where: { firebaseuid } });
        if (user) {
            user.name = user.name ?? name;
            user.cpf = user.cpf ?? cpf;
            user.address = user.address ?? address;
            console.log(`Usuario existe, atualizando dados ${name}, ${cpf}, ${address}`);
        }
        else {
            user = this.userRepository.create({
                firebaseuid,
                name,
                cpf,
                address,
            });
        }
        return await this.userRepository.save(user);
    }
    async findByFirebaseUid(firebaseuid) {
        console.log('Firebaseuid user.service: ', firebaseuid);
        const user = await this.userRepository.findOne({
            where: {
                firebaseuid: firebaseuid,
            },
        });
        console.log('Usuário encontrado:', user);
        return user;
    }
    async setUserAsSeller(userId) {
        const user = await this.userRepository.findOneBy({ id: userId });
        console.log('usuario encontrado com o id que foi passado no controller: ' + user);
        if (!user)
            throw new Error('Usuário não encontrado');
        user.isseller = true;
        return this.userRepository.save(user);
    }
};
exports.UserService = UserService;
exports.UserService = UserService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], UserService);
//# sourceMappingURL=user.service.js.map