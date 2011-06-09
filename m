From: "Dragon" <Sunghost@gmx.de>
Subject: (unknown)
Date: Thu, 09 Jun 2011 14:16:41 +0200
Message-ID: <20110609121641.298530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes if all things get back to normal i will change to raid6. that was m=
y idea for the future too.
here the result of the script:

=2E/lsdrv
**Warning** The following utility(ies) failed to execute:
  pvs
  lvs
Some information may be missing.

PCI [pata_atiixp] 00:14.1 IDE interface: ATI Technologies Inc SB700/SB8=
00 IDE Controller
 =C3=A2=C3=A2scsi 0:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1WZ401747}
 =C3=A2  =C3=A2=C3=A2sda: [8:0] MD raid5 (none/13) 1.36t md0 inactive s=
pare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2     =C3=A2=C3=A2md0: [9:0] Empty/Unknown 0.00k
 =C3=A2=C3=A2scsi 0:0:1:0 ATA SAMSUNG HD154UI {S1XWJ1WZ405098}
 =C3=A2  =C3=A2=C3=A2sdb: [8:16] MD raid5 (none/13) 1.36t md0 inactive =
spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 1:0:0:0 ATA SAMSUNG SV2044D {0244J1BN626842}
    =C3=A2=C3=A2sdc: [8:32] Partitioned (dos) 19.01g
       =C3=A2=C3=A2sdc1: [8:33] (ext3) 18.17g {6858fc38-9fee-4ab5-8135-=
029f305b9198}
       =C3=A2  =C3=A2=C3=A2Mounted as /dev/disk/by-uuid/6858fc38-9fee-4=
ab5-8135-029f305b9198 @ /
       =C3=A2=C3=A2sdc2: [8:34] Partitioned (dos) 1.00k
       =C3=A2=C3=A2sdc5: [8:37] (swap) 854.99m {f67c7f23-e5ac-4c05-992c=
-a9a494687026}
PCI [sata_mv] 02:00.0 SCSI storage controller: Marvell Technology Group=
 Ltd. 88SX7042 PCI-e 4-port SATA-II (rev 02)
 =C3=A2=C3=A2scsi 2:0:0:0 ATA SAMSUNG HD154UI {S1XWJD2Z907626}
 =C3=A2  =C3=A2=C3=A2sdd: [8:48] MD raid5 (none/13) 1.36t md0 inactive =
spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 4:0:0:0 ATA SAMSUNG HD154UI {S1XWJ90ZA03442}
 =C3=A2  =C3=A2=C3=A2sde: [8:64] MD raid5 (none/13) 1.36t md0 inactive =
spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 6:0:0:0 ATA SAMSUNG HD154UI {S1XWJ9AB200390}
 =C3=A2  =C3=A2=C3=A2sdf: [8:80] MD raid5 (none/13) 1.36t md0 inactive =
spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 8:0:0:0 ATA SAMSUNG HD154UI {61833B761A63RP}
    =C3=A2=C3=A2sdg: [8:96] MD raid5 (none/13) 1.36t md0 inactive spare=
 {975d6eb2-285e-ed11-021d-f236c2d05073}
PCI [sata_promise] 04:02.0 Mass storage controller: Promise Technology,=
 Inc. PDC40718 (SATA 300 TX4) (rev 02)
 =C3=A2=C3=A2scsi 3:0:0:0 ATA SAMSUNG HD154UI {S1XWJD5B201174}
 =C3=A2  =C3=A2=C3=A2sdh: [8:112] MD raid5 (none/13) 1.36t md0 inactive=
 spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 5:0:0:0 ATA SAMSUNG HD154UI {S1XWJ9CB201815}
 =C3=A2  =C3=A2=C3=A2sdi: [8:128] MD raid5 (none/13) 1.36t md0 inactive=
 spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 7:x:x:x [Empty]
 =C3=A2=C3=A2scsi 9:0:0:0 ATA SAMSUNG HD154UI {A6311B761A3XPB}
    =C3=A2=C3=A2sdj: [8:144] MD raid5 (none/13) 1.36t md0 inactive spar=
e {975d6eb2-285e-ed11-021d-f236c2d05073}
PCI [ahci] 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SA=
TA Controller [IDE mode]
 =C3=A2=C3=A2scsi 10:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KS915803}
 =C3=A2  =C3=A2=C3=A2sdk: [8:160] MD raid5 (none/13) 1.36t md0 inactive=
 spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 11:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KS915802}
 =C3=A2  =C3=A2=C3=A2sdl: [8:176] MD raid5 (none/13) 1.36t md0 inactive=
 spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 12:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KSC08024}
 =C3=A2  =C3=A2=C3=A2sdm: [8:192] MD raid5 (none/13) 1.36t md0 inactive=
 spare {975d6eb2-285e-ed11-021d-f236c2d05073}
 =C3=A2=C3=A2scsi 13:0:0:0 ATA SAMSUNG HD154UI {S1XWJ1KS915804}
    =C3=A2=C3=A2sdn: [8:208] MD raid5 (13) 1.36t inactive {975d6eb2-285=
e-ed11-021d-f236c2d05073}

--=20
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
