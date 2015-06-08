From: Vilhelm von Ehrenheim <vonehrenheim@gmail.com>
Subject: Reshape of RAID5 array from 3 to 4 disks frozen
Date: Mon, 8 Jun 2015 08:19:22 +0200
Message-ID: <CAJ1MkgJWoeKr+uT39AVwHOax_Z12ZF1G6v9nUz1OLvSkewQQqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!
I recently added a new disk to my RAID5 array and started growing it.

I started the grow process with the following command (as i understand
it i should have had a backup file):

    $ mdadm --grow --raid-devices=4 /dev/md0

The reshape process has frozen at `28%`. I can no longer mount the
array, stop it or anything it just seem to have frozen up.

Trying to mount the array just hangs

    # mount /dev/md0 /mnt/storage/

And the same if I try to stop the array

    # mdadm -S /dev/md0

I have also tried growing it down to 3 devices again but it is busy
with the last reshape:

    # mdadm --grow /dev/md0 --raid-devices=3
    mdadm: /dev/md0 is performing resync/recovery and cannot be reshaped

I tried to mark the new drive as faulty to see if the reshape would
stop but to no avail. It works to mark it as failed but nothing
happens.

After this I tried to reboot (a bit risky, i know) but the reshape
starts again from the same position still frozen at 28%.

I also tried to run a check instead of a reshape (as I read somewhere
this fixed a similar problem) but the device is busy

    # echo check>/sys/block/md0/md/sync_action
    -bash: echo: write error: Device or resource busy



Here is some info on the array:

    # mdadm -D /dev/md0

    /dev/md0:
            Version : 1.2
      Creation Time : Sat Mar 28 17:31:15 2015
         Raid Level : raid5
         Array Size : 5860063744 (5588.59 GiB 6000.71 GB)
      Used Dev Size : 2930031872 (2794.30 GiB 3000.35 GB)
       Raid Devices : 4
      Total Devices : 4
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Sun Jun  7 11:04:28 2015
              State : clean, reshaping
     Active Devices : 4
    Working Devices : 4
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 256K

     Reshape Status : 28% complete
      Delta Devices : 1, (3->4)

               Name : ocular:0  (local to host ocular)
               UUID : e1f7a83b:2e43c552:84d09d04:b1416cb2
             Events : 344582

        Number   Major   Minor   RaidDevice State
           4       8       17        0      active sync   /dev/sdb1
           1       8       49        1      active sync   /dev/sdd1
           3       8       65        2      active sync   /dev/sde1
           5       8       33        3      active sync   /dev/sdc1

and

    # cat /proc/mdstat

    Personalities : [raid6] [raid5] [raid4]
    md0 : active raid5 sdb1[4] sdc1[5] sde1[3] sdd1[1]
          5860063744 blocks super 1.2 level 5, 256k chunk, algorithm 2
[4/4] [UUUU]
          [=====>...............]  reshape = 28.6%
(840259584/2930031872) finish=finish=33438525.6min speed=1K/sec
          bitmap: 3/22 pages [12KB], 65536KB chunk

    unused devices: <none>

I have also run extended SMART tests on all four disks and they all
passed without error.

One thing that is strange and that seem to be connected to the reshape
is this error, present in dmesg:

    [  360.625322] INFO: task md0_reshape:126 blocked for more than 120 seconds.
    [  360.625351]       Not tainted 4.0.4-2-ARCH #1
    [  360.625367] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
    [  360.625394] md0_reshape     D ffff88040af57a58     0   126
2 0x00000000
    [  360.625397]  ffff88040af57a58 ffff88040cf58000 ffff8800da535b20
00000001642a9888
    [  360.625399]  ffff88040af57fd8 ffff8800da429000 ffff8800da429008
ffff8800da429208
    [  360.625401]  0000000096400e00 ffff88040af57a78 ffffffff81576707
ffff8800da429000
    [  360.625403] Call Trace:
    [  360.625410]  [<ffffffff81576707>] schedule+0x37/0x90
    [  360.625428]  [<ffffffffa0120de9>] get_active_stripe+0x5c9/0x760 [raid456]
    [  360.625432]  [<ffffffff810b6c70>] ? wake_atomic_t_function+0x60/0x60
    [  360.625436]  [<ffffffffa01246e0>] reshape_request+0x5b0/0x980 [raid456]
    [  360.625439]  [<ffffffff81579053>] ? schedule_timeout+0x123/0x250
    [  360.625443]  [<ffffffffa011743f>] sync_request+0x28f/0x400 [raid456]
    [  360.625449]  [<ffffffffa00da486>] ? is_mddev_idle+0x136/0x170 [md_mod]
    [  360.625454]  [<ffffffffa00de4ba>] md_do_sync+0x8ba/0xe70 [md_mod]
    [  360.625457]  [<ffffffff81576002>] ? __schedule+0x362/0xa30
    [  360.625462]  [<ffffffffa00d9e54>] md_thread+0x144/0x150 [md_mod]
    [  360.625464]  [<ffffffff810b6c70>] ? wake_atomic_t_function+0x60/0x60
    [  360.625468]  [<ffffffffa00d9d10>] ? md_start_sync+0xf0/0xf0 [md_mod]
    [  360.625471]  [<ffffffff81093418>] kthread+0xd8/0xf0
    [  360.625473]  [<ffffffff81093340>] ? kthread_worker_fn+0x170/0x170
    [  360.625476]  [<ffffffff8157a398>] ret_from_fork+0x58/0x90
    [  360.625478]  [<ffffffff81093340>] ? kthread_worker_fn+0x170/0x170


Also, looking at CPU usage md0_raid5 seems to be having problems as it
is stuck on 100% CPU on one core:

     PID USER      PR  NI    VIRT    RES  %CPU %MEM     TIME+ S COMMAND
     125 root      20   0    0.0m   0.0m 100.0  0.0  35:57.44 R  `- md0_raid5
     126 root      20   0    0.0m   0.0m   0.0  0.0   0:00.06 D  `- md0_reshape

Could this be why the reshape has stopped?

Can I do something to get it going again or Is it possible to revert
to using 3 drives again without losing data? The data is not super
important, hence no backup solution, but it would mean a lot of lost
work.

I'm thankful for any help I can get. Not sure what to do now.

Br,
Vilhelm von Ehrenheim
