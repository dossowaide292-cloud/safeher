import { ConflictException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';
import { randomBytes } from 'crypto';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const email = dto.email?.toLowerCase();
    const phone = dto.phone;
    const existing = await this.prisma.user.findFirst({ where: { OR: [{ email }, { phone }] } });
    if (existing) throw new ConflictException('Un compte existe déjà avec ces informations');

    const passwordHash = await argon2.hash(dto.password);
    const user = await this.prisma.user.create({ data: { email, phone, passwordHash } });
    return this.issueTokens(user.id, user.email, user.phone);
  }

  async login(dto: LoginDto) {
    const identifier = dto.identifier.includes('@') ? { email: dto.identifier.toLowerCase() } : { phone: dto.identifier };
    const user = await this.prisma.user.findFirst({ where: identifier });
    if (!user || !(await argon2.verify(user.passwordHash, dto.password))) {
      throw new UnauthorizedException('Identifiants invalides');
    }
    return this.issueTokens(user.id, user.email, user.phone);
  }

  async refresh(refreshToken: string) {
    const tokenHash = await argon2.hash(refreshToken);
    const candidates = await this.prisma.refreshToken.findMany({
      where: { expiresAt: { gt: new Date() }, revokedAt: null },
      include: { user: true },
    });
    const stored = await this.findMatchingToken(candidates, refreshToken);
    if (!stored) throw new UnauthorizedException('Refresh token invalide ou expiré');

    await this.prisma.refreshToken.update({ where: { id: stored.id }, data: { revokedAt: new Date() } });
    void tokenHash;
    return this.issueTokens(stored.user.id, stored.user.email, stored.user.phone);
  }

  async logout(userId: string) {
    await this.prisma.refreshToken.updateMany({ where: { userId, revokedAt: null }, data: { revokedAt: new Date() } });
    return { message: 'Session(s) révoquée(s)' };
  }

  async getProfile(userId: string) {
    return this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { id: true, email: true, phone: true, createdAt: true, updatedAt: true },
    });
  }

  private async findMatchingToken(tokens: Array<{ id: string; user: { id: string; email: string | null; phone: string | null } }>, raw: string) {
    for (const token of tokens) {
      if (await argon2.verify((await this.prisma.refreshToken.findUniqueOrThrow({ where: { id: token.id } })).tokenHash, raw)) return token;
    }
    return null;
  }

  private async issueTokens(userId: string, email: string | null, phone: string | null) {
    const accessToken = await this.jwtService.signAsync({ sub: userId, email, phone });
    const refreshToken = randomBytes(48).toString('base64url');
    const refreshDays = 30;
    await this.prisma.refreshToken.create({
      data: { userId, tokenHash: await argon2.hash(refreshToken), expiresAt: new Date(Date.now() + refreshDays * 86400000) },
    });
    return { accessToken, refreshToken, expiresIn: 900 };
  }
}
