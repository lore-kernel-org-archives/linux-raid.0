From: "James R Bamford" <jim@jimtreats.com>
Subject: HELP.. how to remove a spare drive i accidently added
Date: Tue, 18 Nov 2003 20:12:16 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOKEHMGOAA.jim@jimtreats.com>
References: <Pine.LNX.4.56.0311181431340.11397@nemesis.cs.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0311181431340.11397@nemesis.cs.yorku.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Help..

as in i came home early to test and then to rebuild the array that just
takes ages..

I followed the advice in the FAQ.. took out one drive, booted up.. it listed
it as failed.. I powered down.. reconnected drive.. booted up.. it still
only used 1 drive... I thought i'd try using mdadm so i tried to add it..
its gone and added it as spare...

I'd tried assemble but that only ever used the 1 drive.. not both..

now i try to remove the spare

[root@backup root]# mdadm /dev/md0 -r /dev/hdg1
mdadm: hot remove failed for /dev/hdg1: Device or resource busy

and just cannot

I stop the array and i can't remove it as array isn't running..

Ahh stupid.. I've just looked at /proc/mdstat

Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hde1[0] hdg1[2]
      16064896 blocks [2/1] [U_]
      [====>................]  recovery = 22.5% (3625536/16064896)
finish=20.2min speed=10225K/sec
unused devices: <none>

Its already recovering... phew.. i didn't find this clear..

mdadm -D revealed this

/dev/md0:
        Version : 00.90.00
  Creation Time : Mon Nov 17 22:16:09 2003
     Raid Level : raid1
     Array Size : 16064896 (15.32 GiB 16.45 GB)
    Device Size : 16064896 (15.32 GiB 16.45 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Nov 18 20:03:00 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1       0        0        1      faulty removed
       2      34        1        2      spare   /dev/hdg1
           UUID : f3be955c:8902d2ea:fb455a5e:8ea38b70
         Events : 0.24

It didn't really shout out to me that the spare drive was being used to
restore.. I did in panic go to the FAQ and follow their advice of
"raidhotadd /dev/mdX /dev/sdX" but this failed as it was already in use as
spare..

So could someone point out what to do when my harddrive really does fail...
take out the faulty one.. put a new one in, partition it.. and then add it
with

mdadm -a /dev/md0 /dev/<harddisk>

this will add it with spare and is equivelant to raidhotadd so will start
syncing the drive in!?

If its that easy then thats fine :)

Great even...

Thanks... sorry.. I'm nearly up to speed with this.. slowly..

Jim

