From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Mon, 21 Aug 2006 18:47:32 -0400
Message-ID: <1156200453.19051.13.camel@fc6.xsintricity.com>
References: <1155987607.7207.23.camel@localhost.localdomain>
	 <17641.25141.373827.77279@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F3vRgtHny3m3hvAUCQTf"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17641.25141.373827.77279@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Lem <l3mming@iinet.net.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-F3vRgtHny3m3hvAUCQTf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-08-21 at 17:35 +1000, Neil Brown wrote:

> > Buffer I/O error on device sde3, logical block 1793
>=20
> This, on the other hand, might be a problem - though possibly only a
> small one.
> Who is trying to access sde3 I wonder.  I'm fairly sure the kernel
> wouldn't do that directly.

It's the mount program collecting possible LABEL=3D data on the partitions
listed in /proc/partitions, of which sde3 is outside the valid range for
the drive.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-F3vRgtHny3m3hvAUCQTf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBE6jgEg6WylM+/8ZQRAt/eAKCrN7NjbtagaF1th0uYQtVTEGjcCACdFAYM
LbxS+TIrOmZD9lfKdbpYv0M=
=jt/R
-----END PGP SIGNATURE-----

--=-F3vRgtHny3m3hvAUCQTf--

