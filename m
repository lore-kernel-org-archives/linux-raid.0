From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3 of 4] MD RAID10:  Improve redundancy for 'far' and
 'offset' algorithms (part 2)
Date: Mon, 7 Jan 2013 17:04:29 +1100
Message-ID: <20130107170429.79325ccd@notabene.brown>
References: <1355769616.15326.25.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nkBJZGE/8Lo0F5Diqx/coXo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355769616.15326.25.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids

--Sig_/nkBJZGE/8Lo0F5Diqx/coXo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Jon,
 I really like the way you have coded this - it makes for very neat code.

 I'm happy to take  it as it is, however I'll just note a couple of little
 issues that you could change if you like:

> --- linux-upstream.orig/drivers/md/raid10.c
> +++ linux-upstream/drivers/md/raid10.c
> @@ -550,6 +550,13 @@ static void __raid10_find_phys(struct ge
>  	sector_t stripe;
>  	int dev;
>  	int slot =3D 0;
> +	int last_far_set_start, last_far_set_size;
> +
> +	last_far_set_start =3D (geo->raid_disks / geo->far_set_size) - 1;
> +	last_far_set_start *=3D geo->far_set_size;
> +
> +	last_far_set_size =3D geo->far_set_size;
> +	last_far_set_size +=3D (geo->raid_disks % geo->far_set_size);
> =20
>  	/* now calculate first sector/dev */
>  	chunk =3D r10bio->sector >> geo->chunk_shift;
> @@ -575,9 +582,16 @@ static void __raid10_find_phys(struct ge
>  		for (f =3D 1; f < geo->far_copies; f++) {
>  			set =3D d / geo->far_set_size;
>  			d +=3D geo->near_copies;
> -			d %=3D geo->far_set_size;
> -			d +=3D geo->far_set_size * set;
> =20
> +			if ((geo->raid_disks % geo->far_set_size) &&
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This test isn't needed.  If it is false, then last_far_set_size will be the
same as geo->far_set_size, so both branches will do the same thing.


> +			    (d > last_far_set_start)) {
> +				d -=3D last_far_set_start;
> +				d %=3D last_far_set_size;
> +				d +=3D last_far_set_start;
> +			} else {
> +				d %=3D geo->far_set_size;
> +				d +=3D geo->far_set_size * set;
> +			}
>  			s +=3D geo->stride;
>  			r10bio->devs[slot].devnum =3D d;
>  			r10bio->devs[slot].addr =3D s;
> @@ -615,6 +629,18 @@ static sector_t raid10_find_virt(struct
>  	struct geom *geo =3D &conf->geo;
>  	int far_set_start =3D (dev / geo->far_set_size) * geo->far_set_size;
>  	int far_set_size =3D geo->far_set_size;
> +	int last_far_set_start;
> +
> +	if (geo->raid_disks % geo->far_set_size) {

Similarly I don't think this test is needed - just perform the following co=
de
in any case.
Maybe you will think the code is more clear the way it is.  If so, I'm fine
to leave it as it is.

Thanks,
NeilBrown



> +		last_far_set_start =3D (geo->raid_disks / geo->far_set_size) - 1;
> +		last_far_set_start *=3D geo->far_set_size;
> +
> +		if (dev >=3D last_far_set_start) {
> +			far_set_size =3D geo->far_set_size;
> +			far_set_size +=3D (geo->raid_disks % geo->far_set_size);
> +			far_set_start =3D last_far_set_start;
> +		}
> +	}
> =20
>  	offset =3D sector & geo->chunk_mask;
>  	if (geo->far_offset) {
>=20


--Sig_/nkBJZGE/8Lo0F5Diqx/coXo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUOplbTnsnt1WYoG5AQKAkA//YAaIABmi31z0kkdnaAFFutLhfIB1Pu3m
GB2ICdAWuGoVMK7V4DeNjSh/sfkpX9IEVwwAZRHvijmj74v24T0o7I04ygKS71HN
VS7wnzpjysdC92N8LhDC9GM1QTrwQ5yi62TfK/cpjmmbjApCevfiQaO04kFgPQX7
ltLMy/zO2G/FR4qr+r1VpmHQSCxj4Pmbt9rMnJDI15Wdywg54Ng7d3mfmuK6xup5
KQrtwHL4QTkx7HpJF909JB+iix0js4jpb/+EG2SmZWeHUju1qsG2pFfV3S0vWDGQ
AVsuVQqAs/e873paKi7v/pHgyW/60HZybvbfW/q+rS5EUU0buDdlVP4lT3k40jwM
m62z6i5FHLKjP1Ss7ZJbRRZBxSkQrJ2L1szpLqZPrAD/CHmSS1ETnhCkAtJ1nBV/
W8jjjyIkhFP0O9ZJpTrOdVBNvmL9HLxhyCULoO7xgtWcMc8IvfufVZ76hVkhxpuA
sqldLyiE1BHKyGMNJALmfGiNT3NOqmedkcOsQWfxb+cNwlaPSY+EmCTYQAykK0Ch
1m36aUendAWuRUyzWaQ0MBTghoWDVx83wlmPOn7lO00n8qZzva3Z53i071bm1z9U
xd60nf39nSs6IncKZe+aY6kRRueZMDuMPeiplzKBtXw/3uNQ9pTsjR38yNHv+v4R
Jo61EOfu9FY=
=1bTY
-----END PGP SIGNATURE-----

--Sig_/nkBJZGE/8Lo0F5Diqx/coXo--
