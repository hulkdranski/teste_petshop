import { Controller, Get } from '@nestjs/common';

@Controller('test')
export class TestController {
  @Get()
  getTest(): any {
    return { message: 'API funcionando!' };
  }
}
