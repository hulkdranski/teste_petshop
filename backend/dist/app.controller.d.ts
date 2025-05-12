import { AppService } from './app.service';
export declare class AppController {
    private readonly appService;
    constructor(appService: AppService);
    getNearbyPetshops(latitude: string, longitude: string): Promise<{
        id: number;
        nome: string;
        latitude: number;
        longitude: number;
    }[]>;
    getPetshopByPlaceId(placeId: string): Promise<{
        id: string;
        nome: any;
        latitude: any;
        longitude: any;
        mapsUrl: any;
    }>;
}
