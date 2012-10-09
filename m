From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: register new md sysfs file 'uuid' read-only
Date: Tue, 9 Oct 2012 14:02:48 +1100
Message-ID: <20121009140248.3ad91484@notabene.brown>
References: <1349185330-9024-1-git-send-email-sebastian.riemer@profitbricks.com>
	<20121003083031.51093f0c@notabene.brown>
	<50730010.5090605@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WzSeDR8hOlEWQgWjNxr9SgF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50730010.5090605@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/WzSeDR8hOlEWQgWjNxr9SgF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 08 Oct 2012 18:32:16 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> Hi Neil,
>=20
> I must have overseen your answer. We want to use as less mdadm as
> possible - especially for simple checking stuff. The kernel knows best.

Kernel sometimes knows.  Some arrays have metadata handled by user-space so
the kernel wouldn't be able to report anything.
Userspace always knows..

> "mdadm -D" reads the data from disk. This means additional disk access.
> It is also possible that this command triggers superblock updates.
> Simple checking stuff shouldn't have to use disk access.

In that case, how about using /run/mdadm/map ??
When mdadm assembles an array it needs to know the uuid, and it records this
in that file for future reference.  Will that do?


>=20
> We are planning to use MD RAID a little bit different with e.g. 100 MD
> arrays. Searching for a particular UUID in this bunch of MD devices can
> be difficult without this patch. This is how the kernel represents
> UUIDs. Conversion can be done in user space.

I believe that format is for RFC4122 UUIDs.  MD's UUIDs are not created
according to those rules, so it isn't really appropriate to make it look li=
ke
they were.
However the formatting isn't the big issue - the UUID is something the kern=
el
knows by accident more than by necessity.  I'd rather it didn't.

>=20
> If you like it better in the xxxxxxxx:xxxxxxxx:xxxxxxxx:xxxxxxxx format,
> I can resend the patch in that format.
>=20
> It simplifies our checking magic not to rely on udev symlinks and to ask
> the kernel for the cached UUID.
>=20
> Btw.: We did an "Assemble-Resize-Stop, Assemble-Resize-Stop, ..."-Test
> with "--assume-clean" and the second resize doesn't work. With
> "Assemble-Resize-Detail-Stop" it works.

More details?  What exactly do you mean by "Resize"?  What exactly do you
mean by "doesn't work"?  Can you make a simple script that reproduces this?
If so, I'd love to see it.

Thanks,
NeilBrown


--Sig_/WzSeDR8hOlEWQgWjNxr9SgF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHOT2Dnsnt1WYoG5AQJJCQ/9F3Sz96utqnAwN32cGR6hdBaSFqox8m3l
z0SR6W6qBbYQY0a9QIQtN83exQ5UFmJmKjgN2MUffm7OWJ+2k/emtg0uqU+QGBaU
ShIhgluZZF/LLJIEQQXN7mIaJP6mgokqPYghfN+DCi+a2aE6UECYXWkrjfEbPmTP
eGisizozNBNwXhyG4f8sFfYlXYcnZn5UPAGUP0wNR6SqaL9++f+LKEtmir3IvLE0
yspIaTfLV3OXWR+dIkx9vf8jj92Up/i49a0rRQUOMnRJqh/abzytpDuksEzlnSAr
g0uo2z+BCdRhZdoTn8bTRp2iXMkMl7+SSx466kdhM/WJSDp8voKPXpCX4lsGRSGm
325L8kGSmDbkQGEXexTm4FIgn7JliXAXDkZ5sSTA5ZkN72Ek2n/dXEb8CZPSym2n
YvPZSBd5MViItkc8krMmdN7Cz5E9uJ1kU2XM7AeKy6fra+R9LgZBGe7fNpAwe6aj
OvR47QMld/+9qd759JTHp5CFNnPjrnimSKR5dpBMO0EZyQF6VZ0QRHh2ZM/7oztJ
Vd8/HChHbn8xROBsdQplmG8hBhvQcaFuirwjxHHpIEhwB6UzeNAd28DmO0xdAFsg
AFI5dXYc+4sr2RNpwu0nbgpTtedGNaoZu7fCHZQ12Fgrh6iviZJ6Ljnb/x/VNIVV
Hi/CJDol2zM=
=rv4d
-----END PGP SIGNATURE-----

--Sig_/WzSeDR8hOlEWQgWjNxr9SgF--
