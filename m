From: Andre Noll <maan@systemlinux.org>
Subject: Re: Size limitation?
Date: Sun, 3 Jan 2010 21:33:36 +0100
Message-ID: <20100103203336.GM21495@skl-net.de>
References: <201001011457.24334.mmclagan@invlogic.com> <4B3E85B3.6080607@matfyz.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z8Ydz/NZAVzoOg+6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B3E85B3.6080607@matfyz.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Behan <rain@matfyz.cz>
Cc: mmclagan+reply@invlogic.com, Michael McLagan <mmclagan@invlogic.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--z8Ydz/NZAVzoOg+6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:30, Zdenek Behan wrote:
> On 01/01/2010 08:57 PM, Michael McLagan wrote:
> >    I'm trying to set up a large array but isn't working.  I tried=20
> > Googling size limits, etc and came up empty.
> >
> > The problem is that with 10 drives (300GB SCSI), the array is coming up=
=20
> > with 500GB of space?!?  I did an experiment and when the array size=20
> > exceeds 2TB, it fails/wraps?
> >  =20
> Just curious, did you compile your kernel with LBD (Large Block Device)
> support?

Jup, missing LBD support would explain what Michael is seeing. That
begs the question why md happily creates arrays > 2T on a kernel
witout LBD support..

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--z8Ydz/NZAVzoOg+6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLQP8gWto1QDEAkw8RAg2oAJ95cG6ZMdEs2tg1pdFBQyQQil8wlQCdHl8W
j6jd5RoGXkbEmKV9J/bwae0=
=hB9F
-----END PGP SIGNATURE-----

--z8Ydz/NZAVzoOg+6--
