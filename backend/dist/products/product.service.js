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
exports.ProductService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const product_entity_1 = require("./product.entity");
const store_entity_1 = require("../stores/store.entity");
const user_entity_1 = require("../users/user.entity");
let ProductService = class ProductService {
    productRepository;
    storeRepository;
    userRepository;
    constructor(productRepository, storeRepository, userRepository) {
        this.productRepository = productRepository;
        this.storeRepository = storeRepository;
        this.userRepository = userRepository;
    }
    async createProduct(createProductDto) {
        const { nome, descricao, preco, link, firebaseuid } = createProductDto;
        const store = await this.storeRepository.findOne({ where: { firebaseuid } });
        if (!store) {
            throw new common_1.NotFoundException('Loja não encontrada para esse usuário.');
        }
        const product = this.productRepository.create({
            nome,
            descricao,
            preco,
            link,
            store,
        });
        return this.productRepository.save(product);
    }
    async findAll() {
        return this.productRepository.find();
    }
    async updateProduct(id, updateProductDto) {
        const product = await this.productRepository.findOne({ where: { id } });
        if (!product) {
            throw new common_1.NotFoundException(`Produto com ID ${id} não encontrado`);
        }
        const updated = Object.assign(product, updateProductDto);
        return this.productRepository.save(updated);
    }
    async getProductsByFirebaseUid(firebaseuid) {
        const store = await this.storeRepository.findOne({
            where: { firebaseuid },
        });
        if (!store) {
            throw new common_1.NotFoundException('Loja não encontrada para este usuário');
        }
        return this.productRepository.find({
            where: { store: { id: store.id } },
            relations: ['store'],
        });
    }
};
exports.ProductService = ProductService;
exports.ProductService = ProductService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(product_entity_1.Product)),
    __param(1, (0, typeorm_1.InjectRepository)(store_entity_1.Store)),
    __param(2, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], ProductService);
//# sourceMappingURL=product.service.js.map