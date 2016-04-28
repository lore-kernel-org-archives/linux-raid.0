From: Peter Bates <peter.thebates@gmail.com>
Subject: Re: mdadm - stuck reshape operation
Date: Fri, 29 Apr 2016 07:31:31 +1000
Message-ID: <CAASHjeBL09KvTaQbfWqkgVaz+RQLcw1Vy8jS-R5DW0FUYDrA6Q@mail.gmail.com>
References: <CAASHjeD2HqH=8ON_VSy1jbmR9NAK+NXQAmHjFw-PsW-gwNWB9g@mail.gmail.com>
 <22305.30340.565924.810276@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22305.30340.565924.810276@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the suggestions John.

I'm not running an SELinux setup. I did notice some of the Kernel
security settings enabled that I would never use so I've removed
those.

Dumping the drives to /dev/null didn't produce any errors.
During the whole process I haven't seen any disk level errors in dmesg
or syslog.

Here is a pastbin of an strace on the mdadm assemble command.
Probably showing my ignorance, but I can't strace the md6_raid kernel
thread can I?

http://pastebin.com/5q0K6w6r

Will upgrade mdadm over the weekend.and try increasing the dmesg log le=
vel to 7.


Peter Bates
peter.thebates@gmail.com


On 28 April 2016 at 12:33, John Stoffel <john@stoffel.org> wrote:
>>>>>> "Peter" =3D=3D Peter Bates <peter.thebates@gmail.com> writes:
>
>
> Peter> I have a 3 disk RAID 5 array that I tried to add a 4th disk to=
=2E
>
>>> mdadm --add /dev/md6 /dev/sdb1
>>> mdadm --grow --raid-devices=3D4 /dev/md6
>
> Peter> This operation started successfully and proceeded until it hit=
 51.1%
>
>>> cat /proc/mdstat
> Peter> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [rai=
d5]
> Peter> [raid4] [multipath] [faulty]
> Peter> md6 : active raid5 sda1[0] sdb1[5] sdf1[3] sde1[4]
> Peter>       3906764800 blocks super 1.2 level 5, 512k chunk, algorit=
hm 2 [4/4] [UUUU]
> Peter>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  reshape =3D=
 51.1% (998533632/1953382400)
> Peter> finish=3D9046506.1min speed=3D1K/sec
> Peter>       bitmap: 0/15 pages [0KB], 65536KB chunk
>
> Peter> It has been sitting on the same 998533632 position for
> Peter> days. I've tried a few reboots, but it never progresses.
> Peter> Stopping the array, or trying to start the logical volume in i=
t
> Peter> hangs.  Altering the min / max speed parameters has no effect.
> Peter> When I reboot and resemble the array the speed indicated
> Peter> steadily drops to almost 0.
>
>>> mdadm --assemble /dev/md6 --verbose --uuid 90c2b5c3:3bbfa0d7:a5efae=
ed:726c43e2
>
> I looked back in my email archives, and I wonder if maybe you have
> SElinux enabled?  If so, please turn it off and see if that helps.
>
> What happens when you use dd on each of the drives and dump the outpu=
t
> to /dev/null?
>
> Are there any messages in the logs, or dmesg output after the stuff
> you showed?  Can you maybe 'strace' the mdadm process, or even go gra=
b
> the latest version using git from:
>
>   git clone git://neil.brown.name/mdadm
>
> And see if compiling it yourself from the master might do the trick.
>
>
> Peter> I haven't tried anything more drastic than a reboot yet,
> Peter> Below is as much information as I can think to provide at this=
 stage.
> Peter> Please let me know what else I can do.
> Peter> I'm happy to change kernels, kernel config or anything else re=
quire to
> Peter> get better info.
>
> Peter> Kernel: 4.4.3
> Peter> mdadm 3.4
>
>>> ps aux | grep md6
> Peter> root      5041 99.9  0.0      0     0 ?        R    07:10 761:=
58 [md6_raid5]
> Peter> root      5042  0.0  0.0      0     0 ?        D    07:10   0:=
00 [md6_reshape]
>
> Peter> This is consistent. 100% cpu on the raid component, but not th=
e reshape
>
>>> mdadm --detail --verbose /dev/md6
> Peter> /dev/md6:
> Peter>         Version : 1.2
> Peter>   Creation Time : Fri Aug 29 21:13:52 2014
> Peter>      Raid Level : raid5
> Peter>      Array Size : 3906764800 (3725.78 GiB 4000.53 GB)
> Peter>   Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
> Peter>    Raid Devices : 4
> Peter>   Total Devices : 4
> Peter>     Persistence : Superblock is persistent
>
> Peter>   Intent Bitmap : Internal
>
> Peter>     Update Time : Wed Apr 27 07:10:07 2016
> Peter>           State : clean, reshaping
> Peter>  Active Devices : 4
> Peter> Working Devices : 4
> Peter>  Failed Devices : 0
> Peter>   Spare Devices : 0
>
> Peter>          Layout : left-symmetric
> Peter>      Chunk Size : 512K
>
> Peter>  Reshape Status : 51% complete
> Peter>   Delta Devices : 1, (3->4)
>
> Peter>            Name : Alpheus:6  (local to host Alpheus)
> Peter>            UUID : 90c2b5c3:3bbfa0d7:a5efaeed:726c43e2
> Peter>          Events : 47975
>
> Peter>     Number   Major   Minor   RaidDevice State
> Peter>        0       8        1        0      active sync   /dev/sda=
1
> Peter>        4       8       65        1      active sync   /dev/sde=
1
> Peter>        3       8       81        2      active sync   /dev/sdf=
1
> Peter>        5       8       17        3      active sync   /dev/sdb=
1
>
>>> iostat
> Peter> Linux 4.4.3-gentoo (Alpheus)    04/27/2016      _x86_64_      =
  (4 CPU)
>
> Peter> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> Peter>            1.84    0.00   24.50    0.09    0.00   73.57
>
> Peter> Looking at the individual disks I can see minor activity on th=
e MD6
> Peter> members. This activity tends to match up with the overall rate
> Peter> reported by /proc/mdstat
>
> Peter> Device:            tps    kB_read/s    kB_wrtn/s    kB_read   =
 kB_wrtn
> Peter> sda               0.02         2.72         1.69     128570   =
   79957
> Peter> sdb               0.01         0.03         1.69       1447   =
   79889
> Peter> sdd               3.85         2.27        56.08     106928   =
 2646042
> Peter> sde               0.02         2.73         1.69     128610   =
   79961
> Peter> sdf               0.02         2.72         1.69     128128   =
   79961
> Peter> sdc               4.08         5.44        56.08     256899   =
 2646042
> Peter> md0               2.91         7.62        55.08     359714   =
 2598725
> Peter> dm-0              0.00         0.03         0.00       1212   =
       0
> Peter> dm-1              0.00         0.05         0.00       2151   =
       9
> Peter> dm-2              2.65         6.52         3.42     307646   =
  161296
> Peter> dm-3              0.19         1.03        51.66      48377   =
 2437420
> Peter> md6               0.00         0.02         0.00       1036   =
       0
>
>>> dmesg
> Peter> [ 1199.426995] md: bind<sde1>
> Peter> [ 1199.427779] md: bind<sdf1>
> Peter> [ 1199.428379] md: bind<sdb1>
> Peter> [ 1199.428592] md: bind<sda1>
> Peter> [ 1199.429260] md/raid:md6: reshape will continue
> Peter> [ 1199.429274] md/raid:md6: device sda1 operational as raid di=
sk 0
> Peter> [ 1199.429275] md/raid:md6: device sdb1 operational as raid di=
sk 3
> Peter> [ 1199.429276] md/raid:md6: device sdf1 operational as raid di=
sk 2
> Peter> [ 1199.429277] md/raid:md6: device sde1 operational as raid di=
sk 1
> Peter> [ 1199.429498] md/raid:md6: allocated 4338kB
> Peter> [ 1199.429807] md/raid:md6: raid level 5 active with 4 out of =
4
> Peter> devices, algorithm 2
> Peter> [ 1199.429810] RAID conf printout:
> Peter> [ 1199.429811]  --- level:5 rd:4 wd:4
> Peter> [ 1199.429812]  disk 0, o:1, dev:sda1
> Peter> [ 1199.429814]  disk 1, o:1, dev:sde1
> Peter> [ 1199.429816]  disk 2, o:1, dev:sdf1
> Peter> [ 1199.429817]  disk 3, o:1, dev:sdb1
> Peter> [ 1199.429993] created bitmap (15 pages) for device md6
> Peter> [ 1199.430297] md6: bitmap initialized from disk: read 1 pages=
, set 0
> Peter> of 29807 bits
> Peter> [ 1199.474604] md6: detected capacity change from 0 to 4000527=
155200
> Peter> [ 1199.474611] md: reshape of RAID array md6
> Peter> [ 1199.474613] md: minimum _guaranteed_  speed: 1000 KB/sec/di=
sk.
> Peter> [ 1199.474614] md: using maximum available idle IO bandwidth (=
but not
> Peter> more than 200000 KB/sec) for reshape.
> Peter> [ 1199.474617] md: using 128k window, over a total of 19533824=
00k.
>
>>> lsblk
> Peter> NAME                          MAJ:MIN RM  SIZE RO TYPE  MOUNTP=
OINT
> Peter> sda                             8:0    0  1.8T  0 disk
> Peter> =E2=94=94=E2=94=80sda1                          8:1    0  1.8T=
  0 part
> Peter>   =E2=94=94=E2=94=80md6                         9:6    0  3.7T=
  0 raid5
> Peter> sdb                             8:16   0  1.8T  0 disk
> Peter> =E2=94=94=E2=94=80sdb1                          8:17   0  1.8T=
  0 part
> Peter>   =E2=94=94=E2=94=80md6                         9:6    0  3.7T=
  0 raid5
> Peter> sdc                             8:32   0  2.7T  0 disk
> Peter> =E2=94=9C=E2=94=80sdc1                          8:33   0   16M=
  0 part
> Peter> =E2=94=94=E2=94=80sdc2                          8:34   0  2.7T=
  0 part
> Peter>   =E2=94=94=E2=94=80md0                         9:0    0  2.7T=
  0 raid1
> Peter>     =E2=94=9C=E2=94=80vg--mirror-swap         253:0    0    4G=
  0 lvm   [SWAP]
> Peter>     =E2=94=9C=E2=94=80vg--mirror-boot         253:1    0  256M=
  0 lvm   /boot
> Peter>     =E2=94=9C=E2=94=80vg--mirror-root         253:2    0  256G=
  0 lvm   /
> Peter>     =E2=94=94=E2=94=80vg--mirror-data--mirror 253:3    0  2.5T=
  0 lvm   /data/mirror
> Peter> sdd                             8:48   0  2.7T  0 disk
> Peter> =E2=94=9C=E2=94=80sdd1                          8:49   0   16M=
  0 part
> Peter> =E2=94=94=E2=94=80sdd2                          8:50   0  2.7T=
  0 part
> Peter>   =E2=94=94=E2=94=80md0                         9:0    0  2.7T=
  0 raid1
> Peter>     =E2=94=9C=E2=94=80vg--mirror-swap         253:0    0    4G=
  0 lvm   [SWAP]
> Peter>     =E2=94=9C=E2=94=80vg--mirror-boot         253:1    0  256M=
  0 lvm   /boot
> Peter>     =E2=94=9C=E2=94=80vg--mirror-root         253:2    0  256G=
  0 lvm   /
> Peter>     =E2=94=94=E2=94=80vg--mirror-data--mirror 253:3    0  2.5T=
  0 lvm   /data/mirror
> Peter> sde                             8:64   0  1.8T  0 disk
> Peter> =E2=94=94=E2=94=80sde1                          8:65   0  1.8T=
  0 part
> Peter>   =E2=94=94=E2=94=80md6                         9:6    0  3.7T=
  0 raid5
> Peter> sdf                             8:80   0  1.8T  0 disk
> Peter> =E2=94=94=E2=94=80sdf1                          8:81   0  1.8T=
  0 part
> Peter>   =E2=94=94=E2=94=80md6                         9:6    0  3.7T=
  0 raid5
>
> Peter> Thanks for any pointers
>
> Peter> Peter Bates
> Peter> peter.thebates@gmail.com
> Peter> --
> Peter> To unsubscribe from this list: send the line "unsubscribe linu=
x-raid" in
> Peter> the body of a message to majordomo@vger.kernel.org
> Peter> More majordomo info at  http://vger.kernel.org/majordomo-info.=
html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
