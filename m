From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Stress testing system?
Date: Fri, 8 Oct 2004 19:48:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410082348.i98NmlN19747@www.watkins-home.com>
References: <4167264B.8070507@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4167264B.8070507@robinbowes.com>
To: 'Robin Bowes' <robin-lists@robinbowes.com>, 'Gordon Henderson' <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not normal.  Was it ever synced?
Wait for it to re-sync, then reboot and check the status.
Some people have problems after a reboot.

Cat /proc/mdstat for the ETA and status.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Bowes
Sent: Friday, October 08, 2004 7:44 PM
To: Gordon Henderson
Cc: linux-raid@vger.kernel.org
Subject: Re: Stress testing system?

Gordon Henderson wrote:
> On Fri, 8 Oct 2004, Robin Bowes wrote:
> 
> 
>>What's the best way to do get all six drives working as hard as possible?
> 
> 
> I always run 'bonnie' on each partition (sometimes 2 to a partition) when
> soak-testing a new server. Try to leave it running for as long as
> possible. (ie. days)

Hi Gordon,

I tried this - just a simple command to start with:

# bonnie++ -d /home -s10 -r4 -u0

This gave the following results:

Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
dude.robinbowes 10M 11482  92 +++++ +++ +++++ +++ 15370 100 +++++ +++ 13406
124
                     ------Sequential Create------ --------Random
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
                  16   347  88 +++++ +++ 19794  91   332  86 +++++ +++  1106
93
dude.robinbowes.com,10M,11482,92,+++++,+++,+++++,+++,15370,100,+++++,+++,134
06.0
,124,16,347,88,+++++,+++,19794,91,332,86,+++++,+++,1106,93


I then noticed that my raid array was using a lot of CPU:

top - 00:41:28 up 33 min,  2 users,  load average: 1.80, 1.78, 1.57
Tasks:  89 total,   1 running,  88 sleeping,   0 stopped,   0 zombie
Cpu(s):  4.1% us, 32.9% sy,  0.0% ni, 59.8% id,  0.0% wa,  0.5% hi,  2.6% si
Mem:   1554288k total,   368212k used,  1186076k free,    70520k buffers
Swap:        0k total,        0k used,        0k free,   200140k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
   239 root      15   0     0    0    0 S 61.0  0.0  20:08.37 md5_raid5
  1414 slimserv  15   0 43644  38m 5772 S  9.0  2.5   2:38.99 slimserver.pl
   241 root      15   0     0    0    0 D  6.3  0.0   2:05.45 md5_resync
  1861 root      16   0  2888  908 1620 R  1.0  0.1   0:00.28 top
  1826 root      16   0  9332 2180 4232 S  0.3  0.1   0:00.28 sshd

So I checked the array:

[root@dude root]# mdadm --detail /dev/md5
/dev/md5:
         Version : 00.90.01
   Creation Time : Thu Jul 29 21:41:38 2004
      Raid Level : raid5
      Array Size : 974566400 (929.42 GiB 997.96 GB)
     Device Size : 243641600 (232.35 GiB 249.49 GB)
    Raid Devices : 5
   Total Devices : 6
Preferred Minor : 5
     Persistence : Superblock is persistent

     Update Time : Sat Oct  9 00:08:22 2004
           State : dirty, resyncing
  Active Devices : 5
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

  Rebuild Status : 12% complete

            UUID : a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
          Events : 0.1410301

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        3       8       50        3      active sync   /dev/sdd2
        4       8       66        4      active sync   /dev/sde2

        5       8       82        -      spare   /dev/sdf2

Is this normal? Should running bonnie++ result in the array being dirty and
requiring resyncing?

R.
-- 
http://robinbowes.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

