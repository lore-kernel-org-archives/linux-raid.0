From: Aldo Foot <lunixer@gmail.com>
Subject: properly configure degraded array
Date: Thu, 23 Jul 2009 11:50:39 -0700
Message-ID: <3d22fc520907231150m70f24365xcd0544f29a03bc12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid setup from which I physically removed a hard drive.
The array has three good active physical devices.
The output from mdadm shows "Raid Devices : 4" and "Total Devices : 3"
My objective is to removed all indications of the removed device. Note that
the removed drive has no device name associated with it, so I cannot
remove it with mdadm.
Is it as simple as editing the /etc/mdadm.conf to "num-devices=3"? Would
that change the "State : clean, degraded " to just clean?
Is there something else that needs to be done to do this correctly?

Here's what the config looks like at the moment:

# mdadm -D /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Jul 10 02:39:32 2009
     Raid Level : raid1
     Array Size : 24000 (23.44 MiB 24.58 MB)
  Used Dev Size : 24000 (23.44 MiB 24.58 MB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jul 23 04:18:18 2009
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           UUID : fafe2b90:7ae3cb68:2011742e:3cbab095 (local to host xxxxxxxxxx)
         Events : 0.82

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8        8        2        active sync   /dev/sda8
       3       0        0        3       removed

# mdadm --detail --scan
ARRAY /dev/md0 level=raid1 num-devices=4 metadata=0.90
UUID=fafe2b90:7ae3cb68:2011742e:3cbab095

any thoughts appreciated,
~af
