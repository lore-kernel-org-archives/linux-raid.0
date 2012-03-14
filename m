From: NeilBrown <neilb@suse.de>
Subject: Re: md:Add judgement bb->unacked_exist in function
Date: Wed, 14 Mar 2012 12:53:58 +1100
Message-ID: <20120314125358.7c5e8f66@notabene.brown>
References: <201203081737420934967@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kjL4HO3k3+Z3E+grZcdL6LW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203081737420934967@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kjL4HO3k3+Z3E+grZcdL6LW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Mar 2012 17:37:45 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> >From 7054a9dcd23a721e3c3dd2ceb8f1243187ea5cc4 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Thu, 8 Mar 2012 17:31:32 +0800
> Subject: [PATCH] md:Add judgement bb->unacked_exist in function
>  md_ack_all_badblocks().
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ce88755..7c57d0f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8040,7 +8040,7 @@ void md_ack_all_badblocks(struct badblocks *bb)
>  		return;
>  	write_seqlock_irq(&bb->lock);
> =20
> -	if (bb->changed =3D=3D 0) {
> +	if (bb->changed =3D=3D 0 && bb->unacked_exist) {
>  		u64 *p =3D bb->page;
>  		int i;
>  		for (i =3D 0; i < bb->count ; i++) {

Thanks.
This is fairly minor optimisation as 'unacked_exists' it almost always true
when ->change is set, but I doesn't hurt so I've included it.

In general I prefer a slightly more details commit comment.  It doesn't have
to be long, but it should make it obvious why the change is needed and what
it does.
I have made it:

    md: Add judgement bb->unacked_exist in function md_ack_all_badblocks().
   =20
    If there are no unacked bad blocks, then there is no point searching
    for them to acknowledge them.
   =20
   =20
    Signed-off-by: majianpeng <majianpeng@gmail.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown

--Sig_/kjL4HO3k3+Z3E+grZcdL6LW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1/6Njnsnt1WYoG5AQKifBAAn7048i5/C9vkeB2SFYNtBR+vN0G1S3Qi
hW0W3XiJOHOTioXuMi0X1JYGhKGAOYZfYnbgwknSbaBSXuwd1woqYjabLlj0DFTY
mj+FX4E0BsRrdhmg+GPja0/55i+Z+flO94Pwaqnx6nLbMw7IcBESNtt8FtCnpI5F
6rOcG+AD2wzNbrkm2Kyt+N1duhPE4VHO+JaFibQZmVL6vq8hItG9XzHyWG2Mv+AI
EHHjNz9hgpOQrkGNysLtegy+CDAWee6S7kV6hN3iE989ERVOt1rugYRqYxoecIdA
gXv/Q/ZuCq8EKGcahrA3SJx3bQM/TnHaDGWN0fCo8L5GyJK6yr10FxayBHnjI6Ex
qfrLZIgMBySWu0qs8hYO0oylZgK+RuKpiWTHXMCkdLLy40r80WM5/QwLYzw7ccof
l3A9AaSUb0jF+8QY4M09SZxe9DKgjnHZ+K5msOFYNEg57ZBia65CqNFcoB6N/xqj
ygJmSjYR6W1MI3a656q4HA+1h2vU4EtBneTZ+awuDAQxVrDSxOdlma368hP9idk+
FETiZyn5GJ95bZa1THXw94LW+33Opl1S3lHn/1q36JSl4d0fvqwsJuqIjkNsNEFA
sr2sP0pcTJNZ2UlqH0D2RqPcjrFb5pHmNIXBFUgM5jE0kxlBp6XBUv1keqW93s5e
48KaSmtp+48=
=hkX0
-----END PGP SIGNATURE-----

--Sig_/kjL4HO3k3+Z3E+grZcdL6LW--
