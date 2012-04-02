From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:Remove unnecessary judgement.
Date: Mon, 2 Apr 2012 11:25:43 +1000
Message-ID: <20120402112543.4d5b0abe@notabene.brown>
References: <201203311005202344147@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Px35EJJLra336lYqIuEU0UH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203311005202344147@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Px35EJJLra336lYqIuEU0UH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Mar 2012 10:05:23 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 033a0330eb210750ec09202ed95696b54d9afeba Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Sat, 31 Mar 2012 09:57:42 +0800
> Subject: [PATCH] md/raid1:Remove unnecessary judgement.=20
> If success =3D=3D 1 then  break the do{}while,so did not judge !success.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..649941b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1624,7 +1624,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>  			d++;
>  			if (d =3D=3D conf->raid_disks * 2)
>  				d =3D 0;
> -		} while (!success && d !=3D r1_bio->read_disk);
> +		} while (d !=3D r1_bio->read_disk);
> =20
>  		if (!success) {
>  			char b[BDEVNAME_SIZE];

This is another micro-optimisation that doesn't really buy us anything.

I actually like the fact that the 'while' condition makes it clear that lot
loop doesn't continue after we reach 'success'.  So I think I'll leave it t=
he
way it is.

Thanks,
NeilBrown


--Sig_/Px35EJJLra336lYqIuEU0UH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3kAFznsnt1WYoG5AQJPsg/+PSKqZ9WkXJPrNwlUBKasl4W5WvLSl3cx
DdtG7qIUbbF5Zv0UDOGlbAUlGcVbw/pAEd+zqMrfHe68oHQA/Ay53VmsxRy0mst9
ulUcRXP9IAOX0DYn6LFQj3F/0cAECtSWKKLAOIypDuE3GHzaxZU1VwSgUoMJMxak
9thx5BGvl4irgDi+TC3pYEQwJg4NI7NiRcAaoECMH8hxKSAXhfFKLpTKvXKbgjTZ
eQTUgY/bSPB5LJSxLxZpFe4IA/cazIA+V+Y337WbvJCTC+i58NAlsEnug48DycJS
96oD4QqzH3lDggszMJyEnJH0Ax5RWmasKAgNrl7G7DcF7IoAifW7v7isprtA0s1F
h5dfP8FZKr+76BUKRUdFt5gcfyBZOHIXcNPAGTEbu+mLjc+2uFCunHq+ZmdlCnAa
iLYBV2a7PHA9e5BeewXoeN/a8CJbrdxAgi0WZDTDvgd2iQX6dZnHcozhUBZozcCA
IFR22jEiHGOc1yzfmi2Fi10mBq7Xbgw+WaB0p5i8aX/CrSXPrfW2JFfvqBBHSeig
9Gg3B/gS9FrrtqdaSh1wXywOor/0q5kl5cISC0uWiXBA51Yu98HPSZyU6rCLMLqL
hG15Ccszuy4I5Tedh2ZZ/0McCqBl6WkS1GtdV7tMg04rXaeTh+QKmasIc4HVNWxi
d1YwgkF64zs=
=44wP
-----END PGP SIGNATURE-----

--Sig_/Px35EJJLra336lYqIuEU0UH--
