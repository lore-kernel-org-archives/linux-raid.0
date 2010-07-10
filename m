From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Sat, 10 Jul 2010 14:45:53 +0300
Message-ID: <201007101445.53556.anssi.hannula@iki.fi>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <4C37FA32.8020008@wasp.net.au> <4C381BC4.9040903@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C381BC4.9040903@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Brad Campbell <brad@wasp.net.au>, Mikael Abrahamsson <swmike@swm.pp.se>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Rudy Zijlstra kirjoitti lauantai, 10. hein=E4kuuta 2010 10:05:40:
> Judging from my dmesg and lsscsi on a system with both scsi and SATA,
> ataX translates into scsi X:0:0:0

AFAIK this is only because you have a real SCSI occupying scsi0. On sys=
tems=20
with only ATA, ataN is scsi(N-1).

I guess it really depends on the load order of ATA, SCSI and USB storag=
e=20
device drivers.

This should probably be changed somehow.. either make ataXX binding ava=
ilable=20
somewhere or use some other known identifier instead of ataXX.

> example dmesg output:
> [    3.901035] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300=
)
> [    3.937046] ata10.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max
> UDMA/133
> [    3.948794] ata10.00: 1465149168 sectors, multi 0: LBA48 NCQ (dept=
h
> 31/32)
> [    3.969065] ata10.00: configured for UDMA/133
> [    3.980847] scsi 10:0:0:0: Direct-Access     ATA      WDC
> WD7500AAKS-0 30.0 PQ: 0 ANSI: 5
> [    3.993120] sd 10:0:0:0: [sdf] 1465149168 512-byte hardware sector=
s:
> (750 GB/698 GiB)
> [    4.005586] sd 10:0:0:0: [sdf] Write Protect is off
> [    4.017936] sd 10:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> [    4.017959] sd 10:0:0:0: [sdf] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
>=20
> and the lsscsi output:
> [0:2:0:0]    disk    LSI      MegaRAID 8344ELP 1.12  /dev/sda
> [0:2:1:0]    disk    LSI      MegaRAID 8344ELP 1.12  /dev/sdb
> [5:0:1:0]    cd/dvd  MATSHITA DVD-ROM UJDA780  1.50  /dev/sr0
> [7:0:0:0]    disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdm
> [8:0:0:0]    disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdl
> [9:0:0:0]    disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdo
> [10:0:0:0]   disk    ATA      SAMSUNG HD154UI  1AG0  /dev/sdn
> [11:0:0:0]   disk    ATA      SAMSUNG HD103SJ  1AJ1  /dev/sdk
> [12:0:0:0]   disk    ATA      Hitachi HDT72101 ST6O  /dev/sdh
> [13:0:0:0]   disk    ATA      Hitachi HDT72101 ST6O  /dev/sdi
> [14:0:0:0]   disk    ATA      Hitachi HDT72101 ST6O  /dev/sdj

--=20
Anssi Hannula
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
