From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: raid10 regression: unrecoverable raids
Date: Mon, 19 Mar 2012 11:59:55 +0100
Message-ID: <4F6711AB.7010906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Brown, Neil" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

commit 2bb77736ae5dca0a189829fbb7379d43364a9dac
Author: NeilBrown <neilb@suse.de>
Date:   Wed Jul 27 11:00:36 2011 +1000

    md/raid10: Make use of new recovery_disabled handling

Caused a serious regression making it impossible to recover certain o2
layout raid10 arrays if they get enter a double degraded state.

If I create an array like this:

root@monkeybay ~]# mdadm --create /dev/md25 --raid-devices=4 --chunk=512
--level=raid10 --layout=o2  --assume-clean  /dev/sda4 missing missing
/dev/sdd4
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md25 started.

Then adding a spare like this:
[root@monkeybay ~]# mdadm -a /dev/md25 /dev/sdb4
mdadm: added /dev/sdb4

The spare ends up being added into slot 4 rather than into the empty
slot 1 and the array never rebuilds.

[root@monkeybay ~]# mdadm --detail /dev/md25
/dev/md25:
        Version : 1.2
  Creation Time : Mon Mar 19 12:52:52 2012
     Raid Level : raid10
     Array Size : 39059456 (37.25 GiB 40.00 GB)
  Used Dev Size : 19529728 (18.63 GiB 20.00 GB)
   Raid Devices : 4
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Mar 19 12:52:56 2012
          State : clean, degraded
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : offset=2
     Chunk Size : 512K

           Name : monkeybay:25  (local to host monkeybay)
           UUID : afbf95cf:7015f3ff:a788bd4d:03b0fe32
         Events : 7

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       0        0        1      removed
       2       0        0        2      removed
       3       8       52        3      active sync   /dev/sdd4

       4       8       20        -      spare   /dev/sdb4
[root@monkeybay ~]#

This only seems to happen with o2 arrays, whereas n2 ones rebuild fine.
I can reproduce the problem if I fail drives 0 and 3 or 1 and 2. Failing
1 and 3 or 2 and 4 works. The problem shows both when creating the array
as above, or if creating it with all four drives and then failing them.

I have been staring at this for a while, but it isn't quite obvious to
me whether it is the recovery procedure that doesn't handle the double
gap properly or whether it is the re-add that doesn't take the o2 layout
into account properly.

This is a fairly serious bug as once a raid hits this state, it is no
longer possible to rebuild it even by adding more drives :(

Neil. any idea what went wrong with the new bad block handling code in
this case?

Cheers,
Jes

dmesg output:
md: bind<sda4>
md: bind<sdd4>
md/raid10:md25: active with 2 out of 4 devices
md25: detected capacity change from 0 to 39996882944
 md25:
md: bind<sdb4>
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:0, o:1, dev:sda4
 disk 1, wo:1, o:1, dev:sdb4
 disk 3, wo:0, o:1, dev:sdd4
md: recovery of RAID array md25
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for recovery.
md: using 128k window, over a total of 19529728k.
md/raid10:md25: insufficient working devices for recovery.
md: md25: recovery done.
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:0, o:1, dev:sda4
 disk 1, wo:1, o:1, dev:sdb4
 disk 3, wo:0, o:1, dev:sdd4
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:0, o:1, dev:sda4
 disk 3, wo:0, o:1, dev:sdd4
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:0, o:1, dev:sda4
 disk 2, wo:1, o:1, dev:sdb4
 disk 3, wo:0, o:1, dev:sdd4
md: recovery of RAID array md25
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for recovery.
md: using 128k window, over a total of 19529728k.
md/raid10:md25: insufficient working devices for recovery.
md: md25: recovery done.
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:0, o:1, dev:sda4
 disk 2, wo:1, o:1, dev:sdb4
 disk 3, wo:0, o:1, dev:sdd4
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:0, o:1, dev:sda4
 disk 3, wo:0, o:1, dev:sdd4
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:0, o:1, dev:sda4
 disk 3, wo:0, o:1, dev:sdd4
