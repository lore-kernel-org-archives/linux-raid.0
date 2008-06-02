From: "Jeremy Leigh" <jeremy.leigh@gmail.com>
Subject: Problem Growing Raid 5 Array - Help Needed!
Date: Tue, 3 Jun 2008 00:50:35 +1000
Message-ID: <484408bf.20018e0a.68db.ffffe97f@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Guys, I have just grown my raid 5 from 7 to 8 500Gb drives.
I am now running into this problem.
When I try to run fsck /dev/md0 I get the following:

fsck.ext2: Device or resource busy while trying to open /dev/md0
=46ilesystem mounted or opened exclusively by another program?

Or when I try to run resize2fs /dev/md0 to make use of new drive, I get=
 the
following:

resize2fs: Device or resource busy while trying to open /dev/md0
Couldn=92t find valid filesystem superblock.

Cat /proc/mdstat outputs:

Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid5 sdb1[0] sdi1[7] sdg1[6] sdh1[5] sdf1[4] sde1[3] sdd1=
[2]
sdc1[1]
=A0=A0=A0=A0=A0 3418686208 blocks level 5, 256k chunk, algorithm 2 [8/8=
] [UUUUUUUU]
=A0=A0=A0=A0=A0=20
unused devices: <none>

However, I can still access and mount my filesystem - I just cannot gro=
w it,
which I find very strange.
I have tried to init 1, to go to single user mode, and I have made sure=
 file
system is unmounted, but this =91busy=92 error still occurs.

Any ideas? I=92m kinda stuck. Google is no help!

I am running fedora core 7.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
