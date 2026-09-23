import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { HealthController } from './health.controller';
import { PrismaModule } from './prisma/prisma.module';
import { SosModule } from './sos/sos.module';

@Module({
  imports: [PrismaModule, AuthModule, SosModule],
  controllers: [HealthController],
})
export class AppModule {}
