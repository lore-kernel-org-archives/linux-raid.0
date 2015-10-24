From: Guillaume ALLEE <guillaume.allee@gmail.com>
Subject: 2nd Faulty drive while rebuilding array on RAID5
Date: Sun, 25 Oct 2015 00:27:52 +0200
Message-ID: <CABEdK7w7zjjEXXenWRK0BSziekBGhkni50y0j3t=rW2AxNkkqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,


Context:
On my RAID5 sdc was faulty. I bought a new HD, format it and add it to
my raid array. However during the rebuilding sda was detected as
faulty. Now I am not sure what to do...

I followed the steps from the wiki. See at the end my question ;-)

Thanks for your help.

$ uname -a
Linux htpc 3.8.0-35-generic #52~precise1-Ubuntu SMP Thu Jan 30
17:27:28 UTC 2014 i686 i686 i386 GNU/Linux

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012

$ sudo mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Sun Jan  2 08:47:01 2011
     Raid Level : raid5
     Array Size : 5842101312 (5571.46 GiB 5982.31 GB)
  Used Dev Size : 1947367104 (1857.15 GiB 1994.10 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sat Oct 24 23:36:30 2015
          State : clean, FAILED
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 426d71a2:5b25a168:a4e2eff2:d305f1c1
         Events : 0.20213

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       19        1      active sync   /dev/sdb3
       2       0        0        2      removed
       3       8       51        3      active sync   /dev/sdd3

       4       8       35        -      spare   /dev/sdc3
       5       8        3        -      faulty spare   /dev/sda3



$ mdadm --examine /dev/sd[abcdefghijklmn]3 >> raid.status
http://pastebin.com/qaP8bvna

$ sudo mdadm --examine /dev/sd[a-z] | egrep 'Event|/dev/sd'
/dev/sda:
/dev/sdb:
/dev/sdc:
/dev/sdd:
/dev/sde:

I seems that some blocks of sda are not readable.Cf from dmesg
"[17852.126321] end_request: I/O error, dev sda, sector 1958539264"
Full dmesg available at:
http://pastebin.com/bBfcYjkg

Is there some way to re-add this disk (sda) in the array without mdadm
thinging it is a new one ?

I have seen from the wiki that I could try to recreate the array with
--assume-clean but I want to do that only in last resort.

Thanks,

Guillaume
