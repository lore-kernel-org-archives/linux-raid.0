From: Dennis Grant <reccedg@gmail.com>
Subject: Re: Mounting array at boot - works with some kernels but not others
Date: Sun, 3 Apr 2011 15:48:21 -0400
Message-ID: <BANLkTikoDDFtD+cQ=mJJbiLzCi4jnUsqdA@mail.gmail.com>
References: <BANLkTinSwLgNze-EdRB6wu1o5QYApHbLXQ@mail.gmail.com>
	<4D98AAD3.2050700@turmel.org>
	<BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
	<4D98B136.1010803@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D98B136.1010803@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You mentioned that the system will boot with a newer kernel, just wit=
hout the array. =A0Could you boot it like that, but select single-user =
mode? =A0Then you can save the dmesg to a file, collect any other usefu=
l messages, reboot into 2.6.31, then paste the files into an email.

Here goes - dmesg heavily redacted:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-30-generic (buildd@vernadsky) (gcc
version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #59-Ubuntu SMP Tue Mar 1
21:30:21 UTC 2011 (Ubuntu 2.6.32-30.59-generic 2.6.32.29+drm33.13)
[    0.923535] ahci 0000:00:11.0: version 3.0
[    0.923554]   alloc irq_desc for 22 on node -1
[    0.923555]   alloc kstat_irqs on node -1
[    0.923564] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> I=
RQ 22
[    0.923721] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[    0.923758] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part ccc
[    0.929507] scsi0 : ahci
[    0.936083] scsi1 : ahci
[    0.943752] scsi2 : ahci
[    0.945123] scsi3 : ahci
[    0.945851] scsi4 : ahci
[    0.947687] scsi5 : ahci
[    0.947834] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY
changed irq 22
[    0.947871] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f180 irq 22
[    0.947907] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f200 irq 22
[    0.947944] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f280 irq 22
[    0.947980] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f300 irq 22
[    0.948017] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port
0xfe02f380 irq 22
[    0.948339] scsi6 : pata_atiixp
[    0.948414] scsi7 : pata_atiixp
[    0.949196] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00=
 irq 14
[    0.949234] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08=
 irq 15
[    1.084835] ata7.00: ATAPI: SONY    DVD RW DRU-810A, 1.0e, max UDMA/=
33
[    1.101607] ata7.01: HPA unlocked: 490232639 -> 490234752, native 49=
0234752
[    1.101644] ata7.01: ATA-7: Maxtor 6B250R0, BAH41BY0, max UDMA/133
[    1.101677] ata7.01: 490234752 sectors, multi 16: LBA48
[    1.116811] ata7.00: configured for UDMA/33
[    1.134253] ata7.01: configured for UDMA/100
[    1.228176] ata3: SATA link down (SStatus 0 SControl 300)
[    1.233152] ata5: SATA link down (SStatus 0 SControl 300)
[    1.233210] ata4: SATA link down (SStatus 0 SControl 300)
[    1.233659] ata6: SATA link down (SStatus 0 SControl 300)
[    1.341157] scsi8 : SCSI emulation for USB Mass Storage devices
[    1.393662] ata2: softreset failed (device not ready)
[    1.393697] ata2: applying SB600 PMP SRST workaround and retrying
[    1.556196] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.557471] ata2.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDM=
A/133
[    1.557506] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    1.559065] ata2.00: configured for UDMA/133
[    1.808688] ata1: applying SB600 PMP SRST workaround and retrying
[    1.972145] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.973383] ata1.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDM=
A/133
[    1.973418] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    1.974956] ata1.00: configured for UDMA/133
[    1.988276] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    1.988439] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.988467] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    1.988491] sd 0:0:0:0: [sda] Write Protect is off
[    1.988493] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.988505] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.988593]  sda:
[    1.988691] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    1.988885] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.988888] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    1.988943] sd 1:0:0:0: [sdb] Write Protect is off
[    1.988945] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.988970] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.989163]  sdb:
[    1.991478] scsi 6:0:0:0: CD-ROM            SONY     DVD RW
DRU-810A  1.0e PQ: 0 ANSI: 5
[    1.996140] CE: hpet increasing min_delta_ns to 15000 nsec
[    2.001025] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda=
 tray
[    2.001059] Uniform CD-ROM driver Revision: 3.20
[    2.001160] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    2.001199] sr 6:0:0:0: Attached scsi generic sg2 type 5
[    2.001308] scsi 6:0:1:0: Direct-Access     ATA      Maxtor 6B250R0
  BAH4 PQ: 0 ANSI: 5
[    2.001430] sd 6:0:1:0: [sdc] 490234752 512-byte logical blocks:
(251 GB/233 GiB)
[    2.001448] sd 6:0:1:0: Attached scsi generic sg3 type 0
[    2.001542]  sdb1
[    2.001553] sd 6:0:1:0: [sdc] Write Protect is off
[    2.001554] sd 6:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    2.001578] sd 6:0:1:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.001686]  sdb2 sdb3 sdb4 <
[    2.001901]  sdc: sda1 sda2 sda3 sda4 < sdb5 >
[    2.019924] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.020510]  sda5 >
[    2.022265]  sdc1 sdc2
[    2.022532] sd 6:0:1:0: [sdc] Attached SCSI disk
[    2.027189] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.045157] usb 3-2: new low speed USB device using ohci_hcd and add=
ress 3
[    2.157952] device-mapper: dm-raid45: initialized v0.2594b
[    2.159783] ohci1394 0000:03:0e.0: PCI INT A -> GSI 22 (level, low) =
-> IRQ 22
[    2.162472] md: linear personality registered for level -1
[    2.164145] md: multipath personality registered for level -4
[    2.166061] md: raid0 personality registered for level 0
[    2.168346] md: raid1 personality registered for level 1
[    2.236543] raid6: int32x1   1304 MB/s
[    2.304530] raid6: int32x2   1410 MB/s
[    2.372522] raid6: int32x4    964 MB/s
[    2.440508] raid6: int32x8    681 MB/s
[    2.508515] raid6: mmxx1     2475 MB/s
[    2.576505] raid6: mmxx2     4750 MB/s
[    2.644505] raid6: sse1x1    2030 MB/s
[    2.712514] raid6: sse1x2    3453 MB/s
[    2.780520] raid6: sse2x1    3800 MB/s
[    2.848505] raid6: sse2x2    6223 MB/s
[    2.848536] raid6: using algorithm sse2x2 (6223 MB/s)
[    2.852248] md: raid6 personality registered for level 6
[    2.852282] md: raid5 personality registered for level 5
[    2.852314] md: raid4 personality registered for level 4
[    2.856787] md: raid10 personality registered for level 10
[    2.949118] md: bind<sda5>
[    2.984447] md: bind<sdb5>
[    2.986309] raid1: raid set md1 active with 2 out of 2 mirrors
[    2.986361] md1: detected capacity change from 0 to 788179124224
[    2.987205]  md1: unknown partition table
[    3.199341] kjournald starting.  Commit interval 5 seconds
[    3.199356] EXT3-fs: mounted filesystem with ordered data mode.
[   29.671452] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader
  1.00 PQ: 0 ANSI: 0
[   29.672325] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader
  1.01 PQ: 0 ANSI: 0
[   29.673158] scsi 8:0:0:2: Direct-Access     Generic  USB xD/SM
Reader 1.02 PQ: 0 ANSI: 0
[   29.674004] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader
  1.03 PQ: 0 ANSI: 0
[   29.674326] sd 8:0:0:0: Attached scsi generic sg4 type 0
[   29.674432] sd 8:0:0:1: Attached scsi generic sg5 type 0
[   29.674536] sd 8:0:0:2: Attached scsi generic sg6 type 0
[   29.674640] sd 8:0:0:3: Attached scsi generic sg7 type 0
[   29.681659] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[   29.682292] sd 8:0:0:1: [sde] Attached SCSI removable disk
[   29.683561] sd 8:0:0:2: [sdf] Attached SCSI removable disk
[   29.684168] sd 8:0:0:3: [sdg] Attached SCSI removable disk
[   29.800664] Adding 2048276k swap on /dev/sda3.  Priority:-1
extents:1 across:2048276k
[   29.909600] Adding 2048276k swap on /dev/sdb3.  Priority:-2
extents:1 across:2048276k
[   30.022862] udev: starting version 151
[   31.253036] shpchp 0000:00:01.0: HPC vendor_id 1022 device_id 9602
ss_vid 0 ss_did 0
[   31.253040] shpchp 0000:00:01.0: Cannot reserve MMIO region
[   31.253095] shpchp: Standard Hot Plug PCI Controller Driver version:=
 0.4
[   31.375816] ACPI: resource piix4_smbus [0xb00-0xb07] conflicts with
ACPI region SOR1 [0xb00-0xb0f]
[   31.375819] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[   40.205687] type=3D1505 audit(1301858645.806:2):
operation=3D"profile_load" pid=3D687 name=3D"/sbin/dhclient3"
[   40.205698] type=3D1505 audit(1301858645.806:3):
operation=3D"profile_replace" pid=3D680 name=3D"/sbin/dhclient3"
[   40.205884] type=3D1505 audit(1301858645.806:4):
operation=3D"profile_load" pid=3D687
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action"
[   40.205902] type=3D1505 audit(1301858645.806:5):
operation=3D"profile_replace" pid=3D680
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action"
[   40.205995] type=3D1505 audit(1301858645.806:6):
operation=3D"profile_load" pid=3D687
name=3D"/usr/lib/connman/scripts/dhclient-script"
[   40.206020] type=3D1505 audit(1301858645.806:7):
operation=3D"profile_replace" pid=3D680
name=3D"/usr/lib/connman/scripts/dhclient-script"
[   44.951085] type=3D1505 audit(1301858650.549:8):
operation=3D"profile_load" pid=3D967 name=3D"/usr/sbin/ntpd"
[   44.951096] type=3D1505 audit(1301858650.549:9):
operation=3D"profile_replace" pid=3D966 name=3D"/usr/sbin/ntpd"
[   54.291501] EXT3 FS on sda2, internal journal
[   54.635654] kjournald starting.  Commit interval 5 seconds
[   54.636035] EXT3 FS on sdb2, internal journal
[   54.636039] EXT3-fs: mounted filesystem with ordered data mode.
[   54.720501] kjournald starting.  Commit interval 5 seconds
[   54.720663] EXT3 FS on dm-0, internal journal
[   54.720667] EXT3-fs: mounted filesystem with ordered data mode.
[   55.437462] kjournald starting.  Commit interval 5 seconds
[   55.437913] EXT3 FS on dm-1, internal journal
[   55.437917] EXT3-fs: mounted filesystem with ordered data mode.
[   55.522745] kjournald starting.  Commit interval 5 seconds
[   55.523174] EXT3 FS on dm-2, internal journal
[   55.523177] EXT3-fs: mounted filesystem with ordered data mode.
[   55.585619] kjournald starting.  Commit interval 5 seconds
[   55.628189] EXT3 FS on md1, internal journal
[   55.628193] EXT3-fs: mounted filesystem with ordered data mode.
[   56.931225] kjournald starting.  Commit interval 5 seconds
[   56.931562] EXT3 FS on dm-3, internal journal
[   56.931566] EXT3-fs: mounted filesystem with ordered data mode.
[   65.876933] type=3D1505 audit(1301858671.474:10):
operation=3D"profile_replace" pid=3D1164 name=3D"/sbin/dhclient3"
[   65.877143] type=3D1505 audit(1301858671.478:11):
operation=3D"profile_replace" pid=3D1164
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action"
[   65.877257] type=3D1505 audit(1301858671.478:12):
operation=3D"profile_replace" pid=3D1164
name=3D"/usr/lib/connman/scripts/dhclient-script"

At the end of the 3 second mark lines, the system stops booting and
needs a series of console inputs (space bar or return) to continue
booting. Each input advances the process a little bit.

/var/log/messages offered nothing different.

DG
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
