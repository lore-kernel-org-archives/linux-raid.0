From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
Date: Thu, 31 Oct 2013 11:16:12 +1100
Message-ID: <20131031111612.2735d0c1@notabene.brown>
References: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QN1VansVW.J2ZAn8L_Hzkvd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QN1VansVW.J2ZAn8L_Hzkvd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Oct 2013 13:20:22 +0100 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> In case of reshape of raid0 through raid4 a value of discard_granularity
> will be set to stripe size. MD driver should re-set this value to correct
> one when migration will be finished. Otherwise array will be left with
> wrong value and discard operations will not work properly.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Cc: Shaohua Li <shli@kernel.org>
> ---
>  drivers/md/raid0.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c4d420b..807ca3a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -266,6 +266,8 @@ static int create_strip_zones(struct mddev *mddev, st=
ruct r0conf **private_conf)
>  	}
>  	mddev->queue->backing_dev_info.congested_fn =3D raid0_congested;
>  	mddev->queue->backing_dev_info.congested_data =3D mddev;
> +	mddev->queue->limits.discard_granularity =3D
> +			queue_logical_block_size(mddev->queue);
> =20
>  	/*
>  	 * now since we have the hard sector sizes, we can make sure

Thanks, but this doesn't seem like the right sort of fix.  It is to specific
to the symptom rather than trying to address the underlying problem.

Maybe something like this?  Can you review and test?

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 628cd529343f..740b6340f980 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3620,6 +3620,7 @@ level_store(struct mddev *mddev, const char *buf, siz=
e_t len)
 		mddev->in_sync =3D 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
+	blk_set_stacking_limit(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);

--Sig_/QN1VansVW.J2ZAn8L_Hzkvd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnGhTDnsnt1WYoG5AQLoeBAAjZBrsLz72tts2FXhs8B4A+1/Tp9exK1S
udJJk38SYP1r8XuKAzqH/nbQpwZ6yAW/gt902mbUgJgiuwAACuMypCJPD2hxIYD3
S2RaSFDNZ5h8U22fHyYplgQwA0jAbRYC+mdHLdxHD/yQ5IqmztBdOTDEK62ZuaKZ
lgM71hFJpIscaiLTl3glJK1Nh3Sez6rmI00yZizRQ6Dd2KdVcJPTNjZZ07SD5ek/
id+K9Qdx7Iy2drE7fK5L8NG22BphE8dY5XFGj9cpKEE9sPWtt/kwnnPNXSV72OzF
rd1GR8pSQ+oYlITVSa528Qi9nX2pAiQMDgm741HyruOFWSq7tZahvWMoYHwrlM5U
Z6mms+6bqLKom6ExswdwKwGdwIxOCvNV5Fv6k0Zly1bD8wp1racIbhK9Ekumk9ZJ
W30T+OWJIGG8irKX9hfPO/noAE02PpszFuyfw/VA+WDsmpNGDs1xEwxQ9V9ejFsd
S9PhvPdsI0JJd+OrGt7C1K9HHTm2s6hsqFuPDiAU450UukipnVBLaWeBecXBR5YD
WBMrWJgAN00pIimiUzBWLDMelHXj3dX29A0CWjDEy1U6sUnSnxt83SQNKPSnKlB2
dbYSO8A/npyY5Y66z6FFnxCJdvpelZtxpW61muK3WjwDUtYv8zxUCksz0IDBcQco
Kaamw5szsM4=
=F60I
-----END PGP SIGNATURE-----

--Sig_/QN1VansVW.J2ZAn8L_Hzkvd--
