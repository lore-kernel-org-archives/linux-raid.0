From: Ronny Plattner <ronny_p@gmx.net>
Subject: sw_raid5-failed_disc(s)
Date: Fri, 11 Mar 2005 22:40:06 +0100
Message-ID: <d0t31v$89o$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

The story:
We are running a Softwareraid 5 with 4 ATA-Discs under Debian. A week
ago, one disc (hdi) had 3 reallocated sectors (seems to be stable), so
we decided to send it back to Maxtor, because the others discs were fine.
After we had built out this disc, another disc (hdm) of this raid array
filled our logfiles with a lot of seek errors. We were frustrated.
I decided to put the harddisc back in the array and after this shutdown,
the raid works and after some troubles [1] the disc was back in the
array. There are two partitions (logical volumes-lvm) on the raid, i
mounted one (/home..ext3) and copied the data to other discs. No
troubles during this operation!
Then i tried to mount the other partition. I was able to read directory
structures, but if i tried to copy files, i got "I/O Errors".
While i tried this, "the raid" (mdadm is started by startscripts) marks
hdm as faulty ...
The "reallocated sectors" counter of hdm shows an increasing amount of
reallocated sectors and the ongoing resync of the raid filled our logs
(some hundred MB) -> we sent hdm to maxtor.
Now, the raid is running degraded mode....

-snip-
server:~# cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdg2[1] hde2[0]
      75709248 blocks [2/2] [UU]

md2 : inactive hdk1[1] hdi1[4] hdo1[3]
      735334848 blocks
md0 : active raid1 hdg1[1] hde1[0]
      2441280 blocks [2/2] [UU]

unused devices: <none>
server:~# mdadm  --detail /dev/md2
/dev/md2:
        Version : 00.90.01
  Creation Time : Mon Jun 14 18:43:20 2004
     Raid Level : raid5
    Device Size : 245111616 (233.76 GiB 250.99 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sun Mar  6 16:40:29 2005
          State : active, degraded
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 72c49e3a:de37c4f8:00a6d8a2:e8fddb2c
         Events : 0.60470022

    Number   Major   Minor   RaidDevice State
       0       0        0        -      removed
       1      57        1        1      active sync   /dev/hdk1
       2       0        0        -      removed
       3      89        1        3      active sync   /dev/hdo1

       4      56        1        -      spare   /dev/hdi1
server:~#
-snap-

I tried a raidstart

-snip-
server:~# raidstart /dev/md2
/dev/md2: Invalid argument
/dev/md2: Invalid argument
/dev/md2: Invalid argument
/dev/md2: Invalid argument
/dev/md2: Invalid argument
server:~#
-snap-

...entry in messages

-snip-
kernel: md: autostart failed!
-snap-

Okay...stopping the raid

-snip-
server:~# mdadm  -S /dev/md2
server:~# cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdg2[1] hde2[0]
      75709248 blocks [2/2] [UU]

md0 : active raid1 hdg1[1] hde1[0]
      2441280 blocks [2/2] [UU]

unused devices: <none>
-snap-

Fine.
Okay..reassembling it...

-snip-
server:~# mdadm --assemble --run --force /dev/md2 /dev/hdk /dev/hdo /dev/hdi
mdadm: no RAID superblock on /dev/hdk
mdadm: /dev/hdk has no superblock - assembly aborted

---> my fault :-)

server:~# mdadm --assemble --run --force /dev/md2 /dev/hdk1 /dev/hdo1
/dev/hdi1
mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
server:~# cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdg2[1] hde2[0]
      75709248 blocks [2/2] [UU]

md2 : inactive hdk1[1] hdi1[4] hdo1[3]
      735334848 blocks
md0 : active raid1 hdg1[1] hde1[0]
      2441280 blocks [2/2] [UU]

unused devices: <none>
server:~#
-snap-
...and the mdadm --detail above..

Anyone knows whats happening here? I do not know how to get our data on
the second partition (xfs there).
I hope one of the gurus here is able to help me (and our data)

Best Regards
Ronny

[1] Some troubles ...i solved that with dmsetup ..after that i was able
to reassemble the array...german speaking people can read the whole
postings, non-german speaking people were able to see "my way" ... here
are the my postings (and raidtab too):
http://www.sbox.tugraz.at/home/p/plattner/raid5_history/


PS: There are also mdadm --examine - outputs

