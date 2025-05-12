"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const axios_1 = require("@nestjs/axios");
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const user_module_1 = require("./users/user.module");
const pet_modules_1 = require("./pets/pet.modules");
const typeorm_1 = require("@nestjs/typeorm");
const pet_entity_1 = require("./pets/pet.entity");
const user_entity_1 = require("./users/user.entity");
const store_entity_1 = require("./stores/store.entity");
const product_entity_1 = require("./products/product.entity");
const store_modules_1 = require("./stores/store.modules");
const product_module_1 = require("./products/product.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot(),
            typeorm_1.TypeOrmModule.forRoot({
                type: 'postgres',
                host: 'localhost',
                port: 5432,
                username: 'postgres',
                password: 'admin',
                database: 'saas_petshop',
                entities: [user_entity_1.User, pet_entity_1.Pet, store_entity_1.Store, product_entity_1.Product],
                synchronize: true,
            }),
            axios_1.HttpModule,
            user_module_1.UserModule,
            pet_modules_1.PetModule,
            store_modules_1.StoreModule,
            product_module_1.ProductModule,
        ],
        controllers: [app_controller_1.AppController],
        providers: [app_service_1.AppService],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map