From: Chris Allen <chris@cjx.com>
Subject: Re: Recovering a raid5 array with strange event count
Date: Fri, 13 Apr 2007 14:07:58 +0100
Message-ID: <461F80AE.5080702@cjx.com>
References: <461F5802.4090608@cjx.com> <17951.29662.910442.896659@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17951.29662.910442.896659@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids





Neil Brown wrote:
> On Friday April 13, chris@cjx.com wrote:
>   
>> Dear All,
>>
>> I have an 8-drive raid-5 array running under 2.6.11. This morning it 
>> bombed out, and when I brought
>> it up again, two drives had incorrect event counts:
>>
>>
>> sda1: 0.8258715
>> sdb1: 0.8258715
>> sdc1: 0.8258715
>> sdd1: 0.8258715
>> sde1: 0.8258715
>> sdf1: 0.8258715
>> sdg1: 0.8258708
>> sdh1: 0.8258716
>>
>>
>> sdg1 is out of date (expected), but sdh1 has received an extra event.
>>
>> Any attempt to restart with mdadm --assemble --force, results in an an
>> un-startable array with an event count of 0.8258715.
>>
>> Can anybody advise on the correct command to use to get it started again?
>> I'm assuming I'll need to use mdadm --create --assume-clean - but I'm 
>> not sure
>> which drives should be included/excluded when I do this.
>>     
>
> A difference of 1 in event counts is not supposed to cause a problem.
> Have you tried simply assembling the array without including sdg1.
> e.g.
>   mdadm -A /dev/md0 /dev/sd[abcdefh]1
>
>
>   

# mdadm -A /dev/md0 /dev/sd[abcdefh]1

mdadm: /dev/md0 assembled from 7 drives - need all 8 to start it (use 
--run to insist)

# mdadm -D /dev/md0

mdadm: md device /dev/md0 does not appear to be active.


mdadm --run /dev/md0

mdadm: failed to run array /dev/md0: invalid argument



I've attached the syslog, the dump for the assembled array, the dump for 
each drive
and the contents of /proc/mdstat. Using --force makes no difference.




Apr 13 13:59:45 snap29 kernel: md: bind<sdb1>
Apr 13 13:59:45 snap29 kernel: md: bind<sdc1>
Apr 13 13:59:45 snap29 kernel: md: bind<sdd1>
Apr 13 13:59:45 snap29 kernel: md: bind<sde1>
Apr 13 13:59:45 snap29 kernel: md: bind<sdf1>
Apr 13 13:59:45 snap29 kernel: md: bind<sdh1>
Apr 13 13:59:45 snap29 kernel: md: bind<sda1>
Apr 13 14:00:01 snap29 kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Apr 13 14:00:01 snap29 kernel: raid5: device sda1 operational as raid disk 0
Apr 13 14:00:01 snap29 kernel: raid5: device sdh1 operational as raid disk 7
Apr 13 14:00:01 snap29 kernel: raid5: device sdf1 operational as raid disk 5
Apr 13 14:00:01 snap29 kernel: raid5: device sde1 operational as raid disk 4
Apr 13 14:00:01 snap29 kernel: raid5: device sdd1 operational as raid disk 3
Apr 13 14:00:01 snap29 kernel: raid5: device sdc1 operational as raid disk 2
Apr 13 14:00:01 snap29 kernel: raid5: device sdb1 operational as raid disk 1
Apr 13 14:00:01 snap29 kernel: raid5: cannot start dirty degraded array 
for md0
Apr 13 14:00:01 snap29 kernel: RAID5 conf printout:
Apr 13 14:00:01 snap29 kernel:  --- rd:8 wd:7 fd:1
Apr 13 14:00:01 snap29 kernel:  disk 0, o:1, dev:sda1
Apr 13 14:00:01 snap29 kernel:  disk 1, o:1, dev:sdb1
Apr 13 14:00:01 snap29 kernel:  disk 2, o:1, dev:sdc1
Apr 13 14:00:01 snap29 kernel:  disk 3, o:1, dev:sdd1
Apr 13 14:00:01 snap29 kernel:  disk 4, o:1, dev:sde1
Apr 13 14:00:01 snap29 kernel:  disk 5, o:1, dev:sdf1
Apr 13 14:00:01 snap29 kernel:  disk 7, o:1, dev:sdh1
Apr 13 14:00:01 snap29 kernel: raid5: failed to run raid set md0
Apr 13 14:00:01 snap29 kernel: md: pers->run() failed ...

/dev/md0:
        Version : 00.90.01
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Apr 13 10:11:15 2007
          State : active, degraded, Not Started
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
         Events : 0.8258715

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       0        0        6      removed
       7       8      113        7      active sync   /dev/sdh1



/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Apr 13 10:11:12 2007
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a469bd5a - correct
         Events : 0.8258715

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Apr 13 10:11:12 2007
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a469bd6b - correct
         Events : 0.8258715

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Apr 13 10:11:12 2007
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a469bd7d - correct
         Events : 0.8258715

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Apr 13 10:11:12 2007
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a469bd8f - correct
         Events : 0.8258715

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Apr 13 10:11:12 2007
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a469bda1 - correct
         Events : 0.8258715

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Apr 13 10:11:12 2007
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a469bdb3 - correct
         Events : 0.8258715

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 31b253f9:02049908:aa4bb1ab:753b8fda
  Creation Time : Wed Apr 19 06:23:21 2006
     Raid Level : raid5
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 3418687552 (3260.31 GiB 3500.74 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Fri Apr 13 10:11:15 2007
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : a469bddb - correct
         Events : 0.8258716

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      113        7      active sync   /dev/sdh1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1



Personalities : [raid5]
md0 : inactive sda1[0] sdh1[7] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
      3418687552 blocks
unused devices: <none>





