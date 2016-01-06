From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] raid5-cache: destroy mempool
Date: Wed, 06 Jan 2016 12:50:19 +1100
Message-ID: <874merxyqs.fsf@notabene.neil.brown.name>
References: <9ab2f48aab9ddc9aa7ac2b9b6a594a97c2d82f5f.1451954517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9ab2f48aab9ddc9aa7ac2b9b6a594a97c2d82f5f.1451954517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Jan 05 2016, Shaohua Li wrote:

> io_unit mempool isn't destroied with recent changes.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index d992d62..55a905e 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1257,6 +1257,7 @@ void r5l_exit_log(struct r5l_log *log)
>  	md_unregister_thread(&log->reclaim_thread);
>  	mempool_destroy(log->meta_pool);
>  	bioset_free(log->bs);
> +	mempool_destroy(log->io_pool);
>  	kmem_cache_destroy(log->io_kc);
>  	kfree(log);
>  }

Thanks!
I've merge that into the offending patch rather than adding it as a
separate patch.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjHLbAAoJEDnsnt1WYoG5m1gP/1TFDmcG6pcJp49fnokcwX4U
P1AH+dr6a1YhIvIOWU3iJyOAsPYymecNoECejlhiIbc4uWOopQLuhixpgNnCFEU6
rSX4VsBG1MQ1ulkq7IjX939i5TVM0BFPuV72mKmGBgTDYu4kSqqaeQMpEHmivx4z
pc0qtinXW9gVxTIR92lvw3horpdWwH07uP5CJd+wudjNXat9YAvqxzkT9PQIhsYx
gWo3Szdtz4SPVb84bzfxXrd3Bo0DPLBZmRmRgodJCzevbHF7e5oTyWp3kPwDpp0D
kWfzX6M6xHdrfV9JsfNaL3Dka5Re5n+SZuLcH5k2Bi3lUu0L3QkFhaJnRUScK7Wb
TuXE3FmBxWNBwUSD2Wp9yxnMQY533CHDgfEqcEzQegJOOovORSswGwXYG/ombcrb
NCGRpDiE5FZlRgnSOYpONltrtEE6M7hZsgEEBjajBrVpEkL7OwURjnKBcKQSr3Eh
THVqIngmzL8wXPeLyIiMRwkrNphsg8xO2bC9BJlvVJPitQg6XiicTHUYgWBEHnys
SBnII443v6Uiw/peakKj8KsfNRZ+Pn68Q2mjXdPN5t9kb6aUQ7cy3JmgXIgLK+Q2
fPpCU0wMq4X0A+SRE+dy3saD3c2sZJ4JKtadaNr37KPBCAqj4Z9T78cMGcvnci5g
VSo2z9kHmS4QMY3Ukx2c
=4jPZ
-----END PGP SIGNATURE-----
--=-=-=--
