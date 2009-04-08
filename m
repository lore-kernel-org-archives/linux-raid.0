From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Wed, 08 Apr 2009 02:15:06 +0200
Message-ID: <87prfof1bp.fsf@frosties.localdomain>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
	<87tz51dmmu.fsf@frosties.localdomain>
	<FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com>
	<155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name>
	(NeilBrown's message of "Wed, 8 Apr 2009 07:26:24 +1000 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Goswin von Brederlow <goswin-v-b@web.de>, LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"NeilBrown" <neilb@suse.de> writes:

> On Tue, April 7, 2009 10:16 pm, Doug Ledford wrote:
>> On Apr 7, 2009, at 2:05 AM, Goswin von Brederlow wrote:
>>> Doug Ledford <dledford@redhat.com> writes:
>>>
>>>> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the
>>>> temporary mappings of incrementally added devices to device names.
>>>> Unfortunately, this breaks incremental assembly if used early in the
>>>> booting process.  Specifically, root may still be read only.  Since
>>>> incremental assembly is largely a udev specific feature, and udev
>>>> needs a writable /dev tmpfs mount even when root is still read only,
>>>> it's safer to put our mdadm.map file in /dev/md so that we can write
>>>> to the map file no matter how early in the boot process we are
>>>> attempting to use incremental assembly.
>>>
>>> What about /lib/init/rw?
>>
>> Never heard of it.  But, if / is read-only, why wouldn't that also be
>> read-only?
>
> because a tmpfs was mounted there.  It's probably a Debian-specific
> thing.
>
> Why /var/run cannot be mounted from tmpfs nice and early too I don't know..

Because /var is not yet mounted.

You would have to create /var/run on the / filesystem, mount a tmpfs
there early during boot. Then later you would have to move the
filesystem somwhere else (/tmp/run?), mount /var and move it back. And
you would have a race condition where /var/run is not available for a
while.

> I understand that some people think /var/run needs to persist across
> reboots to preserve ownership of directories, but they are wrong :-)
> /var/run should be a tmpfs mount point very early.

Which Ubuntu defaults to and Debian is supporting but not defaulting to.

> I have to say that putting the map file in /dev feels very icky
> to me.  It isn't a device, and so doesn't belong in /dev.
> If we go around putting things somewhere convenient rather than
> where they belong, we quickly end up with a mess.
>
> So while it might be very pragmatic, I am currently dis-inclined
> to take the patch.   Can you try asking your boot-script people
> to make /var/run be an early tmpfs ???

Having /var/run early just complicates things needlessly.

Maybe mdadm should just have

  -m, --map <file>
     Filename of the map file for incremental operations. Defaults
     to /var/run/mdadm.map. Note that the default path might not exist
     or be read-only early in the boot process in which case a
     suitable alternative must be specified.

Wouldn't that be more flexible?

Debian could then set 'MAP /lib/init/rw' in its mdadm.conf.

> NeilBrown

MfG
        Goswin
