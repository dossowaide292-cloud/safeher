import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { EvidenceModule } from './evidence/evidence.module';
import { HealthController } from './health.controller';
import { PrismaModule } from './prisma/prisma.module';
import { SosModule } from './sos/sos.module';
import { TrustedContactsModule } from './trusted-contacts/trusted-contacts.module';

@Module({
  imports: [PrismaModule, AuthModule, EvidenceModule, SosModule, TrustedContactsModule],
  controllers: [HealthController],
})
export class AppModule {}
