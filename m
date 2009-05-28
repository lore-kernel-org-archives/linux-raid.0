From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Thu, 28 May 2009 21:07:23 +0200
Message-ID: <87octdyrkk.fsf@frosties.localdomain>
References: <1241300764.5607.36.camel@raz>
	<e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
	<18965.16276.485692.812516@notabene.brown>
	<87f94c370905211220n4e686a30ke452a56a2690d22b@mail.gmail.com>
	<87r5ydqsrd.fsf@frosties.localdomain>
	<18971.6239.413944.47540@notabene.brown>
	<87skisnmed.fsf@frosties.localdomain>
	<18971.55231.745810.961324@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18971.55231.745810.961324@notabene.brown> (Neil Brown's message
	of "Tue, 26 May 2009 21:51:27 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Greg Freemyer <greg.freemyer@gmail.com>, Dan Williams <dan.j.williams@intel.com>, raz ben yehuda <raziebe@013.net>, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Tuesday May 26, goswin-v-b@web.de wrote:
>> Neil Brown <neilb@suse.de> writes:
>> 
>> > On Monday May 25, goswin-v-b@web.de wrote:
>> >> That really seems to scream for LVM to support more raid levels. It
>> >> already has linear, raid0 and raid1 support (although I have no idea
>> >> how device mapper raid1 compares to md raid1).
>> >
>> > Note that LVM (a suite of user-space tools) could conceivably use
>> > md/raid1, md/raid5 etc. The functionality doesn't have to go in dm.
>> >
>> > Neil
>> 
>> How would you do this? Worst case you can have a LV made up of totaly
>> non linear PEs, meaning lots of 4MB (default PE size) big chunks in
>> random order on random disks.
>> 
>> Do you create a raid1/5 for each stripe? You surely run out of md
>> devices.
>
> We have 2^21 md devices easily (I think that is the number) and it
> wouldn't be hard to have more if that were an issue.
>
>> 
>> Create dm mappings for all stripe 0s, stripe 1s, stripe 2s, ... and
>> then a raid1/5 over those stripe devices?
>
> That might be an option.
>
>> 
>> What if the LV has segments with different raid configurations (number
>> of disks in a stripe or even different levels)? Create a raid for each
>> segment and then a dm mapping for a linear raid?
>>
>
> Yes.
>  
>> 
>> You can get a flood of intermediate devices there. A /proc/mdstat with
>> 200 entries would be horrible. iostat output would be totaly
>> useless. ...
>>
>
> Yep, these would be interesting problems to solve.  /proc/mdstat is a
> bit of a wart on the design - getting the entry in /proc/mdstat
> optional might be a good idea.

Resyncing in a way that uses parallelism without using a physical
devices twice would also be difficult without merging all those layers
into one or peaking through them. The raid could doesn't see what
physical devices are in a device-mapper device and so on.

Plus I do want ONE entry in /proc/mdstat (or equivalent) to see how a
resync is going. Just not 200. So it is not just about hiding but also
about showing something sensible.

> As for iostat - where does it get info from ? /proc/partitions? /proc/diskinfo?
> Maybe /sys/block?
> Either way, we could probably find a way to say "this block device is
> 'hidden'" .

One of those places.

> If you want to be able to slice and dice lot of mini-raid arrays into
> an LVM system, then whatever way you implement it you will need to be
> keeping track of all those bits.  I think it makes most sense to use
> the "block device" as the common abstraction, then if we start finding
> issues: solve them.  That way the solutions become available for
> others to use in ways we hadn't expected.

I think the device mapper tables should suffice. They are perfect for
slice and dice operations. This should realy sidestep the block device
overhead (alloc major/minor, send event, not runtime overhead) and
combine status of many slices into a combined status.

I see one problem though for converting md code to dm code: The
metadata. In LVM every PE is basically independent and can be moved
around at will. So the raid code must be able to split and merge raid
devices on a PE granularity at least. Specifically the dirty/clean
informations and serial counts are tricky.

There could be 2 options:

1) Put a little bit of metadata at the start of every PE. The first
block of each PE could also hold an internal bitmap for that PE and
not just a few meta infos and the clean/dirty byte. For internal
bitmaps this might be optimal as it would garanty short seeks to reach
the bits.

2) Have detached metadata. Md already has detached bitmaps. Think of
it as a raid without metadata but with external bitmap.

>> MfG
>>         Goswin

MfG
        Goswin
