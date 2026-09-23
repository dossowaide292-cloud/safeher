import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { HealthController } from './health.controller';
import { PrismaModule } from './prisma/prisma.module';
import { SosModule } from './sos/sos.module';
import { TrustedContactsModule } from './trusted-contacts/trusted-contacts.module';

@Module({
  imports: [PrismaModule, AuthModule, SosModule, TrustedContactsModule],
  controllers: [HealthController],
})
export class AppModule {}
