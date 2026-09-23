import { Module } from '@nestjs/common';
import { TrustedContactsController } from './trusted-contacts.controller';
import { TrustedContactsService } from './trusted-contacts.service';

@Module({
  controllers: [TrustedContactsController],
  providers: [TrustedContactsService],
})
export class TrustedContactsModule {}
