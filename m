From: NeilBrown <neilb@suse.de>
Subject: Re: unable to assemble (mostly?) clean array
Date: Mon, 9 Dec 2013 12:02:17 +1100
Message-ID: <20131209120217.54dd3082@notabene.brown>
References: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
	<52A5089D.3080109@websitemanagers.com.au>
	<CACw0PsYs+UwDVoPXAB6qf8j8OhU5qd8YhEeTj4Bok9aNR+bVew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1fvK7eKljZ02L37nMD=p+Op"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACw0PsYs+UwDVoPXAB6qf8j8OhU5qd8YhEeTj4Bok9aNR+bVew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Hoover <ch@murgatroid.com>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1fvK7eKljZ02L37nMD=p+Op
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Dec 2013 16:32:22 -0800 Christopher Hoover <ch@murgatroid.com>
wrote:

> yes, thanks, typo there.  that was done hastily for the e-mail.
>=20
> i had tried the right thing previously and here it is again.  still no lu=
ck:
>=20
>=20
> ch@snaggle:~$ sudo mdadm -E /dev/sd[defg]1 | egrep 'Events|^/dev/sd'
> /dev/sdd1:
>          Events : 286024
> /dev/sde1:
>          Events : 286011
> /dev/sdf1:
>          Events : 286024
> /dev/sdg1:
>          Events : 286024
> ch@snaggle:~$ sudo mdadm --assemble --force /dev/md0  /dev/sd[dfg]1
> mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
> mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
> start the array.
> ch@snaggle:~$

Please try listing *all* of the devices, and add "-v" for extra output.

NeilBrown

--Sig_/1fvK7eKljZ02L37nMD=p+Op
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqUWmTnsnt1WYoG5AQJ1qhAAtNSAA8Pw1U8lKK5hujjTGSPnEFsntszM
iaIaYelZziiI2aido2lj2iSjITiJk4H7UPLaLMUlLAUbYPW6qnKGbIS1yRwyjhGm
iohekPiCXbUTFlhtU/3ObNjn5m+aiFENRi+Y5XWP0hWs4rjtJYYRwV6yS7oYpZHQ
Gw7RFcsjr1sHcCGCPl2YDPywZGUMvGdePv0pJNowJ8k+nCVjLXUxCrQlnOEIZu1j
oz71Chqnuc5XmpNC7klCRLidw+CY3wkgWBoZ6qndfE6vb3OY5Oz+kPlBgb+wDsEw
EhANcmP6mPd5hQHFN/wC6Tsl9+jrGcitraaJFfzr72B+sW3TJhlMrcHaz/K6qIpd
yVudozCLlSOqih6cCzLR/DTfyW7tGNjNn7wsqX8d6ztDtvAOGnFYBYXJNkzzqU9K
2FT2FAMb0Y/bm/FfB2ffQZHzKjW9kXQrzooBfImHZF94nt/O1fv8Mgt9ZRwPgDkt
N5M+JpaYdXQp5BIsVl/6QkvAcYeHSJZHurnEjKeflKMNuPN0FL5dTR1rr17dmF4c
lvllB3rSJtRwp+JleiKNCwkH99TwFFpEb+KbMPhZ8oWV9BbHwwK3kc5YgdSi+sLk
crbkCtHJrsM5RMaV8Si6tqHWtenNPP2taorFa2al36XoOwC2uKDR29foLIo46U6R
9GmXhaj3EUs=
=9gyn
-----END PGP SIGNATURE-----

--Sig_/1fvK7eKljZ02L37nMD=p+Op--
