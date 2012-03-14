From: NeilBrown <neilb@suse.de>
Subject: Re: md:Fix a bug in function badblocks_show().
Date: Wed, 14 Mar 2012 12:32:45 +1100
Message-ID: <20120314123245.74feeab8@notabene.brown>
References: <201203081446488121330@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3W7QBTiPS5JyZYnYcat9WrU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203081446488121330@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/3W7QBTiPS5JyZYnYcat9WrU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Mar 2012 14:46:52 +0800 "majianpeng" <majianpeng@gmail.com> wrote:

> >From 58d2ba381eee4b732fca99a7311b1dcf589f57c3 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Thu, 8 Mar 2012 14:37:00 +0800
> Subject: [PATCH] md:Fix a bug in function badblocks_show().
>=20
> If unack=3D=3D0, it will show all bad blocks include unacknowledged-bad-b=
locks.

Correct.  It is meant to.
The "bad_blocks" file shows all bad blocks.
The "unacknowledged_bad_blocks" file show all unacknowledged bad blocks.

Thanks,
NeilBrown


>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ce88755..3f1b6e5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8091,7 +8091,7 @@ retry:
>  		int ack =3D BB_ACK(p[i]);
>  		i++;
> =20
> -		if (unack && ack)
> +		if ((unack ^ ack) =3D=3D 0)
>  			continue;
> =20
>  		len +=3D snprintf(page+len, PAGE_SIZE-len, "%llu %u\n",


--Sig_/3W7QBTiPS5JyZYnYcat9WrU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1/1PTnsnt1WYoG5AQKdshAAuJPw7AGNmBSuztrPLZt9NqOocs+NoHp9
pCM/BUsHSUY4KvST2WVyaHqLEZGJuYTOc22QpC5EOP+9xbpJOzrSEu1VZIyEvPIp
k9kenpnMOtLJz5Wi4FdZHs0ENDdWPxIrdKIgwZ/kQ7R/+MO7Pr3MgyzZ+y+i2RAF
/5tQ9WDWtPMT9hqtg7dbtyrhsxarqEoCFGtGffIwSVuvVavmQWlGZ6/yDoSa7INJ
/QDlGY0jgeNGAAwmzu3g/UAKzIlVoudkB/aAkJnN6kuefErVXdLMFSxcgVaG1oDa
uESRgLKFvrnLQC9V6rgUz6JxBHCDASTDmidFfzXSt4RotKFPCVzXLRcyPaNNmeC3
R6mHoYTadMnwowt8FGoxYzYr+9uB6HUf+moD6vrvdOnKpA95SNTY5jPbW+ApUZpN
rb4veauXNVYvjSMAWA0n4mKY6QYSu0PEMLOP/ce7enCYr+CBPl6r35KQn/9cJ1bN
Lgr147W2lxkgOk79zJ1zxY67gWXObGksCoKxG9BPB1TiPc6WnP5eBylT8n9/Xzsw
ZbRTaSRy/oHx/70ih/WoB+/RVhApCe1ftxTtVuKJNR8vEAYLGuNNZBik20xaq7Dz
34dd6Mu9wAAbTqW9janl73CD+5Fh9rejwXfBy5ri8e2/a8SWvb1aO30KT36/9h00
52+IGLvZXDY=
=lHyN
-----END PGP SIGNATURE-----

--Sig_/3W7QBTiPS5JyZYnYcat9WrU--
