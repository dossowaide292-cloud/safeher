import { Body, Controller, Delete, Get, Param, Post, Req, Res, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { Response, Request } from 'express';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { EvidenceService } from './evidence.service';
import { UploadEvidenceDto } from './dto/upload-evidence.dto';

@ApiTags('evidence')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('evidence')
export class EvidenceController {
  constructor(private readonly service: EvidenceService) {}

  @Get()
  list(@Req() request: Request & { user: { sub: string } }) {
    return this.service.list(request.user.sub);
  }

  @Get(':id/download')
  async download(@Req() request: Request & { user: { sub: string } }, @Param('id') id: string, @Res() response: Response) {
    const evidence = await this.service.getDownload(request.user.sub, id);
    response.setHeader('Content-Type', evidence.mimeType);
    response.setHeader('Content-Length', evidence.size);
    response.setHeader('Content-Disposition', `attachment; filename="${evidence.downloadName}"`);
    return evidence.stream.pipe(response);
  }

  @Post('upload')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: 25 * 1024 * 1024 } }))
  upload(
    @Req() request: Request & { user: { sub: string } },
    @UploadedFile() file: { originalname: string; mimetype: string; size: number; buffer: Buffer } | undefined,
    @Body() body: UploadEvidenceDto,
  ) {
    return this.service.upload(request.user.sub, file, body.encrypted);
  }

  @Delete(':id')
  remove(@Req() request: Request & { user: { sub: string } }, @Param('id') id: string) {
    return this.service.remove(request.user.sub, id);
  }
}
