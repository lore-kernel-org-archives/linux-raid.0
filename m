From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 09 May 2009 00:06:07 +0200
Message-ID: <87ab5n45dc.fsf@frosties.localdomain>
References: <49F68CE0.2010906@zytor.com> <1240963225.18303.858.camel@ezra>
	<49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra>
	<49F79F26.9060309@zytor.com> <1240965831.18303.944.camel@ezra>
	<20090429064333.GB9372@boogie.lpds.sztaki.hu>
	<87hc04leau.fsf@frosties.localdomain>
	<1241217394.4418.4.camel@poledra.romunt.nl>
	<1241226246.4862.24.camel@ezra>
	<6c4602af0905021002i6fb0e667mdde8fb589f34ead6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0905021002i6fb0e667mdde8fb589f34ead6@mail.gmail.com>
	(Micha's message of "Sat, 2 May 2009 19:02:45 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Micha Przyuski <mikylie@gmail.com>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Micha=B3 Przy=B3uski <mikylie@gmail.com> writes:

> Hello,
>
> 2009/5/2 Daniel Reurich <daniel@centurion.net.nz>:
>>> It would get worse, as in many situations the installer would succe=
ed,
>>> and the boot would fail. Many raid 5/6 configurations will spread o=
ver
>>> controllers, and not BIOS supports booting over several controllers=
=2E
>>>
>> Then we teach the bootloaders installer to detect whether all the me=
mber
>> disks are on the same controller, and refuse to install (or atleast =
warn
>> at that point) if not.
>
> That has been an interesting discussion over last week or so. I have
> some thoughts at this point, not really technical...
>
> First thing is, DO NOT boot from raid5/6. It's pointless anyway.
> Let's think of raid5 as a bigger raid1. It won't add any extra
> redundancy to our boot-process over a separate raid1 for /boot. Makin=
g

The point was not to add redundany but to remove complexity.

Just look at what you need to do for the next generation of disks
(>2TB):

- Create a MS Dos partition table with a fake /boot partition in the
  first 2TB.
- Create a GPT table with a matching /boot partition and the rest
- Create a raid1 for /boot
- Create a raidX for the rest

Now you have to watch 2 raids and add/remove partitions from 2 raids,
You also need to copy the bootloader to every new disk you add.

The idea is to bring this down to:

- Create raidX over all disks

> it a hidden raid1 over first few sectors is just creating an
> automation that gains nothing and makes things unnecessarily
> complicated inside.

If the hidden raid1 is just reserved space that is considered part of
the raid metadata then this moves completly into mdadm userspace. The
extra complexity comes down to "read reserved space from old disk,
write reserved space to new disk". In the most basic form that is 3
lines of code (declare buffer, read, write).

> For example, if user has a, say, 4 disk raid5, with magic or normal
> raid1 for boot, and looses 2 disks, he or she is still pretty angry,
> no matter that they can boot, when they'd lost all their data. I'm
> quite sure users care more about data when they go raid5 than system
> itself.

Not the point.

> If you can afford real hw controller, that "does it all for raid5/6"
> and provides one int13 device for bootloader then no problems. But
> then, who makes his or hers /boot (and / and data) on one huge
> partition.

People that don't use softwareraid are not a traget group for software
raid. So irelevant.

> If you can't, and want to have reliable boot, then you should mirror
> your drives. Going anywhere over raid1 is pointless. You should just
> have a backup, boot is small and changes rarely, one can burn it to a
> dvd easily.
>
> So, as /boot (or even /) nowadays is really tiny, compared to disk
> sizes, you can easily carve out few gigs at the start of device for
> raid1, and use rest of all disks for raid5. Also, lvm'ing /boot sound=
s
> just wrong, I don't think resizing or other lvm features are of any
> use for /boot.

But being able to pvmove it can be verry usefull. Say you have a
system with 2 disk raid1 that is hotplug capable, has space for 4
disks and you want to migrate to bigger disks. Just plug in 2 new
disks, create raid, extend VG, pvmove everything, reduce VG, stop old
raid, remove old disks.

> Summing up, I don't get, why would anybody really want to boot from r=
aid5 or 6.
>
> I second booting from one thing, and storing data on the other. It ca=
n
> be different partition, it can be different disk, but mixing those
> things together in one place is bad practice for many many reasons.
>
> And my very personal background; I chose mdadm because it allows me t=
o
> make raid sets across multiple controllers, and I don't use my raid6
> for anything other than data. System boots from single (even EIDE)
> disk, I'm totally not worried about my system, only data matter.
>
> So all in all, I think all levels of protections are already
> available. And please, no next metadata format; we already have 4
> mdadm metadata versions, and users are still not sure which one they
> should choose.
>
> Please don't eat me at once,
> Have a nice spring day everybody,
> Mike

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
