From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Reassemble Raid 6
Date: Mon, 10 Feb 2014 16:48:09 +0000
Message-ID: <em138f8d3b-69b5-40ed-baf9-c23fb4e7ae1b@littlez>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have reviewed the Linux Raid Wiki regarding rebuilding and it 
recommended writing a note to the list.

I am running an mdadm raid on CENTOS 6.5 with 6 disks in a Raid 6 off of 
my motherboard's SATA controller.

I added a 7th disk as a spare.

When I rebooted the raid after adding the spare, it would not mount and 
the OS would only boot into recovery mode. I changed my fsck file to 
exclude the raid and can now boot into the GUI.

I have tried to reassemble the array using --assemble and I get the the 
following message:

mdadm: we match both /dev/md/BigBlue:0 and /dev/md0 - cannot decide 
which to use.

I am including the output of the mdadm --examine below.

I am considering using --force to assemble the array, though I suspect 
that this is something simple that I am overlooking -- I am quite new to 
linux.

Any input would be appreciated.

- Justin

/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0  (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 11720533504 (11177.57 GiB 12001.83 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 7f7ace48:01a4b6f6:bf182ae3:6acddef9

     Update Time : Sun Feb  9 20:31:13 2014
        Checksum : cedf7f63 - correct
          Events : 557

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : spare
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0  (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 11720533504 (11177.57 GiB 12001.83 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 8a4d11bd:fe387740:1edc1151:b0ebba43

     Update Time : Sun Feb  9 20:31:13 2014
        Checksum : 44a6c909 - correct
          Events : 557

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 0
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0  (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 11720533504 (11177.57 GiB 12001.83 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : aa158e32:f4449a9b:73e95000:22852278

     Update Time : Sun Feb  9 20:31:13 2014
        Checksum : f8ed43e6 - correct
          Events : 557

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 1
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0  (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 11720533504 (11177.57 GiB 12001.83 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 7bee5d42:cb66c602:162e88f1:e140447c

     Update Time : Sun Feb  9 20:31:13 2014
        Checksum : 65423ef2 - correct
          Events : 557

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 2
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0  (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 11720533504 (11177.57 GiB 12001.83 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : b4a7b35c:6e377711:4b291874:edb2c4d0

     Update Time : Sun Feb  9 20:31:13 2014
        Checksum : 65593610 - correct
          Events : 557

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 3
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0  (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 11720533504 (11177.57 GiB 12001.83 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 7c0bba5a:6b205302:d026a78d:91f5ebdd

     Update Time : Sun Feb  9 20:31:13 2014
        Checksum : 7af1c2ff - correct
          Events : 557

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 4
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdh1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0  (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 11720533504 (11177.57 GiB 12001.83 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : a750a146:7ee7383e:2929d803:2bee9dc1

     Update Time : Sun Feb  9 20:31:13 2014
        Checksum : fca1ca30 - correct
          Events : 557

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 5
    Array State : AAAAAA ('A' == active, '.' == missing)


