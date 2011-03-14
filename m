From: mtice <mjtice@gmail.com>
Subject: Re: Removed two drives (still valid and working) from raid-5 and need to add them back in.
Date: Sun, 13 Mar 2011 18:14:59 -0600
Message-ID: <5EB70557-47EB-4F81-A158-4A5157EB7E37@gmail.com>
References: <837074B9-F2A5-471B-BAD1-6A92249095FB@gmail.com> <31419C89-14D6-405F-B838-C7E040C8FA43@gmail.com> <4D7C3968.700@turmel.org> <05223FC6-A8D4-4A5D-9CF4-27998B9ADD3F@gmail.com> <4D7C4083.2010000@turmel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D7C4083.2010000@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 12, 2011, at 8:56 PM, Phil Turmel wrote:

> On 03/12/2011 10:38 PM, mtice wrote:
>> Hi Phil, thanks for the reply.
>> Here is the output of mdadm -E /dev/sd[cdef] 
>> 
>> /dev/sdc:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
>>  Creation Time : Thu May 27 15:35:56 2010
>>     Raid Level : raid5
>>  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>>   Raid Devices : 4
>>  Total Devices : 5
>> Preferred Minor : 0
>> 
>>    Update Time : Fri Mar 11 15:53:35 2011
>>          State : clean
>> Active Devices : 2
>> Working Devices : 4
>> Failed Devices : 2
>>  Spare Devices : 2
>>       Checksum : 3d3b86 - correct
>>         Events : 43200
>> 
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>> 
>>      Number   Major   Minor   RaidDevice State
>> this     3       8       32        3      active sync   /dev/sdc
>> 
>>   0     0       8       80        0      active sync   /dev/sdf
>>   1     1       0        0        1      faulty removed
>>   2     2       0        0        2      faulty removed
>>   3     3       8       32        3      active sync   /dev/sdc
>>   4     4       8       64        4      spare   /dev/sde
>>   5     5       8      112        5      spare
>> /dev/sdd:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
>>  Creation Time : Thu May 27 15:35:56 2010
>>     Raid Level : raid5
>>  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>>   Raid Devices : 4
>>  Total Devices : 5
>> Preferred Minor : 0
>> 
>>    Update Time : Fri Mar 11 15:53:35 2011
>>          State : clean
>> Active Devices : 2
>> Working Devices : 4
>> Failed Devices : 2
>>  Spare Devices : 2
>>       Checksum : 3d3bd4 - correct
>>         Events : 43200
>> 
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>> 
>>      Number   Major   Minor   RaidDevice State
>> this     5       8      112        5      spare
>> 
>>   0     0       8       80        0      active sync   /dev/sdf
>>   1     1       0        0        1      faulty removed
>>   2     2       0        0        2      faulty removed
>>   3     3       8       32        3      active sync   /dev/sdc
>>   4     4       8       64        4      spare   /dev/sde
>>   5     5       8      112        5      spare
>> /dev/sde:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
>>  Creation Time : Thu May 27 15:35:56 2010
>>     Raid Level : raid5
>>  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>>   Raid Devices : 4
>>  Total Devices : 5
>> Preferred Minor : 0
>> 
>>    Update Time : Fri Mar 11 15:53:35 2011
>>          State : clean
>> Active Devices : 2
>> Working Devices : 4
>> Failed Devices : 2
>>  Spare Devices : 2
>>       Checksum : 3d3ba2 - correct
>>         Events : 43200
>> 
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>> 
>>      Number   Major   Minor   RaidDevice State
>> this     4       8       64        4      spare   /dev/sde
>> 
>>   0     0       8       80        0      active sync   /dev/sdf
>>   1     1       0        0        1      faulty removed
>>   2     2       0        0        2      faulty removed
>>   3     3       8       32        3      active sync   /dev/sdc
>>   4     4       8       64        4      spare   /dev/sde
>>   5     5       8      112        5      spare
>> /dev/sdf:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 11c1cdd8:60ec9a90:2e29483d:f114274d (local to host storage)
>>  Creation Time : Thu May 27 15:35:56 2010
>>     Raid Level : raid5
>>  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>>   Raid Devices : 4
>>  Total Devices : 5
>> Preferred Minor : 0
>> 
>>    Update Time : Fri Mar 11 15:53:35 2011
>>          State : clean
>> Active Devices : 2
>> Working Devices : 4
>> Failed Devices : 2
>>  Spare Devices : 2
>>       Checksum : 3d3bb0 - correct
>>         Events : 43200
>> 
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>> 
>>      Number   Major   Minor   RaidDevice State
>> this     0       8       80        0      active sync   /dev/sdf
>> 
>>   0     0       8       80        0      active sync   /dev/sdf
>>   1     1       0        0        1      faulty removed
>>   2     2       0        0        2      faulty removed
>>   3     3       8       32        3      active sync   /dev/sdc
>>   4     4       8       64        4      spare   /dev/sde
>>   5     5       8      112        5      spare
>> 
>> 
>> I ran mdadm --assemble --force /dev/md0 but it erred with:
>> 
>> mdadm: device /dev/md0 already active - cannot assemble it
> 
> You would have to stop the array first.  But it won't matter.  The dropped devices don't remember their role.  But you have a 50-50 chance of getting it right.  It's either:
> 
> mdadm --create /dev/md0 --level=5 --raid-devices=4 --assume-clean --metadata=0.90 --chunk=64k /dev/sdf /dev/sde /dev/sdd /dev/sdc
> 
> or with /dev/sde and /dev/sdd swapped.
> 
> I suggest you try it both ways, with an "fsck -n" to see which has a consistent filesystem.  Once you figure out which order is correct, do a real fsck to fix up any minor errors from the inadvertent unplug, then mount and grab a fresh backup.
> 
> Let us know how it turns out (I'm about to sign off for the night...).
> 
> Phil

That did it.  Thanks, Phil!

I was able to get the drives added back in with:
 mdadm --create /dev/md0 --level=5 --raid-devices=4 --assume-clean --metadata=0.90 --chunk=64 /dev/sdf /dev/sde /dev/sdd /dev/sdc

An fsck -n came back clean so I ran another fsck and mounted it up and all looks good.

Thanks for your help!

Matt 

