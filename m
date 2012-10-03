From: NeilBrown <neilb@suse.de>
Subject: Re: [patch] md/raid10: use correct limit variable
Date: Wed, 3 Oct 2012 11:51:05 +1000
Message-ID: <20121003115105.304923a6@notabene.brown>
References: <20121002080422.GA12398@elgon.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HJ8oW3i40R+7Lgm_X/aEpP="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121002080422.GA12398@elgon.mountain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HJ8oW3i40R+7Lgm_X/aEpP=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Oct 2012 11:04:22 +0300 Dan Carpenter <dan.carpenter@oracle.com>
wrote:

> Clang complains that we are assigning a variable to itself.  This should
> be using bad_sectors like the similar earlier check does.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 56149ce..4448624 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3219,7 +3219,7 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr,
>  				else {
>  					bad_sectors -=3D (sector - first_bad);
>  					if (max_sync > bad_sectors)
> -						max_sync =3D max_sync;
> +						max_sync =3D bad_sectors;
>  					continue;
>  				}
>  			}

We sure do have some careless programmers around here :-(

That bug has been there since 3.1-rc1.

Thanks for finding it!

NeilBrown

--Sig_/HJ8oW3i40R+7Lgm_X/aEpP=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGuaCTnsnt1WYoG5AQLX2xAAwLKoCitB5jLx6y7wm3DtprlJBDYliIHt
JkfjLqZSgZkZ4eLO2sUcbjY5F2402svutI4IWzES9miA7s76eW04mtjBp1BLybBS
nFFCY0XF4cWme3EQMX3nBoO8f3CeCyIxAV+qbYnrtEzcCBLoApIMRnKFiAJywD/8
w/z0Pe7+ByaPg9DVN7NO/cOfFIVauzhYEE/7V3uP+PWAtmgJ6eWTTVEkAehxgsJG
ri1+VJkK20hqSstTozaG/9AqUrPflENprkvT3aSxrnWOJAbWMJKYxR0kTExwxLqd
wE13lbTtNP9fJKkc/uSh7gmEotLz1vv5LeU4QGPN0f/CJ3SbNDVV5AfABQyz+GfU
Leiu8TSPa9AEF0VxDgTm7zBr8YEjtY7FMTf1bPhbP3Q/E4/7/OSrOnG/la0Q9SKH
3DG5cbX5eY1/6JCANd+0Qsi4JhD1kNbrZEh6umlllPow/+Dan0v0nLUE5svAdWE5
//S4XD2pElR85cAm+jWLS5GFZbFUwYS/0nlvylQ0QFkt2JH7y7wua9Rl+YXayL0k
mJEpK50jE4t+pUGdAbLkrjDP+7WOGe8tmgLcx2kae/JpfzVkajaVj08n/opyN2Oj
+aLrbRrklarwibgK8UYATQIudjW3modsrI0RBod84LtoKHrNmvu4/RzNT0QVXU7L
mVwdffPl4oo=
=oxzC
-----END PGP SIGNATURE-----

--Sig_/HJ8oW3i40R+7Lgm_X/aEpP=--
