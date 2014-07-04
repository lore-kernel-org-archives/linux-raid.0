From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: RAID 6 crashes system when being accessed
Date: Fri, 04 Jul 2014 14:11:55 +0000
Message-ID: <emb6d3f02d-046d-4466-87c3-f86175b9b08a@littlez>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am experiencing some issues with my md raid. It is crashing my system 
when accessed with any "verve". The reboot initiates a resync of the 
raid. I have gone through the crash/reboot/resynced a number of times 
now and the crash happens within minutes of mounting the raid.

Here are some details:

- It is a raid 6 with 7 3TB devices.
- Formatted as EXT4
- mdadm v3.2.6 - 25th October 2012
- centos 6.5 kernel 2.6.32-431.3.1.el6.x86_64
- It has been running flawlessly for the previous 6 months.
- I have a cron script running that resyncs monthly.
- When the raid is unmounted, the system runs fine. (I have an 
additional "dumb" hardware raid 1 for dailies attached to an ESATA port. 
This runs perfectly).
- I am in the process of re-syncing the raid 6 again right now.
- I have run an fsck on the raid volume after it was fully synced and 
everything came up clean.

- there have been lots of power outages the last while with the hot 
summer in Toronto. My UPS shuts the system down for me, though I think I 
can correlate the issues with the power outages.

Below are the printouts from /proc/mdstat and mdadm --examine

I am not very experienced with mdadm and am a newbie with linux. Any 
assistance you might be able to offer would be appreciated.

Best,

- Justin

-----------------------------
/proc/mdstat

Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdg1[4] sdh1[5] sdf1[3] sdc1[0] sde1[2] sdd1[1] 
sdb1[6]
       14650666880 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[7/7] [UUUUUUU]
       [>....................] resync = 4.7% (138332896/2930133376) 
finish=353.0min speed=131774K/sec
------------------------------
mdadm --examine

[root@BigBlue Desktop]# mdadm --examine /dev/sd[b-h]1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0 (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650666880 (13971.97 GiB 15002.28 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 7f7ace48:01a4b6f6:bf182ae3:6acddef9

     Update Time : Fri Jul 4 09:26:41 2014
        Checksum : a1aab985 - correct
          Events : 10631

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 6
    Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0 (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650666880 (13971.97 GiB 15002.28 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 8a4d11bd:fe387740:1edc1151:b0ebba43

     Update Time : Fri Jul 4 09:26:41 2014
        Checksum : 1772032b - correct
          Events : 10631

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 0
    Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0 (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650666880 (13971.97 GiB 15002.28 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : aa158e32:f4449a9b:73e95000:22852278

     Update Time : Fri Jul 4 09:26:41 2014
        Checksum : cbb87e08 - correct
          Events : 10631

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 1
    Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0 (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650666880 (13971.97 GiB 15002.28 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 7bee5d42:cb66c602:162e88f1:e140447c

     Update Time : Fri Jul 4 09:26:41 2014
        Checksum : 380d7914 - correct
          Events : 10631

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 2
    Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0 (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650666880 (13971.97 GiB 15002.28 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : b4a7b35c:6e377711:4b291874:edb2c4d0

     Update Time : Fri Jul 4 09:26:41 2014
        Checksum : 38247032 - correct
          Events : 10631

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 3
    Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0 (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650666880 (13971.97 GiB 15002.28 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 7c0bba5a:6b205302:d026a78d:91f5ebdd

     Update Time : Fri Jul 4 09:26:41 2014
        Checksum : 4dbcfd29 - correct
          Events : 10631

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 4
    Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdh1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0849c677:64e4772e:8892d80b:47e0097a
            Name : BigBlue:0 (local to host BigBlue)
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 5860267024 (2794.39 GiB 3000.46 GB)
      Array Size : 14650666880 (13971.97 GiB 15002.28 GB)
   Used Dev Size : 5860266752 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : a750a146:7ee7383e:2929d803:2bee9dc1

     Update Time : Fri Jul 4 09:26:41 2014
        Checksum : cf6d0452 - correct
          Events : 10631

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 5
    Array State : AAAAAAA ('A' == active, '.' == missing)




