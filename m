From: Peter Bates <peter.thebates@gmail.com>
Subject: mdadm - stuck reshape operation
Date: Wed, 27 Apr 2016 22:21:09 +1000
Message-ID: <CAASHjeD2HqH=8ON_VSy1jbmR9NAK+NXQAmHjFw-PsW-gwNWB9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a 3 disk RAID 5 array that I tried to add a 4th disk to.

> mdadm --add /dev/md6 /dev/sdb1
> mdadm --grow --raid-devices=3D4 /dev/md6

This operation started successfully and proceeded until it hit 51.1%

> cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath] [faulty]
md6 : active raid5 sda1[0] sdb1[5] sdf1[3] sde1[4]
      3906764800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4=
] [UUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  reshape =3D 51.1% (9=
98533632/1953382400)
finish=3D9046506.1min speed=3D1K/sec
      bitmap: 0/15 pages [0KB], 65536KB chunk

It has been sitting on the same 998533632 position for days. I've
tried a few reboots, but it never progresses.
Stopping the array, or trying to start the logical volume in it hangs.
Altering the min / max speed parameters has no effect.
When I reboot and resemble the array the speed indicated steadily
drops to almost 0.

> mdadm --assemble /dev/md6 --verbose --uuid 90c2b5c3:3bbfa0d7:a5efaeed=
:726c43e2

I haven't tried anything more drastic than a reboot yet,
Below is as much information as I can think to provide at this stage.
Please let me know what else I can do.
I'm happy to change kernels, kernel config or anything else require to
get better info.

Kernel: 4.4.3
mdadm 3.4

> ps aux | grep md6
root      5041 99.9  0.0      0     0 ?        R    07:10 761:58 [md6_r=
aid5]
root      5042  0.0  0.0      0     0 ?        D    07:10   0:00 [md6_r=
eshape]

This is consistent. 100% cpu on the raid component, but not the reshape

> mdadm --detail --verbose /dev/md6
/dev/md6:
        Version : 1.2
  Creation Time : Fri Aug 29 21:13:52 2014
     Raid Level : raid5
     Array Size : 3906764800 (3725.78 GiB 4000.53 GB)
  Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Apr 27 07:10:07 2016
          State : clean, reshaping
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

 Reshape Status : 51% complete
  Delta Devices : 1, (3->4)

           Name : Alpheus:6  (local to host Alpheus)
           UUID : 90c2b5c3:3bbfa0d7:a5efaeed:726c43e2
         Events : 47975

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       4       8       65        1      active sync   /dev/sde1
       3       8       81        2      active sync   /dev/sdf1
       5       8       17        3      active sync   /dev/sdb1

> iostat
Linux 4.4.3-gentoo (Alpheus)    04/27/2016      _x86_64_        (4 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.84    0.00   24.50    0.09    0.00   73.57

Looking at the individual disks I can see minor activity on the MD6
members. This activity tends to match up with the overall rate
reported by /proc/mdstat

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               0.02         2.72         1.69     128570      79957
sdb               0.01         0.03         1.69       1447      79889
sdd               3.85         2.27        56.08     106928    2646042
sde               0.02         2.73         1.69     128610      79961
sdf               0.02         2.72         1.69     128128      79961
sdc               4.08         5.44        56.08     256899    2646042
md0               2.91         7.62        55.08     359714    2598725
dm-0              0.00         0.03         0.00       1212          0
dm-1              0.00         0.05         0.00       2151          9
dm-2              2.65         6.52         3.42     307646     161296
dm-3              0.19         1.03        51.66      48377    2437420
md6               0.00         0.02         0.00       1036          0

> dmesg
[ 1199.426995] md: bind<sde1>
[ 1199.427779] md: bind<sdf1>
[ 1199.428379] md: bind<sdb1>
[ 1199.428592] md: bind<sda1>
[ 1199.429260] md/raid:md6: reshape will continue
[ 1199.429274] md/raid:md6: device sda1 operational as raid disk 0
[ 1199.429275] md/raid:md6: device sdb1 operational as raid disk 3
[ 1199.429276] md/raid:md6: device sdf1 operational as raid disk 2
[ 1199.429277] md/raid:md6: device sde1 operational as raid disk 1
[ 1199.429498] md/raid:md6: allocated 4338kB
[ 1199.429807] md/raid:md6: raid level 5 active with 4 out of 4
devices, algorithm 2
[ 1199.429810] RAID conf printout:
[ 1199.429811]  --- level:5 rd:4 wd:4
[ 1199.429812]  disk 0, o:1, dev:sda1
[ 1199.429814]  disk 1, o:1, dev:sde1
[ 1199.429816]  disk 2, o:1, dev:sdf1
[ 1199.429817]  disk 3, o:1, dev:sdb1
[ 1199.429993] created bitmap (15 pages) for device md6
[ 1199.430297] md6: bitmap initialized from disk: read 1 pages, set 0
of 29807 bits
[ 1199.474604] md6: detected capacity change from 0 to 4000527155200
[ 1199.474611] md: reshape of RAID array md6
[ 1199.474613] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1199.474614] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[ 1199.474617] md: using 128k window, over a total of 1953382400k.

> lsblk
NAME                          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                             8:0    0  1.8T  0 disk
=E2=94=94=E2=94=80sda1                          8:1    0  1.8T  0 part
  =E2=94=94=E2=94=80md6                         9:6    0  3.7T  0 raid5
sdb                             8:16   0  1.8T  0 disk
=E2=94=94=E2=94=80sdb1                          8:17   0  1.8T  0 part
  =E2=94=94=E2=94=80md6                         9:6    0  3.7T  0 raid5
sdc                             8:32   0  2.7T  0 disk
=E2=94=9C=E2=94=80sdc1                          8:33   0   16M  0 part
=E2=94=94=E2=94=80sdc2                          8:34   0  2.7T  0 part
  =E2=94=94=E2=94=80md0                         9:0    0  2.7T  0 raid1
    =E2=94=9C=E2=94=80vg--mirror-swap         253:0    0    4G  0 lvm  =
 [SWAP]
    =E2=94=9C=E2=94=80vg--mirror-boot         253:1    0  256M  0 lvm  =
 /boot
    =E2=94=9C=E2=94=80vg--mirror-root         253:2    0  256G  0 lvm  =
 /
    =E2=94=94=E2=94=80vg--mirror-data--mirror 253:3    0  2.5T  0 lvm  =
 /data/mirror
sdd                             8:48   0  2.7T  0 disk
=E2=94=9C=E2=94=80sdd1                          8:49   0   16M  0 part
=E2=94=94=E2=94=80sdd2                          8:50   0  2.7T  0 part
  =E2=94=94=E2=94=80md0                         9:0    0  2.7T  0 raid1
    =E2=94=9C=E2=94=80vg--mirror-swap         253:0    0    4G  0 lvm  =
 [SWAP]
    =E2=94=9C=E2=94=80vg--mirror-boot         253:1    0  256M  0 lvm  =
 /boot
    =E2=94=9C=E2=94=80vg--mirror-root         253:2    0  256G  0 lvm  =
 /
    =E2=94=94=E2=94=80vg--mirror-data--mirror 253:3    0  2.5T  0 lvm  =
 /data/mirror
sde                             8:64   0  1.8T  0 disk
=E2=94=94=E2=94=80sde1                          8:65   0  1.8T  0 part
  =E2=94=94=E2=94=80md6                         9:6    0  3.7T  0 raid5
sdf                             8:80   0  1.8T  0 disk
=E2=94=94=E2=94=80sdf1                          8:81   0  1.8T  0 part
  =E2=94=94=E2=94=80md6                         9:6    0  3.7T  0 raid5

Thanks for any pointers

Peter Bates
peter.thebates@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
