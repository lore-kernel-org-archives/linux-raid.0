From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: cluster-md mddev->in_sync & mddev->safemode_delay may have bug
Date: Wed, 15 Jul 2020 11:48:26 +0800
Message-ID: <a29f8374-cc64-cc87-71cb-507c43aff503@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, guoqing.jiang@cloud.ionos.com
List-Id: linux-raid.ids

Hello List,


@Neil  @Guoqing,
Would you have time to take a look at this bug?

This mail replaces previous mail: commit 480523feae581 may introduce a bug.
Previous mail has some unclear description, I sort out & resend in this mail.

This bug was reported from a SUSE customer.

In cluster-md env, after below steps, "mdadm -D /dev/md0" shows "State: active" all the time.
```
# mdadm -S --scan
# mdadm --zero-superblock /dev/sd{a,b}
# mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb

# mdadm -D /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Mon Jul  6 12:02:23 2020
         Raid Level : raid1
         Array Size : 64512 (63.00 MiB 66.06 MB)
      Used Dev Size : 64512 (63.00 MiB 66.06 MB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Mon Jul  6 12:02:24 2020
              State : active <==== this line
     Active Devices : 2
    Working Devices : 2
     Failed Devices : 0
      Spare Devices : 0

Consistency Policy : bitmap

               Name : lp-clustermd1:0  (local to host lp-clustermd1)
       Cluster Name : hacluster
               UUID : 38ae5052:560c7d36:bb221e15:7437f460
             Events : 18

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
```

with commit 480523feae581 (author: Neil Brown), the try_set_sync never true, so mddev->in_sync always 0.

the simplest fix is bypass try_set_sync when array is clustered.
```
  void md_check_recovery(struct mddev *mddev)
  {
     ... ...
         if (mddev_is_clustered(mddev)) {
             struct md_rdev *rdev;
             /* kick the device if another node issued a
              * remove disk.
              */
             rdev_for_each(rdev, mddev) {
                 if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
                         rdev->raid_disk < 0)
                     md_kick_rdev_from_array(rdev);
             }
+           try_set_sync = 1;
         }
     ... ...
  }
```
this fix makes commit 480523feae581 doesn't work when clustered env.
I want to know what impact with above fix.
Or does there have other solution for this issue?


--------
And for mddev->safemode_delay issue

There is also another bug when array change bitmap from internal to clustered.
the /sys/block/mdX/md/safe_mode_delay keep original value after changing bitmap type.
in safe_delay_store(), the code forbids setting mddev->safemode_delay when array is clustered.
So in cluster-md env, the expected safemode_delay value should be 0.

reproduction steps:
```
# mdadm --zero-superblock /dev/sd{b,c,d}
# mdadm -C /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sdb /dev/sdc
# cat /sys/block/md0/md/safe_mode_delay
0.204
# mdadm -G /dev/md0 -b none
# mdadm --grow /dev/md0 --bitmap=clustered
# cat /sys/block/md0/md/safe_mode_delay
0.204  <== doesn't change, should ZERO for cluster-md
```

thanks
