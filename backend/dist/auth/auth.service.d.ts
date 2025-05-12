export declare class AuthService {
    constructor();
    signUp(email: string, password: string): Promise<any>;
    signIn(email: string, password: string): Promise<any>;
}
