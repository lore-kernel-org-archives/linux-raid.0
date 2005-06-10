From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: RAID 5 of RAID 5's?
Date: Fri, 10 Jun 2005 13:43:39 -0700
Message-ID: <1118436219.25226.252.camel@seki.nac.uci.edu>
References: <1118187572.15459.96.camel@seki.nac.uci.edu>
	 <42A93D30.6080900@apartia.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CMFgK4IKg7BQMC1vU67e"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A93D30.6080900@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CARON <lcaron@apartia.fr>
Cc: strombrg@dcs.nac.uci.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-CMFgK4IKg7BQMC1vU67e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-06-10 at 09:11 +0200, Laurent CARON wrote:
> Dan Stromberg a =E9crit :
>=20
> >Has anyone constructed a RAID 5 of RAID 5's using mdadm on a linux
> >system?
> >
> >Was it reliable?
> >
> >How large was it?
> >
> >Thanks!
> >
> > =20
> >
> Seems to be a large waste of space....

Consider:

You have a bunch of "bricks" that can shuffle data between a NAS head
and a bunch of disks.

The disks are RAID'd (through the "bricks"), but if one of the bricks
themselves dies, you're kinda stuck.

But if you RAID 5 the RAID 5's, then you don't end up with massive
parity pounding, and your bricks aren't a single point of failure, and
you don't lose as much space as if you mirrored.

Sound copacetic?

Thanks for your feedback!


--=-CMFgK4IKg7BQMC1vU67e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCqft7o0feVm00f/8RAj8AAJ4ncBYn58pB4FbEwz89YU405wJ8gwCdF1rX
m9MOqal0dwYXInjAHRezkJA=
=s+Vz
-----END PGP SIGNATURE-----

--=-CMFgK4IKg7BQMC1vU67e--

