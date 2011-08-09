From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: mdadm(IMSM): Unsupported attributes : 40000000
Date: Tue, 9 Aug 2011 09:36:38 +0000
Message-ID: <B76B33F8487BA74591724C4746DFF732938F@IRSMSX102.ger.corp.intel.com>
References: <CACHinyGxah6Utp+ed0WKH58BO8-sOn+QX9DPCy9QGNjuDde=eQ@mail.gmail.com>
 <20110809085117.5d910aed@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110809085117.5d910aed@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Thomas Steinborn <thestonewell@googlemail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Neil,

In fact this bit may cause backward compatibility issue.
It was used in old versions of IMSM metadata and for some reason was ma=
rked as "never use".
Skipping this bit during compatibility check is good idea.

I've checked compatibility with metadata created using dmraid and got a=
nother issue.
Attribute "MPB_ATTRIB_NEVER_USE2" is set in metadata created by dmraid =
so mdadm refuse loading metadata.
Could you add MPB_ATTRIB_NEVER_USE2 to your patch to MPB_ATTRIB_IGNORED=
 list?

Regards
Krzysztof

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, August 09, 2011 12:51 AM
> To: Thomas Steinborn
> Cc: linux-raid@vger.kernel.org; Kwolek, Adam; Wojcik, Krzysztof;
> Williams, Dan J
> Subject: Re: mdadm(IMSM): Unsupported attributes : 40000000
>=20
> On Sat, 6 Aug 2011 20:55:47 +0200 Thomas Steinborn
> <thestonewell@googlemail.com> wrote:
>=20
> > Hi,
> >
> > after updating to mdadm 3.2.2 (by way of upgrading from Fedora 14 t=
o
> > 15) from 3.1.5 I am no longer able to boot my IMSM raid, which I wa=
s
> > able to for the last 5 years or so.
> >
> > The errors I am getting are:
> >
> >   mdadm(IMSM): Unsupported attributes : 40000000
> >   mdadm: IMSM metadata loading not allowed due to attributes
> incompatibility.
> >
> > I tracked that down to the patch at
> >
> > http://www.spinics.net/lists/raid/msg34783.html
> >
> > According to that patch 40000000 means=A0#define MPB_ATTRIB_NEVER_U=
SE
> > __cpu_to_le32(0x40000000). Any advice why an unused but aparently s=
et
> > attribute should stop the raid to boot?
> >
> > For now I am up and running with 3.1.5 but would like to keep up wi=
th
> > the latest mdadm if possible.
> >
> > Thanks
> > Thomas
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Thanks for the report.
>=20
> It looks like we need something like the following.
>=20
> Adam/Kryzysztof:  Is this patch reasonable?
>=20
> Thanks,
> NeilBrown
>=20
>=20
>=20
>=20
>=20
> From 418f9b368a1200370695527d22aba8c3606172c5 Mon Sep 17 00:00:00 200=
1
> From: NeilBrown <neilb@suse.de>
> Date: Tue, 9 Aug 2011 08:49:34 +1000
> Subject: [PATCH] IMSM: allow some array attribute bits to be ignored.
>=20
> Some bits are not handled by mdadm, but their presence should not
> cause failure.
> In particular MPB_ATTRIB_NEVER_USE appears harmless.
>=20
> Reported-by: Thomas Steinborn <thestonewell@googlemail.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> diff --git a/super-intel.c b/super-intel.c
> index dcab5f9..ddf4de9 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -74,14 +74,17 @@
>=20
>  /* Define all supported attributes that have to be accepted by mdadm
>   */
> -#define MPB_ATTRIB_SUPPORTED		MPB_ATTRIB_CHECKSUM_VERIFY | \
> +#define MPB_ATTRIB_SUPPORTED	       (MPB_ATTRIB_CHECKSUM_VERIFY | \
>  					MPB_ATTRIB_2TB             | \
>  					MPB_ATTRIB_2TB_DISK        | \
>  					MPB_ATTRIB_RAID0           | \
>  					MPB_ATTRIB_RAID1           | \
>  					MPB_ATTRIB_RAID10          | \
>  					MPB_ATTRIB_RAID5           | \
> -					MPB_ATTRIB_EXP_STRIPE_SIZE
> +					MPB_ATTRIB_EXP_STRIPE_SIZE)
> +
> +/* Define attributes that are unused but not harmful */
> +#define MPB_ATTRIB_IGNORED		(MPB_ATTRIB_NEVER_USE)
>=20
>  #define MPB_SECTOR_CNT 2210
>  #define IMSM_RESERVED_SECTORS 4096
> @@ -1141,11 +1144,14 @@ void examine_migr_rec_imsm(struct intel_super
> *super)
>  static int imsm_check_attributes(__u32 attributes)
>  {
>  	int ret_val =3D 1;
> -	__u32 not_supported =3D (MPB_ATTRIB_SUPPORTED)^0xffffffff;
> +	__u32 not_supported =3D MPB_ATTRIB_SUPPORTED^0xffffffff;
> +
> +	not_supported &=3D ~MPB_ATTRIB_IGNORED;
>=20
>  	not_supported &=3D attributes;
>  	if (not_supported) {
> -		fprintf(stderr, Name "(IMSM): Unsupported attributes :
> %x\n", not_supported);
> +		fprintf(stderr, Name "(IMSM): Unsupported attributes :
> %x\n",
> +			(unsigned)__le32_to_cpu(not_supported));
>  		if (not_supported & MPB_ATTRIB_CHECKSUM_VERIFY) {
>  			dprintf("\t\tMPB_ATTRIB_CHECKSUM_VERIFY \n");
>  			not_supported ^=3D MPB_ATTRIB_CHECKSUM_VERIFY;
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
