From: Pierre Beck <mail@pierre-beck.de>
Subject: Re: Raid5 crashed, need comments on possible repair solution
Date: Sat, 12 May 2012 19:19:32 +0200
Message-ID: <4FAE9BA3.4000407@pierre-beck.de>
References: <4F955F80.80903@evilazrael.de> <20120424070044.707745b8@notabene.brown> <4F95CDE0.4070200@evilazrael.de> <20120424090122.3d90b4a6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120424090122.3d90b4a6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

got an all-spares auto-assembly on IRC with "Raid level: -unknown-". We 
recovered by re-creating the array. Since more data is always good, I 
add this to the thread and hope it helps confirm the bug is fixed by the 
patch.

RAID-5, 3 members with 1 missing on creation and ever since.

Members on partitions with partition type set for auto-assembly.

Array was transported to a new machine.

Drive order got mixed up on transport: AB_ BA_
(figured that out on recovery)

On target machine boot-up (array not yet configured in mdadm.conf) 
Archlinux auto-assembled array with both drives as spares:

/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : c051172d:52ed3e47:e8dc6dc8:8798f4c9
            Name : OncleGeorges:0
   Creation Time : Fri Aug  5 18:00:19 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 1953515969 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : a8b44e10:ff04d973:c5f92933:3c9e124f

     Update Time : Sat Apr 21 19:14:34 2012
        Checksum : 8b57fb27 - correct
          Events : 1


    Device Role : spare
    Array State :  ('A' == active, '.' == missing)

/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : c051172d:52ed3e47:e8dc6dc8:8798f4c9
            Name : OncleGeorges:0
   Creation Time : Fri Aug  5 18:00:19 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 2046769231 (975.98 GiB 1047.95 GB)
   Used Dev Size : 1953515969 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : d2594375:c8adc5a0:53938a24:9bd5c6be

     Update Time : Sat Apr 21 19:14:34 2012
        Checksum : 83dd0895 - correct
          Events : 1


    Device Role : spare
    Array State :  ('A' == active, '.' == missing)


Versions:

Linux HostName 3.3.4-2-ARCH #1 SMP PREEMPT Wed May 2 15:39:58 UTC 2012 
i686 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD GNU/Linux

mdadm - v3.2.3 - 23rd December 2011

Greetings,

Pierre Beck
