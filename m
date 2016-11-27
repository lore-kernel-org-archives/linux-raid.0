From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 2/2] raid5-cache: don't set STRIPE_R5C_PARTIAL_STRIPE flag
 while load stripe into cache
Date: Sun, 27 Nov 2016 23:49:24 +0000
Message-ID: <A581E969-CBCA-4271-B628-1558D3A7A0FD@fb.com>
References: <1480129034-14700-1-git-send-email-liuzhengyuan@kylinos.cn>
 <1480129034-14700-2-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480129034-14700-2-git-send-email-liuzhengyuan@kylinos.cn>
Content-Language: en-US
Content-ID: <010CE810252BB34BB4F53C9D4F4CF163@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "liuyun01@kylinos.cn" <liuyun01@kylinos.cn>
List-Id: linux-raid.ids


> On Nov 25, 2016, at 6:57 PM, Zhengyuan Liu <liuzhengyuan@kylinos.cn> wrot=
e:
>=20
> r5c_recovery_load_one_stripe should not set STRIPE_R5C_PARTIAL_STRIPE fla=
g,as
> the data-only stripe may be STRIPE_R5C_FULL_STRIPE stripe. The state mach=
ine
> would release the stripe later and add it into neither r5c_cached_full_st=
ripes
> list or r5c_cached_partial_stripes list and set correct flag. Also we sho=
uld
> fix the counter corresponding.
>=20
> Reviewed-by: JackieLiu <liuyun01@kylinos.cn>
> Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
> ---
> drivers/md/raid5-cache.c |  3 +--
> drivers/md/raid5.c       | 11 +++++++++++
> 2 files changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 9911164..e0ac758 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1930,9 +1930,8 @@ static void r5c_recovery_load_one_stripe(struct r5l=
_log *log,
> 			set_bit(R5_UPTODATE, &dev->flags);
> 		}
> 	}
> -	set_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state);
> -	atomic_inc(&conf->r5c_cached_partial_stripes);
> 	list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
> +	atomic_inc(&log->stripe_in_journal_count);
> }

This makes sense to me. Thanks for catching it.=20

> /*
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dbab8c7..8120ce4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -677,12 +677,23 @@ raid5_get_active_stripe(struct r5conf *conf, sector=
_t sector,
> 					atomic_inc(&conf->active_stripes);
> 				BUG_ON(list_empty(&sh->lru) &&
> 				       !test_bit(STRIPE_EXPANDING, &sh->state));
> +
> 				inc_empty_inactive_list_flag =3D 0;
> 				if (!list_empty(conf->inactive_list + hash))
> 					inc_empty_inactive_list_flag =3D 1;
> 				list_del_init(&sh->lru);
> 				if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_list=
_flag)
> 					atomic_inc(&conf->empty_inactive_list_nr);
> +
> +				if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
> +					WARN_ON(atomic_read(&conf->r5c_cached_partial_stripes) =3D=3D 0);
> +					atomic_dec(&conf->r5c_cached_partial_stripes);
> +				}
> +				if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
> +					WARN_ON(atomic_read(&conf->r5c_cached_full_stripes) =3D=3D 0);
> +					atomic_dec(&conf->r5c_cached_full_stripes);
> +				}
> +

I don't think we need these, as we decrease these counters in r5c_make_stri=
pe_write_out().=20

Thanks,
Song=
