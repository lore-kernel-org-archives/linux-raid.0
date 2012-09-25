From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Tue, 25 Sep 2012 17:00:28 +1000
Message-ID: <20120925170028.0748a304@notabene.brown>
References: <20120918082511.GA6298@kernel.org>
	<20120920111517.54d05380@notabene.brown>
	<20120920013642.GA6798@kernel.org>
	<20120920114740.7e2c2d1f@notabene.brown>
	<20120920022717.GD6798@kernel.org>
	<20120920135914.63bf9ff4@notabene.brown>
	<20120920042541.GA12704@kernel.org>
	<20120920103138.GA25389@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Yct0gnZL7jXCbPfU3H+koWW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120920103138.GA25389@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Yct0gnZL7jXCbPfU3H+koWW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 18:31:38 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Sep 20, 2012 at 12:25:41PM +0800, Shaohua Li wrote:
> > On Thu, Sep 20, 2012 at 01:59:14PM +1000, NeilBrown wrote:
> > > On Thu, 20 Sep 2012 10:27:17 +0800 Shaohua Li <shli@kernel.org> wrote:
> > >=20
> > > in which wrong sectors were trimmed....
> > > >=20
> > > > Ok, just confirmed, delete raid5_compute_sector is ok if I adjust
> > > > logical_sector calculation. Here is the new patch.
> > > >=20
> > >=20
> > > Thanks.  That looks better.  I've applied it with some minor formatti=
ng
> > > changes.
> > >=20
> > > I then went to look at the follow-up page and .....
> > > I count 11 separate places where you test the new flag and possibly m=
emset a
> > > page to zero.  This doesn't seem like an improvement to me.
> >=20
> > We do the zero page just before the stripe is hit in cache, which is ra=
re case.
> > =20
> > > Why don't we just mark the page as not up-to-date when we discard it?=
  That
> > > would avoid storing inconsistent data, and would avoid needing to zer=
o pages.
> >=20
> > We need re-read the strip if it's hit in cache, but it's rare case, we =
don't
> > care. So when we clear the up-to-date flag? I saw a lot of places check=
ing
> > up-to-date flag in the write path. Need close look to check if there is=
 race.
>=20
> Alright, appears ok to use the uptodate flag. Here is the new patch.
>=20
>=20
> Subject: MD: raid5 avoid unnecessary zero page for trim
>=20
> We want to avoid zero discarded dev page, because it's useless for discar=
d.
> But if we don't zero it, another read/write hit such page in the cache an=
d will
> get inconsistent data.
>=20
> To avoid zero the page, we don't set R5_UPTODATE flag after construction =
is
> done. In this way, discard write request is still issued and finished, bu=
t read
> will not hit the page. If the stripe gets accessed soon, we need reread t=
he
> stripe, but since the chance is low, the reread isn't a big deal.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

Thanks.  It didn't turn out quite as clean as I hoped, but I suspect it is
the best we will get.

applied, thanks.
NeilBrown






> ---
>  drivers/md/raid5.c |   35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-09-20 18:10:38.546836309 +0800
> +++ linux/drivers/md/raid5.c	2012-09-20 18:17:50.849399945 +0800
> @@ -547,7 +547,7 @@ static void ops_run_io(struct stripe_hea
>  				rw =3D WRITE_FUA;
>  			else
>  				rw =3D WRITE;
> -			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
> +			if (test_bit(R5_Discard, &sh->dev[i].flags))
>  				rw |=3D REQ_DISCARD;
>  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
>  			rw =3D READ;
> @@ -1172,11 +1172,9 @@ ops_run_biodrain(struct stripe_head *sh,
>  					set_bit(R5_WantFUA, &dev->flags);
>  				if (wbi->bi_rw & REQ_SYNC)
>  					set_bit(R5_SyncIO, &dev->flags);
> -				if (wbi->bi_rw & REQ_DISCARD) {
> -					memset(page_address(dev->page), 0,
> -						STRIPE_SECTORS << 9);
> +				if (wbi->bi_rw & REQ_DISCARD)
>  					set_bit(R5_Discard, &dev->flags);
> -				} else
> +				else
>  					tx =3D async_copy_data(1, wbi, dev->page,
>  						dev->sector, tx);
>  				wbi =3D r5_next_bio(wbi, dev->sector);
> @@ -1194,7 +1192,7 @@ static void ops_complete_reconstruct(voi
>  	int pd_idx =3D sh->pd_idx;
>  	int qd_idx =3D sh->qd_idx;
>  	int i;
> -	bool fua =3D false, sync =3D false;
> +	bool fua =3D false, sync =3D false, discard =3D false;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> @@ -1202,13 +1200,15 @@ static void ops_complete_reconstruct(voi
>  	for (i =3D disks; i--; ) {
>  		fua |=3D test_bit(R5_WantFUA, &sh->dev[i].flags);
>  		sync |=3D test_bit(R5_SyncIO, &sh->dev[i].flags);
> +		discard |=3D test_bit(R5_Discard, &sh->dev[i].flags);
>  	}
> =20
>  	for (i =3D disks; i--; ) {
>  		struct r5dev *dev =3D &sh->dev[i];
> =20
>  		if (dev->written || i =3D=3D pd_idx || i =3D=3D qd_idx) {
> -			set_bit(R5_UPTODATE, &dev->flags);
> +			if (!discard)
> +				set_bit(R5_UPTODATE, &dev->flags);
>  			if (fua)
>  				set_bit(R5_WantFUA, &dev->flags);
>  			if (sync)
> @@ -1252,8 +1252,6 @@ ops_run_reconstruct5(struct stripe_head
>  	}
>  	if (i >=3D sh->disks) {
>  		atomic_inc(&sh->count);
> -		memset(page_address(sh->dev[pd_idx].page), 0,
> -			STRIPE_SECTORS << 9);
>  		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
>  		ops_complete_reconstruct(sh);
>  		return;
> @@ -1314,10 +1312,6 @@ ops_run_reconstruct6(struct stripe_head
>  	}
>  	if (i >=3D sh->disks) {
>  		atomic_inc(&sh->count);
> -		memset(page_address(sh->dev[sh->pd_idx].page), 0,
> -			STRIPE_SECTORS << 9);
> -		memset(page_address(sh->dev[sh->qd_idx].page), 0,
> -			STRIPE_SECTORS << 9);
>  		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
>  		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
>  		ops_complete_reconstruct(sh);
> @@ -2775,7 +2769,8 @@ static void handle_stripe_clean_event(st
>  		if (sh->dev[i].written) {
>  			dev =3D &sh->dev[i];
>  			if (!test_bit(R5_LOCKED, &dev->flags) &&
> -				test_bit(R5_UPTODATE, &dev->flags)) {
> +			    (test_bit(R5_UPTODATE, &dev->flags) ||
> +			     test_and_clear_bit(R5_Discard, &dev->flags))) {
>  				/* We can return any write requests */
>  				struct bio *wbi, *wbi2;
>  				pr_debug("Return write for disc %d\n", i);
> @@ -3493,10 +3488,12 @@ static void handle_stripe(struct stripe_
>  	if (s.written &&
>  	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
>  			     && !test_bit(R5_LOCKED, &pdev->flags)
> -			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
> +			     && (test_bit(R5_UPTODATE, &pdev->flags) ||
> +				 test_bit(R5_Discard, &pdev->flags))))) &&
>  	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
>  			     && !test_bit(R5_LOCKED, &qdev->flags)
> -			     && test_bit(R5_UPTODATE, &qdev->flags)))))
> +			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
> +				 test_bit(R5_Discard, &qdev->flags))))))
>  		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
> =20
>  	/* Now we might consider reading some blocks, either to check/generate
> @@ -3523,9 +3520,11 @@ static void handle_stripe(struct stripe_
>  		/* All the 'written' buffers and the parity block are ready to
>  		 * be written back to disk
>  		 */
> -		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
> +		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags) &&
> +		       !test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags));
>  		BUG_ON(sh->qd_idx >=3D 0 &&
> -		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags));
> +		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
> +		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
>  			if (test_bit(R5_LOCKED, &dev->flags) &&


--Sig_/Yct0gnZL7jXCbPfU3H+koWW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGFWjDnsnt1WYoG5AQLFdRAAvimwi4C0fOMgwEXtibJi6aZvwsT6QP2p
PYiYSyvvxNpoczdBtk4jUw2xPPhiyZvZxs61hlR/QePeiGPwWaPL0l+uQnANtkTB
d9hYpsTuX261pjzd9/SheRroXXGwDOF6s5qXcwZPhGf26lKEPJQdYJJ4oVYo2zDE
uORObVvbw4sJi8h0/oBhok2JdKsEJrRh5f0MNSFLAwKAFZID7eWVVxSVtsbilBvf
fQ/NR/QQchq+u3+dY0D47ccNjOK53bHzJPPUZjvFQHjHuaiNwYnvDUrSV/UoxfwE
3sxI9PwnkPScU+EFSaFD0zBGsx8SiLxpqP9U1NZQ6toqXMTs0IpEq9Myjhs+RHT/
obApmK1/nn/pNuWey8z+robqpeRjawaIKVRgfruPOkPT7swGExf2/b0ZCAg6jfWG
UidUvl2dkSWs8uMsik16ZZbiKWriUVXkDhgus75wayJL75FxT/htf62Vf/BxmlfC
YxpFRca1PRt8pUVVAW/tQ51pBkYZHpeduor8H76pQC0RSrwmU0A1FmdzbT1JRSe1
V/wuMY4Ces852+u3mc7HG4Kvkyu/wIde8ya70hhR/0ovbVB3qqUOVKeodJ41Htew
yNI7wFYBNLp43q01xOe1PBdnC46mGZGi5TYttuvovaQTLSvfr2HZlJmDas6A41Nl
TZRf6UZQ1+4=
=/cMJ
-----END PGP SIGNATURE-----

--Sig_/Yct0gnZL7jXCbPfU3H+koWW--
