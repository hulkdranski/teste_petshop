import { Injectable, UnauthorizedException } from '@nestjs/common';
import { CanActivate, ExecutionContext } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class AuthGuard implements CanActivate {
  async canActivate(
    context: ExecutionContext,
  ): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers['authorization'];

    if (!authHeader) {
      throw new UnauthorizedException('Token não fornecido');
    }

    // Verifica se o token está no formato "Bearer <token>"
    const [, token] = authHeader.split(' ');

    if (!token) {
      throw new UnauthorizedException('Token mal formado');
    }

    try {
      const decodedToken = await admin.auth().verifyIdToken(token);
      request.user = decodedToken; 
      return true;
    } catch (error) {
      throw new UnauthorizedException('Token inválido');
    }
  }
}
