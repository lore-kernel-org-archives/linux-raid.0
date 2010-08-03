From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Replacing a drive in RAID 0
Date: Tue, 3 Aug 2010 13:46:58 +0600
Message-ID: <20100803134658.4e48c97c@natsu>
References: <1c7fae50481e2f053798107bf2ad2737@localhost>
	<alpine.DEB.1.10.1008030720540.19930@uplift.swm.pp.se>
	<20100803161456.31d0f69b@notabene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZFG2cFMXjGUAARznsogSJDM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100803161456.31d0f69b@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Ben Nemec <lists@nemebean.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZFG2cFMXjGUAARznsogSJDM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Aug 2010 16:14:56 +1000
Neil Brown <neilb@suse.de> wrote:

> > Yes, you can binary copy the drive like that, that's what I usually do.
>=20
> Of course you need to be sure that the old and new devices are exactly the
> same size.  Normally they will but it is worth double checking that the
> number of sectors (blockdev --getsize) is exactly the same.

Isn't it okay for the new drive to be larger? At least if the RAID0 was
created from partitions, not whole block devices.
And if it was created from devices, there is a way to make the new larger
drive to be of exactly the same size as the old one, by setting a HPA on it
(see hdparm -N).

--=20
With respect,
Roman

--Sig_/ZFG2cFMXjGUAARznsogSJDM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxXyXIACgkQTLKSvz+PZwiEUACfbTO6YT24MpqiqCqBxCJ7gUt/
gxUAn3BZgwOO/0u8/nHKwtRK3hqr9Swy
=YMsq
-----END PGP SIGNATURE-----

--Sig_/ZFG2cFMXjGUAARznsogSJDM--
