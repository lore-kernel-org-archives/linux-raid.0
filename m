From: Piotr Legiecki <piotrlg@pum.edu.pl>
Subject: Re: RAID10 failed with two disks
Date: Mon, 22 Aug 2011 13:42:54 +0200
Message-ID: <4E5240BE.1050807@pum.edu.pl>
References: <4E5231EE.3010001@pum.edu.pl> <20110822210903.2582bcfd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110822210903.2582bcfd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> mdadm --examine /dev/sda1
>> /dev/sda1:
>>            Magic : a92b4efc
>>          Version : 00.90.00
>>             UUID : fab2336d:71210520:990002ab:4fde9f0c (local to host bez)
>>    Creation Time : Mon Aug 22 10:40:36 2011
>>       Raid Level : raid10
>>    Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>>       Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
>>     Raid Devices : 4
>>    Total Devices : 4
>> Preferred Minor : 4
>>
>>      Update Time : Mon Aug 22 10:40:36 2011
>>            State : clean
>>   Active Devices : 2
>> Working Devices : 2
>>   Failed Devices : 2
>>    Spare Devices : 0
>>         Checksum : d4ba8390 - correct
>>           Events : 1
>>
>>           Layout : near=2, far=1
>>       Chunk Size : 64K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     0       8        1        0      active sync   /dev/sda1
>>
>>     0     0       8        1        0      active sync   /dev/sda1
>>     1     1       8       17        1      active sync   /dev/sdb1
>>     2     2       0        0        2      faulty
>>     3     3       0        0        3      faulty
>>
>> The last two disks (failed ones) are sde1 and sdf1.
>>
>> So do I have any chances to get the array running or it is dead?
> 
> Possible.
> Report "mdadm --examine" of all devices that you believe should be part of
> the array.

/dev/sdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : fab2336d:71210520:990002ab:4fde9f0c (local to host bez)
   Creation Time : Mon Aug 22 10:40:36 2011
      Raid Level : raid10
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 4

     Update Time : Mon Aug 22 10:40:36 2011
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 2
   Spare Devices : 0
        Checksum : d4ba83a2 - correct
          Events : 1

          Layout : near=2, far=1
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       0        0        2      faulty
    3     3       0        0        3      faulty



/dev/sde1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 157a7440:4502f6db:990002ab:4fde9f0c (local to host bez)
   Creation Time : Fri Jun  3 12:18:33 2011
      Raid Level : raid10
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 4

     Update Time : Sat Aug 20 03:06:27 2011
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : c2f848c2 - correct
          Events : 24

          Layout : near=2, far=1
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       65        2      active sync   /dev/sde1
    3     3       8       81        3      active sync   /dev/sdf1

/dev/sdf1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 157a7440:4502f6db:990002ab:4fde9f0c (local to host bez)
   Creation Time : Fri Jun  3 12:18:33 2011
      Raid Level : raid10
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 4

     Update Time : Sat Aug 20 03:06:27 2011
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : c2f848d4 - correct
          Events : 24

          Layout : near=2, far=1
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       81        3      active sync   /dev/sdf1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       65        2      active sync   /dev/sde1
    3     3       8       81        3      active sync   /dev/sdf1


smartd reported the sde and sdf disks are failed, but after rebooting it 
does not complain anymore.

You say adjacent disks must be healthy for RAID10. So in my situation I 
have adjacent disks dead (sde and sdf). It does not look good.

And does layout (near, far etc) influence on this rule: adjacent disk 
must be healthy?


Regards
P.
