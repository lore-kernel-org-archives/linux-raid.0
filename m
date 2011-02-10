From: Thomas Heilberg <theilberg42@gmail.com>
Subject: Re: Raid 5 rebuild with only 2 spare devices
Date: Thu, 10 Feb 2011 20:40:48 +0100
Message-ID: <AANLkTinp-XhtrMDcJJKN8R0R+Chv3R67HZPOacECyvsz@mail.gmail.com>
References: <4D542872.3090102@gmail.com>
	<4D543443.9060709@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D543443.9060709@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
thanks for the quick answer.

2011/2/10 Phil Turmel <philip@turmel.org>:
> Working from backups is a very good plan!
Well, not having a backup has brought me into this problem so I
learned form my mistake.

> Hmmm. =A0Not enough info here, and further steps destroy it. =A0Good =
thing you started over.
>
> Please show "mdadm -E /dev/loop[0-2]" on fresh loop copies *before* t=
rying any "create" or "add" operations.
Unfortunately I'm not that familiar the -E option so I don't really
understand what all that means. But I think it's interesting that
there are sometimes 4 devices although the raid only has 3 in reality.

root@backup-server:/media# mdadm -E /dev/loop[0-2]
/dev/loop0:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 9665c475:31f17aa2:83a3570a:c5b3b84e
=A0Creation Time : Thu Nov 19 21:09:37 2009
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
=A0 =A0 Array Size : 2926962432 (2791.37 GiB 2997.21 GB)
=A0 Raid Devices : 3
=A0Total Devices : 2
Preferred Minor : 2

=A0 =A0Update Time : Sun Nov 14 02:08:16 2010
=A0 =A0 =A0 =A0 =A0State : active
=A0Active Devices : 1
Working Devices : 2
=A0Failed Devices : 2
=A0Spare Devices : 1
=A0 =A0 =A0 Checksum : aa2d9609 - correct
=A0 =A0 =A0 =A0 Events : 3352465

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 35 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
spare

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync
=A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
=A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0faulty removed
=A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 35 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
spare
/dev/loop1:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 9665c475:31f17aa2:83a3570a:c5b3b84e
=A0Creation Time : Thu Nov 19 21:09:37 2009
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
=A0 =A0 Array Size : 2926962432 (2791.37 GiB 2997.21 GB)
=A0 Raid Devices : 3
=A0Total Devices : 1
Preferred Minor : 2

=A0 =A0Update Time : Sun Nov 14 14:12:44 2010
=A0 =A0 =A0 =A0 =A0State : clean
=A0Active Devices : 1
Working Devices : 1
=A0Failed Devices : 2
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : aa2e3f94 - correct
=A0 =A0 =A0 =A0 Events : 3352467

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync
=A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
=A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0faulty removed
/dev/loop2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 9665c475:31f17aa2:83a3570a:c5b3b84e
=A0Creation Time : Thu Nov 19 21:09:37 2009
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
=A0 =A0 Array Size : 2926962432 (2791.37 GiB 2997.21 GB)
=A0 Raid Devices : 3
=A0Total Devices : 1
Preferred Minor : 2

=A0 =A0Update Time : Sun Nov 14 01:41:40 2010
=A0 =A0 =A0 =A0 =A0State : active
=A0Active Devices : 1
Working Devices : 1
=A0Failed Devices : 2
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : aa2d8f80 - correct
=A0 =A0 =A0 =A0 Events : 3352459

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 =A03 =A0 =A0 =A0 -1 =A0 =A0 =A0=
spare

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 19 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync
=A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
=A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0faulty removed

> Yeah, mdadm was trying to tell you not to do that. =A0"--assume-clean=
" is really important when trying to recreate an array with existing da=
ta.
>
> [trim /]
>
> If the problem is just the event counts, "mdadm --assemble --force" i=
s probably what you want, followed by "mdadm --readonly". =A0If pvscan =
shows your LVM subsystem at that point, try an fsck to see how much tro=
uble you are in.
>
> Phil
>
I will try that at some point but not right now because the restore
from my backups takes about 15 hours.

Thomas
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
