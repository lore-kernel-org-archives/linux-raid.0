From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 02 Nov 2007 11:50:01 -0400
Message-ID: <1194018601.25553.32.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
	 <471A47CC.1070508@msgid.tls.msk.ru> <18205.2688.952701.567195@stoffel.org>
	 <1193186569.10336.30.camel@firewall.xsintricity.com>
	 <472A3EE0.3090503@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Lc8qOLAlocm0QCprl+bS"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472A3EE0.3090503@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stoffel <john@stoffel.org>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-Lc8qOLAlocm0QCprl+bS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 14:02 -0700, H. Peter Anvin wrote:
> Doug Ledford wrote:
> >>
> >> I would argue that ext[234] should be clearing those 512 bytes.  Why
> >> aren't they cleared =20
> >=20
> > Actually, I didn't think msdos used the first 512 bytes for the same
> > reason ext3 doesn't: space for a boot sector.
> >=20
>=20
> The creators of MS-DOS put the superblock in the bootsector, so that the=20
> BIOS loads them both.  It made sense in some diseased Microsoft=20
> programmer's mind.
>=20
> Either way, for RAID-1 booting, the boot sector really should be part of=20
> the protected area (and go through the MD stack.)

It depends on what you are calling the protected area.  If by that you
mean outside the filesystem itself, and in a non-replicated area like
where the superblock and internal bitmaps go, then yes, that would be
ideal.  If you mean in the file system proper, then that depends on the
boot loader.

>   The bootloader should=20
> deal with the offset problem by storing partition/filesystem-relative=20
> pointers, not absolute ones.

Grub2 is on the way to this, but it isn't there yet.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-Lc8qOLAlocm0QCprl+bS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHK0cpTzP9PM7pjw8RAjHLAJ4qNh0anBfIPhtS4QJv+OljtcQjiwCfbe9o
tevELbtKIkC0GqSelP+ahvc=
=v+Kt
-----END PGP SIGNATURE-----

--=-Lc8qOLAlocm0QCprl+bS--

