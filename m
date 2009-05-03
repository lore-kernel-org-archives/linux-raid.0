From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: 32bit variables on >2T arrays
Date: Sun, 3 May 2009 16:27:28 +0200
Message-ID: <20090503142728.GA1591@darkside.22.kls.lan>
References: <20090503141300.GA30773@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090503141300.GA30773@darkside.22.kls.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 03, 2009 at 04:13:00PM +0200, Mario 'BitKoenig' Holbe wrote:
> there seems to be another (minor) 32bit-issue...
>       [>....................]  check =3D  0.6% (28034560/4395406848) fini=
sh=3D4.7min speed=3D254624K/sec

A little later it normalizes...

      [=3D>...................]  check =3D  6.1% (269385216/4395406848) fin=
ish=3D266.0min speed=3D258429K/sec

seems like it broke the 32bit barrier :)
4395406848 - 269385216 < 2^32


Mario
--=20
"Why are we hiding from the police, daddy?"      | J. E. Guenther
"Because we use SuSE son, they use SYSVR4."      | de.alt.sysadmin.recovery

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSf2p0BS+e2HeSPbpAQI9hwf/RqqKZwQQj9YEQCJuBoDBkZgxv0n0U8g5
lUAaAUcYxJ2Mn8vNsy2SAnN9UcCvJszwr0QXlGU6ssOW/hsOK51PYKDX/T6k9n3o
IlsIz/ZMg2eMdeuuIeX6Jo4WQPYhUwI//sqilLG0qTfSOX1TBF6P0xz+fSyeND7n
pU4rlYbRmRWUNfj3Y2n8jmwUT+GhyaAXQfV48UMnPgZgHo4Ygh7fK2qwLT9nlP/V
aTW6JP/qsRQVRBc0L/G8H1BsyeP/lidFfBy6VhfVZkemJkjx2dIKbR+1IiLS2+gH
+KTv4Heugdj3I2jvucVo4ULdtNALGIrjUsgKZfvRVRpIcDQJfDqT3g==
=Lqa/
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
