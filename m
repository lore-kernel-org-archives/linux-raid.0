From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: RAID1 problem, newbie to RAID
Date: Tue, 21 Jan 2003 13:57:14 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D578@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'J Dalessandro' <joe@nan0.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The way to do this is to build the raid on the second disk, and mark the
first one (where you are currently mounted) as the failed disk in raidtab.
You have the raidtab set to use the first disk as the one to format for
raid, so it is busy.

The steps to build a software RAID from an existing Linux install are
outlined at 
  http://www.ibiblio.org/pub/Linux/docs/HOWTO/Software-RAID-HOWTO (section
4.12 & ff)
or
  http://scsirastools.sourceforge.net/docs/UserGuide (section 4.0)

Andy

-----Original Message-----
From: J Dalessandro [mailto:joe@nan0.com] 
Sent: Monday, January 20, 2003 6:39 PM
To: linux-raid@vger.kernel.org
Subject: RAID1 problem, newbie to RAID


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
[...]
