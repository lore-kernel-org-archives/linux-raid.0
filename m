From: Theophanis Kontogiannis <tkonto@gmail.com>
Subject: Question on blocks periodic writes
Date: Wed, 9 Nov 2016 19:20:14 +0200
Message-ID: <CAOzB0-6NYUqrzUyx3iQ8CbPwFh-dctKTVwE6GKupdYM-8AfOrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello All,

I am in the middle of bringing my server's power consumption to an
absolute minimum.

Have already reduced idle power from 110W to 52W (including 10W
consumed by the UPS).

Having enabled spin down to all 5 x 2TB disks, with 5 seconds idle
times, I noticed that the disks wake up quite often without the server
doing anything actual.

Following

   'echo 1 > /proc/sys/vm/block_dump'

I can not miss that

   'dmesg -c'

reports frequent messages like:

[ 8662.496150] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)
[ 8662.496185] md0_raid6(631): WRITE block 16 on sdf3 (8 sectors)
[ 8662.496253] md0_raid6(631): WRITE block 16 on sdg3 (8 sectors)
[ 8662.496269] md0_raid6(631): WRITE block 16 on sdd3 (8 sectors)
[ 8662.496282] md0_raid6(631): WRITE block 16 on sde3 (8 sectors)
[ 8664.849252] md0_raid6(631): WRITE block 8 on sda3 (1 sectors)
[ 8664.849276] md0_raid6(631): WRITE block 8 on sdf3 (1 sectors)
[ 8664.849287] md0_raid6(631): WRITE block 8 on sdg3 (1 sectors)
[ 8664.849298] md0_raid6(631): WRITE block 8 on sdd3 (1 sectors)
[ 8664.849352] md0_raid6(631): WRITE block 8 on sde3 (1 sectors)
[ 8664.858104] xfsaild/md1(658): WRITE block 0 on md1 (8 sectors)
[ 8664.902688] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)
[ 8664.902705] md0_raid6(631): WRITE block 16 on sdf3 (8 sectors)
[ 8664.902715] md0_raid6(631): WRITE block 16 on sdg3 (8 sectors)
[ 8664.902725] md0_raid6(631): WRITE block 16 on sdd3 (8 sectors)
[ 8664.902735] md0_raid6(631): WRITE block 16 on sde3 (8 sectors)
[ 8665.100056] md1_raid6(630): WRITE block 8 on sda1 (1 sectors)
[ 8665.100107] md1_raid6(630): WRITE block 8 on sdf1 (1 sectors)
[ 8665.100164] md1_raid6(630): WRITE block 8 on sde1 (1 sectors)
[ 8665.100217] md1_raid6(630): WRITE block 8 on sdg1 (1 sectors)
[ 8665.100467] md1_raid6(630): WRITE block 8 on sdd1 (1 sectors)
[ 8665.177050] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)
[ 8665.177098] md0_raid6(631): WRITE block 16 on sdf3 (8 sectors)
[ 8665.177154] md0_raid6(631): WRITE block 16 on sdg3 (8 sectors)
[ 8665.177207] md0_raid6(631): WRITE block 16 on sdd3 (8 sectors)
[ 8665.177431] md0_raid6(631): WRITE block 16 on sde3 (8 sectors)
[ 8665.225978] md0_raid6(631): WRITE block 8 on sda3 (1 sectors)
[ 8665.225996] md0_raid6(631): WRITE block 8 on sdf3 (1 sectors)
[ 8665.226064] md0_raid6(631): WRITE block 8 on sdg3 (1 sectors)
[ 8665.226111] md0_raid6(631): WRITE block 8 on sdd3 (1 sectors)
[ 8665.226191] md0_raid6(631): WRITE block 8 on sde3 (1 sectors)
[ 8670.269138] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)
[ 8670.269180] md0_raid6(631): WRITE block 16 on sdf3 (8 sectors)
[ 8670.269237] md0_raid6(631): WRITE block 16 on sdg3 (8 sectors)
[ 8670.269291] md0_raid6(631): WRITE block 16 on sdd3 (8 sectors)
[ 8670.269344] md0_raid6(631): WRITE block 16 on sde3 (8 sectors)
[ 8680.269050] md0_raid6(631): WRITE block 16 on sda3 (8 sectors)
[ 8680.269092] md0_raid6(631): WRITE block 16 on sdf3 (8 sectors)
[ 8680.269147] md0_raid6(631): WRITE block 16 on sdg3 (8 sectors)
[ 8680.269249] md0_raid6(631): WRITE block 16 on sdd3 (8 sectors)
[ 8680.269428] md0_raid6(631): WRITE block 16 on sde3 (8 sectors)

I guess those messages are the reason for the frequent disks spin up.

What is the reason behind those writes?

Can I affect it? Should I touch it?


---
Best regards,
=CE=9C=CE=A6=CE=A7,

Theophanis Kontogiannis
