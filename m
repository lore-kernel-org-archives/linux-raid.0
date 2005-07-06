From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Bugreport mdadm-2.0-devel-1
Date: Wed, 06 Jul 2005 12:13:31 +0300
Message-ID: <1684363827.20050706121331@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!
I'm getting problems with raid1 creation using new superblock format.
Kernel used is 2.6.12.2 (with drivers/md and include/linux/raid taken from
2.6.13-rc1 to have a support for bitmaps and bug correction of md
failing when starting resync), all compiled together.

For mdadm I tried both mdadm-2.0-devel-1 and mdadm-2.0-devel-1a.
Compiles only if -Werror is removed from the Makefile, otherwise
/usr/include/asm/byteorder.h:6:2: #warning using private kernel header; include <endian.h> instead!

raid1 creation with superblock 0.90 goes OK.
However, when I try using superflock version 1, I get the following from
mdadm-2.0-devel-1a:
# mdadm -C -e 1 /dev/md2 -l 1 -n 2 /dev/sdb /dev/sdc
mdadm: /dev/sdb appears to be part of a raid array:
    level=1 devices=2 ctime=Tue Jul  5 18:55:26 2005
mdadm: /dev/sdc appears to be part of a raid array:
    level=1 devices=2 ctime=Tue Jul  5 18:55:26 2005
Continue creating array? y
mdadm: internal error - sb_offset is wrong
Aborted

(Note that md_p.h already has md_p.h: __u8    pad1[128-100];  /* set
to 0 when written */)

and the following from mdadm-2.0-devel-1:
# mdadm -C -e 1 /dev/md2 -l 1 -n 2 /dev/sdb /dev/sdc
mdadm: /dev/sdb appears to be part of a raid array:
    level=1 devices=2 ctime=Tue Jul  5 18:55:26 2005
mdadm: /dev/sdc appears to be part of a raid array:
    level=1 devices=2 ctime=Tue Jul  5 18:55:26 2005
Continue creating array? y
VERS = 9002
mdadm: ADD_NEW_DISK for /dev/sdb failed: Device or resource busy

Also I think --zero-superblock doesn't do the job since I tried it,
but the superblock still remains.

Please advise.

Thanks,

Maxim.

