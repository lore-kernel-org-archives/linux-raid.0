From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] raid5: fix wakeup condition
Date: Fri, 29 May 2015 15:23:16 +1000
Message-ID: <20150529152316.0cd77069@notabene.brown>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
	<de048e4f0889e59ffb452f8b5f704bd888fcc1c1.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/j17iFMWJWwCOlmYmh.CKZnV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de048e4f0889e59ffb452f8b5f704bd888fcc1c1.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/j17iFMWJWwCOlmYmh.CKZnV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 May 2015 17:33:48 -0700 Shaohua Li <shli@fb.com> wrote:

> Since we have several stripe hash list, the conf->active_stripes doesn't
> determine if there is free stripe in a specific hash list, so delete the
> check. After this, the R5_INACTIVE_BLOCKED check is inappropriate. There
> is no point not to wakeup a task if there is free stripe.
>=20
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 67626f3..4b5a03c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -687,11 +687,7 @@ get_active_stripe(struct r5conf *conf, sector_t sect=
or,
>  					&conf->cache_state);
>  				wait_event_lock_irq(
>  					conf->wait_for_stripe,
> -					!list_empty(conf->inactive_list + hash) &&
> -					(atomic_read(&conf->active_stripes)
> -					 < (conf->max_nr_stripes * 3 / 4)
> -					 || !test_bit(R5_INACTIVE_BLOCKED,
> -						      &conf->cache_state)),
> +					!list_empty(conf->inactive_list + hash),
>  					*(conf->hash_locks + hash));
>  				clear_bit(R5_INACTIVE_BLOCKED,
>  					  &conf->cache_state);

Have you actually tested this?  Because I do remember why I put that code in
and it made a very real performance improvement.

The idea is that once we run out of free stripes, we wait until there a lots
available.  That improves opportunities for batching.

So I would definitely needs some performance numbers with a patch like this.

Thanks for the review anyway !!

NeilBrown

--Sig_/j17iFMWJWwCOlmYmh.CKZnV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWf3xDnsnt1WYoG5AQLsxhAAhxiyQv5SZLB0CM6f7R6aE9HaAuXFeKUb
dXZNdr7SW1CLGqG9TGeDAAI1gmINn0XLA9rhal40eNUfzSKa0z46iZ4n0GHJbcCb
X7BQdpfKiWq7w9muqnefZlUMLr5G1m5WhG4SKEOKf3gU8IzhLp3Ln5SbduxczWlz
lsWcQbIs+dTphOfrFXkBvln/pD/L3ACj08xMTaICbtatH9nU4KRgiAFwb8PT+ar6
+Aaejb2U5XzuEIYn7CG7ZHUihdKD2VquG+PkkLq0l/VIbK6o8b0m4ld141Ouuo6m
B6O9s53cqdHPWbr064TP6HSa1RjnPdtyZKLq+jwqCy5g0e9o4lvTxgcZfL3G0BTw
/nh2s3ft6bW7NvnouUpINfP7KS/hPzgAlMLrf/VYPGXqo6qx1Kuer7l0S4RATa1I
mnXVw/xOeZDAp/Rod/YbnB/c5u2e5iUVhU+1F/KPGI1OLMDw46ooTVXkop6hb7J6
H9775RLUGsPkUBd9BP6Dh5cl5Jw3n+WrenYsqyZDKJUHkoNKMb/fwAR1L0BzsYOQ
2ThKyhCQv9k5Qt4hHVe6cvCcGR0ZFvFATKVXY1xd8YAlPRyNqJ9n/HUik0V01RDT
gPOeWubFBZQ49KrCH56dQvaxC26OdGItE2BdUHYxN7amVrAQtFDuK0xePfYz6A1F
fprCmlrPwas=
=vmv/
-----END PGP SIGNATURE-----

--Sig_/j17iFMWJWwCOlmYmh.CKZnV--
