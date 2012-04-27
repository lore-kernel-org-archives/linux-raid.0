From: likewhoa <likewhoa@weboperative.com>
Subject: raid10 issues after reorder of boot drives.
Date: Fri, 27 Apr 2012 16:04:22 -0400
Message-ID: <4F9AFBC6.7070803@weboperative.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a strange issue on my raid10 8x400GB array. I cannot assemble my
array anymore and it's gotten to a point that I don't know what to do to
recover my data. I was hoping I could get some advice on it. Below is
some info which I hope will help troubleshoot this issue.

> mdadm -Esv
ARRAY /dev/md/1 metadata=1.0 num-devices=0
UUID=828ed03d:0c28afda:4a636e88:7b29ec9f name=Darkside:1
   spares=7  
devices=/dev/sdg3,/dev/sdf3,/dev/sde3,/dev/sdd3,/dev/sdc3,/dev/sda3,/dev/sdb3
ARRAY /dev/md/1 level=raid10 metadata=1.0 num-devices=8
UUID=828ed03d:0c28afda:4a636e88:7b29ec9f name=Darkside:1
   devices=8:131

> mdadm --version
mdadm - v3.2.3 - 23rd December 2011

> for i in /dev/sd{a,b,c,d,e,f,g,i}; do fdisk -l
${i};done                                                                                      


Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x4644f013

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sda2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sda3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e460f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdb2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdb3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x7d10530f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdc2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdc3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdd: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x81a213ab

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdd2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdd3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sde: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x4644f00e

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sde2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sde3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdf: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x4644f00c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdf2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdf3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdg: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x327d8d82

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdg2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdg3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdi: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e460f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdi1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdi2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdi3        73779200   976773119   451496960   fd  Linux raid
autodetect

> uname -r
3.3.3-gentoo

Thanks in advanced.

