From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] raid5: fix incorrectly counter of conf->empty_inactive_list_nr
Date: Wed, 03 Aug 2016 10:44:55 +1000
Message-ID: <87popqpto8.fsf@notabene.neil.brown.name>
References: <1469686934-1937-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469686934-1937-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
Cc: shli@kernel.org, liuzhengyuang521@gmail.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, ZhengYuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28 2016, ZhengYuan Liu wrote:

> The counter conf->empty_inactive_list_nr is only used for determine if the
> raid5 is congested which is deal with in function raid5_congested().
> It was increased in get_free_stripe() when conf->inactive_list got to be
> empty and decreased in release_inactive_stripe_list() when splice
> temp_inactive_list to conf->inactive_list. However, this may have a
> problem when raid5_get_active_stripe or stripe_add_to_batch_list was call=
ed,
> because these two functions may call list_del_init(&sh->lru) to delete sh=
 from
> "conf->inactive_list + hash" which may cause "conf->inactive_list + hash"=
 to
> be empty when atomic_inc_not_zero(&sh->count) got false. So a check shoul=
d be
> done at these two point and increase empty_inactive_list_nr accordingly.
> Otherwise the counter may get to be negative number which would influence
> async readahead from VFS.
>
> Signed-off-by: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
> ---
>  drivers/md/raid5.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7c53861..1656c44 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -659,6 +659,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t=
 sector,
>  {
>  	struct stripe_head *sh;
>  	int hash =3D stripe_hash_locks_hash(sector);
> +	int inc_empty_inactive_list_flag;
>=20=20
>  	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
>=20=20
> @@ -703,7 +704,12 @@ raid5_get_active_stripe(struct r5conf *conf, sector_=
t sector,
>  					atomic_inc(&conf->active_stripes);
>  				BUG_ON(list_empty(&sh->lru) &&
>  				       !test_bit(STRIPE_EXPANDING, &sh->state));
> +				inc_empty_inactive_list_flag =3D 0;
> +				if (!list_empty(conf->inactive_list + hash))
> +					inc_empty_inactive_list_flag =3D 1;
>  				list_del_init(&sh->lru);
> +				if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_lis=
t_flag)
> +					atomic_inc(&conf->empty_inactive_list_nr);

Maybe I'm forgetting an important detail, but this seems more
complicated than it needs to be.
The code just just confirmed that sh->count is zero, so sh must be on
the inactive list, mustn't it?
So inc_empty_inactive_list_flag can never be set to 1.

What am I missing?  Could sh not be on the inactive list at this point?

Same for the code below.

NeilBrown


>  				if (sh->group) {
>  					sh->group->stripes_cnt--;
>  					sh->group =3D NULL;
> @@ -762,6 +768,7 @@ static void stripe_add_to_batch_list(struct r5conf *c=
onf, struct stripe_head *sh
>  	sector_t head_sector, tmp_sec;
>  	int hash;
>  	int dd_idx;
> +	int inc_empty_inactive_list_flag;
>=20=20
>  	if (!stripe_can_batch(sh))
>  		return;
> @@ -781,7 +788,11 @@ static void stripe_add_to_batch_list(struct r5conf *=
conf, struct stripe_head *sh
>  				atomic_inc(&conf->active_stripes);
>  			BUG_ON(list_empty(&head->lru) &&
>  			       !test_bit(STRIPE_EXPANDING, &head->state));
> +			if (!list_empty(conf->inactive_list + hash))
> +				inc_empty_inactive_list_flag =3D 1;
>  			list_del_init(&head->lru);
> +			if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_list=
_flag)
> +				atomic_inc(&conf->empty_inactive_list_nr);
>  			if (head->group) {
>  				head->group->stripes_cnt--;
>  				head->group =3D NULL;
> --=20
> 1.9.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXoT6HAAoJEDnsnt1WYoG5cMcP/3lVI6C5E0x+So0u0/LWWYGX
8HxObfs11lpBXbvEzhS439veIYcAMXPAQhdJvppzkP10kTQXtbLMRoKRHdFmeLkV
+h8VDYQD15huYoiVrHV8y5HaB+L7XOGWHlBuDrX9+0igqPikwaVu5xUtqF/O2H4d
JEVf7s0xGQ0bxhieHMmTStz7oX7hKnGhyb74szyGtpNF9QJOZXnpFmcmjYwdETT4
3xgK3VnsovVpvLev1GPv87opBIiy1pL1aRrGz0rdIFWeqqoT1GPm0P7Rzt5BHGw4
bcWRBGZLJWEdONat2iw/guvma/HIO/EUa0fT+Lvd3kMdiduO9QYDLqo9CEAWOZpv
Oa3H3ZknXhAsIF5JNLU6ykTDZM45eUwBs8oFzFUZVH8VN7F25BOiC1dH85K62MT/
m/57JtSeHoP7gDFyuUIB2rRmciRxZYftcJ1NYs2TQZQcQ/ItkFSZAh+7ZCSJN4lb
fp4XNAkyqKygZVshGK0xah+b+uOP+4zbjClvUWY2BU/zedC4QCbhME6hU7H49zrx
d8loqS0SlDfmpJNoZZajDyWlfEjWobOLzveE2wPXDofRABTzZ768QQgqpKm588ZO
QdNOz82xiEvuFCFvhUJOq69nqweUAmT0btNvt9Du1PKu3iF35A7fs9J1JXmhWL7M
uBqr6+rNDUHZ4wAS+IL4
=8yxO
-----END PGP SIGNATURE-----
--=-=-=--
