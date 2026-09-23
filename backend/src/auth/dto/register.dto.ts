import { IsEmail, IsOptional, IsPhoneNumber, IsString, Matches, MinLength, ValidateIf } from 'class-validator';

export class RegisterDto {
  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsPhoneNumber(null)
  phone?: string;

  @IsString()
  @MinLength(8)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, { message: 'Le mot de passe doit contenir une majuscule, une minuscule et un chiffre' })
  password!: string;
}
