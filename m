From: "William L. Thomson Jr." <wltjr@gentoo.org>
Subject: Re: mdadm file system type check
Date: Sat, 17 Mar 2007 04:20:18 -0400
Message-ID: <1174119618.14762.11.camel@wlt.obsidian-studios.com>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
	 <17915.17571.333717.668140@notabene.brown>
	 <1174099334.13073.46.camel@wlt.obsidian-studios.com>
	 <17915.32562.482059.394771@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ij91v2/Pkdc2TV3Mf6B/"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17915.32562.482059.394771@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ij91v2/Pkdc2TV3Mf6B/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-03-17 at 16:40 +1100, Neil Brown wrote:
> On Friday March 16, wltjr@gentoo.org wrote:
> >=20
> > Instead of passing along an interpretation, here are some IRC log
> > snippets that pertain from #gentoo-dev @ freenode.net
> >=20
> > kingtaco|work: livecd ~ # mdadm --create --level=3D1 --raid-devices=3D2=
 /dev/md0 /dev/sda1 /dev/sdb1
> > kingtaco|work: mdadm: /dev/sda1 is too small: 0K
> > kingtaco|work: mdadm: create aborted
>
> This failure has nothing do to with the partition type. As I
> mentioned, mdadm doesn't see the partition type at all.

Not to contradict but only thing that was changed and the problem was fs
type.

> When you change the partition type, fdisk (or whatever) normally tells
> the kernel to reread the partition table.  It would seem that the
> partition table hadn't been read properly before this point, so
> /dev/sda1 didn't exist.

Not to sure about that, part that I did not post after the above snippet
still left, and before the other one I removed.

wltjr: kingtaco|work: likely something else, partition off, wrong fs type, =
or etc
kingtaco|work: /dev/sda1 1 17 136521 83 Linux
kingtaco|work: /dev/sdb1 1 17 136521 83 Linux

So they for sure existed 83/ext3, and were changed to fd.

>   After running fdisk that partition table had
> been read by the kernel and everything was fine.

That's likely, but the kernel was aware of the partitions prior to the
fs type change.

> I.e. it was using fdisk to write the partition table that 'fixed' the
> problem, not changing the partition type.  And the problem was not
> causes by mdadm but by something else not setting up the partitions
> properly (or removing them maybe).

Well we can rule it out to funky partition creation or etc. But the
partitions were just created via fdisk. With the next logical step being
to setup the array, format, etc. So that the partitions being off, and
re-running fdisk updated kernel or etc is all possible. But kinda
doubtful or odd at the least.

Unless udev or etc was doing something once the partition type changed.
So the problem wasn't with mdadm but something else that detected the
change in fs type.

--=20
William L. Thomson Jr.
Gentoo/Java

--=-ij91v2/Pkdc2TV3Mf6B/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBF+6TCPrChP8zZLyYRApG7AKDlrIo0FVXau0JJeaJ4eWN2JK7szwCaA7aZ
yulTJO7AEeT9Q7mrXqPhnwo=
=HDaO
-----END PGP SIGNATURE-----

--=-ij91v2/Pkdc2TV3Mf6B/--

