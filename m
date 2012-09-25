From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: fix possible oops in add_stripe_bio when enable
 pr_debug
Date: Tue, 25 Sep 2012 16:45:46 +1000
Message-ID: <20120925164546.3882f076@notabene.brown>
References: <2012092014334148441317@gmail.com>
	<20120920164744.1aab090c@notabene.brown>
	<2012092015175190687821@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0NXk/_xAlGL6.HOJCqA2LJZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012092015175190687821@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/0NXk/_xAlGL6.HOJCqA2LJZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 15:17:54 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> On 2012-09-20 14:47 NeilBrown <neilb@suse.de> Wrote:
> >On Thu, 20 Sep 2012 14:34:00 +0800 "Jianpeng Ma" <majianpeng@gmail.com> =
wrote:
> >
> >> In func add_stripe_bio:
> >> >> .....
> >> >>		bip =3D &sh->dev[dd_idx].toread;
> >> >> ......
> >> >>spin_unlock_irq(&sh->stripe_lock);
> >>=20
> >> >>	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> >> >>		(unsigned long long)(*bip)->bi_sector,
> >> >>		(unsigned long long)sh->sector, dd_idx);
> >> After spin_unlock_irq, this thread scheded and toread may become null.
> >> So it will be oops.
> >>=20
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/raid5.c |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>=20
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index adda94d..f172b1e 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -2356,6 +2356,7 @@ static int add_stripe_bio(struct stripe_head *sh=
, struct bio *bi, int dd_idx, in
> >>  	struct bio **bip;
> >>  	struct r5conf *conf =3D sh->raid_conf;
> >>  	int firstwrite=3D0;
> >> +	sector_t sector =3D bi->bi_sector;
> >> =20
> >>  	pr_debug("adding bi b#%llu to stripe s#%llu\n",
> >>  		(unsigned long long)bi->bi_sector,
> >> @@ -2406,7 +2407,7 @@ static int add_stripe_bio(struct stripe_head *sh=
, struct bio *bi, int dd_idx, in
> >>  	spin_unlock_irq(&sh->stripe_lock);
> >> =20
> >>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> >> -		(unsigned long long)(*bip)->bi_sector,
> >> +		(unsigned long long)sector,
> >>  		(unsigned long long)sh->sector, dd_idx);
> >> =20
> >>  	if (conf->mddev->bitmap && firstwrite) {
> >
> >
> >how about we just move the spin_unlock_irq after the pr_debug??
> >
> ah! Why are you think ? my method only add a parameter.

Yes.

> BTW, in func handle_failed_stripe:
> >>if (!test_bit(R5_Wantfill, &sh->dev[i].flags) &&
> >>		    (!test_bit(R5_Insync, &sh->dev[i].flags) ||
> >>		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
> >>			bi =3D sh->dev[i].toread;
> >>			sh->dev[i].toread =3D NULL;
> >>			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
> >>				wake_up(&conf->wait_for_overlap);
> Why use stripe_lock to protect toread?

I assume you mean that we should be holding the lock to protect toread, but
we aren't.
I've queued a patch to fix that.

Thanks.
NeilBrown


>=20
> Thanks!


--Sig_/0NXk/_xAlGL6.HOJCqA2LJZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGFTGjnsnt1WYoG5AQIAPhAAvlhM/Oie5EzoADHe4kpDVesztK/k/suI
fiJHiQXbmptTz2BnesB1z+CfFoAnsn8EXnwjxAOi2+sov9OHuPHoKZ3had8wVqHF
FiQSZF+Ldo7WlNCQd1z3/O5555znZ/o+5rq/Iqsfpyw5O9Iohd/pvj6ZhKmWYtA5
jO1o9LnCIwg4SrCwIFbim7MS5gxNRaRCeYirp7hoO/wiTDwYWuwA41yBytrKU/R3
AQeYmbfDz2VhW+oHM60J2jUI4DUzn7beRtynaZztzEkiZB0gX6D/GxY8RkJia6GK
4/mIHDELspsufcr0B+VYsOmWJmqTnUm06kcvYZdEtBGUoXga9+8fcPMXkPlsMyH+
1Oq76Je8qE83vBv50iPr1a1mJDHL8U0hYaYr+FsvbRf/4vSeba7BD+jMBbKCsEGl
pQkBX8q+YbZ5Ue4Xp1isigQQ5wVJmdRtisbqV5Pztkh45RF0QzhEcQy1vJNc4YUJ
LX8/6hhlJ+OF+ROCjQAj9MIZKaM3KfnMYa0BGTttwli4iIxjfIm0kQiqnVY1pTPT
FPuX8AhVJSjH3lim5rA3pc9hrvlzJ3Nmt+7HJrJUZjpEZh8xOSK9NAoYgKc35W7u
0jH/HWwfPiwGXmgvShjKhnW91/00GuscSqaPbcfASMJ4CQ8S2/qhVvELG5/oSMjs
hUDZj1hzRl4=
=P4I9
-----END PGP SIGNATURE-----

--Sig_/0NXk/_xAlGL6.HOJCqA2LJZ--
