From: =?ISO-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 2 May 2009 19:02:45 +0200
Message-ID: <6c4602af0905021002i6fb0e667mdde8fb589f34ead6@mail.gmail.com>
References: <49F68CE0.2010906@zytor.com> <1240963225.18303.858.camel@ezra>
	 <49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra>
	 <49F79F26.9060309@zytor.com> <1240965831.18303.944.camel@ezra>
	 <20090429064333.GB9372@boogie.lpds.sztaki.hu>
	 <87hc04leau.fsf@frosties.localdomain>
	 <1241217394.4418.4.camel@poledra.romunt.nl>
	 <1241226246.4862.24.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1241226246.4862.24.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

2009/5/2 Daniel Reurich <daniel@centurion.net.nz>:
>> It would get worse, as in many situations the installer would succeed,
>> and the boot would fail. Many raid 5/6 configurations will spread over
>> controllers, and not BIOS supports booting over several controllers.
>>
> Then we teach the bootloaders installer to detect whether all the member
> disks are on the same controller, and refuse to install (or atleast warn
> at that point) if not.

That has been an interesting discussion over last week or so. I have
some thoughts at this point, not really technical...

First thing is, DO NOT boot from raid5/6. It's pointless anyway.
Let's think of raid5 as a bigger raid1. It won't add any extra
redundancy to our boot-process over a separate raid1 for /boot. Making
it a hidden raid1 over first few sectors is just creating an
automation that gains nothing and makes things unnecessarily
complicated inside.
For example, if user has a, say, 4 disk raid5, with magic or normal
raid1 for boot, and looses 2 disks, he or she is still pretty angry,
no matter that they can boot, when they'd lost all their data. I'm
quite sure users care more about data when they go raid5 than system
itself.

If you can afford real hw controller, that "does it all for raid5/6"
and provides one int13 device for bootloader then no problems. But
then, who makes his or hers /boot (and / and data) on one huge
partition.

If you can't, and want to have reliable boot, then you should mirror
your drives. Going anywhere over raid1 is pointless. You should just
have a backup, boot is small and changes rarely, one can burn it to a
dvd easily.

So, as /boot (or even /) nowadays is really tiny, compared to disk
sizes, you can easily carve out few gigs at the start of device for
raid1, and use rest of all disks for raid5. Also, lvm'ing /boot sounds
just wrong, I don't think resizing or other lvm features are of any
use for /boot.

Summing up, I don't get, why would anybody really want to boot from raid5 or 6.

I second booting from one thing, and storing data on the other. It can
be different partition, it can be different disk, but mixing those
things together in one place is bad practice for many many reasons.

And my very personal background; I chose mdadm because it allows me to
make raid sets across multiple controllers, and I don't use my raid6
for anything other than data. System boots from single (even EIDE)
disk, I'm totally not worried about my system, only data matter.

So all in all, I think all levels of protections are already
available. And please, no next metadata format; we already have 4
mdadm metadata versions, and users are still not sure which one they
should choose.

Please don't eat me at once,
Have a nice spring day everybody,
Mike
