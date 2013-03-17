From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID10: Allow skipping recovery when clean arrays are
 assembled
Date: Mon, 18 Mar 2013 10:06:45 +1100
Message-ID: <20130318100645.3d5aa71c@notabene.brown>
References: <51422D10.3040000@arcor.de>
	<1363291891-10408-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f1brk.P1S917wgg4LRglKAK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363291891-10408-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/f1brk.P1S917wgg4LRglKAK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Mar 2013 21:11:31 +0100 mwilck@arcor.de wrote:

> From: Martin Wilck <mwilck@arcor.de>
>=20
> When an array is assembled incrementally with mdadm -I -R
> and the array switches to "active" mode, md starts a recovery.
>=20
> If the array was clean, the "fullsync" flag will be 0. Skip
> the full recovery in this case, as RAID1 does (the code was
> actually copied from the sync_request() method of RAID1).
> ---
>  drivers/md/raid10.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 64d4824..e373d88 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2863,6 +2863,22 @@ static sector_t sync_request(struct mddev *mddev, =
sector_t sector_nr,
>  		if (init_resync(conf))
>  			return 0;
> =20
> +	/*
> +	 * Allow skipping a full rebuild for incremental assembly
> +	 * of a clean array, like RAID1 does.
> +	 */
> +	if (mddev->bitmap =3D=3D NULL &&
> +	    mddev->recovery_cp =3D=3D MaxSector &&
> +	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> +	    conf->fullsync =3D=3D 0) {
> +		*skipped =3D 1;
> +		max_sector =3D mddev->dev_sectors;
> +		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
> +		    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +			max_sector =3D mddev->resync_max_sectors;
> +		return max_sector - sector_nr;
> +	}
> +
>   skipped:
>  	max_sector =3D mddev->dev_sectors;
>  	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||


Thanks Martin - looks good.

However protocol requires that you add the magic string "Signed-off-by: your
email address" to the patch.  This affirms that you have the right (from a
copyright perspective) to contribute that patch - not that I doubt it, but =
it
is always good to have it in writing.
See section 12 of "Documentation/SubmittingPatches".

If you could just send me that line (you don't need to send the whole patch
as well), I'll apply the patch.

Thanks,
NeilBrown

--Sig_/f1brk.P1S917wgg4LRglKAK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUZMhTnsnt1WYoG5AQKRJA//YmMKmfH2aqGjZpqQdXLstyItzdP+hBxJ
Vx7rXkPwuWFKk0cX8oNyCRdeTtsFtxOVsidVPw3UHBk3p7CZmR+LFJkuqG86V67Q
S0Tyz4j1TwdJydYzkL4mN/Q/TBgiM/+TFaKS2qPrA2S6nWamD7G2Ugig4xe0hp+t
MdAShK4NK7HCg5iICkvz6yYoTKIXR+QnhWBd2Fm/9eJkJ2/qxkVCXiXY9HpLxgim
Dm+OWN1hirBYOul5gTehZl96pIur2AmEkBVVD42bViEsgiqH7bS61sVHq0itqVLJ
5jwCB8kwWpomnfhm8JfAh4aX3k5ZRpXpBcFrKzxpTpcerCj57BpKQR20LPpz3Lld
/brCvM70NJhtCqQH7xJ5CMSHf7UIGVHLV2+MGH2FKSHFWodrjWqBD7KokYACl8k0
67UaM/coIvc1AjacVoZ7ABrbSuM1qp1rztfuYr87+NbhcXFwz9urtfWw9A3lybKh
TrrapYT2k/iVaKg1oFp4PDk30Js62zMOXyr3wv3Nre//w10gEDGXq8oIB9DfIFmJ
OUx2HkObaTC/GmGo3VzXAVUVDRMLvnTXSW/OjJ44TFLBQ52U49C/Xz6t01QwDBL1
EuirQPeT0TWbmojNzHjIOB2MzDb+70qK+NMkYSLz1iFPuOrg1VMLp7OM1IAgrEJr
6gKPxMV6Bcs=
=RhOT
-----END PGP SIGNATURE-----

--Sig_/f1brk.P1S917wgg4LRglKAK--
