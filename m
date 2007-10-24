From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 23 Oct 2007 20:09:15 -0400
Message-ID: <1193184555.10336.3.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>  <471E7DC6.7050206@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aKqY8qUVQMJPqDjlj8XA"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471E7DC6.7050206@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-aKqY8qUVQMJPqDjlj8XA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-23 at 19:03 -0400, Bill Davidsen wrote:
> John Stoffel wrote:
> > Why do we have three different positions for storing the superblock? =20
> >  =20
> Why do you suggest changing anything until you get the answer to this=20
> question? If you don't understand why there are three locations, perhaps=20
> that would be a good initial investigation.
>=20
> Clearly the short answer is that they reflect three stages of Neil's=20
> thinking on the topic, and I would bet that he had a good reason for=20
> moving the superblock when he did it.

I believe, and Neil can correct me if I'm wrong, that 1.0 (at the end of
the device) is to satisfy people that want to get at their raid1 data
without bringing up the device or using a loop mount with an offset.
Version 1.1, at the beginning of the device, is to prevent accidental
access to a device when the raid array doesn't come up.  And version 1.2
(4k from the beginning of the device) would be suitable for those times
when you want to embed a boot sector at the very beginning of the device
(which really only needs 512 bytes, but a 4k offset is as easy to deal
with as anything else).  From the standpoint of wanting to make sure an
array is suitable for embedding a boot sector, the 1.2 superblock may be
the best default.

> Since you have to support all of them or break existing arrays, and they=20
> all use the same format so there's no saving of code size to mention,=20
> why even bring this up?
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-aKqY8qUVQMJPqDjlj8XA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHHo0kTzP9PM7pjw8RAjuQAJ4iDa3Awhqr1ajG+BSuVBsypCbV2QCaA1HZ
nk+f+ziN+jhpL3hPiYj98P8=
=fZzh
-----END PGP SIGNATURE-----

--=-aKqY8qUVQMJPqDjlj8XA--

