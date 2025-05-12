import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
export declare class AppService {
    private readonly httpService;
    private readonly configService;
    constructor(httpService: HttpService, configService: ConfigService);
    getNearbyPetshops(latitude: string, longitude: string): Promise<{
        id: number;
        nome: string;
        latitude: number;
        longitude: number;
    }[]>;
    getPlaceById(placeId: string): Promise<{
        id: string;
        nome: any;
        latitude: any;
        longitude: any;
        mapsUrl: any;
    }>;
}
