From: Heming Zhao <heming.zhao@suse.com>
Subject: commit 480523feae581 may introduce a bug
Date: Mon, 6 Jul 2020 04:47:10 +0000
Message-ID: <DB7PR04MB466640DAB67751FE3375C9C297690@DB7PR04MB4666.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello list

In cluster-md env, after below steps, "mdadm -D /dev/md0" show state is "active"
```
mdadm -S --scan
mdadm --zero-superblock /dev/sd{a,b}
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb 
```

```
lp-clustermd1:~ # mdadm -D /dev/md0
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

I am not sure if the active state is special on cluster-md, but before 480523feae581, The state is clean.
the related code in kernel is the value of mddev->in_sync.
with commit 480523feae581, the try_set_sync never true. so in_sync always 0.

I am not familiar with md module code and can't give a good fix for this issue.
Below is my silly solutions, there are 2 ways to fix:
- modify md_allow_write(), let "mddev->safemode = 1" also suite for cluster-md.
  The safemode will change back to 0 in set_in_sync(), and never change to other value later.
or
- in mdadm, add a action like 
   "echo clean > /sys/devices/virtual/block/md0/md/array_state".
  do it after creating a cluster-md dev.
