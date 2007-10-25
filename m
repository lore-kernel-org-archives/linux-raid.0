From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Thu, 25 Oct 2007 12:29:42 -0400
Message-ID: <1193329782.10336.105.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
	 <471A47CC.1070508@msgid.tls.msk.ru> <18205.2688.952701.567195@stoffel.org>
	 <1193186569.10336.30.camel@firewall.xsintricity.com>
	 <471FA970.6070209@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kqOAWmnkj8tz2lLL0jsf"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471FA970.6070209@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: John Stoffel <john@stoffel.org>, Michael Tokarev <mjt@tls.msk.ru>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-kqOAWmnkj8tz2lLL0jsf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 16:22 -0400, Bill Davidsen wrote:
> Doug Ledford wrote:
> > On Mon, 2007-10-22 at 16:39 -0400, John Stoffel wrote:
> >
> >  =20
> >> I don't agree completely.  I think the superblock location is a key
> >> issue, because if you have a superblock location which moves depending
> >> the filesystem or LVM you use to look at the partition (or full disk)
> >> then you need to be even more careful about how to poke at things.
> >>    =20
> >
> > This is the heart of the matter.  When you consider that each file
> > system and each volume management stack has a superblock, and they some
> > store their superblocks at the end of devices and some at the beginning=
,
> > and they can be stacked, then it becomes next to impossible to make sur=
e
> > a stacked setup is never recognized incorrectly under any circumstance.
> > It might be possible if you use static device names, but our users
> > *long* ago complained very loudly when adding a new disk or removing a
> > bad disk caused their setup to fail to boot.  So, along came mount by
> > label and auto scans for superblocks.  Once you do that, you *really*
> > need all the superblocks at the same end of a device so when you stack
> > things, it always works properly.
> Let me be devil's advocate, I noted in another post that location might=20
> be raid level dependent. For raid-1 putting the superblock at the end=20
> allows the BIOS to treat a single partition as a bootable unit.

This is true for both the 1.0 and 1.2 superblock formats.  The BIOS
couldn't care less if there is an offset to the filesystem because it
doesn't try to read from the filesystem.  It just jumps to the first 512
byte sector and that's it.  Grub/Lilo are the ones that have to know
about the offset, and they would be made aware of the offset at install
time.

So, we are back to the exact same thing I was talking about.  With the
superblock at the beginning of the device, you don't hinder bootability
with or without the raid working, the raid would be bootable regardless
as long as you made it bootable, it only hinders accessing the
filesystem via a running linux installation without bringing up the
raid.

>  For all=20
> other arrangements the end location puts the superblock where it is=20
> slightly more likely to be overwritten, and where it must be moved if=20
> the partition grows or whatever.
>=20
> There really may be no "right" answer.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-kqOAWmnkj8tz2lLL0jsf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIMR2TzP9PM7pjw8RAl5GAJ9I9qZ29N9+44jS876FaqFol7ewEQCfbSfP
VNX2HmGqptbGKh+HCnlBV0o=
=UAxa
-----END PGP SIGNATURE-----

--=-kqOAWmnkj8tz2lLL0jsf--

