From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/5] md:Add place to update ->recovery_cp.
Date: Mon, 29 Oct 2012 08:35:29 +1100
Message-ID: <20121029083529.78c2024e@notabene.brown>
References: <201210271028113375556@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/reFnLC6hWJfW.qhiLOtBbjL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210271028113375556@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/reFnLC6hWJfW.qhiLOtBbjL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Oct 2012 10:28:18 +0800 kernelmail <kedacomkernel@gmail.com> wro=
te:

> In resyncing, recovery_cp only updated when resync aborted or completed.
> But in md drives,many place used it to judge.So add a place to update.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1d9940d..01e25bd 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7454,6 +7454,8 @@ void md_do_sync(struct md_thread *thread)
>  			wait_event(mddev->recovery_wait,
>  				   atomic_read(&mddev->recovery_active) =3D=3D 0);
>  			mddev->curr_resync_completed =3D j;
> +			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
> +				mddev->recovery_cp =3D j;
>  			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
>  			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
>  		}

This isn't correct.  If MD_RECOVERY_REQUESTED, then j might be less than
recovery_cp and we don't want to reduce recovery_cp.

If you would like to fix that (i.e. only set recovery_cp if it is less than
'j'), then I'll apply the patch.

NeilBrown

--Sig_/reFnLC6hWJfW.qhiLOtBbjL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI2lITnsnt1WYoG5AQISLhAAkw3NU+kNFRb6bzheZ4R6KT9vFRhj4BDy
b+GlxCWUjtze+nXWCloOkhOMvFoO2CmJXE26O0WWW8Z+jEdDu4TsOq+xud5Xol8W
M2Qa1ly4hjCLVBUxsqFW4GGLLGZfeoUbrUAwEJttBrxdNX8j+dgB+gDievE5pa56
X8onnSd+YrqRmOePy5RE4tZ2ZdFu3ag2oOXyvKWMUGiErbwHeeg6zANa0rkU1wtI
zskyhZ1BU0onIcol9P1INoPx22KndQILRWum1FAu+Zfhtf+Ne3DYFaSHWpwbs80t
a5fbmbQ5ev0i72sDrPVJg7SfsI/FMS/CY/1Ez23TDRdN2yxDLeqChUXRyHbzV/Sf
aU0hWuBAsP8mFaujKtv4XZhXHfZpQAzCtV1P38c5HZgn+fOTalCj50g3CES1R9C6
urcLR1IijOHiYZktDbOASB5q7zyB3cZ5C+dyzDLHU9BzE+7t36+9dKReIKkYRmWf
nYLgFyitFPU+0Fjd+mFc6vEL3ylOFYqMVOqPALYtphfxvmQCkJa+YpwOfMicnKlk
3lYBH3vIYGCHeMFlL4DYgP0AGK8gWROCCu0zgyav1JKJSna3I6fNzKGfl1yRT4DQ
KBm51Nqtu5xEhjidOryZkyP84jFWLlsOuoZdrkB/xPCwkvfLBRJzPbkJ+Hj2L2v0
hB+K1uCa2BI=
=nubY
-----END PGP SIGNATURE-----

--Sig_/reFnLC6hWJfW.qhiLOtBbjL--
