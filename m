From: <rodman@shellport.com>
Subject: Checkarray doesn't seem to do anything
Date: Tue, 01 Mar 2016 14:09:44 -0700
Message-ID: <20160301140944.0a91db92e0d9ae1e5e3fde0508678719.a71523d3be.wbe@email03.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I have a question as it pertains to the checkarray function of Mdadm.  I
can't actually get it to do anything.  I'm running Ubuntu 14.04.4 Server
LTS with the latest mdadm installed.  I have a single RAID 1 mirror
configured and working properly near as I can tell.  

I can force a check if I issue "echo check >
/sys/block/md0/md/sync_action" as root.  I can then see the status of
the check via /proc/mdstat or using the --detail switch on mdadm itself.

However, nothing happens if I type in:
/usr/share/mdadm/checkarray -a
or
/usr/share/mdadm/checkarray -a /dev/mdX
or
/usr/share/mdadm/checkarray -as

I've tried the commands as root and using sudo.  The array sits idle
after all of the above commands.  The only thing I can actually get
checkarray to perform is to give me the help output if I pass it -h.  I
have attached, below, the current status of the mdadm managed array. 
Doing some Googling I haven't been able to find anyone else that isn't
able to use the checkarray function so I must be doing something wrong.

Any ideas?

Rodman Frowert


cat /proc/mdstat shows:
------------------
rodman@nas:/usr/share/mdadm$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdc1[1] sdb1[0]
      5860389696 blocks super 1.2 [2/2] [UU]
-----------------

sudo mdadm --detail /dev/md0 shows:
------------------
rodman@nas:/usr/share/mdadm$ sudo mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Fri Feb 26 14:07:40 2016
     Raid Level : raid1
     Array Size : 5860389696 (5588.90 GiB 6001.04 GB)
  Used Dev Size : 5860389696 (5588.90 GiB 6001.04 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue Mar  1 07:40:19 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : nas:0  (local to host nas)
           UUID : 4765e7df:0e1a6ad2:1321765f:a2d9f2c9
         Events : 164

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1

-----------------
