From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: HELP 13 disk raid 5 not starting
Date: Tue, 15 Nov 2005 16:50:47 -0500
Message-ID: <20051115214704.M9636@contactbda.com>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

all,

I have a 13 disk raid 5 set with 4 disks marks as "clean" and the rest marked as dirty.  When I do the following command
to start the raid set (md0) I get an error.  Any ideas on how to recover?

This is a debian sarge system running kernel 2.6.8-1-686-smp and mdadm version v1.4.0 - 29 Oct 2003

Thanks
Jim

# mdadm --assemble --scan
mdadm: /dev/md0 assembled from 6 drives and 1 spare - not enough to start the array.

my /etc/mdadm/mdadm.conf looks like

DEVICE partitions
ARRAY /dev/md0 level=raid5 num-devices=12 UUID=c9669a6b:cdc5b9d4:1df0802c:86d53e17


and /proc/mdstat looks like

Personalities : [raid5] 
md0 : inactive sdb1[0] sdm1[12] sdn1[11] sdl1[10] sdk1[9] sdj1[8] sdi1[7] sdh1[6] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1]
      3173710592 blocks
unused devices: <none>


