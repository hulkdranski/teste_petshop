import { Injectable } from '@nestjs/common';
import * as firebaseAdmin from 'firebase-admin';

@Injectable()
export class AuthService {
  constructor() {
    if (!firebaseAdmin.apps.length) {
      firebaseAdmin.initializeApp({
        credential: firebaseAdmin.credential.cert('C:/Users/phjesus.RAINHADAPAZ/Documents/Projetos/saas-petshop/saas_petshop/android/app/chave-privada.json'), // Altere para o caminho correto do seu arquivo JSON
      });
    }
  }

  async signUp(email: string, password: string): Promise<any> {
    try {
      const userRecord = await firebaseAdmin.auth().createUser({
        email: email,
        password: password,
      });
      return { uid: userRecord.uid, email: userRecord.email };
    } catch (error) {
      throw new Error('Erro ao criar usuário: ' + error.message);
    }
  }

  async signIn(email: string, password: string): Promise<any> {
    try {
      const userRecord = await firebaseAdmin.auth().getUserByEmail(email);
      return { uid: userRecord.uid, email: userRecord.email };
    } catch (error) {
      throw new Error('Credenciais inválidas');
    }
  }
}
