From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v1 0/0] raid5: fix init_stripe() inconsistencies
Date: Wed, 20 Aug 2014 13:36:58 +1000
Message-ID: <20140820133658.1e8f1fb9@notabene.brown>
References: <fb820ed5-44e5-4596-b8d4-956027be204a@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/l4qwP0EnBabf59FvgmIIbTu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fb820ed5-44e5-4596-b8d4-956027be204a@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/l4qwP0EnBabf59FvgmIIbTu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Aug 2014 09:37:31 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> commit 639a347254c4b8daa22ce09c281259dce7f6ba71
> Author: Markus Stockhausen <markus.stockhausen@collogia.de>
> Date:   Sun Aug 10 09:25:55 2014 +0000
>=20
>     raid5: fix init_stripe() inconsistencies=20
>=20
>     1) remove_hash() is not necessary. We will only be called right after
>     get_free_stripe(). There we have already a call to remove_hash().
>=20
>     2) Tracing prints out the sector of the freed stripe and not the sect=
or
>     that we want to initialize.
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7f66741..c4cd245 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -527,9 +527,7 @@ static void init_stripe(struct stripe_head *sh, secto=
r_t sector, int previous)
>  	BUG_ON(stripe_operations_active(sh));
> =20
>  	pr_debug("init_stripe called, stripe %llu\n",
> -		(unsigned long long)sh->sector);
> -
> -	remove_hash(sh);
> +		(unsigned long long)sector);
>  retry:
>  	seq =3D read_seqcount_begin(&conf->gen_lock);
>  	sh->generation =3D conf->generation - previous;

Applied, thanks.

For future reference:
 - put "md" at the start of the subject line. e.g. "md/raid5:"
 - use "git show --format=3Demail" or some other incantation which
   avoids  indenting the description.  Also avoid the "commit"
   line.  Author: and Date: are redundant but I don't think they
   are actually hurting.
 - Be sure to include a Signed-off-by: line.  Find and read the DCO
   (Developer's Certificate of Origin) to know what that means.
   This patch is sufficiently trivial that I won't insist, but it is a good
   habit to get into (git commit --amend --sign --no-edit)

Thanks,
NeilBrown

--Sig_/l4qwP0EnBabf59FvgmIIbTu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/QX2jnsnt1WYoG5AQKjUw//W3vo8E/M7HCP+E/xq9kCkYuNSHP+/qz+
qZxRD+1P/Qnk/BJGjOaLXQBW51CQyk++RtVaAEETwWlCysJVc6yYMZBv7WF3ooZp
QAnQp+ldq2xM1yfsmro1+5OwErPVeWCwGPm5xjap0oTw5Z3Ap8q+3FfEISb6PqUf
9SoyndqcFl7OOKSILPt+A+qOAEs/yMyBR9eEHo/4XRtNhNZmthTECLv0TE21dchj
BbKCaJeHp4lf2/G142Ko7YkUI/FVyW/Nwia14oyUUeK20lnOTCG66S7ZJOv6OPYh
ACdul0ZMuOCvqGkqUJGSWjAr07IHV0dokRX2QWgEWaeKnlugImxPBltyz/vY3n6b
+S5RZELxY6P761IslHC+CsAJ9Gv/ikHK+9FVGGRWrfE5W9d3NvMizAb5QQAdH2Z+
YC6KnWl5YdH8DXG/IRnAg+9Wie9hZFVyzvFU9CQNA5lFqtc0Eq9xS1tjm91YCOGx
nEC+3/tX1O2i+h8h1wTxX2tLExRJ7gc+1eejll3AcLfWFIA/B1SR5kZb3cYn3+TI
Ad9dhcMXO/6ImoupkVAAHOWFGu03tJE49U2+cErvYGas0XOobLF/0iGWZi2ELgvf
Pf0ylQOjpixWKq2XVcYbX5tRoc+q9PZ7i81PuYliBUfUeJ1IePt8IUziG5Rveq49
tUKXdnV0Aj4=
=iaRX
-----END PGP SIGNATURE-----

--Sig_/l4qwP0EnBabf59FvgmIIbTu--
