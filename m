From: Daniel Gryniewicz <dang@fprintf.net>
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 00:21:45 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1068787304.4157.8.camel@localhost>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RkWuvu1JK8aWraOfTs3x"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-RkWuvu1JK8aWraOfTs3x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2003-11-13 at 22:11, Neil Brown wrote:
> RFCI =3D=3D Request For Clever Ideas.
>=20
> Hi all..
>=20
>  I want be able to partition "md" raid arrays.
>  e.g. I want to be able to use RAID1 to mirror sda and sdb as whole
>  drives, and then partitions that into root, swap, other (or whatever
>  suits the particular situation).

<snip>

Can't LVM do this?  I have a raid array (mirror) that is LVM'd into
multiple partitions.  It currently runs 2.4, but it should work fine
with 2.6, right?  All the rest of my boxes have 2.6 and LVM, but no raid
(no duplicate hard drives).
--=20
Daniel Gryniewicz <dang@fprintf.net>

--=-RkWuvu1JK8aWraOfTs3x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/tGZoomPajV0RnrERAuh7AJ0WQxWWuEO+vqBJ/7viUNzCIZfD0gCeO4EW
FaibFFLk8+xk2dneYnDgjdg=
=Llhx
-----END PGP SIGNATURE-----

--=-RkWuvu1JK8aWraOfTs3x--
