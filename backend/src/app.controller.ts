import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('petshops-proximos')
  async getNearbyPetshops(
    @Query('lat') latitude: string,
    @Query('lng') longitude: string,
  ) {
    return this.appService.getNearbyPetshops(latitude, longitude);
  }

  @Get('petshop')
    async getPetshopByPlaceId(@Query('placeId') placeId: string) {
     return this.appService.getPlaceById(placeId);
    }
}
