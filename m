From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID5 reshape problems
Date: Thu, 26 Mar 2009 11:20:32 +0100
Message-ID: <49CB56F0.9030902@xunil.at>
References: <49CA787C.2090100@xunil.at> <18890.44146.95223.103114@notabene.brown> <49CAB3A3.7020807@xunil.at> <49CB2799.7000305@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CB2799.7000305@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan G. Weichinger schrieb:

> I assume that I will simply have to add /dev/sdf4 then ??
> Or again "add" and then "grow" ?

Did a "mdadm --re-add /dev/md2 /dev/sdf4", now it looks like:

# mdadm -D /dev/md2
/dev/md2:
        Version : 00.91.03
  Creation Time : Wed Oct 22 19:43:13 2008
     Raid Level : raid5
     Array Size : 2903386944 (2768.89 GiB 2973.07 GB)
  Used Dev Size : 967795648 (922.96 GiB 991.02 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Mar 26 11:18:48 2009
          State : clean, degraded, recovering
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 14% complete
  Delta Devices : 2, (4->6)

           UUID : 2e27c42d:40936d45:53eb5abe:265a9668
         Events : 0.96428

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       8       52        2      active sync   /dev/sdd4
       3       8       68        3      active sync   /dev/sde4
       4       0        0        4      removed
       5       8       36        5      active sync   /dev/sdc4

       6       8       84        -      spare   /dev/sdf4


Looks very OK to me.

*phew*

I will wait until it isn't degraded anymore before I do the "pvresize".

Thanks all, Stefan
