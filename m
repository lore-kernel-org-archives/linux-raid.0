From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Fri, 16 Jun 2017 13:26:00 +1000
Message-ID: <877f0c7gvr.fsf@notabene.neil.brown.name>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 09 2017, Shaohua Li wrote:

> From: Shaohua Li <shli@fb.com>
>
> suspend range is controlled by userspace. If userspace doesn't clear susp=
end
> range, it's possible a thread will wait for the range forever, we can't e=
ven
> kill it. This is bad behavior. Add a timeout in the wait. If timeout happ=
ens,
> we return IO error. The app controlling suspend range looks like part of =
disk
> firmware, if disk isn't responded for a long time, timed out IO error is
> returned.
>
> A simple search in SCSI code shows maximum IO timeout is 120s, so I use t=
his
> value here too.

I really don't like this.  It is an API change with no really
justification.  Has the current behavior caused a problem?

Both md and dm export  APIs which allow IO to be suspended while
changes are made.  Changing that to a timed-out period needs, I think,
to be clearly justified.

If it is changed to a timed-out period, then that should be explicit,
rather than having each request independently time out.
i.e. when the suspend is initiated, the end-time should be computed, and
any IO would block until that time, not block for some number of
seconds.

If an md device is left suspended, then the current code will block IO
indefinitely.  This patch will at a 20minute times to every single
request, which will mean IO proceeds, but extremely slowly.  I don't see
that as a useful improvement.

Thanks,
NeilBrown


>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.h    |  1 +
>  drivers/md/raid1.c | 12 +++++++++++-
>  drivers/md/raid5.c | 10 +++++++++-
>  3 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 63d342d560b8..11a0ec33e79b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -29,6 +29,7 @@
>=20=20
>  #define MaxSector (~(sector_t)0)
>=20=20
> +#define MD_SUSPEND_TIMEOUT (120 * HZ)
>  /*
>   * These flags should really be called "NO_RETRY" rather than
>   * "FAILFAST" because they don't make any promise about time lapse,
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d9e5373444d2..bc6dee0259df 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1326,6 +1326,7 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,
>  	    (mddev_is_clustered(mddev) &&
>  	     md_cluster_ops->area_resyncing(mddev, WRITE,
>  		     bio->bi_iter.bi_sector, bio_end_sector(bio)))) {
> +		long remaining =3D -1;
>=20=20
>  		/*
>  		 * As the suspend_* range is controlled by userspace, we want
> @@ -1345,10 +1346,19 @@ static void raid1_write_request(struct mddev *mdd=
ev, struct bio *bio,
>  				break;
>  			sigfillset(&full);
>  			sigprocmask(SIG_BLOCK, &full, &old);
> -			schedule();
> +			remaining =3D schedule_timeout(MD_SUSPEND_TIMEOUT);
>  			sigprocmask(SIG_SETMASK, &old, NULL);
> +			if (remaining =3D=3D 0)
> +				break;
>  		}
>  		finish_wait(&conf->wait_barrier, &w);
> +		if (remaining =3D=3D 0) {
> +			pr_err("md/raid1:%s: suspend range is locked\n",
> +				mdname(mddev));
> +			bio->bi_error =3D -ETIMEDOUT;
> +			bio_endio(bio);
> +			return;
> +		}
>  	}
>  	wait_barrier(conf, bio->bi_iter.bi_sector);
>=20=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cf1ac2e0f4c8..24297f1530d1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5685,6 +5685,7 @@ static bool raid5_make_request(struct mddev *mddev,=
 struct bio * bi)
>  			if (rw =3D=3D WRITE &&
>  			    logical_sector >=3D mddev->suspend_lo &&
>  			    logical_sector < mddev->suspend_hi) {
> +				long remaining =3D -1;
>  				raid5_release_stripe(sh);
>  				/* As the suspend_* range is controlled by
>  				 * userspace, we want an interruptible
> @@ -5697,10 +5698,17 @@ static bool raid5_make_request(struct mddev *mdde=
v, struct bio * bi)
>  					sigset_t full, old;
>  					sigfillset(&full);
>  					sigprocmask(SIG_BLOCK, &full, &old);
> -					schedule();
> +					remaining =3D schedule_timeout(
> +							MD_SUSPEND_TIMEOUT);
>  					sigprocmask(SIG_SETMASK, &old, NULL);
>  					do_prepare =3D true;
>  				}
> +				if (remaining =3D=3D 0) {
> +					pr_err("md/raid5:%s: suspend range is locked\n",
> +						mdname(mddev));
> +					bi->bi_error =3D -ETIMEDOUT;
> +					break;
> +				}
>  				goto retry;
>  			}
>=20=20
> --=20
> 2.11.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllDT8kACgkQOeye3VZi
gbmH8A//e+XgpkwtVLM2zz7k67UwV/2KLHtp2ar/MGTXxFXSDIzraPSf5j8gVfIo
ZydyNdnwDxI4fPOICei5Pfig+swzVU8VsoTswFC0GE2QoZ3winEYBn8Xva0ICUad
JyQY2R/ZlB2Ho1a1sDc4+OjYZm5BlOcrUAGhTLRtCPMJoIblSDrz4Y9DSNhTD6Ij
QECpAbTtCUOcIrnm9wN5QnaKiTKSWxX7aFAtvCd4rUuu9E8kZReHSorgCN+VmFi1
uKKPqUL4iA3VVhrictEl6xk9C14qLVWQPzy7PHECT7geoiVnd4EpLdNmTdfgjrOo
kiiXbwBc96KD9UZ5tid2L3zmeXDA1FYYqVAT1TwQPvbN7T1lXecS/mFZ2aAb+rSF
dHRQK/r/8aGCTN8f3eLIf7qFGN4ujEHeX/dHA2EBWhxLrg3+eUGUixs9/PnwUPte
B3dtJx+XMed4ZaDAyzAo5UyDgy8sqgVffxpCGu2Ro7kwdunB/OQi5yxKaVWRVOwc
TFz+N7Ztl5VlDdMDtUjrdJE/kkEM0xxli1L6P3sxvrkuTqR1JpMztIQf1GQd9riP
z+R8uPeJng4wYJ0RSvCXyyfhwpDUeU4rSO5pvtuO0EmhJEtERFM8lcUHpQyvyerm
6USW9TNPB8RQAz0D2S/YePx8yi6YZcJRUHbdynTcZd2pa7XIslA=
=A/Hw
-----END PGP SIGNATURE-----
--=-=-=--
