From: william L'Heureux <wil_c_will@hotmail.com>
Subject: reaid problem at reboot
Date: Tue, 21 Jun 2011 09:14:34 -0400
Message-ID: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hi,

before we start, please note that im not a pro at mdadm or lvm, and don=
t now the full terminology neither the full how it works.

1 week ago, 1 of my raid6 went wrong. it didnt have any superblock anym=
ore. I know all the drives that belongs to that raid but=20
i=A0
 dont know the right order of the drives. I tried a python script with=20
assemble and permutation all combination possible. it then checks
the
 header and do a e2fsck -n to check errors. Everytime i run the script =
i
 get several and different results on each run. Some say that
the=20
order of the drives doesnt matter, i agree but withotuh superblock its=20
another story. I got another raid6 which is fine and on top of those=20
2
 raid6, there is a lvm. if you have any question or output you want to=20
see, please tell me and i will provide further informations as soon as =
i
 can
if you dont understand me, i apologize, im trying to be better at engli=
sh everyday.

Thanks

William

=A0=A0=A0=A0 sudo cat /dev/.mdadm/map
md0 1.2 85c93553:f5707fc9:b777b1e6:a0427190 /dev/md0
md1 1.2 32d61f75:647daf4b:c1ee26ec:bc926504 /dev/md1

=A0=A0=A0 cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]
md0 : active raid6 sdd1[5] sda1[4] sdi1[3] sdh1[2] sdj1[1] sdc1[0]
=A0=A0=A0=A0=A0 7809854976 blocks super 1.2 level 6, 128k chunk, algori=
thm 2 [6/6] [UUUUUU]

md1 : active raid6 sdk1[0] sdg1[7] sde1[6] sdf1[5] sdm1[8] sdb1[1]
=A0=A0=A0=A0=A0 7809855488 blocks super 1.2 level 6, 128k chunk, algori=
thm 2 [6/6] [UUUUUU]
=A0=A0=A0=A0=A0 bitmap: 0/15 pages [0KB], 65536KB chunk

=A0=A0=A0=A0=A0=A0=A0 mount -r /mnt/data0
mount: wrong fs type, bad option, bad superblock on /dev/mapper/vgRAID6=
0-data0,
=A0=A0=A0=A0=A0=A0 missing codepage or helper program, or other error
=A0=A0=A0=A0=A0=A0 In some cases useful info is found in syslog - try
=A0=A0=A0=A0=A0=A0 dmesg | tail=A0 or so


=A0=A0=A0=A0=A0=A0 cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR jeromepoulin@gmail.com

# definitions of existing MD arrays
#ARRAY /dev/md/0 metadata=3D1.2 UUID=3Dd2349636:b4a0cb67:2af3246a:c7d72=
c9c name=3DBILLSSHACK:0
ARRAY /dev/md1 UUID=3Db52df561:301f043c:b5a7b1ab:9d934878
=A0=A0 spares=3D1
#ARRAY /dev/md/3 metadata=3D1.2 UUID=3D751fd632:4baf7d64:ec26eec1:04659=
2bc name=3Dbillsshack:3
#ARRAY /dev/md/2 metadata=3D1.2 UUID=3Dcf2450e4:bc7a9cea:cb5ccda9:6f3ec=
87c name=3Dbillsshack:2

# This file was auto-generated on Wed, 15 Jun 2011 08:57:49 -0400
# by mkconf $Id$
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
