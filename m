From: "Richard Taylor" <ryo.away@gmail.com>
Subject: Failed create or resync - incorrect checksums
Date: Wed, 16 Aug 2006 19:55:41 -0400
Message-ID: <147d2b050608161655v45735d17i14dc764afed10d70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have been trying to get a raid5 array going on SuSE 10.1 Final
(2.6.16.21-0.13-default) but every time I create, resync, or rebuild a
spare it seems to have worked, but

    # mdadm --examine /dev/sd[bcd]1

gives a report that the checksum is off:

    /dev/sdb1:
              Magic : a92b4efc
            Version : 00.90.00
               UUID : 54c68515:52bd0a49:4e00c3d1:138a01a4
      Creation Time : Tue Aug 15 13:14:09 2006
         Raid Level : raid5
        Device Size : 244195840 (232.88 GiB 250.06 GB)
         Array Size : 488391680 (465.77 GiB 500.11 GB)
       Raid Devices : 3
      Total Devices : 3
    Preferred Minor : 1

        Update Time : Wed Aug 16 18:12:59 2006
              State : clean
     Active Devices : 3
    Working Devices : 3
     Failed Devices : 0
      Spare Devices : 0
           Checksum : 4a95604a - expected 4a955f4e
             Events : 0.6

             Layout : left-symmetric
         Chunk Size : 512K

          Number   Major   Minor   RaidDevice State
    this     0       8       17        0      active sync   /dev/sdb1

       0     0       8       17        0      active sync   /dev/sdb1
       1     1       8       33        1      active sync   /dev/sdc1
       2     2       8       49        2      active sync   /dev/sdd1

Furthermore, I can work with the array at this point and it seems to
be ok unless I were to reboot or stop and re-assemble it:

    # mdadm --assemble /dev/md1
    mdadm: failed to add /dev/sdc1 to /dev/md1: Invalid argument
    mdadm: failed to add /dev/sdd1 to /dev/md1: Invalid argument
    mdadm: failed to add /dev/sdb1 to /dev/md1: Invalid argument
    mdadm: /dev/md1 assembled from 0 drives - not enough to start the array.

I've tried to assemble with --update=resync, super-minor, or
summaries.  The latter two seem to work, but the data on the array has
become corrupt as a result.  I would greatly appreciate any help
anybody could give.

Thanks,
Richard
