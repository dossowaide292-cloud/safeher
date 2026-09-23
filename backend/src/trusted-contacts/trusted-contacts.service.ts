import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateTrustedContactDto } from './dto/create-trusted-contact.dto';
import { UpdateTrustedContactDto } from './dto/update-trusted-contact.dto';

@Injectable()
export class TrustedContactsService {
  constructor(private readonly prisma: PrismaService) {}

  list(userId: string) {
    return this.prisma.trustedContact.findMany({ where: { userId }, orderBy: { createdAt: 'asc' } });
  }

  create(userId: string, dto: CreateTrustedContactDto) {
    return this.prisma.trustedContact.create({ data: { userId, ...dto } });
  }

  async update(userId: string, id: string, dto: UpdateTrustedContactDto) {
    await this.ensureOwned(userId, id);
    return this.prisma.trustedContact.update({ where: { id }, data: dto });
  }

  async remove(userId: string, id: string) {
    await this.ensureOwned(userId, id);
    await this.prisma.trustedContact.delete({ where: { id } });
    return { message: 'Contact supprimé' };
  }

  private async ensureOwned(userId: string, id: string) {
    const contact = await this.prisma.trustedContact.findFirst({ where: { id, userId } });
    if (!contact) throw new NotFoundException('Contact introuvable');
  }
}
