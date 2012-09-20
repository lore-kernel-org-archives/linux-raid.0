From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: fix possible oops in add_stripe_bio when enable
 pr_debug
Date: Thu, 20 Sep 2012 16:47:44 +1000
Message-ID: <20120920164744.1aab090c@notabene.brown>
References: <2012092014334148441317@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HVXJ78GH8KHS5+_/v/c=Rkk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012092014334148441317@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/HVXJ78GH8KHS5+_/v/c=Rkk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 14:34:00 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> In func add_stripe_bio:
> >> .....
> >>		bip =3D &sh->dev[dd_idx].toread;
> >> ......
> >>spin_unlock_irq(&sh->stripe_lock);
>=20
> >>	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> >>		(unsigned long long)(*bip)->bi_sector,
> >>		(unsigned long long)sh->sector, dd_idx);
> After spin_unlock_irq, this thread scheded and toread may become null.
> So it will be oops.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index adda94d..f172b1e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2356,6 +2356,7 @@ static int add_stripe_bio(struct stripe_head *sh, s=
truct bio *bi, int dd_idx, in
>  	struct bio **bip;
>  	struct r5conf *conf =3D sh->raid_conf;
>  	int firstwrite=3D0;
> +	sector_t sector =3D bi->bi_sector;
> =20
>  	pr_debug("adding bi b#%llu to stripe s#%llu\n",
>  		(unsigned long long)bi->bi_sector,
> @@ -2406,7 +2407,7 @@ static int add_stripe_bio(struct stripe_head *sh, s=
truct bio *bi, int dd_idx, in
>  	spin_unlock_irq(&sh->stripe_lock);
> =20
>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> -		(unsigned long long)(*bip)->bi_sector,
> +		(unsigned long long)sector,
>  		(unsigned long long)sh->sector, dd_idx);
> =20
>  	if (conf->mddev->bitmap && firstwrite) {


how about we just move the spin_unlock_irq after the pr_debug??

NeilBrown

--Sig_/HVXJ78GH8KHS5+_/v/c=Rkk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFq8EDnsnt1WYoG5AQLjlA/+PvrCzJfQ/T16NI8+uWH69nXRjklqykJm
KAiyJA3FYUQifbJrMew3sdS0uGs+vGjDGoPkkgD5j+iMusdlF0kUeOKPUeICDXmH
QlLmm/LszCLdPvsn0dd54G/vAa+WV31K9cpUfMAuyY98V1gsL4eKDbHUMU7Hc/7x
I6tYXHY+ymzdtlzIZrgBSdsQc1eu3zFJcI7a0AjnXwELTDlCSitCL5NyMyIbkq00
CuHn9eIqtQ7R+SG5FIpaez9+D8ct2PgYvxC6TlFkOkqZSfRpWD+p/z2foKmoMONu
CP3JK8htGGtRpS+h+EoKyPDZ8FVI9zc0bFN325mJsTwM9/BV2l3DPlWBo39G3da6
odve5NvV1HcNkTnx80WHhodrosCuB++O1msMgmT9JIpMZB0rk16AIk68qM8+iPZV
J4lLagaPxwM6W7ctkI4vHtD5tdru52WVSyRKd330C+nNLkw0HAKQY/VhrZA4Okrt
wh60fihJpAuwBv0O6CZTogfY+cihmJ43RWqX39ZilAA9F2bFIYhfmrTWA3+XTWm4
0VZO1t1RMnI0UGx4N/nIcNCmEAv5sRDNnpcYFP8ytABBICVuWrIjf+DuI4jt+fH8
EtlAkLrrW2nId8VlVDcdvJ10QixUgoP/s2FdmZ6w1xOkq3HDSyYkKAII2/HWpyJa
5nw6t5g0G2U=
=MzW7
-----END PGP SIGNATURE-----

--Sig_/HVXJ78GH8KHS5+_/v/c=Rkk--
