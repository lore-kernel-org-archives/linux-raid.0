From: Ram Ramesh <rramesh2400@gmail.com>
Subject: My md won't assemble even when disks are in clean state.
Date: Thu, 8 Jun 2017 20:44:24 -0500
Message-ID: <f8d51bbd-6df7-2ea0-ba6f-8831a2b3e390@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

   Today my host had a power outage due to user mistake in the middle of 
a disk replacement. The replacement was simply to replace an old/smaller 
disk with new/larger one. No drive had failed prior to replacement.  My 
/dev/md0 is a RAID6 with 6 disks prior to replacement (sd{b,c,e,f,g,h}1) 
I started replacement with this following commands

 1. mdadm /dev/md0 --add /dev/sdi1
 2. echo want-replacement > /sys/block/md0/md/dev-sdg1/state

It was going to take about 6hr for the rebuild to complete. Then the 
power outage happened about 1hr in to the replacement.
On reboot the array has all 7 (old 6+new 1) as spares and failed to 
assemble. The disk names have also changed which did not surprise me. 
mdadm --assemble -force did not work. It reported that all spares are 
busy. I suspect that it has 7 disk for 6 array raid6 and does not know 
which 6 to pick to bring up the array. Looking at the disk vendor and 
serial numbers, I think the replacement is /dev/sdf1 and the one getting 
replaced is /dev/sdi1 in the following details (Note that pre crash this 
was called /dev/sdg1)

    zym [root] 27 > mdadm --version
    mdadm - v3.2.5 - 18th May 2012

    zym [root] 28 > uname -a
    Linux zym 3.13.0-106-generic #153-Ubuntu SMP Tue Dec 6 15:44:32 UTC
    2016 x86_64 x86_64 x86_64 GNU/Linux

    zym [root] 29 > cat /etc/os-release
    NAME="Ubuntu"
    VERSION="14.04.5 LTS, Trusty Tahr"
    ID=ubuntu
    ID_LIKE=debian
    PRETTY_NAME="Ubuntu 14.04.5 LTS"
    VERSION_ID="14.04"
    HOME_URL="http://www.ubuntu.com/"
    SUPPORT_URL="http://help.ubuntu.com/"
    BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"

    zym [root] 31 > cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
    [raid4] [raid10]
    md0 : inactive sdi1[7](S) sdg1[11](S) sdh1[6](S) sdf1[12](S)
    sde1[10](S) sdd1[8](S) sdc1[9](S)
           39069229300 blocks super 1.2

    unused devices: <none>

    foreach i ( /dev/sd{c,d,e,f,h,i}1 )
    sudo mdadm --examine $i >> /tmp/examine
    end

    zym [root] 32 > cat /tmp/examine
    /dev/sdc1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x1
          Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
                Name : zym:0  (local to host zym)
       Creation Time : Mon Apr 22 00:08:12 2013
          Raid Level : raid6
        Raid Devices : 6

      Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
          Array Size : 15627545856 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 7813772928 (3725.90 GiB 4000.65 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
               State : clean
         Device UUID : 05bb9634:4ecf803a:c519c886:cf3f4867

    Internal Bitmap : 8 sectors from superblock
         Update Time : Thu Jun  8 19:11:59 2017
            Checksum : cdf085c0 - correct
              Events : 290068

              Layout : left-symmetric
          Chunk Size : 64K

        Device Role : Active device 5
        Array State : AAAA?A ('A' == active, '.' == missing)

    /dev/sdd1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x1
          Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
                Name : zym:0  (local to host zym)
       Creation Time : Mon Apr 22 00:08:12 2013
          Raid Level : raid6
        Raid Devices : 6

      Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
          Array Size : 15627545856 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 7813772928 (3725.90 GiB 4000.65 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
               State : clean
         Device UUID : 7e16d55d:3f00c22b:44a750ab:b50a4b5d

    Internal Bitmap : 8 sectors from superblock
         Update Time : Thu Jun  8 19:11:59 2017
            Checksum : 2fb6a8f - correct
              Events : 290068

              Layout : left-symmetric
          Chunk Size : 64K

        Device Role : Active device 0
        Array State : AAAA?A ('A' == active, '.' == missing)

    /dev/sde1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x1
          Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
                Name : zym:0  (local to host zym)
       Creation Time : Mon Apr 22 00:08:12 2013
          Raid Level : raid6
        Raid Devices : 6

      Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
          Array Size : 15627545856 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 7813772928 (3725.90 GiB 4000.65 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
               State : clean
         Device UUID : 7e035b56:d1e1882b:e78a08ad:3ba50667

    Internal Bitmap : 8 sectors from superblock
         Update Time : Thu Jun  8 19:11:59 2017
            Checksum : 6bbb74c - correct
              Events : 290068

              Layout : left-symmetric
          Chunk Size : 64K

        Device Role : Active device 2
        Array State : AAAA?A ('A' == active, '.' == missing)

    /dev/sdf1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x1
          Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
                Name : zym:0  (local to host zym)
       Creation Time : Mon Apr 22 00:08:12 2013
          Raid Level : raid6
        Raid Devices : 6

      Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
          Array Size : 15627545856 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 7813772928 (3725.90 GiB 4000.65 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
               State : clean
         Device UUID : 94251d51:a616e735:e7baccdb:3610013b

    Internal Bitmap : 8 sectors from superblock
         Update Time : Thu Jun  8 19:11:59 2017
            Checksum : e9aab94 - correct
              Events : 290068

              Layout : left-symmetric
          Chunk Size : 64K

        Device Role : Active device 1
        Array State : AAAA?A ('A' == active, '.' == missing)

    /dev/sdg1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x1
          Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
                Name : zym:0  (local to host zym)
       Creation Time : Mon Apr 22 00:08:12 2013
          Raid Level : raid6
        Raid Devices : 6

      Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
          Array Size : 15627545856 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 7813772928 (3725.90 GiB 4000.65 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
               State : clean
         Device UUID : ad285b4d:222eea5e:0baad052:02eeb7d2

    Internal Bitmap : 8 sectors from superblock
         Update Time : Thu Jun  8 19:11:59 2017
            Checksum : 429690b8 - correct
              Events : 290068

              Layout : left-symmetric
          Chunk Size : 64K

        Device Role : Active device 3
        Array State : AAAA?A ('A' == active, '.' == missing)

    /dev/sdh1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x13
          Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
                Name : zym:0  (local to host zym)
       Creation Time : Mon Apr 22 00:08:12 2013
          Raid Level : raid6
        Raid Devices : 6

      Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
          Array Size : 15627545856 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 7813772928 (3725.90 GiB 4000.65 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
    Recovery Offset : 1192713176 sectors
               State : clean
         Device UUID : 0ddd2a83:872da375:c7cb7a93:c5bd2ea1

    Internal Bitmap : 8 sectors from superblock
         Update Time : Thu Jun  8 19:11:59 2017
            Checksum : e55791e1 - correct
              Events : 290068

              Layout : left-symmetric
          Chunk Size : 64K

        Device Role : Active device 4
        Array State : AAAA?A ('A' == active, '.' == missing)

    /dev/sdi1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x1
          Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
                Name : zym:0  (local to host zym)
       Creation Time : Mon Apr 22 00:08:12 2013
          Raid Level : raid6
        Raid Devices : 6

      Avail Dev Size : 7813772943 (3725.90 GiB 4000.65 GB)
          Array Size : 15627545856 (14903.59 GiB 16002.61 GB)
       Used Dev Size : 7813772928 (3725.90 GiB 4000.65 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
               State : clean
         Device UUID : 6c35eb93:149c874e:48f7572b:fc6161cc

    Internal Bitmap : 8 sectors from superblock
         Update Time : Thu Jun  8 19:11:59 2017
            Checksum : 6214969b - correct
              Events : 290068

              Layout : left-symmetric
          Chunk Size : 64K

        Device Role : Active device 4
        Array State : AAAA?A ('A' == active, '.' == missing)
    zym [root] 33 >

    ***smartctl output omitted as all disks are healthy with no errors***

Thanks in advance for your help.

Ramesh

