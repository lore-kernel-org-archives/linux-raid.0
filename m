From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/5] md: When resync aborted,using ->curr_resync as the
 last completed request rather than ->curr_resync_completed.
Date: Mon, 19 Nov 2012 12:37:33 +1100
Message-ID: <20121119123733.097b3804@notabene.brown>
References: <2012102710283109761110@gmail.com>
	<20121029083241.2a2dedcc@notabene.brown>
	<2012102911174841643114@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=cSoUvVDCZml3dTvjuZ=K9l"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012102911174841643114@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=cSoUvVDCZml3dTvjuZ=K9l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Oct 2012 11:27:25 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Sat, 27 Oct 2012 10:28:58 +0800 kernelmail <kedacomkernel@gmail.com> =
wrote:
> >
> >> In commit(db91ff55bdf06736b849afc1b1fce5763bbb8d5d),it said:
> >> >If a resync is aborted we should record how far we got
> >> >(recovery_cp) the last request that we know has completed
> >> >(->curr_resync_completed) rather than the last request that was
> >> >submitted (->curr_resync).
> >> But when resync aborted, it execed
> >> >wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active=
));
> >> After this, the ->curr_resync is the last completed request.
> >>=20
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/md.c |    3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>=20
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 9ab768a..1d9940d 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -7558,8 +7558,7 @@ void md_do_sync(struct md_thread *thread)
> >>  					printk(KERN_INFO
> >>  					       "md: checkpointing %s of %s.\n",
> >>  					       desc, mdname(mddev));
> >> -					mddev->recovery_cp =3D
> >> -						mddev->curr_resync_completed;
> >> +					mddev->recovery_cp =3D mddev->curr_resync;
> >>  				}
> >>  			} else
> >>  				mddev->recovery_cp =3D MaxSector;
> >
> >No.
> >This reverts commit db91ff55bdf06736b849afc1b1fce5763bbb8d5d
> >
> >Maybe if we differentiated between an abort-due-to-error and an
> >abort-due-to-request, then in the second card we could use ->curr_resync.
> >
> >NeilBrown
> >
> Yes, i missed the case which interrupted by io-error.
> So i add a flag MD_RECOVERY_ERROR in md_done_sync.
> =20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..cb9864c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7172,6 +7172,7 @@ void md_done_sync(struct mddev *mddev, int blocks, =
int ok)
>         wake_up(&mddev->recovery_wait);
>         if (!ok) {
>                 set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +               set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
>                 md_wakeup_thread(mddev->thread);
>                 // stop recovery, signal do_sync ....
>         }
> @@ -7558,8 +7559,12 @@ void md_do_sync(struct md_thread *thread)
>                                         printk(KERN_INFO
>                                                "md: checkpointing %s of %=
s.\n",
>                                                desc, mdname(mddev));
> -                                       mddev->recovery_cp =3D
> -                                               mddev->curr_resync_comple=
ted;
> +                                       if (test_bit(MD_RECOVERY_ERROR, &=
mddev->recovery))
> +                                               mddev->recovery_cp =3D
> +                                                       mddev->curr_resyn=
c_completed;
> +                                       else
> +                                               mddev->recovery_cp =3D
> +                                                       mddev->curr_resyn=
c;
>                                 }
>                         } else
>                                 mddev->recovery_cp =3D MaxSector;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index af443ab..3b1a35f 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -307,6 +307,7 @@ struct mddev {
>          * REQUEST:  user-space has requested a sync (used with SYNC)
>          * CHECK:    user-space request for check-only, no repair
>          * RESHAPE:  A reshape is happening
> +        * ERROR:    interrupted by IO error not by request
>          *
>          * If neither SYNC or RESHAPE are set, then it is a recovery.
>          */
> @@ -320,6 +321,7 @@ struct mddev {
>  #define        MD_RECOVERY_CHECK       7
>  #define MD_RECOVERY_RESHAPE    8
>  #define        MD_RECOVERY_FROZEN      9
> +#define MD_RECOVERY_ERROR      10
> =20
>         unsigned long                   recovery;
>         /* If a RAID personality determines that recovery (of a particular
>=20
>=20
> How about this patch?
>=20
> Jianpeng
>=20
>=20

Look OK except that it is badly white-space damaged.
Could you try resending it properly please?

Thanks,
NeilBrown

--Sig_/=cSoUvVDCZml3dTvjuZ=K9l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKmNXTnsnt1WYoG5AQK5ww//Sw4eoHX2I1NtaxV6SG2OKxWx4IXCt4IF
XWvz5os2Vfmiuo2Wqw2VlezXUWGRV79kBnFsuwtKlEYd/O2XZEzZikquFTON8pnw
Nf0KOCKXkGNAjD9+2S+iwPa/nyxmHKWQoCOBb/0g70SgeTSYblj9g4ADFTER5Cva
kHZ/rDYSKP36GyxnxD9A0pdAxf55HhTUSbTbBhnSB9jVl93OYw/lm5hadaWQlCej
l14tvpSEdF+TgMBK6WtsZus3AW9OIDlAVXUelt4JaihIyqtUkjLHrzaaIykoexIq
YjnHb270jp8ZSu7KuEEKWndcwEcoFuDj4qEWTu9JuSzv0I+5bbVPG+gZwP3sHxmA
HJa5QtXs2ThdUrHfCqmEdBnipYMt3teA3bPPbbyQ+W335EoQNfbPU21LZijCDU2e
3ZN8HDdtiJqQc5VinvnR55LYu5HL+S6JJzFWhKh65/EpCDoTm4UhL3eNQXr1DfzK
maKKBI/OL/QX/NQVwizT+MoMBZEZm470LktkoPLJyq3caIY50I9J1rXG+Gaug4n5
ch6AzBjLW/IHVU3Gm3mv5slCUV9L1zZjIzxo1FuV/n2GW+SkaiuURvFBjbsZoejq
wUcX4Iq+0Ugoc26uxQ/tXd+7InWc+HowGsUy2OfrZjrpXDsKdDo6iIt6zcj5zw5I
FgUdDA20pQ4=
=rnB3
-----END PGP SIGNATURE-----

--Sig_/=cSoUvVDCZml3dTvjuZ=K9l--
