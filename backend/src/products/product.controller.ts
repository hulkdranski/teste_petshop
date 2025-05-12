import { Body, Controller, Post, Req, Get, Query, Put, Param, NotFoundException } from '@nestjs/common';
import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { Product } from './product.entity';

@Controller('product')
export class ProductController{
    constructor(private readonly productService : ProductService) {}

    @Post('create')
        async createProduct(@Body() createProductDto: CreateProductDto): Promise<any> {
          const product = await this.productService.createProduct(createProductDto);
    
          if (product){
            console.log('Produto criado')
          };
        }

    @Get()
    async findAll(): Promise<Product[]> {
      return this.productService.findAll();
    }

    @Put(':id')
      async updateProduct(
        @Param('id') id: number,
        @Body() updateProductDto: Partial<Product>
      ): Promise<Product> {
        return this.productService.updateProduct(id, updateProductDto);
      }

    @Get('get-products/:firebaseuid')
    async getProductsByUser(@Param('firebaseuid') firebaseuid: string): Promise<Product[]> {
      return this.productService.getProductsByFirebaseUid(firebaseuid);
    }
};