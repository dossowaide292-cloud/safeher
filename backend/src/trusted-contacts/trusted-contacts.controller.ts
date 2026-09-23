import { Body, Controller, Delete, Get, Param, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Request } from 'express';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateTrustedContactDto } from './dto/create-trusted-contact.dto';
import { UpdateTrustedContactDto } from './dto/update-trusted-contact.dto';
import { TrustedContactsService } from './trusted-contacts.service';

@ApiTags('trusted-contacts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('trusted-contacts')
export class TrustedContactsController {
  constructor(private readonly service: TrustedContactsService) {}

  @Get()
  list(@Req() request: Request & { user: { sub: string } }) {
    return this.service.list(request.user.sub);
  }

  @Post()
  create(@Req() request: Request & { user: { sub: string } }, @Body() dto: CreateTrustedContactDto) {
    return this.service.create(request.user.sub, dto);
  }

  @Patch(':id')
  update(@Req() request: Request & { user: { sub: string } }, @Param('id') id: string, @Body() dto: UpdateTrustedContactDto) {
    return this.service.update(request.user.sub, id, dto);
  }

  @Delete(':id')
  remove(@Req() request: Request & { user: { sub: string } }, @Param('id') id: string) {
    return this.service.remove(request.user.sub, id);
  }
}
