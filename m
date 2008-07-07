From: Gerhard Wiesinger <lists@wiesinger.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Mon, 7 Jul 2008 17:04:55 +0200 (CEST)
Message-ID: <alpine.LFD.1.10.0807071649340.1160@bbs.intern>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I'm having a similar problem with a brand new Hardware under Fedora 9 x64
8GB RAM
Motherboard: ASUS M3N-H/HDMI
Chipset: NForce 8300/Nvidia 750a
CPU: AMD AM2 5600+, 2.9GHz, Brisbane Dual Core
Kernel: 2.6.25.9-76.fc9.x86_64
Smartmontools: smartmontools-5.38-2.fc9.x86_64
BIOS AHCI mode
Power cables for ata3 and ata4 are on the same cable from an Enermax 
power supply.

ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata2.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata3.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata4.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata5.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata6.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5

Problem occours only on ata3, I've changed the disk Port 3 the third time 
(new disks) and changed the SATA cable, too. Problem still exists.

Sometimes a RAID rebuild doesn't work at all.

To get the drive to live I've to power down the system.

Logs are attached.

Can it be a bug on concurrent access of smartctl/smartd?

Any ideas?

Ciao,
Gerhard

--
http://www.wiesinger.com/


On Sat, 5 Jul 2008, Justin Piszcz wrote:

> I've read the best way to 'deal' with this issue is to turn off apic/acpi 
> etc, is there any downside to turning them off?  Particularly APIC for IRQ 
> routing?
>
> This happens on drives on both the Intel 965 chipset motherboard ports and 
> PCI-e x1 cards, and the cables are not the issue (the cables with 12 other 
> 150 raptors have no issues) (same cables I used with them)).
>
> With NCQ on or OFF it occurs.
>
> $ ls
> 0/  10/  12/  14/  16/  18/  2/   3/  5/  7/  9/   runtest.sh*
> 1/  11/  13/  15/  17/  19/  20/  4/  6/  8/  linux-2.6.25.10.tar
>
> $ cat runtest.sh
> #!/bin/bash
>
> for i in `seq 0 20`
> do
>  cd $i
>  tar xf ../linux-2.6.25.10.tar &
>  cd ..
> done
>
> With NCQ off (earlier) (from just heavy I/O on the raid5):
> Jul  5 11:50:06 p34 kernel: [112161.433913] ata6.00: exception Emask 0x0 SAct
> 0x0 SErr 0x0 action 0x2 frozen
> Jul  5 11:50:06 p34 kernel: [112161.433923] ata6.00: cmd
> b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> Jul  5 11:50:06 p34 kernel: [112161.433924]          res
> 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jul  5 11:50:06 p34 kernel: [112161.433927] ata6.00: status: { DRDY }
> Jul  5 11:50:06 p34 kernel: [112161.736858] ata6: soft resetting link
> Jul  5 11:50:07 p34 kernel: [112161.889840] ata6: SATA link up 3.0 Gbps 
> (SStatus
> 123 SControl 300)
> Jul  5 11:50:07 p34 kernel: [112161.911418] ata6.00: configured for UDMA/133
> Jul  5 11:50:07 p34 kernel: [112161.656792] sd 5:0:0:0: [sdf] Write Protect 
> is
> off
> Jul  5 11:50:07 p34 kernel: [112161.656797] sd 5:0:0:0: [sdf] Mode Sense: 00 
> 3a
> 00 00
> Jul  5 11:50:07 p34 kernel: [112161.659296] sd 5:0:0:0: [sdf] Write cache:
> enabled, read cache: enabled, doesn't support DPO or FUA
>
> With NCQ on (with the test shown above):
> [115786.990237] ata6.00: exception Emask 0x0 SAct 0x3ffff SErr 0x0 action 0x2 
> frozen
> [115786.990247] ata6.00: cmd 60/80:00:bf:07:94/00:00:10:00:00/40 tag 0 ncq 
> 65536 in
> [115786.990249]          res 40/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x4 
> (timeout)
> [115786.990254] ata6.00: status: { DRDY }
> [115786.990259] ata6.00: cmd 60/88:08:b7:ee:c1/01:00:1d:00:00/40 tag 1 ncq 
> 200704 in
> [115786.990261]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990265] ata6.00: status: { DRDY }
> [115786.990270] ata6.00: cmd 60/f8:10:bf:eb:c1/02:00:1d:00:00/40 tag 2 ncq 
> 389120 in
> [115786.990271]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990275] ata6.00: status: { DRDY }
> [115786.990280] ata6.00: cmd 60/c0:18:3f:e8:c1/01:00:1d:00:00/40 tag 3 ncq 
> 229376 in
> [115786.990282]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990286] ata6.00: status: { DRDY }
> [115786.990291] ata6.00: cmd 60/c0:20:ff:e9:c1/01:00:1d:00:00/40 tag 4 ncq 
> 229376 in
> [115786.990293]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990297] ata6.00: status: { DRDY }
> [115786.990302] ata6.00: cmd 61/08:28:0f:c6:b6/00:00:1f:00:00/40 tag 5 ncq 
> 4096 out
> [115786.990303]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990307] ata6.00: status: { DRDY }
> [115786.990312] ata6.00: cmd 61/10:30:df:b0:17/00:00:01:00:00/40 tag 6 ncq 
> 8192 out
> [115786.990313]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990318] ata6.00: status: { DRDY }
> [115786.990323] ata6.00: cmd 61/10:38:4f:88:79/00:00:03:00:00/40 tag 7 ncq 
> 8192 out
> [115786.990324]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990328] ata6.00: status: { DRDY }
> [115786.990333] ata6.00: cmd 61/10:40:3f:18:95/00:00:05:00:00/40 tag 8 ncq 
> 8192 out
> [115786.990335]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990339] ata6.00: status: { DRDY }
> [115786.990344] ata6.00: cmd 61/08:48:d7:f6:a9/00:00:06:00:00/40 tag 9 ncq 
> 4096 out
> [115786.990345]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990350] ata6.00: status: { DRDY }
> [115786.990355] ata6.00: cmd 61/08:50:9f:37:b7/00:00:07:00:00/40 tag 10 ncq 
> 4096 out
> [115786.990356]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990360] ata6.00: status: { DRDY }
> [115786.990365] ata6.00: cmd 61/08:58:27:7c:d1/00:00:08:00:00/40 tag 11 ncq 
> 4096 out
> [115786.990367]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990371] ata6.00: status: { DRDY }
> [115786.990376] ata6.00: cmd 61/08:60:97:48:46/00:00:0d:00:00/40 tag 12 ncq 
> 4096 out
> [115786.990377]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990381] ata6.00: status: { DRDY }
> [115786.990386] ata6.00: cmd 61/08:68:cf:b4:68/00:00:0e:00:00/40 tag 13 ncq 
> 4096 out
> [115786.990388]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990392] ata6.00: status: { DRDY }
> [115786.990397] ata6.00: cmd 61/80:70:3f:06:94/01:00:10:00:00/40 tag 14 ncq 
> 196608 out
> [115786.990398]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990402] ata6.00: status: { DRDY }
> [115786.990408] ata6.00: cmd 61/08:78:7f:a4:88/00:00:11:00:00/40 tag 15 ncq 
> 4096 out
> [115786.990409]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990413] ata6.00: status: { DRDY }
> [115786.990418] ata6.00: cmd 61/08:80:37:b8:d5/00:00:13:00:00/40 tag 16 ncq 
> 4096 out
> [115786.990419]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990423] ata6.00: status: { DRDY }
> [115786.990428] ata6.00: cmd 61/08:88:c7:a4:8b/00:00:1d:00:00/40 tag 17 ncq 
> 4096 out
> [115786.990430]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [115786.990454] ata6.00: status: { DRDY }
> [115787.293177] ata6: soft resetting link
> [115787.446158] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [115788.133592] ata6.00: configured for UDMA/133
> [115788.133628] ata6: EH complete
> [115787.877547] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 
> MB)
> [115787.877689] sd 5:0:0:0: [sdf] Write Protect is off
> [115787.877692] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> [115787.878746] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, 
> doesn't support DPO or FUA
>
> What is the true cause of this, is there anyway to get more information?
>
> I will test soon with apic/acpi=off.
>
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
