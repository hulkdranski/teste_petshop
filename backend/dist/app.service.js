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
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppService = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = require("@nestjs/axios");
const rxjs_1 = require("rxjs");
const config_1 = require("@nestjs/config");
let AppService = class AppService {
    httpService;
    configService;
    constructor(httpService, configService) {
        this.httpService = httpService;
        this.configService = configService;
    }
    async getNearbyPetshops(latitude, longitude) {
        return [
            {
                id: 1,
                nome: 'PetShop do João',
                latitude: -23.563099,
                longitude: -46.654321,
            },
            {
                id: 2,
                nome: 'Amigo Pet',
                latitude: -23.555500,
                longitude: -46.640000,
            },
            {
                id: 3,
                nome: 'Veterinária Vida Animal',
                latitude: -23.570000,
                longitude: -46.650000,
            },
        ];
    }
    async getPlaceById(placeId) {
        const apiKey = this.configService.get('GOOGLE_MAPS_API_KEY');
        const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=AIzaSyA5BFWe8s_plEE9tc1imjXoi-hqdnSZ5D4`;
        const response = await (0, rxjs_1.firstValueFrom)(this.httpService.get(url));
        const result = response.data.result;
        return {
            id: placeId,
            nome: result.name,
            latitude: result.geometry.location.lat,
            longitude: result.geometry.location.lng,
            mapsUrl: result.url,
        };
    }
};
exports.AppService = AppService;
exports.AppService = AppService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [axios_1.HttpService,
        config_1.ConfigService])
], AppService);
//# sourceMappingURL=app.service.js.map