From: Jeremy Graham <jeremy@doghouse.agency>
Subject: mdadm stuck at 0% reshape after grow
Date: Tue, 5 Dec 2017 20:41:10 +1100
Message-ID: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

After visiting almost every google result for "mdadm reshape stuck"
and other variants, I am calling out to the experts for help.

History:
I have had a linux raid5 array running mostly issue free for many
years now. It started with 3 x 3TB drives and has grown over the years
to 5 disks. Each new drive addition has added without a problem with a
mdadm --add and mdadm --grow.

I recently purchased disk 6, to be safe I did a long smartctl test
first, I got no error so proceeded with a mdadm add/grow. But this
time the reshape got stuck almost immediately. I have rebooted many
times and re-assembled but each time I get the same result.

Reshape never progresses and eventually speed reduces to 0K/sec (I
have let it go for days)

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdf1[8] sdb1[10] sdc1[7] sde1[9] sdd1[5] sdg1[6]
      11721054208 blocks super 1.2 level 5, 512k chunk, algorithm 2
[6/6] [UUUUUU]
      [>....................]  reshape =3D  0.0% (120220/2930263552)
finish=3D9147785.2min speed=3D5K/sec

What I have tried:
* Force assemble
* Purchased another drive and used ddrescue to clone the other new
drive and assemble with that instead
* Upgrading mdadm
* Booting with SystemRescueCD and attempting an assemble
All of above result in the same thing, a stuck reshape at 0%

Logs and output:
https://pastebin.com/fi9pUQgD also at the end of this message. Please
let me know if I can provide anything else

Hardware:
* i3, 16GB Ram
* System disk 256G SSD
* All raid drives are running off a LSI 9211-8i HBA.
* All raid drives are segate NAS drives


If anyone has ideas I would be eternally grateful!

Cheers,
Jeremy







Directly after reboot
---------------------

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdc1[7](S) sdb1[10](S) sde1[9](S) sdd1[5](S) sdg1[6](S)
sdf1[8](S)
      17581584384 blocks super 1.2

unused devices: <none>


$ mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 6
    Persistence : Superblock is persistent

          State : inactive

  Delta Devices : 1, (-1->0)
      New Level : raid5
     New Layout : left-symmetric
  New Chunksize : 512K

           Name : homer2:1
           UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
         Events : 4830576

    Number   Major   Minor   RaidDevice

       -       8       17        -        /dev/sdb1
       -       8       33        -        /dev/sdc1
       -       8       49        -        /dev/sdd1
       -       8       65        -        /dev/sde1
       -       8       81        -        /dev/sdf1
       -       8       97        -        /dev/sdg1


Assemble the array
------------------

$ export MDADM_GROW_ALLOW_OLD=3D1

** Grow allow old used as thought the new drive was faulty and
attempted to assemble array with it unplugged **


$ mdadm --stop /dev/md0
mdadm: stopped /dev/md0


$ mdadm --assemble -v /dev/md0 /dev/sd[bcdefg]1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/md0 has an active reshape - checking if critical section
needs to be restored
mdadm: accepting backup with timestamp 1511984338 for array with
timestamp 1512378131
mdadm: backup-metadata found on device-5 but is not needed
mdadm: added /dev/sdg1 to /dev/md0 as 1
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: added /dev/sdc1 to /dev/md0 as 4
mdadm: added /dev/sdb1 to /dev/md0 as 5
mdadm: added /dev/sdf1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 6 drives.


$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdf1[8] sdb1[10] sdc1[7] sde1[9] sdd1[5] sdg1[6]
      11721054208 blocks super 1.2 level 5, 512k chunk, algorithm 2
[6/6] [UUUUUU]
      [>....................]  reshape =3D  0.0% (120220/2930263552)
finish=3D187144.1min speed=3D260K/sec

unused devices: <none>

** Progress never changes, speed reduces eventually to 0K/sec **


$ mdadm --examine /dev/sd[bcdefg]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
           Name : homer2:1
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1960 sectors, after=3D1024 sectors
          State : active
    Device UUID : d185c556:52b345e2:244ff3c8:9210bf26

  Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
  Delta Devices : 1 (5->6)

    Update Time : Tue Dec  5 18:30:50 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b8e49d67 - correct
         Events : 4830578

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
           Name : homer2:1
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D1024 sectors
          State : active
    Device UUID : 96958379:2ca77922:2065aa7b:26b9afae

  Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
  Delta Devices : 1 (5->6)

    Update Time : Tue Dec  5 18:30:50 2017
       Checksum : 56765f4b - correct
         Events : 4830578

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
           Name : homer2:1
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D1024 sectors
          State : active
    Device UUID : b9fc27cb:36f08923:64d5979a:45d24263

  Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
  Delta Devices : 1 (5->6)

    Update Time : Tue Dec  5 18:30:50 2017
       Checksum : 7cab98d9 - correct
         Events : 4830578

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xc
     Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
           Name : homer2:1
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1960 sectors, after=3D1024 sectors
          State : active
    Device UUID : a33aacb4:00d283ef:5715be52:a0678279

  Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
  Delta Devices : 1 (5->6)

    Update Time : Tue Dec  5 18:30:50 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : 978e30 - correct
         Events : 4830578

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xc
     Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
           Name : homer2:1
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1960 sectors, after=3D1024 sectors
          State : active
    Device UUID : cabeb84a:b5df18c9:cb378062:be0f8998

  Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
  Delta Devices : 1 (5->6)

    Update Time : Tue Dec  5 18:30:50 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : 9f01ea9c - correct
         Events : 4830578

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
           Name : homer2:1
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
     Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
  Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D1024 sectors
          State : active
    Device UUID : 35c83ff2:9c960c86:4982f67a:e4720c3b

  Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
  Delta Devices : 1 (5->6)

    Update Time : Tue Dec  5 18:30:50 2017
       Checksum : be6e5840 - correct
         Events : 4830578

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)

** Reshape pos'n is always: 491520 (480.00 MiB 503.32 MB) **


$ mdadm --examine /dev/sd[bcdefg]
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdf:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdg:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)


$ mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sun Dec  2 12:04:24 2012
     Raid Level : raid5
     Array Size : 11721054208 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 2930263552 (2794.52 GiB 3000.59 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Tue Dec  5 18:30:50 2017
          State : active, reshaping
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

 Reshape Status : 0% complete
  Delta Devices : 1, (5->6)

           Name : homer2:1
           UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
         Events : 4830578

    Number   Major   Minor   RaidDevice State
       8       8       81        0      active sync   /dev/sdf1
       6       8       97        1      active sync   /dev/sdg1
       5       8       49        2      active sync   /dev/sdd1
       9       8       65        3      active sync   /dev/sde1
       7       8       33        4      active sync   /dev/sdc1
      10       8       17        5      active sync   /dev/sdb1


$ dmesg
[69979.860466] md: md0 stopped.
[69979.884579] md: bind<sdg1>
[69979.903373] md: bind<sdd1>
[69979.903750] md: bind<sde1>
[69979.903939] md: bind<sdc1>
[69979.922600] md: bind<sdb1>
[69979.922958] md: bind<sdf1>
[69979.932462] md/raid:md0: not clean -- starting background reconstruction
[69979.932467] md/raid:md0: reshape will continue
[69979.932486] md/raid:md0: device sdf1 operational as raid disk 0
[69979.932488] md/raid:md0: device sdb1 operational as raid disk 5
[69979.932489] md/raid:md0: device sdc1 operational as raid disk 4
[69979.932490] md/raid:md0: device sde1 operational as raid disk 3
[69979.932491] md/raid:md0: device sdd1 operational as raid disk 2
[69979.932493] md/raid:md0: device sdg1 operational as raid disk 1
[69979.932912] md/raid:md0: allocated 6490kB
[69979.932943] md/raid:md0: raid level 5 active with 6 out of 6
devices, algorithm 2
[69979.932945] RAID conf printout:
[69979.932947]  --- level:5 rd:6 wd:6
[69979.932948]  disk 0, o:1, dev:sdf1
[69979.932950]  disk 1, o:1, dev:sdg1
[69979.932951]  disk 2, o:1, dev:sdd1
[69979.932952]  disk 3, o:1, dev:sde1
[69979.932954]  disk 4, o:1, dev:sdc1
[69979.932955]  disk 5, o:1, dev:sdb1
[69979.933007] md0: detected capacity change from 0 to 12002359508992
[69979.933130] md: reshape of RAID array md0
[69979.933132] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[69979.933134] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[69979.933139] md: using 128k window, over a total of 2930263552k.
[70197.635112] INFO: task md0_reshape:30529 blocked for more than 120 secon=
ds.
[70197.635142]       Not tainted 4.4.0-101-generic #124-Ubuntu
[70197.635161] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[70197.635187] md0_reshape     D ffff88011da37aa8     0 30529      2 0x0000=
0000
[70197.635191]  ffff88011da37aa8 ffff88011da37a78 ffff880214a40e00
ffff880210577000
[70197.635193]  ffff88011da38000 ffff8800d49de424 ffff8800d49de658
ffff8800d49de638
[70197.635194]  ffff8800d49de670 ffff88011da37ac0 ffffffff818406d5
ffff8800d49de400
[70197.635196] Call Trace:
[70197.635202]  [<ffffffff818406d5>] schedule+0x35/0x80
[70197.635206]  [<ffffffffc034045f>]
raid5_get_active_stripe+0x31f/0x700 [raid456]
[70197.635210]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70197.635212]  [<ffffffffc0344da4>] reshape_request+0x584/0x950 [raid456]
[70197.635215]  [<ffffffff810a9c6a>] ? finish_task_switch+0x7a/0x220
[70197.635218]  [<ffffffffc034548c>] sync_request+0x31c/0x3a0 [raid456]
[70197.635219]  [<ffffffff81840026>] ? __schedule+0x3b6/0xa30
[70197.635222]  [<ffffffff814102b5>] ? find_next_bit+0x15/0x20
[70197.635225]  [<ffffffff81710bb1>] ? is_mddev_idle+0x9c/0xfa
[70197.635227]  [<ffffffff816adbbc>] md_do_sync+0x89c/0xe60
[70197.635229]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70197.635231]  [<ffffffff816aa319>] md_thread+0x139/0x150
[70197.635233]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70197.635234]  [<ffffffff816aa1e0>] ? find_pers+0x70/0x70
[70197.635236]  [<ffffffff810a0c75>] kthread+0xe5/0x100
[70197.635237]  [<ffffffff810a0b90>] ? kthread_create_on_node+0x1e0/0x1e0
[70197.635239]  [<ffffffff81844b8f>] ret_from_fork+0x3f/0x70
[70197.635241]  [<ffffffff810a0b90>] ? kthread_create_on_node+0x1e0/0x1e0
[70317.630767] INFO: task md0_reshape:30529 blocked for more than 120 secon=
ds.
[70317.630796]       Not tainted 4.4.0-101-generic #124-Ubuntu
[70317.630815] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[70317.630841] md0_reshape     D ffff88011da37aa8     0 30529      2 0x0000=
0000
[70317.630844]  ffff88011da37aa8 ffff88011da37a78 ffff880214a40e00
ffff880210577000
[70317.630846]  ffff88011da38000 ffff8800d49de424 ffff8800d49de658
ffff8800d49de638
[70317.630848]  ffff8800d49de670 ffff88011da37ac0 ffffffff818406d5
ffff8800d49de400
[70317.630850] Call Trace:
[70317.630855]  [<ffffffff818406d5>] schedule+0x35/0x80
[70317.630860]  [<ffffffffc034045f>]
raid5_get_active_stripe+0x31f/0x700 [raid456]
[70317.630863]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70317.630866]  [<ffffffffc0344da4>] reshape_request+0x584/0x950 [raid456]
[70317.630868]  [<ffffffff810a9c6a>] ? finish_task_switch+0x7a/0x220
[70317.630871]  [<ffffffffc034548c>] sync_request+0x31c/0x3a0 [raid456]
[70317.630872]  [<ffffffff81840026>] ? __schedule+0x3b6/0xa30
[70317.630876]  [<ffffffff814102b5>] ? find_next_bit+0x15/0x20
[70317.630878]  [<ffffffff81710bb1>] ? is_mddev_idle+0x9c/0xfa
[70317.630881]  [<ffffffff816adbbc>] md_do_sync+0x89c/0xe60
[70317.630883]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70317.630885]  [<ffffffff816aa319>] md_thread+0x139/0x150
[70317.630886]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70317.630888]  [<ffffffff816aa1e0>] ? find_pers+0x70/0x70
[70317.630890]  [<ffffffff810a0c75>] kthread+0xe5/0x100
[70317.630892]  [<ffffffff810a0b90>] ? kthread_create_on_node+0x1e0/0x1e0
[70317.630894]  [<ffffffff81844b8f>] ret_from_fork+0x3f/0x70
[70317.630896]  [<ffffffff810a0b90>] ? kthread_create_on_node+0x1e0/0x1e0


$ uname -a
Linux homer 4.4.0-101-generic #124-Ubuntu SMP Fri Nov 10 18:29:59 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux


$ mdadm --version
mdadm - v3.4 - 28th January 2016


$ ps aux | grep md0
root      2086  0.0  0.0  14220   940 pts/0    S+   18:49   0:00 grep
--color=3Dauto md0
root     30528 99.9  0.0      0     0 ?        R    18:30  18:35 [md0_raid5=
]
root     30529  0.0  0.0      0     0 ?        D    18:30   0:00 [md0_resha=
pe]

** md0_raid5 always at 100%, md0_reshape always at 0% **


$ cat /sys/block/md0/md/stripe_cache_size
513

$ echo 16384 > /sys/block/md0/md/stripe_cache_size

$ cat /sys/block/md0/md/stripe_cache_size
16384


$ iostat
Linux 4.4.0-101-generic (homer)         12/05/2017      _x86_64_        (4 =
CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.71    0.03    1.11    0.37    0.00   95.78

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             122.04       126.50      1068.10    9006825   76047672
sdb               0.00         0.04         0.31       2543      21918
sdc               0.01         0.47         0.31      33113      21918
sdd               0.01         0.47         0.31      33141      21918
sdf               0.01         0.47         0.31      33665      21922
sde               0.01         0.47         0.31      33637      21922
sdg               0.01         0.47         0.31      33125      21918
md0               0.00         0.01         0.00       1036          0


$ lsblk
NAME    MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda       8:0    0 223.6G  0 disk
=E2=94=9C=E2=94=80sda1    8:1    0 215.7G  0 part  /
=E2=94=9C=E2=94=80sda2    8:2    0     1K  0 part
=E2=94=94=E2=94=80sda5    8:5    0   7.9G  0 part  [SWAP]
sdb       8:16   0   2.7T  0 disk
=E2=94=94=E2=94=80sdb1    8:17   0   2.7T  0 part
  =E2=94=94=E2=94=80md0   9:0    0  10.9T  0 raid5
sdc       8:32   0   2.7T  0 disk
=E2=94=94=E2=94=80sdc1    8:33   0   2.7T  0 part
  =E2=94=94=E2=94=80md0   9:0    0  10.9T  0 raid5
sdd       8:48   0   2.7T  0 disk
=E2=94=94=E2=94=80sdd1    8:49   0   2.7T  0 part
  =E2=94=94=E2=94=80md0   9:0    0  10.9T  0 raid5
sde       8:64   0   2.7T  0 disk
=E2=94=94=E2=94=80sde1    8:65   0   2.7T  0 part
  =E2=94=94=E2=94=80md0   9:0    0  10.9T  0 raid5
sdf       8:80   0   2.7T  0 disk
=E2=94=94=E2=94=80sdf1    8:81   0   2.7T  0 part
  =E2=94=94=E2=94=80md0   9:0    0  10.9T  0 raid5
sdg       8:96   0   2.7T  0 disk
=E2=94=94=E2=94=80sdg1    8:97   0   2.7T  0 part
  =E2=94=94=E2=94=80md0   9:0    0  10.9T  0 raid5


$ for disk in {b,c,d,e,f,g}; do smartctl -a /dev/sd${disk}1; done
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.4.0-101-generic] (local build=
)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     ST3000VN007-2E4166
Serial Number:    Z6A0Z4MY
LU WWN Device Id: 5 000c50 0a3c31b28
Firmware Version: SC60
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Dec  5 19:00:40 2017 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (  107) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 376) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x10bd) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   006    Pre-fail
Always       -       209008
  3 Spin_Up_Time            0x0003   097   097   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       4
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   100   253   030    Pre-fail
Always       -       45978
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       78
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       4
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0
189 High_Fly_Writes         0x003a   088   088   000    Old_age
Always       -       12
190 Airflow_Temperature_Cel 0x0022   061   058   045    Old_age
Always       -       39 (Min/Max 38/40)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       4
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       4
194 Temperature_Celsius     0x0022   039   042   000    Old_age
Always       -       39 (0 22 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%        78       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.4.0-101-generic] (local build=
)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate NAS HDD
Device Model:     ST3000VN000-1HJ166
Serial Number:    W6A077L9
LU WWN Device Id: 5 000c50 07d588414
Firmware Version: SC60
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Dec  5 19:00:40 2017 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (  107) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 389) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x10bd) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail
Always       -       163598304
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       42
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   080   060   030    Pre-fail
Always       -       108755626
  9 Power_On_Hours          0x0032   074   074   000    Old_age
Always       -       23572
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       42
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0
189 High_Fly_Writes         0x003a   019   019   000    Old_age
Always       -       81
190 Airflow_Temperature_Cel 0x0022   067   060   045    Old_age
Always       -       33 (Min/Max 32/34)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       26
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       1011
194 Temperature_Celsius     0x0022   033   040   000    Old_age
Always       -       33 (0 23 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     12035       =
  -
# 2  Short offline       Completed without error       00%     11911       =
  -
# 3  Short offline       Completed without error       00%     10759       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.4.0-101-generic] (local build=
)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate NAS HDD
Device Model:     ST3000VN000-1HJ166
Serial Number:    W6A07K5E
LU WWN Device Id: 5 000c50 07d5cca73
Firmware Version: SC60
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Dec  5 19:00:41 2017 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (   97) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 386) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x10bd) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   115   099   006    Pre-fail
Always       -       85334928
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       60
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   080   060   030    Pre-fail
Always       -       107935868
  9 Power_On_Hours          0x0032   073   073   000    Old_age
Always       -       23904
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       60
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0
189 High_Fly_Writes         0x003a   001   001   000    Old_age
Always       -       118
190 Airflow_Temperature_Cel 0x0022   066   058   045    Old_age
Always       -       34 (Min/Max 33/35)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       39
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       1043
194 Temperature_Celsius     0x0022   034   042   000    Old_age
Always       -       34 (0 23 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     12367       =
  -
# 2  Short offline       Completed without error       00%     12243       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.4.0-101-generic] (local build=
)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate NAS HDD
Device Model:     ST3000VN000-1HJ166
Serial Number:    W6A1GLG8
LU WWN Device Id: 5 000c50 09b618897
Firmware Version: SC60
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Dec  5 19:00:41 2017 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (  107) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 379) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x10bd) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   118   099   006    Pre-fail
Always       -       169536040
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       27
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   076   060   030    Pre-fail
Always       -       46431252
  9 Power_On_Hours          0x0032   086   086   000    Old_age
Always       -       12765
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       27
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0
189 High_Fly_Writes         0x003a   083   083   000    Old_age
Always       -       17
190 Airflow_Temperature_Cel 0x0022   065   059   045    Old_age
Always       -       35 (Min/Max 34/36)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       22
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       62
194 Temperature_Celsius     0x0022   035   041   000    Old_age
Always       -       35 (0 19 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      1229       =
  -
# 2  Short offline       Completed without error       00%      1105       =
  -
# 3  Short offline       Completed without error       00%      1090       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.4.0-101-generic] (local build=
)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate NAS HDD
Device Model:     ST3000VN000-1HJ166
Serial Number:    W6A0TLA6
LU WWN Device Id: 5 000c50 08b715e4e
Firmware Version: SC60
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Dec  5 19:00:41 2017 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (  107) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 387) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x10bd) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   115   099   006    Pre-fail
Always       -       83913088
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       31
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   076   060   030    Pre-fail
Always       -       47812930
  9 Power_On_Hours          0x0032   086   086   000    Old_age
Always       -       12820
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       31
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0
189 High_Fly_Writes         0x003a   034   034   000    Old_age
Always       -       66
190 Airflow_Temperature_Cel 0x0022   063   057   045    Old_age
Always       -       37 (Min/Max 35/38)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       23
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       559
194 Temperature_Celsius     0x0022   037   043   000    Old_age
Always       -       37 (0 21 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      1284       =
  -
# 2  Short offline       Completed without error       00%      1160       =
  -
# 3  Short offline       Completed without error       00%      1145       =
  -
# 4  Short offline       Completed without error       00%         8       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.4.0-101-generic] (local build=
)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate NAS HDD
Device Model:     ST3000VN000-1HJ166
Serial Number:    W6A07KJY
LU WWN Device Id: 5 000c50 07d5cb95b
Firmware Version: SC60
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Dec  5 19:00:41 2017 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (  107) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 392) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x10bd) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   116   099   006    Pre-fail
Always       -       109735048
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       48
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   080   060   030    Pre-fail
Always       -       108007271
  9 Power_On_Hours          0x0032   073   073   000    Old_age
Always       -       23829
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       48
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   099   000    Old_age
Always       -       8
189 High_Fly_Writes         0x003a   015   015   000    Old_age
Always       -       85
190 Airflow_Temperature_Cel 0x0022   063   058   045    Old_age
Always       -       37 (Min/Max 35/38)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       29
193 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       1029
194 Temperature_Celsius     0x0022   037   042   000    Old_age
Always       -       37 (0 24 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   196   000    Old_age
Always       -       3577

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     12293       =
  -
# 2  Short offline       Completed without error       00%     12169       =
  -
# 3  Extended offline    Completed without error       00%       475       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

end<div id=3D"DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><br />
<table style=3D"border-top: 1px solid #D3D4DE;">
	<tr>
        <td style=3D"width: 55px; padding-top: 13px;"><a
href=3D"http://www.avg.com/email-signature?utm_medium=3Demail&utm_source=3D=
link&utm_campaign=3Dsig-email&utm_content=3Dwebmail"
target=3D"_blank"><img
src=3D"https://ipmcdn.avast.com/images/icons/icon-envelope-tick-green-avg-v=
1.png"
alt=3D"" width=3D"46" height=3D"29" style=3D"width: 46px; height: 29px;"
/></a></td>
		<td style=3D"width: 470px; padding-top: 12px; color: #41424e;
font-size: 13px; font-family: Arial, Helvetica, sans-serif;
line-height: 18px;">Virus-free. <a
href=3D"http://www.avg.com/email-signature?utm_medium=3Demail&utm_source=3D=
link&utm_campaign=3Dsig-email&utm_content=3Dwebmail"
target=3D"_blank" style=3D"color: #4453ea;">www.avg.com</a>
		</td>
	</tr>
</table><a href=3D"#DAB4FAD8-2DD7-40BB-A1B8-4E2AA1F9FDF2" width=3D"1"
height=3D"1"></a></div>
