import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { createHash, randomUUID } from 'crypto';
import { mkdir, unlink, writeFile } from 'fs/promises';
import { join } from 'path';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EvidenceService {
  private readonly storageDir = process.env.EVIDENCE_STORAGE_DIR ?? join(process.cwd(), 'storage', 'evidence');

  constructor(private readonly prisma: PrismaService) {}

  list(userId: string) {
    return this.prisma.evidence.findMany({ where: { userId }, orderBy: { uploadedAt: 'desc' }, select: { id: true, originalName: true, mimeType: true, size: true, sha256: true, capturedAt: true, uploadedAt: true, encrypted: true } });
  }

  async upload(userId: string, file?: { originalname: string; mimetype: string; size: number; buffer: Buffer }, encrypted = false) {
    if (!file?.buffer?.length) throw new BadRequestException('Un fichier est obligatoire');
    const sha256 = createHash('sha256').update(file.buffer).digest('hex');
    const storageKey = `${userId}/${randomUUID()}.bin`;
    const destination = join(this.storageDir, storageKey);
    await mkdir(join(this.storageDir, userId), { recursive: true });
    await writeFile(destination, file.buffer, { mode: 0o600 });

    try {
      return await this.prisma.evidence.create({
        data: { userId, originalName: file.originalname.slice(0, 255), storageKey, mimeType: file.mimetype || 'application/octet-stream', size: file.size, sha256, encrypted },
        select: { id: true, originalName: true, mimeType: true, size: true, sha256: true, uploadedAt: true, encrypted: true },
      });
    } catch (error) {
      await unlink(destination).catch(() => undefined);
      throw error;
    }
  }

  async remove(userId: string, id: string) {
    const evidence = await this.prisma.evidence.findFirst({ where: { id, userId } });
    if (!evidence) throw new NotFoundException('Preuve introuvable');
    await this.prisma.evidence.delete({ where: { id } });
    await unlink(join(this.storageDir, evidence.storageKey)).catch(() => undefined);
    return { message: 'Preuve supprimée' };
  }
}
