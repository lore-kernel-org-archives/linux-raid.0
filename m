From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] raid5: Fix to_read/to_write judgement.
Date: Tue, 25 Sep 2012 17:12:39 +1000
Message-ID: <20120925171239.2a2592e9@notabene.brown>
References: <201209221022560932318@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9WI5IGg+Yd3bnhqc=gVx7_5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201209221022560932318@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/9WI5IGg+Yd3bnhqc=gVx7_5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Sep 2012 10:22:58 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> In func analyse_stripe, it added to_read/to_write by
> sh->dev[i]->toread/towrite.
> If stripe failed, in func handle_failed_stripe it decreased
> to_read/to_write also by sh->dev[i]->toread/towrite.
> But between func analyse_stripe and handle_failed_stripe, toread/towrite
> can change.So the to_read/to_write maybe less zero.
> For example, if to_write was less zero,it may introduce a bug in func asy=
nc_xor:
> 'BUG_ON(src_cnt <=3D 1);'.
> So after handle_failed_stripe,it should use 'to_read/to_write > 0' instead
> of judging 'to_read/to_write'.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a56aa5b..554ca9e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2641,7 +2641,7 @@ static int fetch_block(struct stripe_head *sh, stru=
ct stripe_head_state *s,
>  	     (s->failed >=3D 2 && fdev[1]->toread) ||
>  	     (sh->raid_conf->level <=3D 5 && s->failed && fdev[0]->towrite &&
>  	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
> -	     (sh->raid_conf->level =3D=3D 6 && s->failed && s->to_write))) {
> +	     (sh->raid_conf->level =3D=3D 6 && s->failed && s->to_write > 0))) {
>  		/* we would like to get this block, possibly by computing it,
>  		 * otherwise read it if the backing disk is insync
>  		 */
> @@ -3471,8 +3471,8 @@ static void handle_stripe(struct stripe_head *sh)
>  	 * parity, or to satisfy requests
>  	 * or to load a block that is being partially written.
>  	 */
> -	if (s.to_read || s.non_overwrite
> -	    || (conf->level =3D=3D 6 && s.to_write && s.failed)
> +	if (s.to_read > 0 || s.non_overwrite
> +	    || (conf->level =3D=3D 6 && s.to_write > 0 && s.failed)
>  	    || (s.syncing && (s.uptodate + s.compute < disks))
>  	    || s.replacing
>  	    || s.expanding)
> @@ -3519,7 +3519,7 @@ static void handle_stripe(struct stripe_head *sh)
>  	 * 2/ A 'check' operation is in flight, as it may clobber the parity
>  	 *    block.
>  	 */
> -	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
> +	if (s.to_write > 0 && !sh->reconstruct_state && !sh->check_state)
>  		handle_stripe_dirtying(conf, sh, &s, disks);
> =20
>  	/* maybe we need to check and possibly fix the parity for this stripe


Thanks.
However I would prefer to fix this by not decrementing the counters in
handle_failed_stripe.  There is no harm in the counters being a little bigg=
er
than they should be.
I have queued a patch to do this.

Thanks,
NeilBrown


--Sig_/9WI5IGg+Yd3bnhqc=gVx7_5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGFZZznsnt1WYoG5AQJGiQ/9EDubsPQB6D/sSQJ32I2VLx82o63VvMFM
am0SfT/PG6iGpmdAZ7KXM2HHFLrvjZG3ZO3PYVuUzL6SSd2CLLiTXs4GtC2nzIbV
pNcpUiS+npem6MHmtxlWEkM91F7lo1G8S8qf/Mjw1Z3c50u1MHIcwRaR61WnRTjB
LMVpjYwWGm4O1X3oBMs7v0gkFAPITRPjCTkEhtBTW5Xhg/See9sD0ubTtja5+P48
aOZrTeA01IV5Sdjpfq0NaBDfriDnw5yx1tZygPdTySxwd5yPQEZD4Qtx7VT00Ht0
5s3nJ0VucL6JQvQbjpWS4hl9nLA5GznxQQZ4kxc1vAdaqU0mvQwEUVi2jqrbW+xn
lBQgowQMcnOnM5gCFaNYTse1EkP/d5ZWRHA362u3EcX5sWymLZ/AQhfI/jSfMbis
bxMt3z6zdQBGp4rZFVBKtsnVBd4NY8Maa6mDMdBUr44EVak2OgmYEM+Co4DC4YrU
rZJt3FEcOCLKDCS1bjMvnVEXj/gjFUkzKX4CcbS+sQqe/eJzxErT+HQnf2fQJ7Gs
9J/RZn1qSAxIv9Huyp9xaSwJX3YfcN68X4nrE44rm4oYYdgqmNwrF7kWdMzXfS9R
4vfrt8w6Gj5dmGKxBzu+Nn/hrgQECxLUjr1P4QPh+Jt/qOkViWgUfxiz7F74362F
F1EQTOb7Vaw=
=oKzo
-----END PGP SIGNATURE-----

--Sig_/9WI5IGg+Yd3bnhqc=gVx7_5--
