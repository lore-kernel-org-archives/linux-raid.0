From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: 3Ware on 64bit Linux.
Date: Wed, 08 Jun 2005 12:58:40 -0700
Message-ID: <1118260720.15459.177.camel@seki.nac.uci.edu>
References: <602f2f2b050608100938ddad81@mail.gmail.com>
	 <200506081156.31051.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/b3rNV0ke4hDJpxs/O6A"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506081156.31051.hjm@tacgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <hjm@tacgi.com>
Cc: strombrg@dcs.nac.uci.edu, Jason Leach <jason.leach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-/b3rNV0ke4hDJpxs/O6A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-06-08 at 11:56 -0700, Harry Mangalam wrote:

>=20
> Dan Stromberg who has been posting here recently can speak to the=20
> viability/reliability of the right Maxtor disks to use, but the 3ware tec=
h=20
> said that the WD SD series disks were very reliable and fast.

I have a writeup of the 3ware+maxtor SATA mess we just got a refund on
at:

http://dcs.nac.uci.edu/~strombrg/3ware-maxtor-notes.html

...but in short, we never determined definitively if the hardware
problems (there were software problems too) were due to the RAID
controllers or the disks.  The integrator we were working with was
blaming the disks, but sometimes we'd get repeated failures with
different disks in the same slot of a given RAID controller.


--=-/b3rNV0ke4hDJpxs/O6A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCp03wo0feVm00f/8RAig5AKCbGO9cUOh9FXIGDD9/hkKCaC/MqwCeMqIz
K4gFTm0y7tPPco1ZpqEtdug=
=CiJP
-----END PGP SIGNATURE-----

--=-/b3rNV0ke4hDJpxs/O6A--

