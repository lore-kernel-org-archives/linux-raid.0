From: Leon Avery <leon@eatworms.swmed.edu>
Subject: raidhotadd works, mdadm --add doesn't
Date: Sun, 10 Sep 2006 15:30:39 -0500
Message-ID: <7.0.1.0.0.20060910150522.0360c060@eatworms.swmed.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been using RAID for a long time, but have been using the old 
raidtools.  Having just discovered mdadm, I want to switch, but I'm 
having trouble.  I'm trying to figure out how to use mdadm to replace 
a failed disk.  Here is my /proc/mdstat:

     Personalities : [linear] [raid1]
     read_ahead 1024 sectors
     md5 : active linear md3[1] md4[0]
           1024504832 blocks 64k rounding

     md4 : active raid1 hdf5[0] hdh5[1]
           731808832 blocks [2/2] [UU]

     md3 : active raid1 hde5[0] hdg5[1]
           292696128 blocks [2/2] [UU]

     md2 : active raid1 hda5[0] hdc5[1]
           48339456 blocks [2/2] [UU]

     md0 : active raid1 hda3[0] hdc3[1]
           9765376 blocks [2/2] [UU]

     unused devices: <none>

The relevant parts are md0 and md2.  Physical disk hda failed, which 
left md0 and md2 running in degraded mode.  Having an old spare used 
disk sitting on the shelf, I plugged it in, repartitioned it, and said

     mdadm --add /dev/md0 /dev/hda3

This appeared to work, but when I looked at mdstat, hda3 was marked 
as failed, and md0 was still running degraded.  I then foolishly tried

     mdadm --add /dev/md0 /dev/hda3 --run

That caused a kernel panic and crashed my system.

I rebooted and said

     raidhotadd /dev/md0 /dev/hda3

That worked perfectly, and reconstruction started immediately.  So, 
although I don't actually have a problem at the moment, I still 
haven't figured out how to make mdadm hot-add a replacement disk.

Examination of the syslog was interesting if not exactly 
informative.  Here's the relevant extract from the attempt to use mdadm:

     Sep 10 06:50:28 eatworms kernel: md: trying to hot-add hda3 to md0 ...
     Sep 10 06:50:28 eatworms kernel: md: bind<hda3,2>
     Sep 10 06:50:28 eatworms kernel: RAID1 conf printout:
     Sep 10 06:50:28 eatworms kernel:  --- wd:1 rd:2 nd:1
     Sep 10 06:50:28 eatworms kernel:  disk 0, s:0, o:0, n:0 rd:0 
us:1 dev:[dev 00:00]
     Sep 10 06:50:28 eatworms kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdc3
         ...snip...
     Sep 10 06:50:28 eatworms kernel: RAID1 conf printout:
     Sep 10 06:50:28 eatworms kernel:  --- wd:1 rd:2 nd:2
     Sep 10 06:50:28 eatworms kernel:  disk 0, s:0, o:0, n:0 rd:0 
us:1 dev:[dev 00:00]
     Sep 10 06:50:28 eatworms kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdc3
     Sep 10 06:50:28 eatworms kernel:  disk 2, s:1, o:0, n:2 rd:2 us:1 dev:hda3
         ...snip...
     Sep 10 06:50:28 eatworms kernel: md: updating md0 RAID 
superblock on device
     Sep 10 06:50:28 eatworms kernel: md: hda3 [events: 
0000038c]<6>(write) hda3's sb offset: -64
     Sep 10 06:50:28 eatworms kernel: attempt to access beyond end of device
     Sep 10 06:50:28 eatworms kernel: 03:03: rw=1, want=2147483588, limit=1
     Sep 10 06:50:28 eatworms kernel: md: write_disk_sb failed for device hda3
         ...followed by several retries of this before giving up

The problem seems to be the negative superblock offset.  In contrast, 
the section after the raidhotadd looks like this:

     Sep 10 07:12:29 eatworms kernel: md: trying to hot-add hda3 to md0 ...
     Sep 10 07:12:29 eatworms kernel: md: bind<hda3,2>
     Sep 10 07:12:29 eatworms kernel: RAID1 conf printout:
     Sep 10 07:12:29 eatworms kernel:  --- wd:1 rd:2 nd:1
     Sep 10 07:12:29 eatworms kernel:  disk 0, s:0, o:0, n:0 rd:0 
us:1 dev:[dev 00:00]
     Sep 10 07:12:29 eatworms kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdc3
         ...snip...
     Sep 10 07:12:29 eatworms kernel: RAID1 conf printout:
     Sep 10 07:12:29 eatworms kernel:  --- wd:1 rd:2 nd:2
     Sep 10 07:12:29 eatworms kernel:  disk 0, s:0, o:0, n:0 rd:0 
us:1 dev:[dev 00:00]
     Sep 10 07:12:29 eatworms kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdc3
     Sep 10 07:12:29 eatworms kernel:  disk 2, s:1, o:0, n:2 rd:2 us:1 dev:hda3
         ...snip...
     Sep 10 07:12:29 eatworms kernel: md: updating md0 RAID 
superblock on device
     Sep 10 07:12:29 eatworms kernel: md: hda3 [events: 
00000459]<6>(write) hda3's sb offset: 9765440
     Sep 10 07:12:29 eatworms kernel: md: hdc3 [events: 
00000459]<6>(write) hdc3's sb offset: 9765440

Here we have a reasonable offset of 9765440 and everything works fine.

I suppose this could be an mdadm bug, but it seems more likely that 
I'm doing something stupid.  Could someone enlighten me?

My system config (uname -a):

     Linux eatworms.swmed.edu 2.4.22e #1 Tue Feb 17 13:37:36 CST 2004 
i686 unknown unknown GNU/Linux


--
Leon Avery                                        (214) 648-4931 (voice)
Department of Molecular Biology                            -1488 (fax)
University of Texas Southwestern Medical Center
6000 Harry Hines Blvd                            leon@eatworms.swmed.edu
Dallas, TX  75390-9148                  http://eatworms.swmed.edu/~leon/

