From: Stefan Borggraefe <stefan@spybot.info>
Subject: Re: Help with recovering a RAID5 array
Date: Thu, 02 May 2013 15:29:48 +0200
Message-ID: <3800236.bN8bMq2WMZ@chablis>
References: <34199580.p6EyCyMeIZ@chablis> <2322111.Fd18rzrueQ@chablis> <CADNH=7EZFx1DPAiXMWav5S6FN+0Tb1JxNxrHVczfaDAEwW-oVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7EZFx1DPAiXMWav5S6FN+0Tb1JxNxrHVczfaDAEwW-oVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Donnerstag, 2. Mai 2013, 14:17:04 schrieb Mathias Bur=E9n:
> On 2 May 2013 14:14, Stefan Borggraefe <stefan@spybot.info> wrote:
> > Am Donnerstag, 2. Mai 2013, 13:30:22 schrieb Mathias Bur=E9n:
> >> I won't scold you for using RAID5 instead of RAID6 with this numbe=
r of
> >> if drives and especially the size of the drives.
> >>=20
> >> Could you please post the output of smartctl -a for each device? (=
from
> >> smartmontools)
> >>=20
> >> That way we can verify which HDDs are broken, before proceeding.
> >>=20
> >> Mathias
> >=20
> > Hello Mathias,
> >=20
> > RAID6 would have been the safer option clearly, but we needed the
> > extra-space and only had this number of drives available.
> >=20
> > Here the requested output:
> >=20
> > smartctl -a /dev/sdc
> > smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (loc=
al
> > build) Copyright (C) 2002-11 by Bruce Allen,
> > http://smartmontools.sourceforge.net
> >=20
> > Vendor:               Hitachi
> > Product:              HUS724040ALE640
> > Revision:             MJAO
> > User Capacity:        4.000.787.030.016 bytes [4,00 TB]
> > Logical block size:   512 bytes
> > Logical Unit id:      0x5000cca22bd08a85
> > Serial number:              PK2331PAH5D0YT
> > Device type:          disk
> > Local Time is:        Thu May  2 15:09:16 2013 CEST
> > Device supports SMART and is Enabled
> > Temperature Warning Disabled or Not Supported
> > SMART Health Status: OK
> >=20
> > [...]
>=20
> Hm are these behind some controller of sorts? What about smartctl -x =
?

We use an Adaptec 71605 controller. smartctl -x does not provide any mo=
re
useful information, I suppose. I only post the output of one drive as a=
n
example this time. They all give a similar result.

smartctl -x /dev/sdc
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Vendor:               Hitachi=20
Product:              HUS724040ALE640=20
Revision:             MJAO
User Capacity:        4.000.787.030.016 bytes [4,00 TB]
Logical block size:   512 bytes
Logical Unit id:      0x5000cca22bd08a85
Serial number:              PK2331PAH5D0YT
Device type:          disk
Local Time is:        Thu May  2 15:20:55 2013 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     <not available>

Error Counter logging not supported
Device does not support Self Test logging
Device does not support Background scan results logging
scsiPrintSasPhy Log Sense Failed [unsupported field in scsi command]

What about the state of the software RAID5? It would be great if I
could bring it back to a state where the filesystem on it is fully
working again without having to copy the 20 TB of data to it again
(copying this amount of data takes some time :( ).
--=20
Best regards,
Stefan Borggraefe
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
