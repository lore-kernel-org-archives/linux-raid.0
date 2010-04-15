From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: RAID scrubbing
Date: Wed, 14 Apr 2010 17:51:11 -0700
Message-ID: <w2h150c16851004141751w6d798c12k548527dab7420db4@mail.gmail.com>
References: <q2s150c16851004091828t235d2derf36033d19e2f11ad@mail.gmail.com>
	 <l2t4877c76c1004091841n40a6ad69gb9f73c9d1b68f4ae@mail.gmail.com>
	 <s2y150c16851004091846t94347cf8u9ffd65133061d16b@mail.gmail.com>
	 <h2m4877c76c1004091901k37443583h316eb0efacbcac80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h2m4877c76c1004091901k37443583h316eb0efacbcac80@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 9, 2010 at 7:01 PM, Michael Evans <mjevans1983@gmail.com> w=
rote:
> On Fri, Apr 9, 2010 at 6:46 PM, Justin Maggard <jmaggard10@gmail.com>=
 wrote:
>> On Fri, Apr 9, 2010 at 6:41 PM, Michael Evans <mjevans1983@gmail.com=
> wrote:
>>> On Fri, Apr 9, 2010 at 6:28 PM, Justin Maggard <jmaggard10@gmail.co=
m> wrote:
>>>> Hi all,
>>>>
>>>> I've got a system using two RAID5 arrays that share some physical
>>>> devices, combined using LVM. =A0Oddly, when I "echo repair >
>>>> /sys/block/md0/md/sync_action", once it finishes, it automatically
>>>> starts a repair on md1 also, even though I haven't requested it.
>>>> Also, if I try to stop it using "echo idle >
>>>> /sys/block/md0/md/sync_action", a repair starts on md1 within a fe=
w
>>>> seconds. =A0If I stop that md1 repair immediately, sometimes it wi=
ll
>>>> respawn and start doing the repair again on md1. =A0What should I =
be
>>>> expecting here? =A0If I start a repair on one array, is it suppose=
d to
>>>> automatically go through and do it on all arrays sharing that
>>>> personality?
>>>>
>>>> Thanks!
>>>> -Justin
>>>>
>>>
>>> Is md1 degraded with an active spare? =A0It might be delaying resyn=
c on
>>> it until the other devices are idle.
>>
>> No, both arrays are redundant. =A0I'm just trying to do scrubbing
>> (repair) on md0; no resync is going on anywhere.
>>
>> -Justin
>>
>
> First: Reply to all.
>
> Second, if you insist that things are not as I suspect:
>
> cat /proc/mdstat
>
> mdadm -Dvvs
>
> mdadm -Evvs
>

I insist it's something different. :)  Just ran into it again on
another system.  Here's the requested output:

JMAGGARD:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md3 : active raid5 sde6[0] sdc6[1]
      976750832 blocks super 1.2 level 5, 16k chunk, algorithm 2 [2/2] =
[UU]

md2 : active raid5 sda5[0] sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1]
      4860206480 blocks super 1.2 level 5, 16k chunk, algorithm 2 [6/6]=
 [UUUUUU]

unused devices: <none>
JMAGGARD:~# ls /sys/block/dm-0/slaves/
md2  md3
JMAGGARD:~# cat /sys/block/dm-0/slaves/md?/md/sync_action
idle
idle
JMAGGARD:~# echo repair > /sys/block/md2/md/sync_action
JMAGGARD:~# dmesg -c
md: requested-resync of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for requested-resync.
md: using 128k window, over a total of 972041296 blocks.
JMAGGARD:~#
JMAGGARD:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md3 : active raid5 sde6[0] sdc6[1]
      976750832 blocks super 1.2 level 5, 16k chunk, algorithm 2 [2/2] =
[UU]

md2 : active raid5 sda5[0] sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1]
      4860206480 blocks super 1.2 level 5, 16k chunk, algorithm 2 [6/6]=
 [UUUUUU]
      [>....................]  resync =3D  0.1% (1409104/972041296)
finish=3D195.1min speed=3D82888K/sec

unused devices: <none>
JMAGGARD:~# echo idle > /sys/block/md2/md/sync_action
JMAGGARD:~# dmesg -c
md: md_do_sync() got signal ... exiting
JMAGGARD:~# dmesg -c
JMAGGARD:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md3 : active raid5 sde6[0] sdc6[1]
      976750832 blocks super 1.2 level 5, 16k chunk, algorithm 2 [2/2] =
[UU]

md2 : active raid5 sda5[0] sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1]
      4860206480 blocks super 1.2 level 5, 16k chunk, algorithm 2 [6/6]=
 [UUUUUU]

unused devices: <none>
JMAGGARD:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md3 : active raid5 sde6[0] sdc6[1]
      976750832 blocks super 1.2 level 5, 16k chunk, algorithm 2 [2/2] =
[UU]
      [>....................]  resync =3D  0.1% (1213304/976750832)
finish=3D227.8min speed=3D71370K/sec

md2 : active raid5 sda5[0] sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1]
      4860206480 blocks super 1.2 level 5, 16k chunk, algorithm 2 [6/6]=
 [UUUUUU]

unused devices: <none>
JMAGGARD:~# dmesg -c
md: requested-resync of RAID array md3
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for requested-resync.
md: using 128k window, over a total of 976750832 blocks.
JMAGGARD:~# tail -10 /var/log/kern.log
Apr 14 16:36:31 JMAGGARD kernel: usb 1-2: new high speed USB device
using ehci_hcd and address 2
Apr 14 17:32:23 JMAGGARD kernel: md: requested-resync of RAID array md2
Apr 14 17:32:23 JMAGGARD kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Apr 14 17:32:23 JMAGGARD kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for requested-resync.
Apr 14 17:32:23 JMAGGARD kernel: md: using 128k window, over a total
of 972041296 blocks.
Apr 14 17:32:51 JMAGGARD kernel: md: md_do_sync() got signal ... exitin=
g
Apr 14 17:33:35 JMAGGARD kernel: md: requested-resync of RAID array md3
Apr 14 17:33:35 JMAGGARD kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Apr 14 17:33:35 JMAGGARD kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for requested-resync.
Apr 14 17:33:35 JMAGGARD kernel: md: using 128k window, over a total
of 976750832 blocks.
JMAGGARD:~#
JMAGGARD:~# mdadm -Dvvs
/dev/md3:
        Version : 1.2
  Creation Time : Wed Apr 14 10:30:07 2010
     Raid Level : raid5
     Array Size : 976750832 (931.50 GiB 1000.19 GB)
  Used Dev Size : 976750832 (931.50 GiB 1000.19 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Wed Apr 14 16:11:08 2010
          State : active, resyncing
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 16K

 Rebuild Status : 0% complete

           Name : 001AD408C964:3
           UUID : 34522369:e16f6b97:c9ba035d:392c01ea
         Events : 27

    Number   Major   Minor   RaidDevice State
       0       8       70        0      active sync   /dev/sde6
       1       8       38        1      active sync   /dev/sdc6
JMAGGARD:~# mdadm -Evvs
mdadm: No md superblock detected on /dev/md3.
mdadm: No md superblock detected on /dev/c/c.
mdadm: No md superblock detected on /dev/md2.
/dev/sdf5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 002a8919:5d4f3b2d:99a502c5:6ad57a52
           Name : 001AD408C964:2
  Creation Time : Tue Apr 13 19:31:40 2010
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 1944082604 (927.01 GiB 995.37 GB)
     Array Size : 9720412960 (4635.05 GiB 4976.85 GB)
  Used Dev Size : 1944082592 (927.01 GiB 995.37 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c190fc75:fbf482b0:6e7ec0f1:bbc3f1f4

    Update Time : Wed Apr 14 17:32:51 2010
       Checksum : 418c175c - correct
         Events : 71

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 5
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 34522369:e16f6b97:c9ba035d:392c01ea
           Name : 001AD408C964:3
  Creation Time : Wed Apr 14 10:30:07 2010
     Raid Level : raid5
   Raid Devices : 2

 Avail Dev Size : 1953501952 (931.50 GiB 1000.19 GB)
     Array Size : 1953501664 (931.50 GiB 1000.19 GB)
  Used Dev Size : 1953501664 (931.50 GiB 1000.19 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 56016c35:ebb5b3b1:732a20a9:2e03e8e0

    Update Time : Wed Apr 14 16:11:08 2010
       Checksum : 8fec23c5 - correct
         Events : 27

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 0
   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 002a8919:5d4f3b2d:99a502c5:6ad57a52
           Name : 001AD408C964:2
  Creation Time : Tue Apr 13 19:31:40 2010
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 1944082604 (927.01 GiB 995.37 GB)
     Array Size : 9720412960 (4635.05 GiB 4976.85 GB)
  Used Dev Size : 1944082592 (927.01 GiB 995.37 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4604bf53:fa8b8f98:29ac1273:ddd7d318

    Update Time : Wed Apr 14 17:32:51 2010
       Checksum : ac8f63ba - correct
         Events : 71

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 4
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 002a8919:5d4f3b2d:99a502c5:6ad57a52
           Name : 001AD408C964:2
  Creation Time : Tue Apr 13 19:31:40 2010
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 1944082604 (927.01 GiB 995.37 GB)
     Array Size : 9720412960 (4635.05 GiB 4976.85 GB)
  Used Dev Size : 1944082592 (927.01 GiB 995.37 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 162d3da0:9e796a82:e9811a93:5e21fc47

    Update Time : Wed Apr 14 17:32:51 2010
       Checksum : 3218996f - correct
         Events : 71

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 3
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 34522369:e16f6b97:c9ba035d:392c01ea
           Name : 001AD408C964:3
  Creation Time : Wed Apr 14 10:30:07 2010
     Raid Level : raid5
   Raid Devices : 2

 Avail Dev Size : 1953501952 (931.50 GiB 1000.19 GB)
     Array Size : 1953501664 (931.50 GiB 1000.19 GB)
  Used Dev Size : 1953501664 (931.50 GiB 1000.19 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : fc30ef80:1341367e:e611bc15:ae905745

    Update Time : Wed Apr 14 16:11:08 2010
       Checksum : 78fd5386 - correct
         Events : 27

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 1
   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 002a8919:5d4f3b2d:99a502c5:6ad57a52
           Name : 001AD408C964:2
  Creation Time : Tue Apr 13 19:31:40 2010
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 1944082604 (927.01 GiB 995.37 GB)
     Array Size : 9720412960 (4635.05 GiB 4976.85 GB)
  Used Dev Size : 1944082592 (927.01 GiB 995.37 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 45e19226:873f8207:49543089:a8d14f46

    Update Time : Wed Apr 14 17:32:51 2010
       Checksum : 31ef962f - correct
         Events : 71

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 2
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 002a8919:5d4f3b2d:99a502c5:6ad57a52
           Name : 001AD408C964:2
  Creation Time : Tue Apr 13 19:31:40 2010
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 1944082604 (927.01 GiB 995.37 GB)
     Array Size : 9720412960 (4635.05 GiB 4976.85 GB)
  Used Dev Size : 1944082592 (927.01 GiB 995.37 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5d9c342e:569c096d:63efac3b:28912736

    Update Time : Wed Apr 14 17:32:51 2010
       Checksum : 416d08af - correct
         Events : 71

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 1
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sda5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 002a8919:5d4f3b2d:99a502c5:6ad57a52
           Name : 001AD408C964:2
  Creation Time : Tue Apr 13 19:31:40 2010
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 1944082604 (927.01 GiB 995.37 GB)
     Array Size : 9720412960 (4635.05 GiB 4976.85 GB)
  Used Dev Size : 1944082592 (927.01 GiB 995.37 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 50327e35:a1b602d2:da883a40:e0314bed

    Update Time : Wed Apr 14 17:32:51 2010
       Checksum : 6960f31c - correct
         Events : 71

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 0
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
JMAGGARD:~#
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
