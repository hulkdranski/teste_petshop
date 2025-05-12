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
exports.StoreController = void 0;
const common_1 = require("@nestjs/common");
const create_store_dto_1 = require("./dto/create-store.dto");
const store_service_1 = require("./store.service");
const user_service_1 = require("../users/user.service");
let StoreController = class StoreController {
    storeService;
    userService;
    constructor(storeService, userService) {
        this.storeService = storeService;
        this.userService = userService;
    }
    async createStore(createStoreDto) {
        const store = await this.storeService.createStore(createStoreDto);
        const firebaseuid = createStoreDto.firebaseuid;
        console.log('loja criada: ' + store);
        if (store) {
            const user = await this.userService.findByFirebaseUid(firebaseuid);
            if (user) {
                await this.userService.setUserAsSeller(user.id);
                console.log('user id encontrado pelo firebaseuid: ' + user.id);
            }
            else {
                console.log('Usuário não encontrado com firebaseuid: ' + createStoreDto.firebaseuid);
            }
            return {
                message: 'Loja cadastrada com sucesso!',
                store,
            };
        }
        return {
            message: 'Erro ao cadastrar loja.',
        };
    }
    async getAllPlaceIds() {
        return this.storeService.getAllPlaceIds();
    }
};
exports.StoreController = StoreController;
__decorate([
    (0, common_1.Post)('create'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_store_dto_1.CreateStoreDto]),
    __metadata("design:returntype", Promise)
], StoreController.prototype, "createStore", null);
__decorate([
    (0, common_1.Get)('get-data'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], StoreController.prototype, "getAllPlaceIds", null);
exports.StoreController = StoreController = __decorate([
    (0, common_1.Controller)('store'),
    __metadata("design:paramtypes", [store_service_1.StoreService,
        user_service_1.UserService])
], StoreController);
//# sourceMappingURL=store.controller.js.map