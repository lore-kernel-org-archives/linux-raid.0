From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 6/7 v2] MD: raid5 trim support
Date: Tue, 11 Sep 2012 14:10:08 +1000
Message-ID: <20120911141008.10dd0a50@notabene.brown>
References: <20120810025113.050392766@kernel.org>
	<20120810025255.292192477@kernel.org>
	<20120813115051.64d5d44e@notabene.brown>
	<20120813020454.GA447@kernel.org>
	<20120813135831.284d721d@notabene.brown>
	<20120813054347.GA20261@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7371pVZ/mhj.sqGLAWEkcX9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120813054347.GA20261@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fusionio.com>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/7371pVZ/mhj.sqGLAWEkcX9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 13:43:47 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Mon, Aug 13, 2012 at 01:58:31PM +1000, NeilBrown wrote:
> > On Mon, 13 Aug 2012 10:04:54 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Mon, Aug 13, 2012 at 11:50:51AM +1000, NeilBrown wrote:
> > > > On Fri, 10 Aug 2012 10:51:19 +0800 Shaohua Li <shli@fusionio.com> w=
rote:
> > > >=20
> > > > > @@ -4094,6 +4159,19 @@ static void make_request(struct mddev *m
> > > > >  	bi->bi_next =3D NULL;
> > > > >  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stri=
pes */
> > > > > =20
> > > > > +	/* block layer doesn't correctly do alignment even we set corre=
ct alignment */
> > > > > +	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
> > > > > +		int stripe_sectors =3D conf->chunk_sectors *
> > > > > +			(conf->raid_disks - conf->max_degraded);
> > > >=20
> > > > This isn't right when an array is being reshaped.
> > > > I suspect that during a reshape we should only attempt DISCARD on t=
he part of
> > > > the array which has already been reshaped.  On the other section we=
 can
> > > > either fail the discard (is that a good idea?) or write zeros.
> > >=20
> > > I had a check in below for-loop for reshape, is it enough? If not, I'=
d like
> > > just ignore discard request for reshape. We force discard_zero_data t=
o be 0, so
> > > should be ok.
> >=20
> > Yes, you are right - that is sufficient.  I hadn't read it properly.
> >=20
> > >=20
> > > I'll fix other two issues. Will repost the raid5 discard patches late=
r.
>=20
> Here is the updated version. Last patch can still be applied cleanly.
>=20
>=20
> Subject: MD: raid5 trim support
>=20
> Discard for raid4/5/6 has limitation. If discard request size is small, w=
e do
> discard for one disk, but we need calculate parity and write parity disk.=
  To
> correctly calculate parity, zero_after_discard must be guaranteed. Even i=
t's
> true, we need do discard for one disk but write another disks, which make=
s the
> parity disks wear out fast. This doesn't make sense. So an efficient disc=
ard
> for raid4/5/6 should discard all data disks and parity disks, which requi=
res
> the write pattern to be (A, A+chunk_size, A+chunk_size*2...). If A's size=
 is
> smaller than chunk_size, such pattern is almost impossible in practice. S=
o in
> this patch, I only handle the case that A's size equals to chunk_size. Th=
at is
> discard request should be aligned to stripe size and its size is multiple=
 of
> stripe size.
>=20
> Since we can only handle request with specific alignment and size (or par=
t of
> the request fitting stripes), we can't guarantee zero_after_discard even
> zero_after_discard is true in low level drives.
>=20
> The block layer doesn't send down correctly aligned requests even correct
> discard alignment is set, so I must filter out.
>=20
> For raid4/5/6 parity calculation, if data is 0, parity is 0. So if
> zero_after_discard is true for all disks, data is consistent after discar=
d.
> Otherwise, data might be lost. Let's consider a scenario: discard a strip=
e,
> write data to one disk and write parity disk. The stripe could be still
> inconsistent till then depending on using data from other data disks or p=
arity
> disks to calculate new parity. If the disk is broken, we can't restore it=
. So
> in this patch, we only enable discard support if all disks have
> zero_after_discard.
>=20
> If discard fails in one disk, we face the similar inconsistent issue abov=
e. The
> patch will make discard follow the same path as normal write request. If
> discard fails, a resync will be scheduled to make the data consistent. Th=
is
> isn't good to have extra writes, but data consistency is important.
>=20
> If a subsequent read/write request hits raid5 cache of a discarded stripe=
, the
> discarded dev page should have zero filled, so the data is consistent. Th=
is
> patch will always zero dev page for discarded request stripe. This isn't
> optimal because discard request doesn't need such payload. Next patch will
> avoid it.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |  135 ++++++++++++++++++++++++++++++++++++++++++++++=
+++++--
>  drivers/md/raid5.h |    1=20
>  2 files changed, 132 insertions(+), 4 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-08-13 10:25:22.325095834 +0800
> +++ linux/drivers/md/raid5.c	2012-08-13 12:01:28.628603083 +0800
> @@ -547,6 +547,8 @@ static void ops_run_io(struct stripe_hea
>  				rw =3D WRITE_FUA;
>  			else
>  				rw =3D WRITE;
> +			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
> +				rw |=3D REQ_DISCARD;
>  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
>  			rw =3D READ;
>  		else if (test_and_clear_bit(R5_WantReplace,
> @@ -1170,8 +1172,13 @@ ops_run_biodrain(struct stripe_head *sh,
>  					set_bit(R5_WantFUA, &dev->flags);
>  				if (wbi->bi_rw & REQ_SYNC)
>  					set_bit(R5_SyncIO, &dev->flags);
> -				tx =3D async_copy_data(1, wbi, dev->page,
> -					dev->sector, tx);
> +				if (wbi->bi_rw & REQ_DISCARD) {
> +					memset(page_address(dev->page), 0,
> +						STRIPE_SECTORS << 9);
> +					set_bit(R5_Discard, &dev->flags);
> +				} else
> +					tx =3D async_copy_data(1, wbi, dev->page,
> +						dev->sector, tx);
>  				wbi =3D r5_next_bio(wbi, dev->sector);
>  			}
>  		}
> @@ -1237,6 +1244,20 @@ ops_run_reconstruct5(struct stripe_head
>  	pr_debug("%s: stripe %llu\n", __func__,
>  		(unsigned long long)sh->sector);
> =20
> +	for (i =3D 0; i < sh->disks; i++) {
> +		if (pd_idx =3D=3D i)
> +			continue;
> +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> +			break;
> +	}
> +	if (i >=3D sh->disks) {
> +		atomic_inc(&sh->count);
> +		memset(page_address(sh->dev[pd_idx].page), 0,
> +			STRIPE_SECTORS << 9);
> +		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
> +		ops_complete_reconstruct(sh);
> +		return;
> +	}
>  	/* check if prexor is active which means only process blocks
>  	 * that are part of a read-modify-write (written)
>  	 */
> @@ -1281,10 +1302,28 @@ ops_run_reconstruct6(struct stripe_head
>  {
>  	struct async_submit_ctl submit;
>  	struct page **blocks =3D percpu->scribble;
> -	int count;
> +	int count, i;
> =20
>  	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
> =20
> +	for (i =3D 0; i < sh->disks; i++) {
> +		if (sh->pd_idx =3D=3D i || sh->qd_idx =3D=3D i)
> +			continue;
> +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> +			break;
> +	}
> +	if (i >=3D sh->disks) {
> +		atomic_inc(&sh->count);
> +		memset(page_address(sh->dev[sh->pd_idx].page), 0,
> +			STRIPE_SECTORS << 9);
> +		memset(page_address(sh->dev[sh->qd_idx].page), 0,
> +			STRIPE_SECTORS << 9);
> +		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
> +		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
> +		ops_complete_reconstruct(sh);
> +		return;
> +	}
> +
>  	count =3D set_syndrome_sources(blocks, sh);
> =20
>  	atomic_inc(&sh->count);
> @@ -2353,7 +2392,7 @@ schedule_reconstruction(struct stripe_he
>   */
>  static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd=
_idx, int forwrite)
>  {
> -	struct bio **bip;
> +	struct bio **bip, *orig_bi =3D bi;
>  	struct r5conf *conf =3D sh->raid_conf;
>  	int firstwrite=3D0;
> =20
> @@ -2370,6 +2409,23 @@ static int add_stripe_bio(struct stripe_
>  	 * protect it.
>  	 */
>  	spin_lock_irq(&sh->stripe_lock);
> +
> +	if (bi->bi_rw & REQ_DISCARD) {
> +		int i;
> +		dd_idx =3D -1;
> +		for (i =3D 0; i < sh->disks; i++) {
> +			if (i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)
> +				continue;
> +			if (dd_idx =3D=3D -1)
> +				dd_idx =3D i;
> +			if (sh->dev[i].towrite) {
> +				dd_idx =3D i;
> +				goto overlap;
> +			}
> +		}
> +	}
> +
> +again:
>  	if (forwrite) {
>  		bip =3D &sh->dev[dd_idx].towrite;
>  		if (*bip =3D=3D NULL)
> @@ -2403,6 +2459,15 @@ static int add_stripe_bio(struct stripe_
>  		if (sector >=3D sh->dev[dd_idx].sector + STRIPE_SECTORS)
>  			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
>  	}
> +
> +	bi =3D orig_bi;
> +	if (bi->bi_rw & REQ_DISCARD) {
> +		dd_idx++;
> +		while (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
> +			dd_idx++;
> +		if (dd_idx < sh->disks)
> +			goto again;
> +	}

I'm afraid there there is something else here that I can't make my self hap=
py
with.

You added a new "goto again" loop inside add_stripe_bio, and to compensate
the increase logical_sector in make_request so that it doesn't call
add_stripe_bio so many times.
This means that to control flow between make_request and add_stripe_bio is
very different depending on whether it is a discard or not.  That make the
code harder to understand and easier to break later.

I think it would to create a completely separate "make_trim_request()" which
handles the trim/discard case, and leave the current code as it is.

If/when you do send a patch to do that, please also resend the other raid5
patch which comes after this one.  I tend not to keep patches once I've
devices not to apply them immediately.  It also reduces the chance of
confusion if you just send whatever you want me to apply.

Thanks,
NeilBrown

--Sig_/7371pVZ/mhj.sqGLAWEkcX9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE65oDnsnt1WYoG5AQJTphAAjsMSak7DyT7zZ5vVDffgqZA55JEfRXAe
dI2rDIxGEHfuX0lnF7ND51VaQL/ESVD4pLyFJdiqg3hx7Fh2Sk5qblBtFU5oF+qO
xPzIT8Ukh2JsjyWgwrTS305gHJxa/udOD8QhCb+aOKM1kYMb2nJtPgWtfOCgHPRg
CeUHqhGimDcY/Ml6CReEYOlFS7m8+4yC3dHhHw0Vm8BjNSsndJm9TsA+1Lp+PdTw
5Qyyf2X0UuhEYLB9j8zqAm2mr84alIHq9xxkG4sKTytsWGcTs6M6VS04M9zYLpp9
ALfA2hDYoKT21SFr4uVFfmv7cTeVe8pEu0KqLTWlTwkPZsXwOkTNCfjeP6x6BiFA
XK7pJHglEW89tZ12GrXuHhXg1v5c48RRA9qygrcdwSJph6OzuPZs1qXReoCAJzeC
+G1fFd0RdwHymsqvxahle94DL8k1GxtCTvT7ECiCeTLn8d7LqmQSq6bMun5kTv6O
1TOPrjh/oA5+Bo9kU1vDURtgdxQsc6+JOJVHNUACkwV/xINlysQ81loVwL79gXjc
IIdI04aBvptpTcuP3Q8puS+WoRebLZlKwjifinncmri0sAVvEl6WMKIQ/qtJxRm/
2Vti6I7+FTHQmfcjRq12vHCx+Ydg6n5uYkxM6iZb3q/bghe3eYbkZKxDHlsNhKjm
yoH5CAdCKbU=
=QU0l
-----END PGP SIGNATURE-----

--Sig_/7371pVZ/mhj.sqGLAWEkcX9--
