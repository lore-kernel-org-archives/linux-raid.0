From: Noah Beck <noah.b.beck@gmail.com>
Subject: Re: recovery from selinux blocking --backup-file during RAID5->6
Date: Wed, 6 Apr 2016 10:16:36 -0400
Message-ID: <CAFAW0zzauYrAd-v3Yq03-XSpO9KCSXcUtXnGWKMvd-VYQj5O5g@mail.gmail.com>
References: <CAFAW0zxisX2Db_YdJxtNpF4YKayy=AnKnWcGdAgw6piy1Jjyng@mail.gmail.com>
	<CAF-Kpgaj2ycfxLumyXw1FwX+NetPa3XN0zhr6EM5O-qvnm6jrA@mail.gmail.com>
	<CAF-KpgYqa9hB7m=pNAc8GFrTuKF8YwToHXvU4U2uCncs77Jx5g@mail.gmail.com>
	<CAFAW0zyNS3m4ZZ59xCkznxopo0d4soWQZrd2eBVfovfNCoX6Sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFAW0zyNS3m4ZZ59xCkznxopo0d4soWQZrd2eBVfovfNCoX6Sg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Update:

I backed up locally all data I cared about from the "raid5" array while it was
stuck in the state:

md127 : active raid6 sde1[3] sda1[2] sdd1[0] sdf1[1]
      5860535808 blocks super 0.91 level 6, 64k chunk, algorithm 18
[5/4] [UUUU_]
      [>....................]  reshape =  0.0% (1/1953511936)
finish=1895.2min speed=16642K/sec

I found that the previous patch (in
https://marc.info/?l=linux-raid&m=145187378405337&w=2) of course does not apply
cleanly to the top of the current git tree.  Looking through the change logs, I
found that a slightly modified version of said patch was included just before
the mdadm-3.4 release.  So instead I grabbed the git repo tagged mdadm-3.4
(http://git.neil.brown.name/?p=mdadm.git;a=snapshot;h=c61b1c0bb5ee7a09bb25250e6c12bcd4d4cafb0c;sf=tgz)
and built mdadm from there.

Starting point after unmounting filesystems and a vgchange -an (md127
is a physical volume in lvm):
# mdadm --detail /dev/md127
/dev/md127:
        Version : 0.91
  Creation Time : Sat Dec 17 23:41:15 2011
     Raid Level : raid6
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Wed Apr  6 08:33:26 2016
          State : clean, degraded, reshaping
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric-6
     Chunk Size : 64K

 Reshape Status : 0% complete
     New Layout : left-symmetric

           UUID : 31838cca:af76c356:b4981550:b0a7388d
         Events : 0.184874

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8       81        1      active sync   /dev/sdf1
       2       8        1        2      active sync   /dev/sda1
       3       8       65        3      active sync   /dev/sde1
       8       0        0        8      removed

I stopped the array:
# mdadm --stop /dev/md127

Then tried re-assembling it (using the locally-built mdadm):
# mdadm --assemble --verbose --update=revert-reshape /dev/md127 $devices
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdd1: Can only revert reshape which changes number of devices

Is the mdadm code only looking for the case where a new device was added but
the raid level was not modified?  Recall, this was a 4-device raid5 that was
attempted to be converted to a 5-device raid6.

Out of curiosity, from looking at the patch Neil committed to the tree, I also
tried adding the --invalid-backup option:

# ./md127/mdadm --assemble --verbose --update=revert-reshape
--invalid-backup /dev/md127 $devices
mdadm: looking for devices for /dev/md127
mdadm: --update=revert-reshape not understood for 0.90 metadata

I see the current metadata version is something like 1.2 now?  This array (now
running on a Fedora 22 system) was originally created on a much older Fedora,
at least as old as Fedora 9.

I can create a new array out of the disks and dump my data back onto it if the
array is really stuck in a state it can't get out of.  Is there anything else I
should try first, or any other experiment to run?

Noah
