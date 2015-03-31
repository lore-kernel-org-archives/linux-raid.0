From: =?UTF-8?Q?Dieter_N=C3=BCtzel?= <Dieter@nuetzel-hh.de>
Subject: openSUSE 13.2: md - Need advice which raid1 super format (1.0/1.2) is
 preferred
Date: Wed, 01 Apr 2015 01:55:18 +0200
Message-ID: <309b2c5704621339acbe84a19d84f766@mail.ud03.udmedia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello List,

I need advice from the 'gurus' which raid1 md super format (1.0 or 1.2)=
=20
is preferred for SSD/'old' SATA disks.

Currently I have this on my gfx devel machine (Xeon X3430):

cat /=E2=81=A0proc/=E2=81=A0mdstat
Personalities : [raid1]
md2 : active raid1 sdc1[0] sdd1[1]
       156288896 blocks super 1.0 [2/=E2=81=A02] [UU]
       bitmap: 0/=E2=81=A02 pages [0KB], 65536KB chunk

md1 : active raid1 sdb2[1] sda2[0]
       60391744 blocks super 1.2 [2/=E2=81=A02] [UU]

md0 : active raid1 sdb1[1] sda1[0]
       2095104 blocks super 1.2 [2/=E2=81=A02] [UU]

unused devices: <none>

md0 and md1
are on my SSD's which I've created by 'hand' (with mdadm) under openSUS=
E=20
13.2.

md2
is on my SATAs which I've created 'automatically' under yast2.

My question to you is:
Looks this sane (chunk only for super 1.0 on real SATAs and super 1.2 o=
n=20
SSDs) or should I change anything, here.

I'll nuke md0 (swap) and merge it with md1 (root) 'cause I've upgraded=20
my RAM from 4 GB to 16 GB (soon to 24/32 GB max) and do not need swap=20
anylonger.

Any hints?

-=E2=81=A0Dieter
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
