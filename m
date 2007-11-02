From: Doug Ledford <dledford@redhat.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Fri, 02 Nov 2007 11:55:47 -0400
Message-ID: <1194018947.25553.39.camel@firewall.xsintricity.com>
References: <20071030210721.386ca2fa@absurd>
	 <1193781699.10336.585.camel@firewall.xsintricity.com>
	 <472A0D7A.4040807@zytor.com>
	 <1193941858.10336.659.camel@firewall.xsintricity.com>
	 <472A2194.9070408@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cxV1PItBJE4CM92vwBXg"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472A2194.9070408@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-cxV1PItBJE4CM92vwBXg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 11:57 -0700, H. Peter Anvin wrote:
> Doug Ledford wrote:
> >=20
> > Correct, and that's what you want.  The alternative is that if the BIOS
> > can see the first disk but it's broken and can't be used, and if you
> > have the boot sector on the second disk set to read from BIOS disk 0x81
> > because you ASSuMEd the first disk would be broken but still present in
> > the BIOS tables, then your machine won't boot unless that first dead bu=
t
> > preset disk is present.  If you remove the disk entirely, thereby
> > bumping disk 0x81 to 0x80, then you are screwed.  If you have any drive
> > failure that prevents the first disk from being recognized (blown fuse,
> > blown electronics, etc), you are screwed until you get a new disk to
> > replace it.
> >=20
>=20
> What you want is for it to use the drive number that BIOS passes into it=20
> (register DL), not a hard-coded number.  That was my (only) point --=20
> you're obviously right that hard-coding a number to 0x81 would be worse=20
> than useless.

Oh, and I forgot to mention that in grub2, the DL register is ignored
for RAID1 devices.  Well, maybe not ignored, but once grub2 has
determined that the intended boot partition is a raid partition, the
raid code takes over and the raid code doesn't care about the DL
register.  Instead, it scans for all the other members of the raid array
and utilizes whichever drives it needs to in order to complete the boot
process.  And since it does reads a sector (or a small group of sectors)
at a time, it doesn't need any member of a raid1 array to be perfect, it
will attempt a round robin read on all the sectors and only fail if all
drives return an error for a given read.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-cxV1PItBJE4CM92vwBXg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHK0iDTzP9PM7pjw8RAngRAJ0aILL3p3nFcZYMzNNA45PkBfFgPACfZb/p
F+fSEEGlo/eJGFbP5wEFZjQ=
=UYGz
-----END PGP SIGNATURE-----

--=-cxV1PItBJE4CM92vwBXg--

