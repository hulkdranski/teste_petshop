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
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const firebaseAdmin = require("firebase-admin");
let AuthService = class AuthService {
    constructor() {
        if (!firebaseAdmin.apps.length) {
            firebaseAdmin.initializeApp({
                credential: firebaseAdmin.credential.cert('C:/Users/phjesus.RAINHADAPAZ/Documents/Projetos/saas-petshop/saas_petshop/android/app/chave-privada.json'),
            });
        }
    }
    async signUp(email, password) {
        try {
            const userRecord = await firebaseAdmin.auth().createUser({
                email: email,
                password: password,
            });
            return { uid: userRecord.uid, email: userRecord.email };
        }
        catch (error) {
            throw new Error('Erro ao criar usuário: ' + error.message);
        }
    }
    async signIn(email, password) {
        try {
            const userRecord = await firebaseAdmin.auth().getUserByEmail(email);
            return { uid: userRecord.uid, email: userRecord.email };
        }
        catch (error) {
            throw new Error('Credenciais inválidas');
        }
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [])
], AuthService);
//# sourceMappingURL=auth.service.js.map