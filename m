From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid456:Remove the judgement
 atomic_read(&rdev->read_errors).
Date: Thu, 24 May 2012 09:40:22 +1000
Message-ID: <20120524094022.5a951c91@notabene.brown>
References: <201205232038121562929@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oy0P43lXQ8BlOYql_e+dtu6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205232038121562929@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/oy0P43lXQ8BlOYql_e+dtu6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 May 2012 20:38:16 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> It isn't necessary to judge.Because the atomic_read and atomic_set is exc=
uce same cpu. So
> read_errors is zero or not, directly set it zero.

'read' imposes less bus contention than 'write'.  And read_errors will most
often be 0.  So if we can avoid lots of unnecessary writes we should.

i.e. code is correct as it is.

Thanks,
NeilBrown


> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f351422..1fe2def 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1690,8 +1690,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
>  		}
> -		if (atomic_read(&rdev->read_errors))
> -			atomic_set(&rdev->read_errors, 0);
> +		atomic_set(&rdev->read_errors, 0);
>  	} else {
>  		const char *bdn =3D bdevname(rdev->bdev, b);
>  		int retry =3D 0;


--Sig_/oy0P43lXQ8BlOYql_e+dtu6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT711Zjnsnt1WYoG5AQKw2g//R12LCGozmSUUYLWLNqrxAomJ1pHkNi+x
SbKyERk/37MTA9+GUl0fTvq6V+SkebwZMRv8jZA0K0WUWcfwIfGzanuax2UTpF0h
qRGejaJEsZgxMmuMwg7vSKoK9WvdOokLSXj3MG3i5WDWWIFz5hwFejBUF8gZSNNA
j1bVURkBNjPvu8Z9nAWwGNLQmrsF5o300MmShr/r9/byd/woAQCT9HbB1x2TGn75
pUHVWwaosPwPDn8wwogrDnrlnMn4lSAIex4nkOvDFx8p/+XhWgfXo/GshL8gywLF
AKeMJGjPNvzzBOR6nMuH7hfN3/mxIEQaEU35QopQrPuW6klCunS8ra5n/44QdVoM
MLxpfSa99dR0gORGJKNmcJyserf8JFjkkL/MNE6mnTeGFc1LWymleSNl4LOxXfxT
40UPT7ZyafcDdInhd6igt5mT6lWFzzN+/rCM0KrSYrDDAM2q9pll7SbaoP8XmsB1
UXTK4kk5mVMwMG9ZEY1nPaELybYFPccOiugKQz/Nt/O/nJuU+kMfQQss1uJOH0vx
G46XqGt7JLnson25flA2bXnAR+D+4+xoRC3gH746df2BuVWFH279UHObSNk+2En5
OXRmWWgwbwiQ6+uJeS4RDwUtbxipVXF67DRCMO8NEwqGMexZcrUfJBfWO5X+DAQ7
o+JtL1eVC/g=
=muJ4
-----END PGP SIGNATURE-----

--Sig_/oy0P43lXQ8BlOYql_e+dtu6--
