From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sat, 27 Oct 2007 16:47:30 -0400
Message-ID: <1193518050.10336.343.camel@firewall.xsintricity.com>
References: <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com>
	 <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com>
	 <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com>
	 <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <20071026091513.GB32550@percy.comedia.it>
	 <1193426793.10336.302.camel@firewall.xsintricity.com>
	 <20071027075054.GA12053@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iTJ8ZlzPTZg0LxTbaJbq"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071027075054.GA12053@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-iTJ8ZlzPTZg0LxTbaJbq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-27 at 09:50 +0200, Luca Berra wrote:
> On Fri, Oct 26, 2007 at 03:26:33PM -0400, Doug Ledford wrote:
> >On Fri, 2007-10-26 at 11:15 +0200, Luca Berra wrote:
> >> On Thu, Oct 25, 2007 at 02:40:06AM -0400, Doug Ledford wrote:
> >> >The partition table is the single, (mostly) universally recognized
> >> >arbiter of what possible data might be on the disk.  Having a partiti=
on
> >> >table may not make mdadm recognize the md superblock any better, but =
it
> >> >keeps all that other stuff from even trying to access data that it
> >> >doesn't have a need to access and prevents random luck from turning y=
our
> >> >day bad.
> >> on a pc maybe, but that is 20 years old design.
> >
> >So?  Unix is 35+ year old design, I suppose you want to switch to Vista
> >then?
> unix is a 35+ year old design that evolved in time, some ideas were
> kept, some ditched.

BSD disk labels are still in use, SunOS disk labels are still in use,
partition tables are somewhat on the way out, but only because they are
being replaced by the new EFI disk partitioning method.  The only place
where partitionless devices is common is in dedicated raid boxes where
the raid controller is the only thing that will *ever* see that disk.
Sometimes they do it on big SAN/NAS stuff because they don't want to
align the partition table to the underlying device's stripe layout, but
even then they do so in a tightly controlled environment where they know
exactly which machines will be allowed to even try and access the
device.

> >> partition table design is limited because it is still based on C/H/S,
> >> which do not exist anymore.
> >> Put a partition table on a big storage, say a DMX, and enjoy a 20%
> >> performance decrease.
> >
> >Because you didn't stripe align the partition, your bad.
> :)
> by default fdisk misalignes partition tables
> and aligning them is more complex than just doing without.

So.  You really need to take the time and to understand the alignment of
the device because then and only then can you pass options to mke2fs to
align the fs metadata with the stripes as well thereby buying you ever
more performance than just leaving off the partition table (assuming
that's what you use, I don't know if other mkfs programs have the same
options for aligning metadata with stripes).  And if you take the time
to understand the underlying stripe layout for the mkfs stuff, then you
can use the same information to align the partition table.

> >> >Oh, and let's not go into what can happen if you're talking about a d=
ual
> >> >boot machine and what Windows might do to the disk if it doesn't thin=
k
> >> >the disk space is already spoken for by a linux partition.
> >> Why the hell should the existance of windows limit the possibility of
> >> linux working properly.
> >
> >Linux works properly with a partition table, so this is a specious
> >statement.
> It should also work properly without one.

Most of the time it does.  But those times where it can fail, the
failure is due to not taking the precautions necessary to prevent it:
aka labeling disk usage via some sort of partition table/disklabel/etc.

> >> If i have a pc that dualboots windows i will take care of using the
> >> common denominator of a partition table, if it is my big server i will
> >> probably not. since it won't boot anything else than Linux.
> >
> >Doesn't really gain you anything, but your choice.  Besides, the
> >question wasn't "why shouldn't Luca Berra use whole disk devices", it
> >was why I don't recommend using whole disk devices, and my
> >recommendation wasn't based in the least bit upon a single person's use
> >scenario.
> If i am the only person in the world that believes partition tables
> should not be required then i'll shut up.
>=20
> >> On the opposite, i once inserted an mmc memory card, which had been
> >> initialized on my mobile phone, into the mmc slot of my laptop, and wa=
s
> >> faced with a load of error about mmcblk0 having an invalid partition
> >> table.
> >
> >So?  The messages are just informative, feel free to ignore them.
> but did not anaconda propose to wipe unpartitioned disks?

Did you stick your mmc card in there during the install of the OS?
That's the only time anaconda ever runs, and therefore the only time it
ever checks your devices.  It makes sense that during the initial
install, when the OS is only configured to see locally connected
devices, or possibly iSCSI devices that you have specifically told it to
probe, that it would then ask you the question about those devices.
Other network attached or shared devices are generally added after the
initial install.

> >The phone dictates the format, only a moron would say otherwise.  But,
> >then again, the phone doesn't care about interoperability and many other
> >issues on memory cards that it thinks it owns, so only a moron would
> >argue that because a phone doesn't use a partition table that nothing
> >else in the computer realm needs to either.
> i don't count myself as a moron, what i am trying to say is that
> partition tables are one way of organizing disk space, not the only one.

Using whole disk devices isn't a means of organizing space.  It's a way
to get a rather miniscule amount of space back by *not* organizing the
space.

This whole argument seems to boil down to you wanting to perfectly
optimize your system for your use case which includes controlling the
environment enough that you know it's safe to not partition your disks,
where as I argue that although this works in controlled environments, it
is known to have failure modes in other environments, and I would be
totally remiss if I recommended to my customers that they should take
the risk that you can ignore because of your controlled environment
since I know a lot of my customers *don't* have a controlled environment
such as you do.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-iTJ8ZlzPTZg0LxTbaJbq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI6PiTzP9PM7pjw8RArL8AJ4wUuZbLEPcCGvR1LMfT1TOMDqlUgCbBd5c
1mWUBWUPJJv8xn5NBv7rQ2Q=
=b2tO
-----END PGP SIGNATURE-----

--=-iTJ8ZlzPTZg0LxTbaJbq--

