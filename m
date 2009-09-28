From: Andre Noll <maan@systemlinux.org>
Subject: Re: RAID1 assembled broken array
Date: Mon, 28 Sep 2009 18:12:55 +0200
Message-ID: <20090928161255.GJ21495@skl-net.de>
References: <h8ophd$n8p$6@ger.gmane.org> <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com> <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name> <20090917082528.GO5174@skl-net.de> <19132.31575.349988.442763@notabene.brown> <20090926095834.GP5174@skl-net.de> <4ABE108C.9030606@anonymous.org.uk> <b7b14cbb0909261221v10a78615j4c6ee60876151c40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CxDuMX1Cv2n9FQfo"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b7b14cbb0909261221v10a78615j4c6ee60876151c40@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--CxDuMX1Cv2n9FQfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21:21, Clinton Lee Taylor wrote:
> >> Maybe we should depricate kernel-level autodetection at the same time
> >> so that using an initramfs becomes mandatory for setups with / on md.
> >
> > It already is deprecated; afaik all the recent distros already use an
> > initramfs, even if they still use 0.90 metadata.
> >
> > I second making this a priority to get into the next round of distro
> > updates, for all the reasons given. As soon as metadata version upgrade
> > facilities go in to mdadm, 0.90 metadata can also be deprecated and per=
haps
> > mdadm can issue warnings, or at least the kernel autoassembly code can =
start
> > issuing warnings (if it doesn't already).
>=20
>  All this talk of metadata 1.x, what about all the metadata 0.90 RAID
> array's out there?  What is needed for an upgrade or conversion?

We're just talking about making 1.x the default for creating _new_
arrays. The old v0.90 metadata format will still be supported for
years. However, if one could easily upgrade from v0.90 to v1.x
metadata, we could stop supporting the old format a bit earlier.

It would be good enough to teach mdadm to convert the superblocks of
inactive arrays only.

> Would a conversion program need to understand the under lying
> filesystem?

No.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--CxDuMX1Cv2n9FQfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKwOCHWto1QDEAkw8RAvw5AKCqyM0+Cre2JWhCVh/SPsCMAA7s+ACgoATA
T1jKIB7G38loi8eujiBAYJg=
=lEym
-----END PGP SIGNATURE-----

--CxDuMX1Cv2n9FQfo--
