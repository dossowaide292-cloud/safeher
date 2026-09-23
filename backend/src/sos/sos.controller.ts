import { Body, Controller, Get, Param, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Request } from 'express';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateSosDto } from './dto/create-sos.dto';
import { SosService } from './sos.service';

@ApiTags('sos')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('sos')
export class SosController {
  constructor(private readonly sosService: SosService) {}

  @Post()
  create(@Req() request: Request & { user: { sub: string } }, @Body() dto: CreateSosDto) {
    return this.sosService.create(request.user.sub, dto);
  }

  @Get()
  list(@Req() request: Request & { user: { sub: string } }) {
    return this.sosService.list(request.user.sub);
  }

  @Patch(':id/cancel')
  cancel(@Req() request: Request & { user: { sub: string } }, @Param('id') id: string) {
    return this.sosService.cancel(request.user.sub, id);
  }
}
