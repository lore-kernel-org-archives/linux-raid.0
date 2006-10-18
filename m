From: Doug Ledford <dledford@redhat.com>
Subject: Re: why partition arrays?
Date: Wed, 18 Oct 2006 09:26:52 -0400
Message-ID: <1161178012.2917.529.camel@fc6.xsintricity.com>
References: <20061018124225.GA23653@piper.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wl5/DdMgnz76b5/1M1sO"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061018124225.GA23653@piper.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-wl5/DdMgnz76b5/1M1sO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-10-18 at 14:42 +0200, martin f krafft wrote:
> Why would anyone want to create a partitionable array and put
> partitions in it, rather than creating separate arrays for each
> filesystem? Intuitively, this makes way more sense as then the
> partitions are independent of each other; one array can fail and the
> rest still works -- part of the reason why you partition in the
> first place.
>=20
> Would anyone help me answer this FAQ?

There are a couple reasons I can think.

First, not all md types make sense to be split up, aka multipath.  For
those types, when a disk fails, the *entire* disk is considered to be
failed, but with different arrays you won't fail over to the next path
until each md array has attempted to access the bad path.  This can have
obvious bad consequences for certain array types that do automatic
failover from one port to another (you can end up getting the array in a
loop of switching ports repeatedly to satisfy the fact that one array
failed over during a path down, then the path came back up, and another
array stayed on the old path because it didn't send any commands during
the path down time period).

Second, convenience.  Assume you have a 6 disk raid5 array.  If a disk
fails and you are using a partitioned md array, then all the partitions
on the disk will already be handled without using that disk.  No need to
manually fail any still active array members from other arrays.

Third, safety.  Again with the raid5 array.  If you use multiple arrays
on a single disk, and that disk fails, but it only failed on one array,
then you now need to manually fail that disk from the other arrays
before shutting down or hot swapping the disk.  Generally speaking,
that's not a big deal, but people do occasionally have fat finger
syndrome and this is a good opportunity for someone to accidentally fail
the wrong disk, and when you then go to remove the disk you create a two
disk failure instead of one and now you are in real trouble.

Forth, to respond to what you wrote about independent of each other --
part of the reason why you partition.  I would argue that's not true.
If your goal is to salvage as much use from a failing disk as possible,
then OK.  But, generally speaking, people that have something of value
on their disks don't want to salvage any part of a failing disk, they
want that disk gone and replaced immediately.  There simply is little to
no value in an already malfunctioning disk.  They're too cheap and the
data stored on them too valuable to risk loosing something in an effort
to further utilize broken hardware.  This of course is written with the
understanding that the latest md raid code will do read error rewrites
to compensate for minor disk issues, so anything that will throw a disk
out of an array is more than just a minor sector glitch.

> (btw: [0] and [1] are obviously for public consumption; they are
> available under the terms of the artistic licence 2.0)
>=20
> 0. http://svn.debian.org/wsvn/pkg-mdadm/mdadm/trunk/debian/FAQ?op=3Dfile&=
rev=3D0&sc=3D0
> 1. http://svn.debian.org/wsvn/pkg-mdadm/mdadm/trunk/debian/README.recipes=
?op=3Dfile&rev=3D0&sc=3D0
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-wl5/DdMgnz76b5/1M1sO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFNiubTzP9PM7pjw8RAoFRAJ4oFRpS36hVZASO0NdM4TAkCvQJIwCfZkXJ
8tEwNZlXTCGxr+n5KkRR93I=
=e0wo
-----END PGP SIGNATURE-----

--=-wl5/DdMgnz76b5/1M1sO--

