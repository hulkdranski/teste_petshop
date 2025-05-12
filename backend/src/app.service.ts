import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AppService {
  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService
  ) {}

  async getNearbyPetshops(latitude: string, longitude: string) {
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

  async getPlaceById(placeId: string) {
    const apiKey = this.configService.get<string>('GOOGLE_MAPS_API_KEY');
    const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=AIzaSyA5BFWe8s_plEE9tc1imjXoi-hqdnSZ5D4`;

    const response = await firstValueFrom(this.httpService.get(url));
    const result = response.data.result;

    return {
      id: placeId,
      nome: result.name,
      latitude: result.geometry.location.lat,
      longitude: result.geometry.location.lng,
      mapsUrl: result.url,
    };
  }
}
