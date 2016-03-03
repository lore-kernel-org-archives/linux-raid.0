From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Thu, 3 Mar 2016 11:37:37 +0000
Message-ID: <CAOS+5GGB5gVSFJbYwwJu+z0C0oyYPzsLRhnjD6FkmLEWFFquFA@mail.gmail.com>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
	<56D6E883.50801@youngman.org.uk>
	<CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
	<CAOS+5GEfQ2p0xguguKC3uXW8GYBDCxt2vk=-Ci6+nTKwkcWtdQ@mail.gmail.com>
	<CAOS+5GGX8QBo3=s+Mcj=Kd6VSmZyatfZ30NXBy8E=4WJE6z0sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GGX8QBo3=s+Mcj=Kd6VSmZyatfZ30NXBy8E=4WJE6z0sA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just to add a bit more to this.....

It looks like the backup file is just full of EOLs (I haven't looked
at it with a bit editor admittedly).

So I'm absolutely stuck now and would really appreciate some help.

I'd even be happy to just bring the array up in readonly mode and
transfer the data off, but it will NOT let me reassemble the array
without the 'need data backup file to finish reshape, sorry' error and
will not reassemble.

Anyone?

On 2 March 2016 at 15:59, Another Sillyname <anothersname@googlemail.com> wrote:
> I've found out more info....and now have a theory.......but do not
> know how best to proceed.
>
>>sudo mdadm -A --scan --verbose
>
> mdadm: looking for devices for further assembly
> mdadm: No super block found on /dev/sdh (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdh
> mdadm: No super block found on /dev/sdg (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdg
> mdadm: No super block found on /dev/sdf (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdf
> mdadm: No super block found on /dev/sde (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sde
> mdadm: No super block found on /dev/sdd (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdd
> mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdc
> mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sdb
> mdadm: No super block found on /dev/sda6 (Expected magic a92b4efc, got 00000000)
> mdadm: no RAID superblock on /dev/sda6
> mdadm: No super block found on /dev/sda5 (Expected magic a92b4efc, got 75412023)
> mdadm: no RAID superblock on /dev/sda5
> mdadm: /dev/sda4 is too small for md: size is 2 sectors.
> mdadm: no RAID superblock on /dev/sda4
> mdadm: No super block found on /dev/sda3 (Expected magic a92b4efc, got 00000401)
> mdadm: no RAID superblock on /dev/sda3
> mdadm: No super block found on /dev/sda2 (Expected magic a92b4efc, got 00000401)
> mdadm: no RAID superblock on /dev/sda2
> mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 0000007e)
> mdadm: no RAID superblock on /dev/sda1
> mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got e71e974a)
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sdh1 is identified as a member of /dev/md/server187:1, slot 5.
> mdadm: /dev/sdg1 is identified as a member of /dev/md/server187:1, slot 0.
> mdadm: /dev/sdf1 is identified as a member of /dev/md/server187:1, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md/server187:1, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md/server187:1, slot 6.
> mdadm: /dev/sdc1 is identified as a member of /dev/md/server187:1, slot 1.
> mdadm: /dev/sdb1 is identified as a member of /dev/md/server187:1, slot 4.
> mdadm: /dev/md/server187:1 has an active reshape - checking if
> critical section needs to be restored
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
>        Possibly you needed to specify the --backup-file
> mdadm: looking for devices for further assembly
> mdadm: No arrays found in config file or automatically
>
> As I stated in my original posting I do not know where the server187
> stuff came from when I tried the original assemble and two of the
> drives (sdg & sdh) reported as busy.
>
> So my theory is this......
>
> This 30TB array has been up and active since about August 2015, fully
> functional without any major issues, except performance was sometimes
> a bit iffy.
>
> It is possible that drives sdg and sdh were used in a temporary box in
> a different array that was only active for about 10 days, before they
> were moved to the new 30TB array that was cleanly built.  That array
> may well have been called server187 (it was a temp box so no reason to
> remember it).
>
> When the reshape of the current array 'died' during initialisation or
> immediately thereafter, even though cat /proc/mdstat showed the
> reshape active after 12 hours it was still stuck on 0.0%.
>
> When the machine was rebooted and the array didn't come up...is it
> possible that drives sdh and sdg still thought they were in the old
> server187 array and that is why they reported themselves busy?  I'm
> not sure why this would happen, but am just theorising.
>
> When I tried the assemble command where it reported it was merging
> with the already existing server187 array, even though there
> wasn't/isn't a server187 array as prior to that assemble cat
> /proc/mdstat reported the offline md127 array.
>
> Somehow therefore the array names have got confused/transposed and
> that's why the backup file is now not seen as the correct one?  This
> would seem to be borne out by all the drives now seeing themselves as
> part of server187 array rather then md127 array and also the reshape
> seems to be attached to this server187 array.
>
> I still believe/hope the data is all still intact and complete,
> however I am averse to just hacking around using google to 'try
> commands' hoping I hit a solution before someone with much more
> experience casts an eye over this to give me a little guidance.
>
> Help!!
>
>
>
> On 2 March 2016 at 13:42, Another Sillyname <anothersname@googlemail.com> wrote:
>> Kernel is latest Fedora x86_64 4.3.5-300, can't get too much newer
>> then that (latest is 4.4.x), mdadm is 3.3.4-2.
>>
>> I agree that the data is likely still intact, doesn't stop me being
>> nervous till I see it though!!
>>
>>
>>
>> On 2 March 2016 at 13:20, Wols Lists <antlists@youngman.org.uk> wrote:
>>> On 02/03/16 03:46, Another Sillyname wrote:
>>>> Any help and guidance would be appreciated, the drives showing clean
>>>> gives me comfort that the data is likely intact and complete (crossed
>>>> fingers) however I can't re-assemble the array as I keep getting the
>>>> 'critical information for reshape, sorry' warning.
>>>>
>>>> Help???
>>>
>>> Someone else will chip in what to do, but this doesn't seem alarming at
>>> all. Reshapes stuck at zero is a recent bug, but all the data is
>>> probably safe and sound.
>>>
>>> Wait for one of the experts to chip in what to do, but you might find
>>> mdadm --resume --invalid-backup will get it going again.
>>>
>>> Otherwise it's likely to be an "upgrade your kernel and mdadm" job ...
>>>
>>> Cheers,
>>> Wol
