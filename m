From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Fri, 29 Jan 2010 08:06:35 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001290803320.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se> <alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 29 Jan 2010, Mikael Abrahamsson wrote:

> Still no go. Anyone who can help me what might be going wrong here, I 
> mean, that a drive is stuck in "active" can't be a very weird event 
> state?

mdadm --examine on all the drives:

http://pastebin.com/m271096ba

Also:

root@ub:~# mdadm --query --detail /dev/md0
/dev/md0:
         Version : 01.02
   Creation Time : Thu Mar 19 16:32:38 2009
      Raid Level : raid5
   Used Dev Size : 1953514432 (1863.02 GiB 2000.40 GB)
    Raid Devices : 6
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Fri Jan 29 03:08:35 2010
           State : active, degraded, Not Started
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : swmike-htpc2:0
            UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
          Events : 2742684

     Number   Major   Minor   RaidDevice State
        0       8       48        0      active sync   /dev/sdd
        6       8       96        1      active sync   /dev/sdg
        2       8       16        2      active sync   /dev/sdb
        4       8       32        3      active sync   /dev/sdc
        4       0        0        4      removed
        7       8       80        5      active sync   /dev/sdf

root@ub:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : inactive sdd[0] sdf[7] sdc[4] sdb[2] sdg[6]
       9767572240 blocks super 1.2

unused devices: <none>

root@ub:~# echo "clean" > /sys/block/md0/md/array_state
-bash: echo: write error: Invalid argument

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
