From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: RE: Should I Start Over?
Date: Wed, 7 Jul 2004 16:36:53 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2910.66.230.1.97.1089236213.squirrel@exitwound.org>
References: <2128.66.230.1.97.1089224667.squirrel@exitwound.org>
    <200407071907.i67J7b309004@watkins-home.com>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407071907.i67J7b309004@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, here we go.  See below for the information you requested earlier.

# mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/hdg1 /dev/hdd1
missing
mdadm: /dev/hdg1 appears to be part of a raid array:
    level=5 devices=3 ctime=Wed Jul  7 08:11:18 2004
mdadm: /dev/hdd1 appears to be part of a raid array:
    level=5 devices=3 ctime=Wed Jul  7 08:11:18 2004
Continue creating array? y
mdadm: array /dev/md0 started.

Guy said:
>
> Send me the output from these 2 commands:
> Cat /proc/mdstat

# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdd1[1] hdg1[0]
      240121472 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]

unused devices: <none>

>
> mdadm -D /dev/md0

# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Wed Jul  7 16:32:44 2004
     Raid Level : raid5
     Array Size : 240121472 (229.00 GiB 245.88 GB)
    Device Size : 120060736 (114.50 GiB 122.94 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jul  7 16:32:44 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      34        1        0      active sync   /dev/hdg1
       1      22       65        1      active sync   /dev/hdd1
       2       0        0        2      faulty
           UUID : 4120b6d1:f484d7f2:2372ca69:3c1063cd
         Events : 0.1

--
Steve
