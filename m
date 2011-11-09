From: William Colls <william.colls@rogers.com>
Subject: Re: Raid Problem - Unknown File System Type
Date: Wed, 09 Nov 2011 12:12:28 -0500
Message-ID: <4EBAB47C.5070002@rogers.com>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111109163933.GA26630@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/09/2011 11:39 AM, Robin Hill wrote:
> On Wed Nov 09, 2011 at 11:12:59AM -0500, William Colls wrote:
>
>>
>> Environment
>>
>> Kubuntu Linux 10.04.3 LTS
>> mdadm 2.6.7.1-1ubuntu15
>>
>> I have two identical disks that were in a raid configuration in another
>> machine (also running 10.04). I removed them from the old machine,
>> mounted them in a new machine, booted up, and at a terminal prompt as
>> root issued
>>
>> mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
>>
> You should have just assembled them. You've now created a new array
> instead of just assembling the old one.

I thought, at the time, that I needed to do the create so that the 
/dev/md0 device would be created properly (new machine had no raid before).

>
>> The configuration in the old machine was raid 1.
>>
>> I checked the contents of /proc/mdstat and it confirmed that md0 was
>> indeed running, with 2 devices, as expected. But it also said it was
>> resyncing the disks, which I didn't expect.
>>
>> When the reync completed, I was unable to mount /dev/md0p1. Specifying
>> -t ext3 in the mount command gives the error message "wrong fs, bad
>> option, bad superblock on /dev/md0p1". Trying mount with no -t gives the
>> error "unknown file type linux_raid_member". Looking at the disks with
>> Gparted, confims that the system sees the disks, but the filesystem
>> shows as unknown.
>>
> It would look like the old array was either created with an older mdadm
> version (with different defaults) or used some non-default parameter
> values.
>
>> The output from mdamd --detail /dev/sdb
>>
>> /dev/sdb:
>>             Magic : a92b4efc
>>           Version : 00.90.00
>>              UUID : 1443e74d:f63f16ab:d527ef8c:7225e0b0
>>     Creation Time : Tue Nov  8 13:14:48 2011
>>        Raid Level : raid1
>>     Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>        Array Size : 732574464 (698.64 GiB 750.16 GB)
>>      Raid Devices : 2
>>     Total Devices : 2
>> Preferred Minor : 0
>>
>>       Update Time : Tue Nov  8 16:05:42 2011
>>             State : clean
>>    Active Devices : 2
>> Working Devices : 2
>>    Failed Devices : 0
>>     Spare Devices : 0
>>          Checksum : c4195c85 - correct
>>            Events : 34
>>
>>
>>         Number   Major   Minor   RaidDevice State
>> this     0       8       16        0      active sync   /dev/sdb
>>
>>      0     0       8       16        0      active sync   /dev/sdb
>>      1     1       8       32        1      active sync   /dev/sdc
>>
>> --- end of output
>>
>> Output from mdadm --examine /dev/sdc
>>
>> /dev/sdc:
>>             Magic : a92b4efc
>>           Version : 00.90.00
>>              UUID : 1443e74d:f63f16ab:d527ef8c:7225e0b0
>>     Creation Time : Tue Nov  8 13:14:48 2011
>>        Raid Level : raid1
>>     Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>        Array Size : 732574464 (698.64 GiB 750.16 GB)
>>      Raid Devices : 2
>>     Total Devices : 2
>> Preferred Minor : 0
>>
>>       Update Time : Tue Nov  8 16:05:42 2011
>>             State : clean
>>    Active Devices : 2
>> Working Devices : 2
>>    Failed Devices : 0
>>     Spare Devices : 0
>>          Checksum : c4195c97 - correct
>>            Events : 34
>>
>>
>>         Number   Major   Minor   RaidDevice State
>> this     1       8       32        1      active sync   /dev/sdc
>>
>>      0     0       8       16        0      active sync   /dev/sdb
>>      1     1       8       32        1      active sync   /dev/sdc
>>
>> ---- end of output
>>
>> So - am I truly up the creek without a paddle? Is there any way to
>> recover this array? I have backups of most of it, but it will take a
>> while to find and restore. And for sure something will be lost.
>>
>
> Certainly most of the data should be there still. I don't suppose you
> have a copy of the mdadm --examine output from the old system at all?

No output from the original setup.

>
> Cheers,
>      Robin


-- 
I know you believe that you understand what you think I said, but I am 
not sure that you realize that what you heard was not what I ment.
