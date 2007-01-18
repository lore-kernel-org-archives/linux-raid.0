From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: bad performance on RAID 5
Date: Thu, 18 Jan 2007 18:10:42 -0500
Message-ID: <45AFFE72.8070709@tmr.com>
References: <45AE9640.1040500@start.no> <45AFBC85.8020500@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45AFBC85.8020500@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Sevrin Robstad <quackyo@start.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

) Steve Cousins wrote:
> Sevrin Robstad wrote:
>> I'm suffering from bad performance on my RAID5.
>>
>> a "echo check >/sys/block/md0/md/sync_action"
>>
>> gives a speed at only about 5000K/sec , and HIGH load average :
>
> What do you get when you try something like:
>
> time dd if=/dev/zero of=/mount-point/test.dat bs=1024k count=1024
That doesn't give valid (repeatable) results due to caching issues. Go 
back to the thread I started on RAID-5 write, and see my results. More 
important, the way I got rid of the cache effects (beside an unloaded 
systems) was:
  sync; time bash -c "dd if=/dev/zero bs=1024k count=2048 
of=/mnt/point/file; sync"
I empty the cache, then time the dd including the sync at the end. 
Results are far more repeatable.

I actually was able to create custom arrays on unused devices to play 
with array setting, once you use the array you can't tune as much.
>
> where /mount-point is where /dev/md0 is mounted.
>
> This will create a 1 GiB file and it will tell you how long it takes 
> to create it.  Also, I'd try running Bonnie++ on it to see what the 
> different performance values are.
>
> I don't know a lot about the md sync process but I remember having my 
> sync action stuck at a low value at one point and it didn't have 
> anything to do with the performance of the RAID array in general.
>
> Steve
>
>> # uptime
>> 20:03:55 up 8 days, 19:55,  1 user,  load average: 11.70, 4.04, 1.52
>>
>> kernel is 2.6.18.1.2257.fc5
>> mdadm is v2.5.5
>>
>> the system consist of an athlon XP1,2GHz and two Sil3114 4port S-ATA 
>> PCI cards with a total of 6  250gb S-ATA drives connected.
>>
>> [root@compaq ~]# mdadm --detail /dev/md0
>> /dev/md0:
>>        Version : 00.90.03
>>  Creation Time : Tue Dec  5 00:33:01 2006
>>     Raid Level : raid5
>>     Array Size : 1218931200 (1162.46 GiB 1248.19 GB)
>>    Device Size : 243786240 (232.49 GiB 249.64 GB)
>>   Raid Devices : 6
>>  Total Devices : 6
>> Preferred Minor : 0
>>    Persistence : Superblock is persistent
>>
>>    Update Time : Wed Jan 17 23:14:39 2007
>>          State : clean
>> Active Devices : 6
>> Working Devices : 6
>> Failed Devices : 0
>>  Spare Devices : 0
>>
>>         Layout : left-symmetric
>>     Chunk Size : 256K
>>
>>           UUID : 27dce477:6f45d11b:77377d08:732fa0e6
>>         Events : 0.58
>>
>>    Number   Major   Minor   RaidDevice State
>>       0       8        1        0      active sync   /dev/sda1
>>       1       8       17        1      active sync   /dev/sdb1
>>       2       8       33        2      active sync   /dev/sdc1
>>       3       8       49        3      active sync   /dev/sdd1
>>       4       8       65        4      active sync   /dev/sde1
>>       5       8       81        5      active sync   /dev/sdf1
>> [root@compaq ~]#
>>
>>
>> Sevrin 

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

