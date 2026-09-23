import { IsLatitude, IsLongitude, IsOptional, IsString, MaxLength } from 'class-validator';

export class CreateSosDto {
  @IsOptional()
  @IsLatitude()
  latitude?: number;

  @IsOptional()
  @IsLongitude()
  longitude?: number;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  message?: string;
}
