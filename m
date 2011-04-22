From: John Valarti <mdadmuser@gmail.com>
Subject: =?UTF-8?Q?Re=3AServer_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assis?=
	=?UTF-8?Q?tance?=
Date: Thu, 21 Apr 2011 20:32:57 -0600
Message-ID: <BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 21, 2011 at 1:59 PM, David Brown <david.brown@hesbynett.no>=
 wrote:
=2E
> My first thought would be to get /all/ the disks, not just the "faile=
d"
> ones, out of the machine. =A0You want to make full images of them (wi=
th
> ddrescue or something similar) to files on another disk, and then wor=
k with
> those images. =A0..
> Once you've got some (hopefully most) of your data recovered from the
> images, buy four /new/ disks to put in the machine, and work on your
> restore. =A0You don't want to reuse the failing disks, and probably t=
he other
> two equally old and worn disks will be high risk too.

OK, I think I understand.
Does that mean I need to buy 8 disks, all the same size or bigger?
The originals are 250GB SATA so that should be OK, I guess.

I read some more and found out I should run mdadm --examine.

Should I not be able to just add the one disk partition sdc2 back to th=
e RAID?


Here is the result of --examine

/dev/sda2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
=A0Creation Time : Mon May 15 16:38:05 2006
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
=A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
=A0 Raid Devices : 4
=A0Total Devices : 3
Preferred Minor : 1

=A0 =A0Update Time : Mon Apr 18 07:48:54 2011
=A0 =A0 =A0 =A0 =A0State : clean
Active Devices : 3
Working Devices : 3
=46ailed Devices : 1
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 5674ce60 - correct
=A0 =A0 =A0 =A0 Events : 28580020

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 256K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
/dev/sdb2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
=A0Creation Time : Mon May 15 16:38:05 2006
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
=A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
=A0 Raid Devices : 4
=A0Total Devices : 4
Preferred Minor : 1

=A0 =A0Update Time : Sun Oct 18 10:04:06 2009
=A0 =A0 =A0 =A0 =A0State : active
Active Devices : 4
Working Devices : 4
=46ailed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 5171dcb2 - correct
=A0 =A0 =A0 =A0 Events : 20333614

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 256K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 50 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 50 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd2
/dev/sdc2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
=A0Creation Time : Mon May 15 16:38:05 2006
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
=A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
=A0 Raid Devices : 4
=A0Total Devices : 3
Preferred Minor : 1

=A0 =A0Update Time : Mon Apr 18 07:48:51 2011
=A0 =A0 =A0 =A0 =A0State : clean
Active Devices : 3
Working Devices : 3
=46ailed Devices : 1
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 5674ce6b - correct
=A0 =A0 =A0 =A0 Events : 28580018

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 256K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
/dev/sdd2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : ddf4d448:36afa319:f0917855:03f8bbe8
=A0Creation Time : Mon May 15 16:38:05 2006
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 244975104 (233.63 GiB 250.85 GB)
=A0 =A0 Array Size : 734925312 (700.88 GiB 752.56 GB)
=A0 Raid Devices : 4
=A0Total Devices : 3
Preferred Minor : 1

=A0 =A0Update Time : Mon Apr 18 07:48:54 2011
=A0 =A0 =A0 =A0 =A0State : clean
Active Devices : 3
Working Devices : 3
=46ailed Devices : 1
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 5674ce4e - correct
=A0 =A0 =A0 =A0 Events : 28580020

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 256K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =
=A0active sync =A0 /dev/sda2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
