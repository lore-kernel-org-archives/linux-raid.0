From: Stefan Borggraefe <stefan@spybot.info>
Subject: Re: Help with recovering a RAID5 array
Date: Thu, 02 May 2013 15:14:27 +0200
Message-ID: <2322111.Fd18rzrueQ@chablis>
References: <34199580.p6EyCyMeIZ@chablis> <CADNH=7Gfx-HV7j-kwLOwQydcGRoXyt-1f4JjoYg1NoiTLO4p=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7Gfx-HV7j-kwLOwQydcGRoXyt-1f4JjoYg1NoiTLO4p=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Donnerstag, 2. Mai 2013, 13:30:22 schrieb Mathias Bur=E9n:
> I won't scold you for using RAID5 instead of RAID6 with this number o=
f
> if drives and especially the size of the drives.
>=20
> Could you please post the output of smartctl -a for each device? (fro=
m
> smartmontools)
>=20
> That way we can verify which HDDs are broken, before proceeding.
>=20
> Mathias

Hello Mathias,

RAID6 would have been the safer option clearly, but we needed the
extra-space and only had this number of drives available.

Here the requested output:

smartctl -a /dev/sdc
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
Local Time is:        Thu May  2 15:09:16 2013 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     <not available>

Error Counter logging not supported
Device does not support Self Test logging

smartctl -a /dev/sdd
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Vendor:               Hitachi=20
Product:              HUS724040ALE640=20
Revision:             MJAO
User Capacity:        4.000.787.030.016 bytes [4,00 TB]
Logical block size:   512 bytes
Logical Unit id:      0x5000cca22bc3effb
Serial number:              PK2331PAG8NHZT
Device type:          disk
Local Time is:        Thu May  2 15:09:19 2013 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     <not available>

Error Counter logging not supported
Device does not support Self Test logging

smartctl -a /dev/sde
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Vendor:               Hitachi=20
Product:              HUS724040ALE640=20
Revision:             MJAO
User Capacity:        4.000.787.030.016 bytes [4,00 TB]
Logical block size:   512 bytes
Logical Unit id:      0x5000cca22bc3ff79
Serial number:              PK2331PAG8TMXT
Device type:          disk
Local Time is:        Thu May  2 15:09:23 2013 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     <not available>

Error Counter logging not supported
Device does not support Self Test logging

smartctl -a /dev/sdf
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Vendor:               Hitachi=20
Product:              HUS724040ALE640=20
Revision:             MJAO
User Capacity:        4.000.787.030.016 bytes [4,00 TB]
Logical block size:   512 bytes
^[[3~Logical Unit id:      0x5000cca22bc419ef
Serial number:              PK2331PAG90PET
Device type:          disk
Local Time is:        Thu May  2 15:09:25 2013 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     <not available>

Error Counter logging not supported
Device does not support Self Test logging

smartctl -a /dev/sdg
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Vendor:               Hitachi=20
Product:              HUS724040ALE640=20
Revision:             MJAO
User Capacity:        4.000.787.030.016 bytes [4,00 TB]
Logical block size:   512 bytes
Logical Unit id:      0x5000cca22bc2fe51
Serial number:              PK2331PAG6L49T
Device type:          disk
Local Time is:        Thu May  2 15:09:27 2013 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     <not available>

Error Counter logging not supported
Device does not support Self Test logging

smartctl -a /dev/sdh
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-37-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Vendor:               Hitachi=20
Product:              HUS724040ALE640=20
Revision:             MJAO
User Capacity:        4.000.787.030.016 bytes [4,00 TB]
Logical block size:   512 bytes
Logical Unit id:      0x5000cca22bc2fe2d
Serial number:              PK2331PAG6L34T
Device type:          disk
Local Time is:        Thu May  2 15:09:30 2013 CEST
Device supports SMART and is Enabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Current Drive Temperature:     <not available>

Error Counter logging not supported
Device does not support Self Test logging
--=20
Best regards,
Stefan Borggraefe
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
