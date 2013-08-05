From: NeilBrown <neilb@suse.de>
Subject: Re: Bugreport: mdmon will not start with latest git version when
 using ddf container
Date: Mon, 5 Aug 2013 16:43:52 +1000
Message-ID: <20130805164352.3a721dae@notabene.brown>
References: <51F953FA.5000400@gmail.com>
	<20130801104433.1e7b41a5@notabene.brown>
	<CAGkViCGM5-ztFSh3d-yh=P0HNfvcPYr6p7g3rDfkmx2+8YaqEw@mail.gmail.com>
	<20130801152818.27cf61a5@notabene.brown>
	<CAGkViCGbxJofuBbU41QvfQbBdaAEQKe3BhrSXmKZv17rGC4jzQ@mail.gmail.com>
	<20130801165052.3285cacc@notabene.brown>
	<CAGkViCGcuv=Ves47LUedirzTPV6dxzRZKM2a2M0MFPgDdH8tZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/e_J9Qm+ltbn7dGB_8m0bfnf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCGcuv=Ves47LUedirzTPV6dxzRZKM2a2M0MFPgDdH8tZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/e_J9Qm+ltbn7dGB_8m0bfnf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Aug 2013 10:00:56 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:

> Hi Neil,
>=20
> just using standard Centos 6.4, looks like RedHat and its derivatives are
> not going the /run route for now.
>=20
> Yes, checking if it exists should be good. If not, resort to /var/run, and
> when that does not exist, fall back to /dev.
> That last step may be a bit superfluous, but a very safe fallback.
>=20

I rather not do too much guessing..
For now I've changed the Makefile so that if the relevant directory doesn't
exist it will fail and tell you how to avoid the failure.

Thanks,
NeilBrown

--Sig_/e_J9Qm+ltbn7dGB_8m0bfnf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUf9JqDnsnt1WYoG5AQJuXBAAswMkiOvDk7SPUvfyoyHHD1fb+4U9q/xD
96ErackgIBSjEMm2TR7bHBbZpI/EgJsOpXDNUyexPHHODT/FVjsTnM7oQwQr3xZt
3ECP6kzGwygIJin0AVtc8G7m4HOoNPIh5fh9a8jDK24IzgSUwA+ZDIE2rBijG/1t
F8b1OgAh3MsalvetO4PqbMYYDwT0jvi0rToQqnaSjHdiKJ7bCEjLCl+WfGadHOFe
1jnmVVD4jTrlBP7QUa7ymFubc+i0//bX2ayHP0I509I+wbdK0Lj/1m3XLPyPUK9j
jmJCNu8i4WjWz15GtGmexbjr0abeXtLm0xZxCoOpswugLGFhiKQiJgZOvHZPDmjE
5qefcfQCJ1CkiJVNoG4a0dOaLZNbM1+ML55C3UgChjiMmfuUkfYJuipVB/lwMfbq
6t0z36qSLOHIlVoltJce/3HwS/tkouBvblS3uzVja7wMreVyGFrCEkWS8MYwT3LW
8OeVvDOHk8hbLFCun8R94aFtSWzHevGff4tKVLI0ECKSRmk7FY0YUSPF+6SWCoj/
iZgByQCiktwTHf92VsA+hZm2a4m1KXG7LME8k8JlKooWhYzYlynic9Vi0l0db4jT
ITw3TqQ4FqHnwIBbLeqxKyyYtaGHi+4IhEVFsY833PaRdxvdqhbKkblg8piIEIOc
ZZJCCLoOStE=
=MJQD
-----END PGP SIGNATURE-----

--Sig_/e_J9Qm+ltbn7dGB_8m0bfnf--
