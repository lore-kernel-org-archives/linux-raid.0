From: Danilo Godec <danilo.godec@agenda.si>
Subject: Re: MD RAID1 weirdness *SOLVED*
Date: Fri, 18 Nov 2011 09:06:06 +0100
Message-ID: <4EC611EE.6070402@agenda.si>
References: <4EC60D1A.5030808@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EC60D1A.5030808@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


While I couldn't find out how or why this happened, I did find the way 
to 'repair':

> |mdadm --grow -n X /dev/md1|

Where 'X'  is the actual number of devices in my array.

    Regards, Danilo







On 11/18/2011 08:45 AM, Danilo Godec wrote:
> I have three hard drives in my machine and on installation, I 
> configured two 3-partition RAID1 arrays for /boot and /. The third 
> array is a RAID3 and this one is OK.
>
> Somehow both RAID1 arrays are now 'degraded' with three devices active 
> and one 'removed':
>
>> /dev/md0:
>>         Version : 1.0
>>   Creation Time : Mon May 23 11:33:58 2011
>>      Raid Level : raid1
>>      Array Size : 530100 (517.76 MiB 542.82 MB)
>>   Used Dev Size : 530100 (517.76 MiB 542.82 MB)
>>    Raid Devices : 4
>>   Total Devices : 3
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Fri Nov 18 08:36:11 2011
>>           State : active, degraded
>>  Active Devices : 3
>> Working Devices : 3
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>            Name : linux:0
>>            UUID : be28253b:04ef7513:53ddc8e4:4417a480
>>          Events : 751
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       33        0      active sync   /dev/sdc1
>>        1       0        0        1      removed
>>        2       8        1        2      active sync   /dev/sda1
>>        3       8       17        3      active sync   /dev/sdb1
>
>> /dev/md2:
>>         Version : 1.0
>>   Creation Time : Mon May 23 11:34:06 2011
>>      Raid Level : raid1
>>      Array Size : 41945640 (40.00 GiB 42.95 GB)
>>   Used Dev Size : 41945640 (40.00 GiB 42.95 GB)
>>    Raid Devices : 4
>>   Total Devices : 3
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Fri Nov 18 08:43:32 2011
>>           State : active, degraded
>>  Active Devices : 3
>> Working Devices : 3
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>            Name : linux:2
>>            UUID : 3889bec9:12aa98b3:81df75b8:c87832bc
>>          Events : 66961
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       35        0      active sync   /dev/sdc3
>>        1       0        0        1      removed
>>        2       8        3        2      active sync   /dev/sda3
>>        3       8       19        3      active sync   /dev/sdb3
>
> Can this be resolved without re-creating the array?
>
>
>   Danilo

