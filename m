From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 23 Oct 2007 20:42:49 -0400
Message-ID: <1193186569.10336.30.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
	 <471A47CC.1070508@msgid.tls.msk.ru>  <18205.2688.952701.567195@stoffel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5715/0vqV5dctfL3P+zG"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18205.2688.952701.567195@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-5715/0vqV5dctfL3P+zG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-22 at 16:39 -0400, John Stoffel wrote:

> I don't agree completely.  I think the superblock location is a key
> issue, because if you have a superblock location which moves depending
> the filesystem or LVM you use to look at the partition (or full disk)
> then you need to be even more careful about how to poke at things.

This is the heart of the matter.  When you consider that each file
system and each volume management stack has a superblock, and they some
store their superblocks at the end of devices and some at the beginning,
and they can be stacked, then it becomes next to impossible to make sure
a stacked setup is never recognized incorrectly under any circumstance.
It might be possible if you use static device names, but our users
*long* ago complained very loudly when adding a new disk or removing a
bad disk caused their setup to fail to boot.  So, along came mount by
label and auto scans for superblocks.  Once you do that, you *really*
need all the superblocks at the same end of a device so when you stack
things, it always works properly.

> Michael> Another example is ext[234]fs - it does not touch first 512
> Michael> bytes of the device, so if there was an msdos filesystem
> Michael> there before, it will be recognized as such by many tools,
> Michael> and an attempt to mount it automatically will lead to at
> Michael> least scary output and nothing mounted, or in fsck doing
> Michael> fatal things to it in worst scenario.  Sure thing the first
> Michael> 512 bytes should be just cleared.. but that's another topic.
>=20
> I would argue that ext[234] should be clearing those 512 bytes.  Why
> aren't they cleared =20

Actually, I didn't think msdos used the first 512 bytes for the same
reason ext3 doesn't: space for a boot sector.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-5715/0vqV5dctfL3P+zG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHHpUJTzP9PM7pjw8RAmLMAJ9jrlgJugBnnv5VGcNvH9hCDhW11gCaAsru
gq3oYI271b9Cpe6z2Mnhetc=
=nlvq
-----END PGP SIGNATURE-----

--=-5715/0vqV5dctfL3P+zG--

