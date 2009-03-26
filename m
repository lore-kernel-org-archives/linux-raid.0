From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID5 reshape problems
Date: Thu, 26 Mar 2009 07:58:33 +0100
Message-ID: <49CB2799.7000305@xunil.at>
References: <49CA787C.2090100@xunil.at> <18890.44146.95223.103114@notabene.brown> <49CAB3A3.7020807@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CAB3A3.7020807@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan G. Weichinger schrieb:

> Might take till tomorrow when the owner comes to office again that he
> will be able to reboot the box via console.
> 
> At least I am somehow more confident now that we won't lose data.

Update: a hard reboot worked, the raid was visible but inactive.
We re-added the now checked sdf (in a completely cleaned server) and the
raid was still inactive. In the end I had to re-assemble the md-device
with 5 out of 6 devices, right now it rebuilds:

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid5 sde3[3](S) sdd3[2] sdb3[1] sda3[0]
      17591040 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md2 : active raid5 sde4[3] sdd4[2] sdc4[5] sdb4[1] sda4[0]
      2903386944 blocks super 0.91 level 5, 64k chunk, algorithm 2 [6/5]
[UUUU_U]
      [>....................]  reshape =  1.9% (18408064/967795648)
finish=1479.2min speed=10696K/sec


# mdadm -D /dev/md2
/dev/md2:
        Version : 00.91.03
  Creation Time : Wed Oct 22 19:43:13 2008
     Raid Level : raid5
     Array Size : 2903386944 (2768.89 GiB 2973.07 GB)
  Used Dev Size : 967795648 (922.96 GiB 991.02 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Mar 26 07:56:33 2009
          State : clean, degraded, recovering
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 1% complete
  Delta Devices : 2, (4->6)

           UUID : 2e27c42d:40936d45:53eb5abe:265a9668
         Events : 0.12576

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       8       52        2      active sync   /dev/sdd4
       3       8       68        3      active sync   /dev/sde4
       4       0        0        4      removed
       5       8       36        5      active sync   /dev/sdc4


---

I assume that I will simply have to add /dev/sdf4 then ??
Or again "add" and then "grow" ?

The PV/VG/LVs all are valid, time to try to relax a bit now.

Thanks, Neil,

Stefan
