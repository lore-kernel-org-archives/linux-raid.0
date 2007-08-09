From: Andy Smith <andy@lug.org.uk>
Subject: Re: Mustn't be RAID 1 and 0 read-performance be similar?
Date: Thu, 9 Aug 2007 14:13:10 +0000
Message-ID: <20070809141310.GM27603@bitfolk.com>
References: <735D322AED9CD711BE53000476917CD00281A96B@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6axCafNXXMM8qu6Q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <735D322AED9CD711BE53000476917CD00281A96B@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--6axCafNXXMM8qu6Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Thu, Aug 09, 2007 at 09:15:53AM +0200, Rustedt, Florian wrote:
> On RAID 1, it is possible, to read two blocks in parallel to speed up, to=
o.
>=20
> I tried to measure this some weeks ago, but i couldn't get over the
> read-performance of a single disk on my raid 1, so that means, that the
> software-raid does not use this easy possibility to speed up?

Were you doing this with a single thread or multiple threads?  My
understanding is that for RAID-1, a single thread's IO will come
=66rom whichever component is knwon to be closest to where it needs to
start reading from.

If that's not correct I'd love to hear the reality!

Cheers,
Andy

--6axCafNXXMM8qu6Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGuyD2IJm2TL8VSQsRAknCAJ9oruZDjRjFVvbSiRQKC4xBr7QKfwCfVkoD
eiFqqJV2DVNjGlDKn99PQzw=
=BM+/
-----END PGP SIGNATURE-----

--6axCafNXXMM8qu6Q--
