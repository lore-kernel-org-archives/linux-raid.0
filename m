From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size, why?
Date: Thu, 27 Mar 2014 16:23:09 +0100
Message-ID: <5334425D.5010704@fastmail.fm>
References: <tencent_66C345191B9B49B92956F243@qq.com> <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se> <loom.20140326T205013-837@post.gmane.org> <53334347.4050108@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53334347.4050108@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Tide <lovetide@qq.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/26/2014 10:14 PM, Stan Hoeppner wrote:
> On 3/26/2014 3:00 PM, Tide wrote:
> ...
>> =================
>> Array 2 (RAID 6):
>> =================
>> # mdadm --examine /dev/sdb1
> ...
>>       Raid Level : raid6
>>     Raid Devices : 5
> ...
>>    Bad Block Log : 512 entries available at offset 72 sectors
>
> The RAID6 array has sectors on each drive reserved for bad block
> reassignment.  The RAID5 array does not.
>
> This is the answer to your mystery.

Commits and code do not confirm this assumption.

>         __u16   bblog_size;     /* number of sectors reserved for badblocklist */

...

>                 printf("  Bad Block Log : %d entries available at offset %ld sectors",
>                        __le16_to_cpu(sb->bblog_size)*512/8,


So 512 bad-block-log entries only need 8 sectors and that would still 
fit into the data offset of 2048 bytes (array 1). The 
write-intent-bitmap is also not that big. But this commit log gives the 
correct answer

> commit 508a7f16b242d6c3353e15aab46ac8ca8dc7cd08
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Apr 4 14:00:40 2012 +1000
>
>     super1: leave more space in front of data by default.
>
>     The kernel is growing the ability to avoid the need for a
>     backup file during reshape by being able to change the data offset.
>
>     For this to be useful we need plenty of free space before the
>     data so the data offset can be reduced.
>
>     So for v1.1 and v1.2 metadata make the default data_offset much
>     larger.  Aim for 128Meg, but keep a power of 2 and don't use more
>     than 0.1% of each device.
>
>     Don't change v1.0 as that is used when the data_offset is required to
>     be zero.



Bernd

