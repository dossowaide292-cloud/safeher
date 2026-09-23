import { Transform } from 'class-transformer';
import { IsBoolean, IsOptional } from 'class-validator';

export class UploadEvidenceDto {
  @IsOptional()
  @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  encrypted = false;
}
