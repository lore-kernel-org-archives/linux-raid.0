From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/5] md: When resync aborted,using ->curr_resync as the
 last completed request rather than ->curr_resync_completed.
Date: Mon, 29 Oct 2012 08:32:41 +1100
Message-ID: <20121029083241.2a2dedcc@notabene.brown>
References: <2012102710283109761110@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QS6kHzT93EyvCp2.+ALKVdf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012102710283109761110@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/QS6kHzT93EyvCp2.+ALKVdf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Oct 2012 10:28:58 +0800 kernelmail <kedacomkernel@gmail.com> wro=
te:

> In commit(db91ff55bdf06736b849afc1b1fce5763bbb8d5d),it said:
> >If a resync is aborted we should record how far we got
> >(recovery_cp) the last request that we know has completed
> >(->curr_resync_completed) rather than the last request that was
> >submitted (->curr_resync).
> But when resync aborted, it execed
> >wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
> After this, the ->curr_resync is the last completed request.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..1d9940d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7558,8 +7558,7 @@ void md_do_sync(struct md_thread *thread)
>  					printk(KERN_INFO
>  					       "md: checkpointing %s of %s.\n",
>  					       desc, mdname(mddev));
> -					mddev->recovery_cp =3D
> -						mddev->curr_resync_completed;
> +					mddev->recovery_cp =3D mddev->curr_resync;
>  				}
>  			} else
>  				mddev->recovery_cp =3D MaxSector;

No.
This reverts commit db91ff55bdf06736b849afc1b1fce5763bbb8d5d

Maybe if we differentiated between an abort-due-to-error and an
abort-due-to-request, then in the second card we could use ->curr_resync.

NeilBrown

--Sig_/QS6kHzT93EyvCp2.+ALKVdf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI2keTnsnt1WYoG5AQLR9Q//SbGUY0JsWtWNmiqGF9Us/YlKmmMMUYHI
BC/giF0iQsnb8lBRjbUIShkcSUEfT/rFmwrgxbgqzJc0MkFzwJ4JjbTT5vtOm64v
Nq0HHsZLFiO4NyP2JIP1eHDsNGkv/jZRpvwUo+CNAUF5QX2NEBMLPkNCy8rI3e6x
ORDLjCBwwHxcJ2AkfdzskcpWNGU3cm+plpxhATTQ8avjAVUsDU0ggv6LQaIO5IVD
8ABUrapVzQecFSeihzoBeetoE75vVnenjYkjj52rxkFxFsgF63DQ9Tx+PB90tRKY
TkXOOmdkn4h9zwKYInxvPdFLyHIiaxjHMNXxhOsymb+rUnUIbtAIrJWtctGa50pn
WYnhGjenxRB8YT6qK+9yQvMrk8llLK2CD5+YZq7/C2IJiGiudU3N/vC+kv2rJHxa
uTVLnPilC4lFd6Su+NSnam6XGrLv7Q99sTXKt0hTj8r5BFqB13Se6vGKYPMJ0Lj2
PXITUgdYtmAObB3D4q+CJmiMnHGV5cDE1s47tm786zl7ElXu42VlJvdmdU5QL5DZ
xSV7hilgPavhTKCXwn3x4sX15pj0AYFUIJzxCbcuTt1EtOePMVmnM66hbHRGanvK
2mZ89Xh5As+3ueRs73CbdZZgSRXk55YQLNT1CkxmSONYuYcc78GK0fzT0BaW8ZRv
zRDc+15p4yQ=
=zA5H
-----END PGP SIGNATURE-----

--Sig_/QS6kHzT93EyvCp2.+ALKVdf--
