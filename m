From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: remove unnecesary md_new_event_inintr
Date: Mon, 04 Jan 2016 12:36:25 +1100
Message-ID: <87twmuxh0m.fsf@notabene.neil.brown.name>
References: <1451270798-25056-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1451270798-25056-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 28 2015, Guoqing Jiang wrote:

> md_new_event had removed sysfs_notify since 'commit 72a23c211e45
> ("Make sure all changes to md/sync_action are notified.")', so we
> can use md_new_event and delete md_new_event_inintr.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c0c3e6d..43a1404 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -205,15 +205,6 @@ void md_new_event(struct mddev *mddev)
>  }
>  EXPORT_SYMBOL_GPL(md_new_event);
>=20=20
> -/* Alternate version that can be called from interrupts
> - * when calling sysfs_notify isn't needed.
> - */
> -static void md_new_event_inintr(struct mddev *mddev)
> -{
> -	atomic_inc(&md_event_count);
> -	wake_up(&md_event_waiters);
> -}
> -
>  /*
>   * Enables to iterate over all existing md arrays
>   * all_mddevs_lock protects this list.
> @@ -7209,7 +7200,7 @@ void md_error(struct mddev *mddev, struct md_rdev *=
rdev)
>  	md_wakeup_thread(mddev->thread);
>  	if (mddev->event_work.func)
>  		queue_work(md_misc_wq, &mddev->event_work);
> -	md_new_event_inintr(mddev);
> +	md_new_event(mddev);
>  }
>  EXPORT_SYMBOL(md_error);
>=20=20
> --=20
> 2.6.2

Applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWicyZAAoJEDnsnt1WYoG53zkP/397Io5eobaT5t7tGf+/2zcP
95LU0JH+voPQoiUjnv/t+mmTODAgIN0pPaZl5Z0LAStY0JWzWOaSXhwUbPUgW7GH
C9KNF4EJbefupVE0SIVLgZ5FFlYMZgLV+cA8mAGzuRhUZSlonHtgMrpjotAS/AZV
INZJDfhxSYb5Btm60tbX2BswqFcpnfBC4mmTDURfkGAyqPsWLANOqGRQB03ZDlCq
vlTq9sUGEoOKdG8YWRTrXcGM9T1KQiwhjShdQQKQ/HuBBAotsGPxJuHpe4PvfGwa
cKzdzLJUaeoZDKRPcj+4pVa+3ms6EPoBuPogHCOXje4VbnhJ2IzXltAfvltZVf6D
TS+6S6EuZgp0dQBFRGa8DJyTiE2fyQsAa0XGgaPKvbcTUIwW3PBa4azmSjZoYIGe
dKJAqe+OjWJjLf5XNSt0ikNhnmaHGXe3Ct9EgCd9vGmOQrd3Zj9A/OBtDUntKDIN
nizpk9Of/FEyCtHZPSRSj9EMIKPjy4LoVQJp7+ANt2soEZuNpvF9zRB0UHpf/4ir
WdFq7PIWTZZt/M3UcV4Ak/yK0F4KzQ3/FCMZSQ5ZBxkRoMVnBkWhBZzGe6fLUF9P
sM0U2xpgDjOQmF7E1T9XLSDy5F+JJXbxWqt4wcxvaLW9Bu4HG63fTfGY3F2fIjs0
FybYuz8Qoh4jr7vSccyj
=AdMv
-----END PGP SIGNATURE-----
--=-=-=--
