import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSosDto } from './dto/create-sos.dto';

@Injectable()
export class SosService {
  constructor(private readonly prisma: PrismaService) {}

  async create(userId: string, dto: CreateSosDto) {
    const contacts = await this.prisma.trustedContact.findMany({ where: { userId, isActive: true } });
    const alert = await this.prisma.sosAlert.create({
      data: {
        userId,
        latitude: dto.latitude,
        longitude: dto.longitude,
        message: dto.message,
        status: 'TRIGGERED',
        notifications: {
          create: contacts.map((contact) => ({ userId, contactId: contact.id })),
        },
      },
      include: { notifications: { include: { contact: { select: { id: true, name: true, phone: true } } } } },
    });
    await this.prisma.auditLog.create({ data: { userId, action: 'SOS_TRIGGERED', resourceType: 'SosAlert', resourceId: alert.id } });
    return { ...alert, notificationMessage: contacts.length ? 'Contacts préparés pour notification.' : 'Aucun contact actif à notifier.' };
  }

  list(userId: string) {
    return this.prisma.sosAlert.findMany({ where: { userId }, orderBy: { triggeredAt: 'desc' }, take: 50, include: { notifications: { include: { contact: { select: { name: true, phone: true } } } } } });
  }

  async cancel(userId: string, id: string) {
    const existing = await this.prisma.sosAlert.findFirst({ where: { id, userId } });
    if (!existing) throw new NotFoundException('Alerte introuvable');
    return this.prisma.sosAlert.update({ where: { id }, data: { status: 'CANCELLED', resolvedAt: new Date() } });
  }
}
