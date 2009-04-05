From: Miles Fidelman <mfidelman@traversetechnologies.com>
Subject: Re: rebuilding raided root partition
Date: Sun, 05 Apr 2009 09:31:31 -0400
Message-ID: <49D8B2B3.7050903@traversetechnologies.com>
References: <49D81804.6070102@traversetechnologies.com> <871vs7h9pe.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871vs7h9pe.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Miles Fidelman <mfidelman@traversetechnologies.com> writes:
>
>
> my root partition is raided, and is now running only on its single
> spare drive:
>
> -----
> server1:~# more /proc/mdstat   md2 : inactive sdd3[0] sdb3[2]
>     195318016 blocks
>
> server1:~# mdadm --detail /dev/md2  [details omitted]
> /dev/md2:
>    Raid Level : raid1
>   Device Size : 97659008 (93.13 GiB 100.00 GB)
>  Raid Devices : 2
> Total Devices : 2
> Preferred Minor : 2
>   Persistence : Superblock is persistent
>
>        State : active, degraded
> Active Devices : 0
> Working Devices : 2
> Failed Devices : 0
> Spare Devices : 2
>
>   Number   Major   Minor   RaidDevice State
>      0       8       51        0      spare rebuilding   /dev/sdd3
>      1       0        0        -      removed
>
>      2       8       19        -      spare   /dev/sdb3
>   
>
> You have 0 active devices and only spare devices. So there is nothing
> to rebuild from. Looks like on top of your one drive failing you also
> have a second drive that failed in that array or wasn't added to the
> raid. Or the raid was running degraded before your drive failure.
>   
> It is not running, it is inactive. There is nothing left to run.
>   
That really is my question here... I've replaced the bad drive, and I'd 
like to have it come up and resync - which would give me an array that 
contains the replaced drive and the spare.  I'm not sure why it's not 
happening.
>   
>> so..... on to questions:
>>
>> 1. What's going on?
>>
>> 2. Any suggestions on how to reassemble the array?  mdadm --assemble
>> /dev/md2 tells me I need to deactivate the device, but then, it's my /
>> volume - which leaves me a little stumped
>>     
>
> Ar you sure your / is actualy /dev/md2? Maybe you booted from
> /dev/sda3 or /dev/sdc3? I recommend booting a rescue/life CD and
> then look for a partition containing an active drive for md2 so you
> can rebuild your raid.
>   
pretty sure - there's a physical LVM volume defined on top of /dev/md2, 
and / is a LV defined on top of that - the machine comes up and runs
> Also did you know that you can run a raid1 with 3 active drives? That
> way you are potected against 2 drive failures and don't need to wait
> for the spare drive to resync before having fault tolerance if one
> drive fails.
>
>   
Can you elaborate on how to do that, particularly how to add a new 
active volume to an existing array?  It seems like mdadm wants to add 
new disks as spares.

Thanks,

Miles

