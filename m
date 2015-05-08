From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/raid5: avoid duplicate code
Date: Fri, 8 May 2015 15:28:00 +1000
Message-ID: <20150508152800.18140bac@notabene.brown>
References: <1430905550-6142-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6rV3JYptn3Ghm04PLklw9CZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1430905550-6142-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6rV3JYptn3Ghm04PLklw9CZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  6 May 2015 17:45:49 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> Move the code that put one idle sh(hot in cache, but happens to be
> zero referenced) back to active stage to __find_stripe(). Because
> that's what need to do every time you invoke __find_stripe().
>=20
> Moving it there avoids duplicate code, as well as makes a bit more
> sense, IMO, as it tells a whole story now.

Thanks for this.  It is a good cleanup.

However I don't want to make any new changes to the RAID5 code until I find=
 a
couple of bugs that I'm hunting.  So I won't apply it just yet.
Remind me in a couple of weeks if I seem to have forgotten.

Thanks,
NeilBrown


>=20
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/raid5.c | 50 ++++++++++++++++++------------------------------=
--
>  1 file changed, 18 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 77dfd72..e7fa818 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -567,8 +567,25 @@ static struct stripe_head *__find_stripe(struct r5co=
nf *conf, sector_t sector,
> =20
>  	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
>  	hlist_for_each_entry(sh, stripe_hash(conf, sector), hash)
> -		if (sh->sector =3D=3D sector && sh->generation =3D=3D generation)
> +		if (sh->sector =3D=3D sector && sh->generation =3D=3D generation) {
> +			if (!atomic_inc_not_zero(&sh->count)) {
> +				spin_lock(&conf->device_lock);
> +				if (!atomic_read(&sh->count)) {
> +					if (!test_bit(STRIPE_HANDLE, &sh->state))
> +						atomic_inc(&conf->active_stripes);
> +					BUG_ON(list_empty(&sh->lru) &&
> +					       !test_bit(STRIPE_EXPANDING, &sh->state));
> +					list_del_init(&sh->lru);
> +					if (sh->group) {
> +						sh->group->stripes_cnt--;
> +						sh->group =3D NULL;
> +					}
> +				}
> +				atomic_inc(&sh->count);
> +				spin_unlock(&conf->device_lock);
> +			}
>  			return sh;
> +		}
>  	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
>  	return NULL;
>  }
> @@ -698,21 +715,6 @@ get_active_stripe(struct r5conf *conf, sector_t sect=
or,
>  				init_stripe(sh, sector, previous);
>  				atomic_inc(&sh->count);
>  			}
> -		} else if (!atomic_inc_not_zero(&sh->count)) {
> -			spin_lock(&conf->device_lock);
> -			if (!atomic_read(&sh->count)) {
> -				if (!test_bit(STRIPE_HANDLE, &sh->state))
> -					atomic_inc(&conf->active_stripes);
> -				BUG_ON(list_empty(&sh->lru) &&
> -				       !test_bit(STRIPE_EXPANDING, &sh->state));
> -				list_del_init(&sh->lru);
> -				if (sh->group) {
> -					sh->group->stripes_cnt--;
> -					sh->group =3D NULL;
> -				}
> -			}
> -			atomic_inc(&sh->count);
> -			spin_unlock(&conf->device_lock);
>  		}
>  	} while (sh =3D=3D NULL);
> =20
> @@ -771,22 +773,6 @@ static void stripe_add_to_batch_list(struct r5conf *=
conf, struct stripe_head *sh
>  	hash =3D stripe_hash_locks_hash(head_sector);
>  	spin_lock_irq(conf->hash_locks + hash);
>  	head =3D __find_stripe(conf, head_sector, conf->generation);
> -	if (head && !atomic_inc_not_zero(&head->count)) {
> -		spin_lock(&conf->device_lock);
> -		if (!atomic_read(&head->count)) {
> -			if (!test_bit(STRIPE_HANDLE, &head->state))
> -				atomic_inc(&conf->active_stripes);
> -			BUG_ON(list_empty(&head->lru) &&
> -			       !test_bit(STRIPE_EXPANDING, &head->state));
> -			list_del_init(&head->lru);
> -			if (head->group) {
> -				head->group->stripes_cnt--;
> -				head->group =3D NULL;
> -			}
> -		}
> -		atomic_inc(&head->count);
> -		spin_unlock(&conf->device_lock);
> -	}
>  	spin_unlock_irq(conf->hash_locks + hash);
> =20
>  	if (!head)


--Sig_/6rV3JYptn3Ghm04PLklw9CZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUxJYDnsnt1WYoG5AQL28A//VQuwhwb+qry0e68Gt4qpZ5qE9+ZU680W
Hw1rRWxY9zF6g9gXMatIDNaRtFDhgVm/CvpFRKCZFXw6aZJ1KeQP6YTag9Srt6Ap
skPKWTcm2jB3MYV0dfEeEoliLYrXCshH913jgZneT2ixmZgLo6Vj/isYsFceoNL2
sEwVeDBhNFXpNhuUzC5boOmFWIm9h49q2eVXV70/8kWzpQCjLYx/vtKvlwI+fR7m
xJ+exvAtOEyK5v1Dx0uZ3NdzOgzD78WGpjbmrXMgV3StjB6ajRvha1sK65GI23Ii
5lJeSNIjrQu5Ox0ZQIIq8BCg1pDLZ5qw8TG9wVtDqk2t48Y4HyZzv8atUYpqCC9/
NS81zkHn6bh2lPwMQ8u2t2ui3FX4fcoI8h4raBQJdMzLe2QRRBTHP1r8aPlwwIyu
W+4u87C4WqRDcc+Q5dIBztwkxSL428h4qIBSWGgZkVrXAPDn3ZhrQRU7tj5A4D+a
5idkzsjA8Mtji9QAZ4xorPQyl+K5MrViRFekHHQYmoDVCr9u6dTs9X8fazaKjfz5
Js2NKbf8D/nm9L824c8BRJVzqAB/+JQfvwn+UF1QXSU3l/iCY0LTSmkuM8B5lPFb
xxWk5RbQffYmCkK9b/fzxjdQ6h31it+19R6EnakOkiHoaC0SF6NI5k3Szyc+rvHR
wuDO06dKaog=
=Iz5y
-----END PGP SIGNATURE-----

--Sig_/6rV3JYptn3Ghm04PLklw9CZ--
