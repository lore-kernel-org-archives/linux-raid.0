From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] md: set MD_HAS_JOURNAL in correct places
Date: Thu, 07 Jan 2016 11:28:18 +1100
Message-ID: <87egdu9qsd.fsf@notabene.neil.brown.name>
References: <55aef157bf27c1de417577f02b69944a277a0141.1452119479.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55aef157bf27c1de417577f02b69944a277a0141.1452119479.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 07 2016, Shaohua Li wrote:

> Set MD_HAS_JOURNAL when a array is loaded or journal is initialized.
> This is to avoid the flags set too early in journal disk hotadd.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c          | 8 ++++----
>  drivers/md/raid5-cache.c | 1 +
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c0c3e6d..e896320 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1607,6 +1607,10 @@ static int super_1_validate(struct mddev *mddev, s=
truct md_rdev *rdev)
>  			mddev->new_chunk_sectors =3D mddev->chunk_sectors;
>  		}
>=20=20
> +		if (mddev->recovery_cp =3D=3D MaxSector)
> +			set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
> +		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
> +			set_bit(MD_HAS_JOURNAL, &mddev->flags);

This looks wrong.  I don't think it is safe to set MD_JOURNAL_CLEAR if
MD_HAS_JOURNAL is not set.
So I rearranged the code to:

		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL) {
			set_bit(MD_HAS_JOURNAL, &mddev->flags);
			if (mddev->recovery_cp =3D=3D MaxSector)
				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
		}

Please say if you disagree.

I've applied this and the other two patches - thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjbEiAAoJEDnsnt1WYoG5y2cQAKzaAcy17l2v484QMzUbVuiJ
tlEe09MogdQHDa5eYjnmScyRW8MZcpO3VED0t4tkVsWRm5zpKAnzDRqC9YcAqpgh
3vbzCHPmX/cu9jNK6qtfisqLGXuQ0NCVe/ERMB9+VZ4ZVdTYpkZkl1Wlixv2/dxS
gMyrsvEs4oVVPoAr48VdvKul4QBOJS1dz1a97ZPrxeanasVK1GQQSdOJNTMwmIJV
eJukaxKNok7d0G4X8xmM16rZQKW7sw2lswrKYXB8PUbMFVe2zgxFQSnkiXgO9tXC
MEIbxSl5vKISFLWYmpvEelLR7SMabe7Z5nEJk0/4Dto2RPR/ocisf+e4PhkhBmcj
bRvSdCHNBm4xw6HebGlHBTwXboicL85UDE8IMA/+2dGsGfq2StnIaJKEUFLAcEoy
sLbEwg3HwIFYJ3NX+U4T1shAqzgSFfmslUaFlx6ZONmPPUB5M0aGYFvAFI5pqPMh
R6sgUMxG+jCilN/bMfhlvSPTAi+ndAIa1OWW92MHMGrM8dtshW5q8ovLY5nG2HWn
tPpi22BCETIpTNzx6VhKuXtmmUH5x/JEhw+qYL9h20BHqryFaCf1CUoN5sezcWPS
CGSyZnVAL4txFZY3XpdFayhLTEVe1KFJopZa8fBCU/CPuTg5awFbmt4fCj16htN1
vT4QVCJjPcEEt9zNxYmk
=Fvcu
-----END PGP SIGNATURE-----
--=-=-=--
