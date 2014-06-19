From: Henry Golas <henry.golas@argonaut.ca>
Subject: Re: Failed RAID5 & recovery advise
Date: Thu, 19 Jun 2014 17:45:32 -0400
Message-ID: <53A359FC.8090800@argonaut.ca>
References: <53A04052.70905@argonaut.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53A04052.70905@argonaut.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Afternoon All,

I've been added to this DL so hopefully emails will get through.

Got the output of mdadm --examine here below. Completed manufacturer 
drive tests and it looks like one of the drives failed. Looks like 
/dev/sdd has some bad sectors.

My next step is to attempt to use: mdadm --assemble --force

Any insight would be greatly appreciated,

Thanks,

Hg

My current /proc/mdstat (I removed /dev/sdd):

root@hexcore:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md126 : inactive sdd[3](S) sdf[0](S) sde[1](S)
       5860543488 blocks

/dev/sdb:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 7a546254:db5399b5:208c7c81:db418059
   Creation Time : Fri Feb 11 16:09:34 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 126

     Update Time : Sat Jun 14 22:25:41 2014
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 10065342 - correct
          Events : 36223

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       48        3      active sync   /dev/sdd

    0     0       0        0        0      removed
    1     1       8       64        1      active sync   /dev/sde
    2     2       0        0        2      faulty removed
    3     3       8       48        3      active sync   /dev/sdd
/dev/sdc:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 7a546254:db5399b5:208c7c81:db418059
   Creation Time : Fri Feb 11 16:09:34 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 126

     Update Time : Sat Jun 14 22:25:41 2014
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 1006534e - correct
          Events : 36223

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       64        1      active sync   /dev/sde

    0     0       0        0        0      removed
    1     1       8       64        1      active sync   /dev/sde
    2     2       0        0        2      faulty removed
    3     3       8       48        3      active sync   /dev/sdd
/dev/sdd:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 7a546254:db5399b5:208c7c81:db418059
   Creation Time : Fri Feb 11 16:09:34 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 126

     Update Time : Mon Jun  9 03:29:24 2014
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : ffdf923 - correct
          Events : 12628

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       80        2      active sync   /dev/sdf

    0     0       8       96        0      active sync   /dev/sdg
    1     1       8       64        1      active sync   /dev/sde
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       48        3      active sync   /dev/sdd
/dev/sde:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 7a546254:db5399b5:208c7c81:db418059
   Creation Time : Fri Feb 11 16:09:34 2011
      Raid Level : raid5
   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
      Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 126

     Update Time : Mon Jun  9 03:29:24 2014
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : ffdf92f - correct
          Events : 12628

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8       96        0      active sync   /dev/sdg

    0     0       8       96        0      active sync   /dev/sdg
    1     1       8       64        1      active sync   /dev/sde
    2     2       8       80        2      active sync   /dev/sdf
    3     3       8       48        3      active sync   /dev/sdd


On 06/17/2014 09:19 AM, Henry Golas wrote:
> Hello All,
>
> Checking to see if this mailing list is still active.
>
> I've got a RAID5 (3+1) array that has failed two drives (yes I know 
> that is bad). I wanted to see what recovery advise is out there.
>
> My action plan was to:
>
> 1) run mdadm --examine /dev/sd[whatever] >> raidoutput.txt
> 2) run manufacture disk diagnostic tools to see if the disks have 
> really failed
> 3) attempt to for assembly of the RAID
> 4) if unsuccessful, go from there.
>
> Running mdadm version v3.2.2
>
> Any insight / advise would be much appreciated,
>
> Thanks,
>
> Hg

