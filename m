From: "=?ISO-8859-2?Q?Micha=B3_Przy=B3uski?=" <mikylie@gmail.com>
Subject: Problems with raid6 growing
Date: Fri, 7 Nov 2008 20:40:57 +0100
Message-ID: <6c4602af0811071140m636c8729xf57f57c6a2c393c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day everybody,

My current setup is raid5 across 3 750G disks. It contains about
1.4T of data (ext3). I'm running Fedora 7.92 (2.6.23-0.214.rc8.git2.fc8,
mdadm v2.6.2). I've ruined myself today to get next 3 750G disks, and
I'm doing some preparatory testing. My aim is to end up with a raid6
across 6 drives, and of course, preserve the data I have. ;-)

After rethinking, and thanks to the feedback from this list, I've obtained a
few months ago, I've come up with the following plan. It seems pretty safe,
as it can survive a single drive failure at any time (I reckon so).

1. create a 3 hdd + 1 missing raid6
2. copy data
3. "check" both arrays
4. degrade old raid5 by 1 drive (--zero-superblock)
5. add it to raid6 & let it sync back
6. "check" raid6 again
7. stop raid5, --zero-superblock on its drives
8. add 2 drives to raid6, --grow it, and then resize ext3

I'm also planning on not doing one huge partition on each disk, but rather
giving whole sd? to md (instead of sd?1 that is).

I've tried dry-running some parts of my plan, and apparently I've encountered
at least 2 problems so far.

First of all, it seems that my version of mdadm doesn't like the idea
of creating
a raid6 with one missing drive. It appears that with mdadm 2.6.7 it's
going good,
but I've still not installed new mdadm system-wide, a bit worried about my
old array created with old mdadm. Anyways, that's within reach, if it's
the aforementioned "raid6 with one missing" problem. It errored with:
Nov  7 18:17:39 kylie kernel: raid5: failed to run raid set md55
Nov  7 18:17:39 kylie kernel: md: pers->run() failed ...
Nov  7 18:17:39 kylie kernel: md: md55 stopped.

Second problem is way more mysterious to me. I cannot grow a raid6!

[root@kylie raid-test]# /sbin/losetup -a
/dev/loop0: [0805]:488562 (dysk1)
/dev/loop1: [0805]:488563 (dysk2)
/dev/loop2: [0805]:488565 (dysk3)
/dev/loop3: [0805]:488566 (dysk4)
/dev/loop4: [0805]:683033 (dysk5)
/dev/loop5: [0805]:683034 (dysk6)

They are about 25MB big.

[root@kylie raid-test]# /sbin/mdadm --create --verbose /dev/md55
--chunk=256 -l 6  --raid-devices=4 /dev/loop0 /dev/loop1 /dev/loop2
/dev/loop3
mdadm: layout defaults to left-symmetric
mdadm: /dev/loop0 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Fri Nov  7 18:24:05 2008
mdadm: /dev/loop1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Fri Nov  7 18:24:05 2008
mdadm: /dev/loop2 appears to be part of a raid array:
    level=raid6 devices=4 ctime=Fri Nov  7 18:23:39 2008
mdadm: /dev/loop3 appears to be part of a raid array:
    level=raid6 devices=4 ctime=Fri Nov  7 18:23:39 2008
mdadm: size set to 24832K
Continue creating array? y
mdadm: array /dev/md55 started.
[root@kylie raid-test]# /sbin/mdadm --add /dev/md55 /dev/loop4 /dev/loop5
mdadm: added /dev/loop4
mdadm: added /dev/loop5
[root@kylie raid-test]# /sbin/mdadm --grow /dev/md55 --raid-devices=6
mdadm: Need to backup 1024K of critical section..

and that's when it hangs. I mean, that mdadm invocation is not returning,
or haven't returned in last 2 hours. It clearly should've.
dmesg seems to say that reshape has been successful

Nov  7 18:26:12 kylie kernel: md: bind<loop4>
Nov  7 18:26:12 kylie kernel: md: bind<loop5>
Nov  7 18:26:35 kylie kernel: RAID5 conf printout:
Nov  7 18:26:35 kylie kernel:  --- rd:6 wd:6
Nov  7 18:26:35 kylie kernel:  disk 0, o:1, dev:loop0
Nov  7 18:26:35 kylie kernel:  disk 1, o:1, dev:loop1
Nov  7 18:26:35 kylie kernel:  disk 2, o:1, dev:loop2
Nov  7 18:26:35 kylie kernel:  disk 3, o:1, dev:loop3
Nov  7 18:26:35 kylie kernel:  disk 4, o:1, dev:loop5
Nov  7 18:26:35 kylie kernel: RAID5 conf printout:
Nov  7 18:26:35 kylie kernel:  --- rd:6 wd:6
Nov  7 18:26:35 kylie kernel:  disk 0, o:1, dev:loop0
Nov  7 18:26:35 kylie kernel:  disk 1, o:1, dev:loop1
Nov  7 18:26:35 kylie kernel:  disk 2, o:1, dev:loop2
Nov  7 18:26:35 kylie kernel:  disk 3, o:1, dev:loop3
Nov  7 18:26:35 kylie kernel:  disk 4, o:1, dev:loop5
Nov  7 18:26:35 kylie kernel:  disk 5, o:1, dev:loop4
Nov  7 18:26:35 kylie kernel: md: reshape of RAID array md55
Nov  7 18:26:35 kylie kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Nov  7 18:26:35 kylie kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reshape.
Nov  7 18:26:35 kylie kernel: md: using 128k window, over a total of
24832 blocks.
Nov  7 18:26:35 kylie kernel: md: md55: reshape done.
Nov  7 18:26:35 kylie kernel: RAID5 conf printout:
Nov  7 18:26:35 kylie kernel:  --- rd:6 wd:6
Nov  7 18:26:35 kylie kernel:  disk 0, o:1, dev:loop0
Nov  7 18:26:35 kylie kernel:  disk 1, o:1, dev:loop1
Nov  7 18:26:35 kylie kernel:  disk 2, o:1, dev:loop2
Nov  7 18:26:35 kylie kernel:  disk 3, o:1, dev:loop3
Nov  7 18:26:35 kylie kernel:  disk 4, o:1, dev:loop5
Nov  7 18:26:35 kylie kernel:  disk 5, o:1, dev:loop4

and of course, I cannot stop the array.

Nov  7 18:33:17 kylie kernel: md: md55 still in use.

[root@kylie kotek]# /sbin/mdadm --detail --verbose /dev/md55
/dev/md55:
        Version : 00.90.03
  Creation Time : Fri Nov  7 18:24:27 2008
     Raid Level : raid6
     Array Size : 99328 (97.02 MiB 101.71 MB)
  Used Dev Size : 24832 (24.25 MiB 25.43 MB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 55
    Persistence : Superblock is persistent

    Update Time : Fri Nov  7 18:38:45 2008
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

           UUID : e6ed36fd:117f91d8:0bcc3650:23ed078a
         Events : 0.42

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1
       2       7        2        2      active sync   /dev/loop2
       3       7        3        3      active sync   /dev/loop3
       4       7        5        4      active sync   /dev/loop5
       5       7        4        5      active sync   /dev/loop4

[root@kylie kotek]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md55 : active raid6 loop0[0] loop4[5] loop5[4] loop3[3] loop2[2] loop1[1]
      99328 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]

md0 : active raid5 sdb1[0] sdd1[2] sdc1[1]
      1465143808 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

I can interrupt the hung 'mdadm --grow' with ^C. After stopping the array,
it also seems that it's fine.

[root@kylie raid-test]# /sbin/mdadm -A --verbose  /dev/md55 /dev/loop[012345]
mdadm: looking for devices for /dev/md55
mdadm: /dev/loop0 is identified as a member of /dev/md55, slot 0.
mdadm: /dev/loop1 is identified as a member of /dev/md55, slot 1.
mdadm: /dev/loop2 is identified as a member of /dev/md55, slot 2.
mdadm: /dev/loop3 is identified as a member of /dev/md55, slot 3.
mdadm: /dev/loop4 is identified as a member of /dev/md55, slot 5.
mdadm: /dev/loop5 is identified as a member of /dev/md55, slot 4.
mdadm: added /dev/loop1 to /dev/md55 as 1
mdadm: added /dev/loop2 to /dev/md55 as 2
mdadm: added /dev/loop3 to /dev/md55 as 3
mdadm: added /dev/loop5 to /dev/md55 as 4
mdadm: added /dev/loop4 to /dev/md55 as 5
mdadm: added /dev/loop0 to /dev/md55 as 0
mdadm: /dev/md55 has been started with 6 drives.

Question here arises, is it dangerous? Or at least, we know what's going
on, why mdadm is not returning. I'm a bit worried about it, to be honest.

Also, somewhere in test, I've had the following (in the same scenario)
[root@kylie raid-test]# /sbin/mdadm --grow /dev/md55 --raid-devices=6
mdadm: Need to backup 1024K of critical section..
mdadm: /dev/md55: failed to suspend device.
[root@kylie raid-test]# /sbin/mdadm --grow /dev/md55 --raid-devices=6
mdadm: Need to backup 1024K of critical section..

(nothing happens, ^C, and arrays is grown again)

Additionally, I've tried this with mdadm 2.6.7, it goes as follows,

[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --zero-superblock
/dev/loop[012345]
[root@kylie raid-test]# /sbin/mdadm --create --verbose /dev/md55
--chunk=256 -l 6  --raid-devices=4 /dev/loop0 /dev/loop1 /dev/loop2
/dev/loop3
mdadm: layout defaults to left-symmetric
mdadm: size set to 24832K
mdadm: array /dev/md55 started.
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --add /dev/md55
/dev/loop4 /dev/loop5
mdadm: added /dev/loop4
mdadm: added /dev/loop5
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --grow /dev/md55
--raid-devices=6
mdadm: Need to backup 1024K of critical section..
mdadm: /dev/md55: failed to suspend device.
[root@kylie raid-test]# ~kotek/mdadm-2.6.7/mdadm --grow /dev/md55
--raid-devices=6
mdadm: Need to backup 1024K of critical section..
mdadm: ... critical section passed.
[root@kylie raid-test]#

On top of that, dmesg doesn't have any error for "failed to suspend device"
on any of those invocations. Yes, I'm really worried.

It's better than old mdadm, for sure, but I'm worried about 1st error
message too.
I'll be very happy to hear any comforting opinion, that it's totally harmless.
Pretty please.

My last and final question is really simple for you. Which version of
superblock
should I use. 1.1 seems the most common choice, and I've not seen any
reasons not to use it. I hope I'm right on that.

My contingency plan is to just add those 3 new drives to raid5 (I do hope
grow will work on it), and wait for raid5->6 live reshape.

Your input on any of those topic will be extremely valuable to me,
Have a pleasant evening,
Mike
