From: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Subject: mdadmin can't re-sync a mirror?!
Date: Fri, 24 Jan 2003 15:34:40 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301241529360.26021-100000@pcmy.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Either I've grossly understood how Linux RAID and/or the mdadmin
command works, or this is horribly wrong:

   Device Boot    Start       End    Blocks   Id  System
/dev/sdb1             1        33    265041   fd  Linux raid autodetect

   Device Boot    Start       End    Blocks   Id  System
/dev/sdc1             1        33    265041   fd  Linux raid autodetect

$ mdadm --create /dev/md0 --verbose --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1

[wait for mirror to sync]

$ cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 sdc1[1] sdb1[0]
      264960 blocks [2/2] [UU]
unused devices: <none>

Okay, now simulate (without physically changing any disks) a failure,
and then a replacement:

$ mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0
mdadm: hot removed /dev/sdc1

$ mdadm --zero-superblock /dev/sdc1

$ mdadm /dev/md0 -a /dev/sdc1
mdadm: hot added /dev/sdc1

But the mirror doesn't sync (!):

$ cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 sdc1[2] sdb1[0]
      264960 blocks [2/1] [U_]
unused devices: <none>

Have I completely misunderstood how Linux software RAID is supposed to
work?  (I certainly hope so, because otherwise, it can't even perform
the simplest of recovery operations: replacing a failed mirror
component and re-syncing.)

Thanks for any comments...

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA

