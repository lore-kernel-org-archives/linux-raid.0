From: Geoff Attwater <geoffwater@gmail.com>
Subject: Re: mystified by behaviour of mdadm raid5 -> raid0 conversion
Date: Sun, 11 Nov 2012 00:00:40 +1100
Message-ID: <CAH4NvfnzDzWjJM0rs=WkaB9MB1X6McYhVKWOffP7L+tam4j4FA@mail.gmail.com>
References: <CAH4Nvfn6Ek50DEqFr_hWrpeK9qrBqrGsfsG9ULmLTReJSpGWSw@mail.gmail.com>
	<20121108090035.324782ee@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121108090035.324782ee@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the speedy and informative reply. The fail, remove, echo
raid0 > /sys/block/md0/md/level worked perfectly to turn the
parity-last raid5 into raid0 (the parity disk *was* /dev/sdb, as the
array was built in that order in the first place). By this time I had
already concluded that raid10 was kind of nuts for my purposes anyway,
as raid6 is more resilient and easier to resize and I don't need
speed. So I converted it straight back to raid5, then raid6 and all of
that was easy and went fine.

I did notice however, that mdadm doesn't quite seem to convert raid0
-> raid10 as I expected either. I didn't try too hard then as I'd
already thought better of it, but I did some tests in a VM just now.

Taking a raid0 with disks /dev/vda and /dev/vdb ,
running mdadm /dev/md0 --grow --level=10 --add /dev/vdc /dev/vdd
states: "mdadm: Need 2 spares to create working array, and only have 0."
running mdadm /dev/md0 --grow --level=10
(which hypothetically one might expect to promote it to an array with
two missing drives, if it worked)
gives: "mdadm: can only add devices to linear arrays"

There seems to be a chicken-and-egg problem where raid0 arrays can't
have spares (as they can never be useful in normal usage), but mdadm
doesn't want to flip the mode until it has extra disks to work with.
The man page does seem to imply that this should work.

However, running
echo raid10 > /sys/block/md0/md/level
by analogy with before actually did mutate the array into one with two
missing devices,
mdadm --add /dev/vdc /dev/vdd
worked fine to then extend it.

I'm not very familiar with the whole mdadm system, so I might just be
using it wrong. But perhaps the raid0 -> raid10 path has an issue
also?

A third possible issue I noted before, but it might have been lost in
the middle of my last rambling message as I mentioned anything I
thought could possible relate is:
The grow sometimes requires a stripe_cache_size boost to function
properly, and reports "mdadm: failed to set raid disks" which is kind
of confusing unless you check the dmesg.

Anyway, it seems to me that a direct conversion to raid6 is a great
deal saner than what I was trying to do anyway, so all of this is
probably the kind of thing that only gets tested because some newbie
is trying to do weird things that don't make much sense.

Thanks again for clearing this up, and I must say, I'm impressed by md
and all the mutations this array has undergone, online, without losing
any data even if it got stuck. It's really nifty.

- Geoff.

On Thu, Nov 8, 2012 at 9:00 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 7 Nov 2012 22:47:20 +1100 Geoff Attwater <geoffwater@gmail.com> wrote:
>
>> I have a relatively unimportant home fileserver that uses an mdadm
>> raid5 across three 1TB partitions (on separate disks - one is 1.5 TB
>> and has another 500GB partitition for other stuff). I wish to convert
>> it to raid10 across 4 1TB partitions by adding a fresh drive.
>>
>> The mdadm man page, section *Grow Mode* states that it may
>>
>> "convert between RAID1 and RAID5, between RAID5 and RAID6, between
>> RAID0, RAID4, and RAID5, and between RAID0 and RAID10 (in the near-2
>> mode)."
>>
>> Conversion between RAID5 and RAID10 directly is not supported (mdadm
>> tells you so if you try it).
>> So my plan was to do a three stage conversion:
>>
>>  1. back everything up
>>  2. convert from 3-disk raid5 -> 2-disk raid0 (now with no redundancy,
>>  but it's backed up, so that's ok)
>>  3. convert the 2-disk raid0 -> 4-disk raid10
>>
>> All of these have the same logical size (2TB). This is on an Ubuntu
>> 12.10 system.
>> mdadm --version reports:
>> mdadm - v3.2.5 - 18th May 2012
>> uname -a reports:
>> Linux penguin 3.5.0-18-generic #29-Ubuntu SMP Fri Oct 19 10:26:51 UTC
>> 2012 x86_64 x86_64 x86_64 GNU/Linux
>>
>> I searched around to see if anyone had followed this kind of procedure
>> before, but didn't find anything directly addressing exactly what I
>> was trying to do (I saw much more about raid0 -> raid5 type
>> conversions, while adding a device and the like and nothing much on
>> going the other way), so I proceeded based on what I understood from
>> the man page and other general stuff on mdadm raid reshaping I read.
>>
>> for stage 2, I used the command
>>
>>     mdadm --grow /dev/md0 --level=raid0 --raid-devices=2
>> --backup-file=/media/newdisk/raid_to_0_backup
>>
>> where the backup-file is on another disk not in the array. I put the
>> --raid-devices=2 in to make it clear that what I was after was 2x1TB
>> disks in RAID0 and one spare (the same logical size), rather than a
>> larger logical size 3TB three-disk RAID0. Although based on Neil
>> Brown's blog post at http://neil.brown.name/blog/20090817000931 it
>> seems the conversion should generally operate by reshuffling things
>> into an equal-logical size array anyway, so that perhaps wasn't
>> necessary.
>>
>> This began a lengthy rebuild process that has now finished. However,
>> at the end of the process, after no visible error messages and
>> obviously a lot of data movement seen via iostat, `mdadm --detail
>> /dev/md0` showed the array as *still raid5* with all disks used, and
>> the dmesg output contained these relevant lines:
>>
>>     [93874.341429] md: reshape of RAID array md0
>>     [93874.341435] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>>     [93874.341437] md: using maximum available idle IO bandwidth (but
>> not more than 200000 KB/sec) for reshape.
>>     [93874.341442] md: using 128k window, over a total of 976630272k.
>>     === snip misc unrelated stuff  ===
>>     [183629.064361] md: md0: reshape done.
>>     [183629.072722] RAID conf printout:
>>     [183629.072732]  --- level:5 rd:3 wd:3
>>     [183629.072738]  disk 0, o:1, dev:sda1
>>     [183629.072742]  disk 1, o:1, dev:sdc1
>>     [183629.072746]  disk 2, o:1, dev:sdb1
>>     [183629.088584] md/raid0:md0: raid5 must be degraded! Degraded disks: 0
>>     [183629.091657] md: md0: raid0 would not accept array
>
> These last two are the interesting messages.
> The raid0 module in the kernel will only access a raid5 for conversion if it
> is in 'parity-last' layout, and is degraded.  But it isn't.
>
> mdadm should fail and remove the 'parity' disk before trying to convert to
> raid0, but it doesn't.
> I guess I never tested it - and untested code is buggy code!
>
> You could be able to finish the task manually.
>  - fail the last (parity) device
>  - remove that device
>  - echo raid0 > /sys/block/md0/md/level
>
> So:
>   mdadm /dev/md0 -f /dev/sdb1
>   mdadm /dev/md0 -r /dev/sdb1
>   echo raid0 > /sys/block/md0/md/level
>
> However you should double-check that 'sdb1' is the correct device.  Look in
> the output of 'mdadm -D' and see what raid device number '2' is.
>
> I'll add this to my list of things to fix.
>
> Thanks,
>
> NeilBrown
>
