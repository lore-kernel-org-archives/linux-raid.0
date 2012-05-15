From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: [PATCH] Don't consider disks with a valid recovery
 offset as candidates for bumping up event count
Date: Tue, 15 May 2012 14:21:04 +1000
Message-ID: <20120515142104.41a80d73@notabene.brown>
References: <CAGRgLy5tEups--dzoV6+bq+CzZzwYMy7tv0FFJqah-Q5ZJc6kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R+Bs.zQfDi28zujcNxO1om0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5tEups--dzoV6+bq+CzZzwYMy7tv0FFJqah-Q5ZJc6kA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/R+Bs.zQfDi28zujcNxO1om0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 May 2012 13:10:43 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> do you think the below patch sounds reasonable?

Yes, looks good.  Applied.

Thanks,
NeilBrown



>=20
> Thanks,
> Alex.
>=20
>=20
> >From 98adc21bba9cf5d77214d665f2218fd7de2623b9 Mon Sep 17 00:00:00 2001
> From: Alex Lyakas <alex@zadarastorage.com>
> Date: Sun, 13 May 2012 13:04:24 +0300
> Subject: [PATCH] Don't consider disks with a valid recovery offset as
>  candidates for bumping up event count.
>=20
> When we are looking for a candidate disk to bump up the event count,
> we consider only disks that have recovery_start=3D=3DMaxSector.
> However, after we find one such disk, we agree to accept more disks
> having same event count, regardless of their recovery_start.
> Be consistent and don't accept disks with a valid recovery_start at all.
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 080993d..227d66f 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1069,6 +1069,7 @@ int Assemble(struct supertype *st, char *mddev,
>                         int j =3D best[i];
>                         if (j >=3D 0 &&
>                             !devices[j].uptodate &&
> +                           devices[j].i.recovery_start =3D=3D MaxSector =
&&
>                             devices[j].i.events =3D=3D current_events) {
>                                 chosen_drive =3D j;
>                                 goto add_another;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/R+Bs.zQfDi28zujcNxO1om0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7HZsDnsnt1WYoG5AQItjhAAhIT5GKzQBCT0GCcmWvTqWoWXkFGYXx8Z
xb+RWBdwZiMMk2uruf+r3QupSN9/oIsqFGbQK14vlW4vMH3hE4qHktds2YHzTKIX
Mi7xzE5FG6gvMZZQZVbdpk/1Brvj+ozsf66S8NGKXSX3bG3FOPhmBBuW75dCZ3Jn
WuvWx+Im+yJTdsHBAY3x26cYXHBTX0cNnIJen+iO0goq8wm5TRrXnP9SbHOIZJl4
j/6LQMi5ZghLMUNIXfeYmx/2S8Pr0BJA5rri/azZz6BSaEegrbHMof+0ov6wJRCr
q7Ed/VofYIv2bXe8S/GLQKUmgcx29ydGfZlEVmjI7vMxljyRE0NqwXBdmP8t1b4Q
bVcN4wO/2nO5oQSdUCUyjmzpq7ICUS03Uhrdu7D6bM2DfRerKY05SG7wowNp2+X7
55U98FYra5xopOPFH4XyLvwectbnLloENd9TbNxqMaCgbLEbCudCFp0/Vwsua2UJ
sHfZbRJKQSkKWSNrHDwa9k0GIYyKC+mJ8TX8akT31YiQ3AEIpaBMJ6CEw/c6QuL8
Re/h0Zf77qplE+636bt+12OpWUl2H1eNKihwD+0dcVzkEDW/Wcj0WL0X21q4YQtc
qEaDFbc8lThoGKX9FTMQnMVpISJehVbbkSj/iRftZ7WAXDa7MVyEbvXydCn25z7u
rkSzXCWNTIU=
=s/VE
-----END PGP SIGNATURE-----

--Sig_/R+Bs.zQfDi28zujcNxO1om0--
