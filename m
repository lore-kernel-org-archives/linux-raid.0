From: J Dalessandro <joe@nan0.com>
Subject: RAID1 problem, newbie to RAID
Date: Mon, 20 Jan 2003 16:38:44 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E2C8884.8040003@nan0.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to get RAID1 working on a Debian machine with a 2.4.20 
kernel. I hope I am close, but this is my first attempt at RAID on any 
platform.

I seem to get two out of three partitions. I think my problem is in that 
my "/" partition is mounted, but I'm new to RAID and I'm not sure how to 
fix this issue. Below is my: /proc/mdstat, raidtab, fdisk -l outputs. 
What am I missing here to solve my bungled configuration?

CM:~# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hda1[0]
       96256 blocks [2/1] [U_]

md1 : active raid1 hda2[0]
       9767424 blocks [2/1] [U_]

unused devices: <none>

CM:~# cat /etc/raidtab
raiddev /dev/md2
         raid-level              1
         nr-raid-disks           2
         nr-spare-disks          0
         chunk-size              32
         persistent-superblock   1
         device                  /dev/hda3
         raid-disk               0
         device                  /dev/hdc3
         failed-disk             1

raiddev /dev/md1
         raid-level              1
         nr-raid-disks           2
         nr-spare-disks          0
         chunk-size              32
         persistent-superblock   1
         device                  /dev/hda2
         raid-disk               0
         device                  /dev/hdc2
         failed-disk             1

raiddev /dev/md0
         raid-level              1
         nr-raid-disks           2
         nr-spare-disks          0
         chunk-size              32
         persistent-superblock   1
         device                  /dev/hda1
         raid-disk               0
         device                  /dev/hdc1
         failed-disk             1

CM:~# df -k
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/hda3             86437648    480844  81565840   1% /

CM:~# fdisk -l

Disk /dev/hdc: 255 heads, 63 sectors, 12161 cylinders
Units = cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hdc1             1        12     96358+  fd  Linux raid autodetect
/dev/hdc2            13      1228   9767520   fd  Linux raid autodetect
/dev/hdc3          1229     12161  87819322+  fd  Linux raid autodetect

Disk /dev/hda: 255 heads, 63 sectors, 12161 cylinders
Units = cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1        12     96358+  83  Linux
/dev/hda2            13      1228   9767520   82  Linux swap
/dev/hda3          1229     12161  87819322+  83  Linux
CM:~#

