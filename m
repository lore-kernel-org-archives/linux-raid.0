From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V1] md:Add place to update ->recovery_cp.
Date: Wed, 31 Oct 2012 11:20:42 +1100
Message-ID: <20121031112042.68bfc67a@notabene.brown>
References: <201210290951150457229@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ch89_A6/_Bp367RrLKuNRRL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210290951150457229@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Ch89_A6/_Bp367RrLKuNRRL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Oct 2012 09:51:25 +0800 kernelmail <kedacomkernel@gmail.com> wro=
te:

> In resyncing, recovery_cp only updated when resync aborted or completed.
> But in md drives,many place used it to judge.So add a place to update.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..5bd7d93 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7454,6 +7454,9 @@ void md_do_sync(struct md_thread *thread)
>  			wait_event(mddev->recovery_wait,
>  				   atomic_read(&mddev->recovery_active) =3D=3D 0);
>  			mddev->curr_resync_completed =3D j;
> +			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
> +				(j > mddev->recovery_cp))
> +				mddev->recovery_cp =3D j;
>  			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
>  			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
>  		}

Applied, thanks.

NeilBrown

--Sig_/Ch89_A6/_Bp367RrLKuNRRL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJBu2jnsnt1WYoG5AQI0wg//TpzGMsiH3aFcHVGpfoyrSO2qxj0yw18Y
ET9bX0K/koT7Zzi65+ZYF87VZTd8KjAnrk1S6L4yl57TJNqJ+0s+irVo8VsMGai4
SDuT7Yx3SCrXfVfRgs1SXD+sakiHifkcONVFTxg3x4S9vlpiMNrexc1+VyZJGaDb
r6++OIg0qIwa9X8aQCrDh30kGEl1wq5Dh+PXEd0MExPOv+kISmLKFjjAJoQtYD1C
uBV811YONUMYKhW42Knbr+OxzMYdulUMsnN1DGSKLBQCQffXTmbZUe4mlYXQzUag
1HPBYckDjpjmWP3AMKs2OJ3o0GQFbBE3kJzWshjW8Wv6Fl9dzgtByEE0YQ1GAAv3
6hBHJBjbP18FucJpKV/XaQn79W8HxmYHa3bw5Pyp6/4742X0PndbOI6q5uasx/W2
VPTjvRXOS6BEsYI/a0+WUOAoZw53UPHQPfIrHIs6My6DnC7966KwQMHqPpTWji4X
3t59P3czEa7lti2nQ9XZKoLkfNbyf0p/O4J9ONx/X3REYWwb1UZNk6HYgNf2HQKA
QHs6pJtAGYRU/YQc7jFgi1t3GjlRh8uitJfph+DNmnuYksi/52uRVYbmasaBZkhb
NGU+2wOKEEZ9ivLIYrvhhaFI7SOL011mS0Cfhiz7zlXGVVX8PVE6oVtilNvgjYu8
14Q2Lwn54XU=
=+vRX
-----END PGP SIGNATURE-----

--Sig_/Ch89_A6/_Bp367RrLKuNRRL--
