import { IsBoolean, IsOptional, IsPhoneNumber, IsString, MaxLength, MinLength } from 'class-validator';

export class UpdateTrustedContactDto {
  @IsOptional()
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  name?: string;

  @IsOptional()
  @IsPhoneNumber(null)
  phone?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  relationship?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
