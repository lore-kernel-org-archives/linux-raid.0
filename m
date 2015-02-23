From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 02/24] Add number of nodes to bitmap structure for
 clustering
Date: Mon, 23 Feb 2015 12:38:48 +1100
Message-ID: <20150223123848.01416b69@notabene.brown>
References: <20141218161523.GA29576@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/20.0PYKxnoe61_eNZs5mOOq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141218161523.GA29576@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/20.0PYKxnoe61_eNZs5mOOq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Dec 2014 10:15:23 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/bitmap.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index 30210b9..6872945 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -128,10 +128,11 @@ typedef struct bitmap_super_s {
>  	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
>  	__le32 daemon_sleep; /* 56  seconds between disk flushes */
>  	__le32 write_behind; /* 60  number of outstanding write-behind writes */
> -	__le32 sectors_reserved; /* 64 number of 512-byte sectors that are
> +	__le32 nodes;        /* 64 the maximum number of nodes in cluster. */
> +	__le32 sectors_reserved; /* 68 number of 512-byte sectors that are
>  				  * reserved for the bitmap. */
> =20
> -	__u8  pad[256 - 68]; /* set to zero */
> +	__u8  pad[256 - 72]; /* set to zero */
>  } bitmap_super_t;
> =20
>  /* notes:

Hi Goldwyn,
 I was reviewing you latest series to make sure it wouldn't affect the
 non-clustered use case at all, and I found this.  I really should have
 noticed it earlier....

 You are changing the location of 'sectors_reserved' in the bitmap superblo=
ck.
 That obviously cannot be allowed - new fields must always be added to the
 end.

 Can you update the series in git to fix that please?  Then I will pull it =
in
 for -next.

Thanks,
NeilBrown

--Sig_/20.0PYKxnoe61_eNZs5mOOq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOqEqDnsnt1WYoG5AQKoyQ/+JctIhnHwz2dJGvOXUQ4wMBhlEwyAfKa0
Yqn4AQg9X6aYFs1GuudghEcyZmzb4HWiuMbivyB6TwL98dZGu/ofk42m91iVhLiN
LC073MkW1e53Txc6CuZu73iC0u+BOtucIdbpGj9UjPk1BSglU44K+YIK11DcOvct
Jav/tsrVWrI+fzctRooAXE6Frz3e/3Mb/7Nv3Wnx7PEWSCuXZwNnIKyUdvQ7wNcC
V+uFbrElfqLPQlmXYpZ08swPndxFi2PjbumerH6jYoyHF3rJzRcajrly5DQOwPWP
egvP4GrDZnGGzqqjRdrsSnub3uTjHvgowYgfGeldWlAk2SSUWd4WqWG4l7PfZhbh
vRGBfS0OUSfmXgTi81jBY+RbSiReDQ6V7Y/QTpKRRTHRwNxFdaRT192Ypc8mMbtF
6K4F4D14zgsdtAbB0qjW+bO4Qhywdz3pmCsKmVYAWyr1US4h+m/8LG16vq+2alQG
YF5yIRLOwXeygfpgC5oZBx5R+4ibgLuocr2DC7s9K4C6FQteAnN41Pust+rdzYfr
yPQETMvWvXKcwNjqRx8bkZQvIex6RXxsU+2pfSCEXDxtLC9wkkdnvMxT1NJldMl8
vV7dbhDii+ec70ffi5CW7FpUUzrg06yhtkSZLCO7UST2UjRMfQeAB24gI7jIwH6k
cXw8QViRhgg=
=BU2q
-----END PGP SIGNATURE-----

--Sig_/20.0PYKxnoe61_eNZs5mOOq--
