From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: prevent segfault in mark_failure
Date: Thu, 20 Oct 2011 13:00:00 +1100
Message-ID: <20111020130000.32b245c6@notabene.brown>
References: <20111019095148.6240.80135.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_O8kAg.E5C6YHHtpskgMde7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111019095148.6240.80135.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/_O8kAg.E5C6YHHtpskgMde7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Oct 2011 11:51:48 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Using an array of chars without the terminating null byte
> as a parameter of sprintf() function causes segfault
> when dealing with SAS drives (with 20-digits serial number).
> The memcpy() function is used instead.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 401c701..2c1bf05 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6015,7 +6015,9 @@ static int mark_failure(struct imsm_dev *dev, struc=
t imsm_disk *disk, int idx)
>  	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
>  		return 0;
> =20
> -	sprintf(buf, "%s:0", disk->serial);
> +	memcpy(buf, disk->serial, MAX_RAID_SERIAL_LEN);
> +	buf[MAX_RAID_SERIAL_LEN] =3D '\000';
> +	strcat(buf, ":0");
>  	if ((len =3D strlen(buf)) >=3D MAX_RAID_SERIAL_LEN)
>  		shift =3D len - MAX_RAID_SERIAL_LEN + 1;
>  	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);


Applied. Thanks,

NeilBrown

--Sig_/_O8kAg.E5C6YHHtpskgMde7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp+Apjnsnt1WYoG5AQJGhBAAwBZRZ8zNUdU6I7CDtbxR+ryRsm3J/1wT
PU9rwzztIV28mEfMza/VKCBEfa1Ql8L7fOLVMUuYA86OHc/xBMtajIZt8c9w7c0r
RJDYoVRDJf+261KAWX/KL1R42F1zyrmT3L4dil8Knc2Eb6SnwHUxxhKxGjOPQ10i
lVasSnuNtMNXmXVbJIeazsNC60GIqwBOMXQd0ojG9ug62QaTDHvqCUdTr3/9LTyD
18PDNLzIDIc5aKOYXMrSVrFji2C0G0yE3DeT29kZU6CPTe4AXoOKE28rhW9NyLQb
99qhixBvKewJscex1+3sHCYlUpAsPByCvIDPQP+MDPY842jwJs+XZ/YJLhxJHBmC
KWwx8qoYSAuX3iIk+SAmqVX/AWDQZK6v+4aqyPkI9pQZ4N2RiQ92mHPL4zpkSBdE
KCS+prN8ujT8fTjcHYbOfLebxqx7mH+vfaJurOElWOSHxGE9pNoo5aicl+1W9L+v
WmY3283hcPzfZSeq73v9rd68LjEKt1JhLLcRbu4I0/OMBzfASHaURUY2nbEE/XRl
VFEpELha4h29U4dxgPN8QjXGqAaubavQovAm5TuLlSzgfsypXr/K+DHkpkIuBZB0
XL7T2MKKlq6yZTsHOdXYTRVhxTqxQSEZfM2OroUNUA78IYG0eOFQaoen5xJk89rU
O9s7zq7uQwE=
=VQYG
-----END PGP SIGNATURE-----

--Sig_/_O8kAg.E5C6YHHtpskgMde7--
