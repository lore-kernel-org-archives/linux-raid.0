From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Raid5 Failure
Date: Sun, 17 Jul 2005 22:24:22 -0400
Message-ID: <006401c58b3f$cf3e3c10$c200a8c0@NCNF5131FTH>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH><17114.54800.132155.142544@cse.unsw.edu.au><00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH><17114.62108.319878.983091@cse.unsw.edu.au><010701c58b32$ee423830$c200a8c0@NCNF5131FTH><17115.149.130115.176372@cse.unsw.edu.au><001601c58b37$620c69d0$c200a8c0@NCNF5131FTH><17115.1749.370942.838069@cse.unsw.edu.au><004b01c58b3a$8e26f910$c200a8c0@NCNF5131FTH> <17115.4262.933192.235433@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil -

I'm using 2.6.12.

-(root@abyss)-(/)- # uname -ar
Linux abyss 2.6.12 #2 SMP Mon Jun 20 22:15:25 EDT 2005 i686 unknown unknown 
GNU/Linux

I unmounted the raid, used the readonly, then readwrite - then remounted the 
raid.

Jul 17 22:19:14 abyss kernel: md: md0 switched to read-only mode.
Jul 17 22:19:23 abyss kernel: md: md0 switched to read-write mode.
Jul 17 22:19:23 abyss kernel: RAID5 conf printout:
Jul 17 22:19:23 abyss kernel:  --- rd:28 wd:27 fd:1
Jul 17 22:19:23 abyss kernel:  disk 0, o:1, dev:sda
Jul 17 22:19:23 abyss kernel:  disk 1, o:1, dev:sdb
Jul 17 22:19:23 abyss kernel:  disk 2, o:1, dev:sdc
Jul 17 22:19:23 abyss kernel:  disk 3, o:1, dev:sdd
Jul 17 22:19:23 abyss kernel:  disk 4, o:1, dev:sde
Jul 17 22:19:23 abyss kernel:  disk 5, o:1, dev:sdf
Jul 17 22:19:23 abyss kernel:  disk 6, o:1, dev:sdg
Jul 17 22:19:23 abyss kernel:  disk 7, o:1, dev:sdh
Jul 17 22:19:23 abyss kernel:  disk 8, o:1, dev:sdi
Jul 17 22:19:23 abyss kernel:  disk 9, o:1, dev:sdj
Jul 17 22:19:23 abyss kernel:  disk 10, o:1, dev:sdk
Jul 17 22:19:23 abyss kernel:  disk 11, o:1, dev:sdl
Jul 17 22:19:23 abyss kernel:  disk 12, o:1, dev:sdm
Jul 17 22:19:23 abyss kernel:  disk 13, o:1, dev:sdn
Jul 17 22:19:23 abyss kernel:  disk 14, o:1, dev:sdo
Jul 17 22:19:23 abyss kernel:  disk 15, o:1, dev:sdp
Jul 17 22:19:23 abyss kernel:  disk 16, o:1, dev:sdq
Jul 17 22:19:23 abyss kernel:  disk 17, o:1, dev:sdr
Jul 17 22:19:23 abyss kernel:  disk 18, o:1, dev:sds
Jul 17 22:19:23 abyss kernel:  disk 19, o:1, dev:sdt
Jul 17 22:19:23 abyss kernel:  disk 20, o:1, dev:sdu
Jul 17 22:19:23 abyss kernel:  disk 21, o:1, dev:sdv
Jul 17 22:19:23 abyss kernel:  disk 22, o:1, dev:sdw
Jul 17 22:19:23 abyss kernel:  disk 23, o:1, dev:sdx
Jul 17 22:19:23 abyss kernel:  disk 24, o:1, dev:sdy
Jul 17 22:19:23 abyss kernel:  disk 25, o:1, dev:sdz
Jul 17 22:19:23 abyss kernel:  disk 26, o:1, dev:sdaa
Jul 17 22:19:23 abyss kernel:  disk 27, o:1, dev:sdab
Jul 17 22:19:23 abyss kernel: .<6>md: syncing RAID array md0
Jul 17 22:19:23 abyss kernel: md: minimum _guaranteed_ reconstruction speed: 
1000 KB/sec/disc.
Jul 17 22:19:23 abyss kernel: md: using maximum available idle IO bandwith 
(but not more than 200000 KB/sec) for reconstruction.
Jul 17 22:19:23 abyss kernel: md: using 128k window, over a total of 
71687296 blocks.


-(root@abyss)-(/)- # mdadm --detail /dev/md0
/dev/md0:
        Version : 01.00.01
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
     Array Size : 1935556992 (1845.89 GiB 1982.01 GB)
    Device Size : 71687296 (68.37 GiB 73.41 GB)
   Raid Devices : 28
  Total Devices : 28
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Jul 17 22:20:09 2005
          State : clean, degraded, recovering
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-asymmetric
     Chunk Size : 128K

 Rebuild Status : 0% complete

           UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
         Events : 176947

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/evms/.nodes/sda
       1       8       16        1      active sync   /dev/evms/.nodes/sdb
       2       8       32        2      active sync   /dev/evms/.nodes/sdc
       3       8       48        3      active sync   /dev/evms/.nodes/sdd
       4       8       64        4      active sync   /dev/evms/.nodes/sde
       5       8       80        5      active sync   /dev/evms/.nodes/sdf
       6       8       96        6      active sync   /dev/evms/.nodes/sdg
       7       8      112        7      active sync   /dev/evms/.nodes/sdh
       8       8      128        8      active sync   /dev/evms/.nodes/sdi
       9       8      144        9      active sync   /dev/evms/.nodes/sdj
      10       8      160       10      active sync   /dev/evms/.nodes/sdk
      11       8      176       11      active sync   /dev/evms/.nodes/sdl
      12       8      192       12      active sync   /dev/evms/.nodes/sdm
      13       8      208       13      active sync   /dev/evms/.nodes/sdn
      14       8      224       14      active sync   /dev/evms/.nodes/sdo
      15       8      240       15      active sync   /dev/evms/.nodes/sdp
      16      65        0       16      active sync   /dev/evms/.nodes/sdq
      17      65       16       17      active sync   /dev/evms/.nodes/sdr
      18      65       32       18      active sync   /dev/evms/.nodes/sds
      19      65       48       19      active sync   /dev/evms/.nodes/sdt
      20      65       64       20      active sync   /dev/evms/.nodes/sdu
      21      65       80       21      active sync   /dev/evms/.nodes/sdv
      22      65       96       22      active sync   /dev/evms/.nodes/sdw
      23      65      112       23      active sync   /dev/evms/.nodes/sdx
      24      65      128       24      active sync   /dev/evms/.nodes/sdy
      25      65      144       25      active sync   /dev/evms/.nodes/sdz
      26       0        0        -      removed
      27      65      176       27      active sync   /dev/evms/.nodes/sdab

      28      65      160       26      spare rebuilding 
/dev/evms/.nodes/sdaa


It is re-syncing now. Thanks!

This is from my drivers/md.c - lines 2215->2249.

        if (rdev->faulty) {
                printk(KERN_WARNING
                        "md: can not hot-add faulty %s disk to %s!\n",
                        bdevname(rdev->bdev,b), mdname(mddev));
                err = -EINVAL;
                goto abort_export;
        }
        rdev->in_sync = 0;
        rdev->desc_nr = -1;
        bind_rdev_to_array(rdev, mddev);

        /*
         * The rest should better be atomic, we can have disk failures
         * noticed in interrupt contexts ...
         */

        if (rdev->desc_nr == mddev->max_disks) {
                printk(KERN_WARNING "%s: can not hot-add to full array!\n",
                        mdname(mddev));
                err = -EBUSY;
                goto abort_unbind_export;
        }

        rdev->raid_disk = -1;

        md_update_sb(mddev);

        /*
         * Kick recovery, maybe this spare has to be added to the
         * array immediately.
         */
        set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
        md_wakeup_thread(mddev->thread);

        return 0;

-- David M. Strang

----- Original Message ----- 
From: Neil Brown
To: David M. Strang
Cc: linux-raid@vger.kernel.org
Sent: Sunday, July 17, 2005 10:15 PM
Subject: Re: Raid5 Failure


On Sunday July 17, dstrang@shellpower.net wrote:
> Neil --
>
> That worked, the device has been added to the array. Now, I think the next
> problem is my own ignorance.

It looks like your kernel is missing the following patch (dated 31st
may 2005).  You're near the bleeding edge working with version-1
superblocks (and I do thank you for being a guinea pig:-) and should
use an ultra-recent kernel if at all possible.

If you don't have the array mounted (or can unmount it safely) then
you might be able to convince it to start the rebuild with by setting
it read-only, then writable.
i.e
  mdadm --readonly /dev/md0
  mdadm --readwrite /dev/md0

alternately stop and re-assemble the array.

NeilBrown



-----------------------

Make sure recovery happens when add_new_disk is used for hot_add

Currently if add_new_disk is used to hot-add a drive to a degraded
array, recovery doesn't start ... because we didn't tell it to.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 files changed, 2 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~ 2005-05-31 13:40:35.000000000 +1000
+++ ./drivers/md/md.c 2005-05-31 13:40:34.000000000 +1000
@@ -2232,6 +2232,8 @@ static int add_new_disk(mddev_t * mddev,
  err = bind_rdev_to_array(rdev, mddev);
  if (err)
  export_rdev(rdev);
+
+ set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
  if (mddev->thread)
  md_wakeup_thread(mddev->thread);
  return err; 

