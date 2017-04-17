From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/raid10: wait up frozen array in handle_write_completed
Date: Tue, 18 Apr 2017 09:04:01 +1000
Message-ID: <87shl6tz4u.fsf@notabene.neil.brown.name>
References: <20170417091105.27180-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170417091105.27180-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 17 2017, Guoqing Jiang wrote:

> Since nr_queued is changed, we need to call wake_up here
> if the array is already frozen and waiting for condition
> "nr_pending =3D=3D nr_queued + extra" to be true.
>
> And commit 824e47daddbf ("RAID1: avoid unnecessary spin
> locks in I/O barrier code") which has already added the
> wake_up for raid1.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/raid10.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 4167091..acb3f46 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2704,6 +2704,11 @@ static void handle_write_completed(struct r10conf =
*conf, struct r10bio *r10_bio)
>  			list_add(&r10_bio->retry_list, &conf->bio_end_io_list);
>  			conf->nr_queued++;
>  			spin_unlock_irq(&conf->device_lock);
> +			/*
> +			 * In case freeze_array() is waiting for condition
> +			 * nr_pending =3D=3D nr_queued + extra to be true.
> +			 */
> +			wake_up(&conf->wait_barrier);
>  			md_wakeup_thread(conf->mddev->thread);
>  		} else {
>  			if (test_bit(R10BIO_WriteError,
> --=20
> 2.10.0

Reviewed-by: NeilBrown <neilb@suse.com>

I think I looked at this once before and convinced myself that
md_wakeup_thread() would wake up the only thread that might be waiting
in freeze_array().  This is completely wrong, so I don't know why I
thought it:-(

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj1SeEACgkQOeye3VZi
gbmcSw/9HYL0tWulGA778jGEpfmy4JfRDzt3NkPKAjUB01Tvc/qkPtxv2hieiAt3
K2ht/OMyMMaH2oBVM1ffmx6RlZUpxlPNwnuyLWSAIlGQXzTq3Uf+abcQRgCk1qwd
UIippScVDJCgOa7NfDqRaqR6tpvfDChGDj80zC8ttwhoDYvD4oS5FVFrakcJ4YP6
DoJdyO/2TnMCGQMBdTEmrwyObExUlVBvFsRbSIZetxIEU4NgO7c2swFUcg6JM/nJ
Yt07v94d0oIYn0qeikQHaWAE2ONoyoZ+IzreAdcH2J0YXUtjUxVLGobaKFqwHf12
vwKIbGJSJTgt959ii0B3IWnNr8F53yqgrDcaJ7sep9aps47WZ1f4XkJeJ2LyEyrh
ZqqDk8jtVTk9PMkB41RB664F8f2XMGQiRg4Ceg+6mDGOmp0gm7YhW0NhQG1mhMYI
0iIeAxm7Tic/UJs4taooQoGDEq+Kq2GXChKcjeRbZv/50S+ZHT8qgf0wh3a8E7b0
Fgk+p897vwDLPLbLeabCjBFmKTTp+OHpQM23ut6JsgHK0YQS1pDJqYh4QdBbNXgs
Yb0a0y8+a58xdkwxv5wq9I4n+IMsti65lp61xeRNZJbZ1pTt6Fuc+n5uTN008ey0
stb31Vm0vUvG5p2DhYAK3QALPGqVlTi4PAPhdpyDxyd8K8QBvjg=
=xHks
-----END PGP SIGNATURE-----
--=-=-=--
