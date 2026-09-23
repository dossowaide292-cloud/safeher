import { IsOptional, IsPhoneNumber, IsString, MaxLength, MinLength } from 'class-validator';

export class CreateTrustedContactDto {
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  name!: string;

  @IsPhoneNumber(null)
  phone!: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  relationship?: string;
}
