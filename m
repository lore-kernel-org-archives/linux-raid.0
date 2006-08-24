From: "Andreas Pelzner" <Andreas.Pelzner@aixvision.net>
Subject: md: only binds to one mirror after reboot
Date: Thu, 24 Aug 2006 21:03:34 +0200
Message-ID: <C05CC316E92A964C9BDD81EE36AE05343C704F@x2k3.a-team.ihs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello,

after reboot, md only binds to one mirror (/dev/hdb1).
raid1: raid set md0 active with 1 out of 2 mirrors
 
After adding /dev/hda1 manually 'mdadm --add /dev/md0 /dev/hda1', the
raid seems to work well:

isp:/var/log# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hda1[0] hdb1[1]
      154191744 blocks [2/2] [UU]

Any idea what I did wrong?

Tia

some system information:

isp:/var/log# uname -r
2.6.17.8
isp:/var/log# mdadm -V
mdadm - v1.9.0 - 04 February 2005

isp:/var/log# fdisk -l

Disk /dev/hda: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1       19196   154191838+  fd  Linux raid
autodetect
/dev/hda2           19197       19457     2096482+   5  Extended
/dev/hda5           19197       19388     1542208+  82  Linux swap /
Solaris

Disk /dev/hdb: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdb1   *           1       19196   154191838+  fd  Linux raid
autodetect
/dev/hdb2           19197       19457     2096482+   5  Extended
/dev/hdb5           19197       19388     1542208+  82  Linux swap /
Solaris

Disk /dev/md0: 157.8 GB, 157892345856 bytes
2 heads, 4 sectors/track, 38547936 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
#
isp:/var/log# grep md messages
Aug 23 22:16:07 isp kernel: Kernel command line: root=/dev/md0
md=0,/dev/hda1,/dev/hdb1 ro
Aug 23 22:16:07 isp kernel: md: md driver 0.90.3 MAX_MD_DEVS=256,
MD_SB_DISKS=27
Aug 23 22:16:07 isp kernel: md: bitmap version 4.39
Aug 23 22:16:07 isp kernel: md: raid1 personality registered for level 1
Aug 23 22:16:07 isp kernel: md: md0 stopped.
Aug 23 22:16:07 isp kernel: md: bind<hdb1>
Aug 23 22:16:07 isp kernel: raid1: raid set md0 active with 1 out of 2
mirrors
Aug 23 22:16:07 isp kernel: EXT3 FS on md0, internal journal
Aug 23 22:45:55 isp kernel: Kernel command line: root=/dev/md0
md=0,/dev/hda1,/dev/hdb1 ro
Aug 23 22:45:55 isp kernel: md: md driver 0.90.3 MAX_MD_DEVS=256,
MD_SB_DISKS=27
Aug 23 22:45:55 isp kernel: md: bitmap version 4.39
Aug 23 22:45:55 isp kernel: md: raid1 personality registered for level 1
Aug 23 22:45:55 isp kernel: md: md0 stopped.
Aug 23 22:45:55 isp kernel: md: bind<hdb1>
Aug 23 22:45:55 isp kernel: raid1: raid set md0 active with 1 out of 2
mirrors
Aug 23 22:45:55 isp kernel: EXT3 FS on md0, internal journal

<manually added /dev/hda1/>

Aug 24 07:12:30 isp kernel: md: bind<hda1>
Aug 24 07:12:30 isp kernel: md: syncing RAID array md0
Aug 24 07:12:30 isp kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Aug 24 07:12:30 isp kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Aug 24 07:12:30 isp kernel: md: using 128k window, over a total of
154191744 blocks.
Aug 24 08:28:05 isp kernel: md: md0: sync done.

Kind Regards
Andreas Pelzner
