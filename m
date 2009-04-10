From: Jared Raddigan <jraddigan@kfh.org>
Subject: Mirroring Entire Drives Partition Type Clarification
Date: Fri, 10 Apr 2009 14:00:23 -0700
Message-ID: <68c007470904101400s498b2d03w79e15072f1fa6605@mail.gmail.com>
References: <68c007470904101351y7442396bla5366afbc7653e10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c007470904101351y7442396bla5366afbc7653e10@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Playing with mdadm today I noticed it seems to allow full drive
mirroring something I remember that raidtools would fail on.

 Back in raidtools days I remember that even though it was possible to
mirror an entire drive with a single md volume (sda, sdb rather than
sda1, sdb1) it really did not work and was not recommended.=A0 It looks
like that is no longer the case with mdadm.   Here is what I did.

 Took two hard drives and created a single partition that spans the
whole drive.=A0 then do:

 mdadm --create --level=3Dmirror --raid-devices=3D2 /dev/md1 /dev/sd[ab=
]1

 Look using mdadm --detail and see
 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
 =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1
 =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1


 I reboot and now using mdadm --detail I see:
 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
 =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda
 =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb

 So it would seem mdadm basically figured out what I wanted to do and
no longer shows the partition number after a reboot.=A0 So next deleted
all partitions on the drives and recreated the raid set without
referencing the partitions

 mdadm --create --level=3Dmirror --raid-devices=3D2 /dev/md1 /dev/sd[ab=
]

 That worked just fine and now=A0 mdadm --detail gives me the same as
before (but without rebooting)
 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
 =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda
 =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb


 My questions are:

 Is there anything wrong with doing this as this was not recommend
with raidtools.=A0 This with LVM or partition the md directly (cool
feature you added) seems like a hard combo to beat?

 Does the MBR get synced across the drives when doing this?

 I know partition type does not seem to matter with mdadm compared to
raidtools, but when creating partitions I use "da" rather than "fd",
is that the recommended type or since it no longer seems to matter no
one really cares what you use?

 I am using version mdadm - v2.6.7.2 - 14th November 2008 from Debian L=
enny

 Thanks and I am pretty excited how mdadm keeps getting better and bett=
er.

 --
 Jared


>
>



--
Jared Raddigan
Koinonia I.T. Director
p. 916-577-7982 x101
http://www.kfh.org
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
