From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V1] md:For aborted a resync by request,using
 ->curr_resync as the last completed request rather than
 ->curr_resync_completed.
Date: Tue, 20 Nov 2012 09:07:25 +1100
Message-ID: <20121120090725.7de3348a@notabene.brown>
References: <201211191957314065143@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AX/Iq+M/VrfEAy3d4O+2LaO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211191957314065143@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/AX/Iq+M/VrfEAy3d4O+2LaO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Nov 2012 19:57:34 +0800 majianpeng <majianpeng@gmail.com> wrote:

> V0-->V1:
> As suggested by neil, it added a flag MD_RECOVERY_ERROR to differentiate =
between an
> abort-due-to-error and an abort-due-to-request.We only deal with the late=
r case.
>=20
> Thanks!
> Jianpeng
>=20
> Aborting a resync maybe by io-error,or request(stop array or reboot
> system).
> So we add a flag MD_RECOVERY_ERROR to differentiate between an
> abort-due-to-error and an abort-due-to-request.
> For the later case,when resync aborted,it exec
> wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active)).
> So the ->curr_resync is the last completed request.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |   10 ++++++++--
>  drivers/md/md.h |    2 ++
>  2 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..5199657 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7172,6 +7172,7 @@ void md_done_sync(struct mddev *mddev, int blocks, =
int ok)
>  	wake_up(&mddev->recovery_wait);
>  	if (!ok) {
>  		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
>  		md_wakeup_thread(mddev->thread);
>  		// stop recovery, signal do_sync ....
>  	}
> @@ -7558,8 +7559,13 @@ void md_do_sync(struct md_thread *thread)
>  					printk(KERN_INFO
>  					       "md: checkpointing %s of %s.\n",
>  					       desc, mdname(mddev));
> -					mddev->recovery_cp =3D
> -						mddev->curr_resync_completed;
> +					if (test_bit(MD_RECOVERY_ERROR,
> +						&mddev->recovery_cp))
> +						mddev->recovery_cp =3D
> +							mddev->curr_resync_completed;
> +					else
> +						mddev->recovery_cp =3D
> +							mddev->curr_resync;
>  				}
>  			} else
>  				mddev->recovery_cp =3D MaxSector;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index af443ab..c29e62e 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -307,6 +307,7 @@ struct mddev {
>  	 * REQUEST:  user-space has requested a sync (used with SYNC)
>  	 * CHECK:    user-space request for check-only, no repair
>  	 * RESHAPE:  A reshape is happening
> +	 * ERROR:    sync-action interrupted because io-error
>  	 *
>  	 * If neither SYNC or RESHAPE are set, then it is a recovery.
>  	 */
> @@ -320,6 +321,7 @@ struct mddev {
>  #define	MD_RECOVERY_CHECK	7
>  #define MD_RECOVERY_RESHAPE	8
>  #define	MD_RECOVERY_FROZEN	9
> +#define	MD_RECOVERY_ERROR	10
> =20
>  	unsigned long			recovery;
>  	/* If a RAID personality determines that recovery (of a particular



The attachment still have MS-windows line endings ("\r\n" instead of just
"\n") but it wasn't too hard to strip those out.

Applied, thanks,
NeilBrown


--Sig_/AX/Iq+M/VrfEAy3d4O+2LaO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKqtnTnsnt1WYoG5AQJdgBAAq2qzCNM7shkVLSgFS2tyqPm/YR25GOiZ
1/Fj/OFe6OF/QEQ+8yjJBsbTstiybQSbnyeW04xWK3vlatfy4GKSdoclqX8Yw/UM
w7bQxlZQ16J88j5cC1o4ampJUkQmdP9OSBttCtkgmV0Ekik4BgyUmLnrBe1xv6iF
MdQMo0oeDzkEFoxH7slW1akLfm0BipT5ALyZdIeFiCBZ4uihm3IpbCT3fm72bvui
avGX6ZMWgCxX02LBZU63WzSgW1M7RO+tyNiOsvvn8Seml3C8LwXYM5xyg9dr19M9
6mbkiQs52xodPXqfxGf88oi/8Pdw899g5EJc86sN3O56fs+rHRBduXDYcBN7bGGH
Uru6NyD98xCdF8fq0lA0uteJ4utib869zzmivkRYBBshZcmk99nhUQjvYcgSnzg+
LyFEyRxfyLZUbD55xAyMDee/x7zlZWOdjodyVKWRnQrXVXxTrZjyZPNjPO9Yt4Om
dRqtJqmtC50i63HjHcAzrl5vgozmupeZO0gcoIKJao6GkDqTRqgwFPUt3VSHuzRI
5oDf3o9i8/On0DfENoSdOOWjdXlq4/I9nRVFTmG1wXSOARDW/wlbPo117nJ+jdUp
fkgWDKZk1OSgPy1uhHx0DsaPcXRwkNv1fvNBcIY37yXyUrotMjp4kzqZZUCNV7PI
X/+5GOnSYCc=
=E25M
-----END PGP SIGNATURE-----

--Sig_/AX/Iq+M/VrfEAy3d4O+2LaO--
