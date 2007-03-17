From: "William L. Thomson Jr." <wltjr@gentoo.org>
Subject: Re: mdadm file system type check
Date: Fri, 16 Mar 2007 22:42:14 -0400
Message-ID: <1174099334.13073.46.camel@wlt.obsidian-studios.com>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
	 <17915.17571.333717.668140@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xLUHrVXlrY2PYcCUVqF/"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17915.17571.333717.668140@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-xLUHrVXlrY2PYcCUVqF/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-03-17 at 12:30 +1100, Neil Brown wrote:
>=20
> It would be very awkward for mdadm to get at the partition type
> information.=20
> And there is very little software that actually cares.  mdadm
> certainly doesn't care what the partition type is.

I got it reversed. :) There was an error when the file system was not
linux auto raid. More on that below.

> I don't understand why you would have to 'start over'.  If you
> discover that the partition type isn't what you want for some reason,
> just change it.

It might have been that simple, it was quite some time ago. But it was a
memorable event since it stuck in my head as one of the things to check
when having problems with mdadm. But obviously not a clear memory.

> This is the right place, thanks.

Good to know ;)

> But maybe I don't really understand what the problem is.
> Could you give more details?  Exactly what didn't work the way you
> expected it to?

Instead of passing along an interpretation, here are some IRC log
snippets that pertain from #gentoo-dev @ freenode.net

kingtaco|work: livecd ~ # mdadm --create --level=3D1 --raid-devices=3D2 /de=
v/md0 /dev/sda1 /dev/sdb1
kingtaco|work: mdadm: /dev/sda1 is too small: 0K
kingtaco|work: mdadm: create aborted

Now despite suggesting it pretty early on, it took a bit of time to
realize that error was existing only because of file system type. Once
he realized the problem and changed fs type. All was well, and he was
able to create the arrays and move on.

kingtaco|work: wltjr, see, raidtools would have let me create an array even=
though the type wasn't fs
kingtaco|work: er, fd
kingtaco|work: mdadm just isn't that smart
kingtaco|work: (and that fixed it)

So ot to sure about the error or why they would get that just because of
file system type.

--=20
William L. Thomson Jr.
Gentoo/Java

--=-xLUHrVXlrY2PYcCUVqF/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBF+1WGPrChP8zZLyYRAlmNAJ45OnLo4GuOEgAl/fOxdOabwSFpEQCeO5Mn
+xaIXhGdn92W1NAn4NFeWtk=
=OAsu
-----END PGP SIGNATURE-----

--=-xLUHrVXlrY2PYcCUVqF/--

