From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID6 Reshape Gone Awry
Date: Fri, 03 Aug 2012 15:37:36 +0200
Message-ID: <501BD420.10203@hesbynett.no>
References: <8C493F417CC49C6619BBAF45@ryoohko.kodachi.com> <501BB374.9020607@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501BB374.9020607@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Flynn <flynn@kodachi.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/08/2012 13:18, Stan Hoeppner wrote:
> On 8/3/2012 12:27 AM, Flynn wrote:
>
>> My RAID6 is actually a little bit odd in that the drives are split into
>> 10 partitions.  All the partition 5's are a RAID6; all the partition 6's
>> are a RAID6; etc.
>
> md offered the ability, so you _could_ create such a monstrosity.  But
> you never bothered to consider if you _should_
>
> The primary function of RAID is to protect your data in the event of a
> _disk_ failure.  Creating multiple arrays from _partitions_ on the same
> set of physical disks does nothing to protect one from disk failure.
>

That's not how I understand the disk layout - if I'm right, it is still 
a monstrosity, but one that will offer protection on disk failure.

As I read it, he has this (prior to adding the new disk):

md0 = raid6(sda5, sdb5, sdc5, sdd5, sde5)
md1 = raid6(sda6, sdb6, sdc6, sdd6, sde6)
...
md9 = raid6(sda14, sdb14, sdc14, sdd14, sde14)

If that's the case, then it will be an administrative mess (as the OP is 
now experiencing), but it will protect the data, and if the LVM is a 
linear concatenation of these then performance normally will be okay. 
Of course, if the LVM tries to use a stripe of these arrays, it will be 
terrible - and rebuild/reshape will involve massively inefficient head 
movement (as you noted).

> What it can do is cause massive problems for the elevator when you try
> to reshape 10 arrays simultaneously, which just happen to reside on the
> same set of disks.  By doing this you force the heads on the drives into
> a massive random seek pattern, bumping all over the platters, top to
> bottom.  This is likely what caused, or is directly related to, your crash.
>
>> Suggestions very welcome.
>
> Backup what you need to external storage.  Blow the entire mess away.
> Start over from scratch, and build a single RAID6 array, as you should
> have in the first place.

If the OP can manage it, then I agree.

>
> md allows the use of partitions, but not so you can create 50 arrays on
> the same set of disks, shooting yourself in the foot.  Similarly, most
> cars can travel at velocities over 120 mph, but most people have enough
> sense not to attempt driving that fast.

I have sometimes used multiple arrays like this:

md0 = raid1,n4(sda1, sdb1, sdc1, sdd1) for /boot (makes grub happy)
md1 = raid5(sda2, sdb2, sdc2, sdd2) for everything else

But this particular setup seems very odd to me - I would love to know 
the reasoning behind it.

>
> Learn the difference between "Can I?" and "Should I?".  You never
> bothered to consider the latter when you built this.  Please consider it
> now, for your sake.
>

