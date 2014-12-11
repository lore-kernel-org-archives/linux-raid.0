From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] IMSM: do not use comma expression for simple assignments
Date: Thu, 11 Dec 2014 10:06:57 +0100
Message-ID: <54895EB1.4040502@intel.com>
References: <1407313179-24598-1-git-send-email-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1407313179-24598-1-git-send-email-j@bitron.ch>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsO8cmcgQmlsbGV0ZXI=?= <j@bitron.ch>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

On 08/06/2014 10:19 AM, J=C3=BCrg Billeter wrote:
> Fixes build with gcc 4.9.
>=20
> error: right-hand operand of comma expression has no effect
>   snprintf((char *) spare->sig, MAX_SIGNATURE_LENGTH,
>   ^
>=20
> Signed-off-by: J=C3=BCrg Billeter <j@bitron.ch>
> ---
>  super-intel.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index e28ac7d..f24d101 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5069,13 +5069,13 @@ static int write_super_imsm_spares(struct int=
el_super *super, int doclose)
>  	__u32 sum;
>  	struct dl *d;
> =20
> -	spare->mpb_size =3D __cpu_to_le32(sizeof(struct imsm_super)),
> -	spare->generation_num =3D __cpu_to_le32(1UL),
> +	spare->mpb_size =3D __cpu_to_le32(sizeof(struct imsm_super));
> +	spare->generation_num =3D __cpu_to_le32(1UL);
>  	spare->attributes =3D MPB_ATTRIB_CHECKSUM_VERIFY;
> -	spare->num_disks =3D 1,
> -	spare->num_raid_devs =3D 0,
> -	spare->cache_size =3D mpb->cache_size,
> -	spare->pwr_cycle_count =3D __cpu_to_le32(1),
> +	spare->num_disks =3D 1;
> +	spare->num_raid_devs =3D 0;
> +	spare->cache_size =3D mpb->cache_size;
> +	spare->pwr_cycle_count =3D __cpu_to_le32(1);
> =20
>  	snprintf((char *) spare->sig, MAX_SIGNATURE_LENGTH,
>  		 MPB_SIGNATURE MPB_VERSION_RAID0);
>=20

Hi Neil,

We verified that this patch indeed is needed to build mdadm with gcc
4.9. Can you apply it?

Thanks,
Artur

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
