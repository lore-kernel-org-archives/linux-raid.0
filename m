From: Arne Wiebalck <wiebalck@kip.uni-heidelberg.de>
Subject: Partitioning a RAID device
Date: Wed, 4 Sep 2002 14:51:45 +0200 (METDST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.HPX.4.43.0209041432440.11531-100000@electra.kip.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

is it possible to have partitions on a RAID device?

I tried to use fdisk/cfdisk for that. I could set up partitions named
md0p1, md0p2 and so on. The names were given automatically by the tools.

After quit and restart, cfdisk showed the partitions I just set up.
But the corresponding special files were missing, so I created
them using mknod.

After a reboot, cfdisk still reported the partitions to be on the RAID
device, but whenever I try to run a mke2fs, it reports

mke2fs: Device size reported to be zero.  Invalid partition specified, or
        partition table wasn't reread after running fdisk, due to
        a modified partition being busy and in use.  You may need to
        reboot to re-read your partition table.

Anything I am missing here?

TIA,

 arne




**********************************************************************
 Arne Wiebalck                        Kirchhoff Institute for Physics
                                           Technical Computer Science
                                                     Schroederstr. 90
                                                   D-69120 Heidelberg

 e-mail: wiebalck@kip.uni-heidelberg.de      Tel.: (+49) 6221/54-4362
 web   : http://www.kip.uni-heidelberg.de    Fax.: (+49) 6221/54-4345
**********************************************************************



