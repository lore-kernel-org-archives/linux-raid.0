From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Thu, 7 Apr 2011 19:01:13 -0700 (PDT)
Message-ID: <407815.71568.qm@web65101.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Looks like the log file was simply too big.

Here are the initial and ending lines:

Cheers,
Gavin

output of:
grep -i ATA /var/log/messages

Apr  4 00:46:18 saturn kernel: [58150.946089] pata_atiixp 0000:00:14.1:=
 PCI INT A disabled
Apr  4 00:46:19 saturn kernel: [58151.620996] pata_atiixp 0000:00:14.1:=
 PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr  4 00:46:19 saturn kernel: [58151.776364] ata6.00: ACPI cmd ef/03:0=
c:00:00:00:a0 (SET FEATURES) filtered out
Apr  4 00:46:19 saturn kernel: [58151.776367] ata6.00: ACPI cmd ef/03:4=
6:00:00:00:a0 (SET FEATURES) filtered out
Apr  4 00:46:19 saturn kernel: [58151.776370] ata6.00: ACPI cmd f5/00:0=
0:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Apr  4 00:46:19 saturn kernel: [58151.792475] ata5.00: ACPI cmd ef/03:0=
c:00:00:00:a0 (SET FEATURES) filtered out
Apr  4 00:46:19 saturn kernel: [58151.792478] ata5.00: ACPI cmd ef/03:4=
2:00:00:00:a0 (SET FEATURES) filtered out
Apr  4 00:46:19 saturn kernel: [58151.792481] ata5.00: ACPI cmd f5/00:0=
0:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Apr  4 00:46:19 saturn kernel: [58151.814455] ata5.00: configured for U=
DMA/33
Apr  4 00:46:19 saturn kernel: [58151.850339] ata6.00: configured for U=
DMA/100
Apr  4 00:46:19 saturn kernel: [58151.864031] ata3: softreset failed (d=
evice not ready)
Apr  4 00:46:19 saturn kernel: [58151.864035] ata4: softreset failed (d=
evice not ready)
Apr  4 00:46:19 saturn kernel: [58151.864038] ata3: applying SB600 PMP =
SRST workaround and retrying
Apr  4 00:46:19 saturn kernel: [58151.864040] ata4: applying SB600 PMP =
SRST workaround and retrying
Apr  4 00:46:19 saturn kernel: [58151.864059] ata2: softreset failed (d=
evice not ready)
Apr  4 00:46:19 saturn kernel: [58151.864061] ata1: softreset failed (d=
evice not ready)
Apr  4 00:46:19 saturn kernel: [58151.864063] ata2: applying SB600 PMP =
SRST workaround and retrying
Apr  4 00:46:19 saturn kernel: [58151.864065] ata1: applying SB600 PMP =
SRST workaround and retrying
Apr  4 00:46:19 saturn kernel: [58152.019042] ata2: SATA link up 3.0 Gb=
ps (SStatus 123 SControl 300)
Apr  4 00:46:19 saturn kernel: [58152.019046] ata4: SATA link up 3.0 Gb=
ps (SStatus 123 SControl 300)
Apr  4 00:46:19 saturn kernel: [58152.019070] ata3: SATA link up 3.0 Gb=
ps (SStatus 123 SControl 300)
Apr  4 00:46:19 saturn kernel: [58152.019079] ata1: SATA link up 3.0 Gb=
ps (SStatus 123 SControl 300)
Apr  4 00:46:19 saturn kernel: [58152.021363] ata3.00: configured for U=
DMA/133
Apr  4 00:46:19 saturn kernel: [58152.085139] ata4.00: configured for U=
DMA/133
Apr  4 00:46:19 saturn kernel: [58152.085152] ata1.00: configured for U=
DMA/133
Apr  4 00:46:19 saturn kernel: [58152.085165] ata2.00: configured for U=
DMA/133
[...]
Apr  7 14:41:58 saturn kernel: [231943.624749] ata3: hard resetting lin=
k
Apr  7 14:42:05 saturn kernel: [231950.625059] ata3: SATA link up 1.5 G=
bps (SStatus 113 SControl 310)
Apr  7 14:42:05 saturn kernel: [231950.635608] ata3.00: configured for =
UDMA/33
Apr  7 14:42:05 saturn kernel: [231950.635617] ata3: EH complete
Apr  7 14:42:05 saturn kernel: [231950.654531] ata3.00: exception Emask=
 0x50 SAct 0x1 SErr 0x90a00 action 0xe frozen
Apr  7 14:42:05 saturn kernel: [231950.654535] ata3.00: irq_stat 0x0140=
0000, PHY RDY changed
Apr  7 14:42:05 saturn kernel: [231950.654538] ata3: SError: { Persist =
HostInt PHYRdyChg 10B8B }
Apr  7 14:42:05 saturn kernel: [231950.654541] ata3.00: failed command:=
 READ FPDMA QUEUED
Apr  7 14:42:05 saturn kernel: [231950.654546] ata3.00: cmd 60/80:00:f0=
:21:3b/00:00:1c:00:00/40 tag 0 ncq 65536 in
Apr  7 14:42:05 saturn kernel: [231950.654547]          res 40/00:00:f0=
:21:3b/00:00:1c:00:00/40 Emask 0x50 (ATA bus error)
Apr  7 14:42:05 saturn kernel: [231950.654550] ata3.00: status: { DRDY =
}
Apr  7 14:42:05 saturn kernel: [231950.654554] ata3: hard resetting lin=
k
Apr  7 14:42:12 saturn kernel: [231957.654285] ata3: SATA link up 1.5 G=
bps (SStatus 113 SControl 310)
Apr  7 14:42:12 saturn kernel: [231957.666115] ata3.00: configured for =
UDMA/33
Apr  7 14:42:12 saturn kernel: [231957.666123] ata3: EH complete
Apr  7 14:42:12 saturn kernel: [231957.756013] ata3.00: exception Emask=
 0x50 SAct 0x1 SErr 0x90a00 action 0xe frozen
Apr  7 14:42:12 saturn kernel: [231957.756016] ata3.00: irq_stat 0x0140=
0000, PHY RDY changed
Apr  7 14:42:12 saturn kernel: [231957.756020] ata3: SError: { Persist =
HostInt PHYRdyChg 10B8B }
Apr  7 14:42:12 saturn kernel: [231957.756023] ata3.00: failed command:=
 READ FPDMA QUEUED
Apr  7 14:42:12 saturn kernel: [231957.756028] ata3.00: cmd 60/80:00:f0=
:24:3b/00:00:1c:00:00/40 tag 0 ncq 65536 in
Apr  7 14:42:12 saturn kernel: [231957.756029]          res 40/00:00:f0=
:24:3b/00:00:1c:00:00/40 Emask 0x50 (ATA bus error)
Apr  7 14:42:12 saturn kernel: [231957.756032] ata3.00: status: { DRDY =
}
Apr  7 14:42:12 saturn kernel: [231957.756037] ata3: hard resetting lin=
k
Apr  7 14:42:16 saturn kernel: [231961.389026] ata3: softreset failed (=
device not ready)
Apr  7 14:42:16 saturn kernel: [231961.389032] ata3: applying SB600 PMP=
 SRST workaround and retrying
Apr  7 14:42:16 saturn kernel: [231961.544030] ata3: SATA link up 1.5 G=
bps (SStatus 113 SControl 310)
Apr  7 14:42:16 saturn kernel: [231961.546323] ata3.00: configured for =
UDMA/33
Apr  7 14:42:16 saturn kernel: [231961.546331] ata3: EH complete

--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!


--- On Fri, 8/4/11, Gavin Flower <gavinflower@yahoo.com> wrote:

> From: Gavin Flower <gavinflower@yahoo.com>
> Subject: RAID6 data-check took almost 2 hours, clicking sounds, syste=
m unresponsive
> To: neilb@suse.de
> Cc: linux-raid@vger.kernel.org
> Date: Friday, 8 April, 2011, 13:32
[...]
> My original email may have been eaten: as it did not appear
> on the list, nor did I get an error message back.=A0 So
> perhaps there was a problem with the attached files.
>=20
> I will resend the attachments one at a time in separate
> emails.
[...]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
