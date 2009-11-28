From: Doug Ledford <dledford@redhat.com>
Subject: Re: Question for Neil/Superblocks
Date: Sat, 28 Nov 2009 16:17:51 -0500
Message-ID: <4B11937F.7000200@redhat.com>
References: <alpine.DEB.2.00.0911271624450.30813@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3147D32CA277C30253796A23"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0911271624450.30813@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3147D32CA277C30253796A23
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/27/2009 04:27 PM, Justin Piszcz wrote:
> Hi Neil,
>=20
> A couple of things, recently I tried to make a new system
> (MDADM/latest/SW RAID1) and noticed that GRUB & LILO still only support=

> 0.90 superblocks. This leads me to my next question.
>=20
> Will the newer superblocks be supported? I ask this due to my final
> question.

Not by grub or lilo, which are both dead projects.  However, grub2 does
support newer superblocks and we actually ship it in F12.

> With 0.90 superblocks, I have never seen any array (raid1,raid5,raid6)
> try to correct a read-error, but when I made an array with 1.2
> superblocks (not the boot volume of course) using VelociRaptors, great
> for testing crap disks that don't work in read, I did see it try to
> correct read errors!  I was wondering if that is only applicable to
> superblocks >=3D 1.x+?

Coincidence.

> I know you can build yourself an initrd/miniroot so/on/so forth but its=

> nice when you can just build a kernel, run lilo and have it auto-detect=

> the raid1 volumes and boot accordingly (as you can with 0.90 superblock=
s).

The hack in lilo that allows it to do this is a very ugly hack.  It is
not even close to proper raid1 boot support.  I would look into grub2.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig3147D32CA277C30253796A23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksRk38ACgkQg6WylM+/8ZQMFwCfZVTzn3jkRtZK/GireMnlZHYP
zmcAoK3uOjSgnJAsKQWCz30tPcRP5zvr
=KELQ
-----END PGP SIGNATURE-----

--------------enig3147D32CA277C30253796A23--
