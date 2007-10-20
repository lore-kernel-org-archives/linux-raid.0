From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 16:02:58 -0400
Message-ID: <1192910578.1666.138.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
	 <18200.57042.989520.666476@stoffel.org>
	 <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
	 <1192813477.1666.74.camel@firewall.xsintricity.com>
	 <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan>
	 <1192814581.1666.87.camel@firewall.xsintricity.com>
	 <Pine.LNX.4.64.0710191347080.10857@p34.internal.lan>
	 <471A4B3F.907@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l+a8mvo8oIJoSINnH3gG"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471A4B3F.907@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-l+a8mvo8oIJoSINnH3gG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-20 at 22:38 +0400, Michael Tokarev wrote:
> Justin Piszcz wrote:
> >=20
> > On Fri, 19 Oct 2007, Doug Ledford wrote:
> >=20
> >> On Fri, 2007-10-19 at 13:05 -0400, Justin Piszcz wrote:
> []
> >>> Got it, so for RAID1 it would make sense if LILO supported it (the
> >>> later versions of the md superblock)
> >>
> >> Lilo doesn't know anything about the superblock format, however, lilo
> >> expects the raid1 device to start at the beginning of the physical
> >> partition.  In otherwords, format 1.0 would work with lilo.
> > Did not work when I tried 1.x with LILO, switched back to 00.90.03 and
> > it worked fine.
>=20
> There are different 1.x - and the difference is exactly this -- location
> of the superblock.  In 1.0, superblock is located at the end, just like
> with 0.90, and lilo works just fine with it.  It gets confused somehow
> (however I don't see how really, because it uses bmap() to get a list
> of physical blocks for the files it wants to access - those should be
> in absolute numbers, regardless of the superblock locaction) when the
> superblock is at the beginning (v 1.1 or 1.2).
>=20
> /mjt

It's been a *long* time since I looked at the lilo raid1 support (I
wrote the original patch that Red Hat used, I have no idea if that's
what the lilo maintainer integrated though).  However, IIRC, it uses
bmap on the file, which implies it's via the filesystem mounted on the
raid device.  And the numbers are not absolute I don't think except with
respect to the file system.  So, I think the situation could be made to
work if you just taught lilo that on version 1.1 or version 1.2
superblock raids that it should add the data offset of the raid to the
bmap numbers (which I think are already added to the partition offset
numbers).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-l+a8mvo8oIJoSINnH3gG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGl7yTzP9PM7pjw8RAtXrAJ4sn1E90DRjMmRq4U6dQ3j0SgXEpQCfa2wK
JJYxG4dLI3kS+gJyumvuM0M=
=xE1Z
-----END PGP SIGNATURE-----

--=-l+a8mvo8oIJoSINnH3gG--

