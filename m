From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] Fix bus error when accessing MBR partition records
Date: Mon, 03 Oct 2016 09:32:23 +1100
Message-ID: <87r37y5qmg.fsf@notabene.neil.brown.name>
References: <20160929122838.66975-1-jrtc27@jrtc27.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160929122838.66975-1-jrtc27@jrtc27.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: James Clarke <jrtc27@jrtc27.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 29 2016, James Clarke wrote:

> Since the MBR layout only has partition records as 2-byte aligned, the 32=
-bit
> fields in them are not aligned. Thus, they cannot be accessed on some
> architectures (such as SPARC) by using a "struct MBR_part_record *" point=
er,
> as the compiler can assume that the pointer is properly aligned. Instead,=
 the
> records must be accessed by going through the MBR struct itself every tim=
e.

Weird....

Can you see if adding "__attribute__((packed))" to struct
MBR_part_record also fixes the problem?

It seems strange that the compiler lets you take a pointer, but then
doesn't use it correctly.  Maybe it is an inconsistency in the types.

I don't necessarily disagree with your fix, but I'd like to understand
why the current code is wrong.

Thanks,
NeilBrown


>
> Signed-off-by: James Clarke <jrtc27@jrtc27.com>
> ---
>  super-mbr.c |  6 ++++++
>  util.c      | 14 +++++++-------
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/super-mbr.c b/super-mbr.c
> index 62b3f03..303dde4 100644
> --- a/super-mbr.c
> +++ b/super-mbr.c
> @@ -57,6 +57,9 @@ static void examine_mbr(struct supertype *st, char *hom=
ehost)
>=20=20
>  	printf("   MBR Magic : %04x\n", sb->magic);
>  	for (i =3D 0; i < MBR_PARTITIONS; i++)
> +		/* Have to make every access through sb rather than using a pointer to
> +		 * the partition table (or an entry), since the entries are not
> +		 * properly aligned. */
>  		if (sb->parts[i].blocks_num)
>  			printf("Partition[%d] : %12lu sectors at %12lu (type %02x)\n",
>  			       i,
> @@ -151,6 +154,9 @@ static void getinfo_mbr(struct supertype *st, struct =
mdinfo *info, char *map)
>  	info->component_size =3D 0;
>=20=20
>  	for (i =3D 0; i < MBR_PARTITIONS ; i++)
> +		/* Have to make every access through sb rather than using a pointer to
> +		 * the partition table (or an entry), since the entries are not
> +		 * properly aligned. */
>  		if (sb->parts[i].blocks_num) {
>  			unsigned long last =3D
>  				(unsigned long)__le32_to_cpu(sb->parts[i].blocks_num)
> diff --git a/util.c b/util.c
> index a238a21..08adbd5 100644
> --- a/util.c
> +++ b/util.c
> @@ -1412,7 +1412,6 @@ static int get_gpt_last_partition_end(int fd, unsig=
ned long long *endofpart)
>  static int get_last_partition_end(int fd, unsigned long long *endofpart)
>  {
>  	struct MBR boot_sect;
> -	struct MBR_part_record *part;
>  	unsigned long long curr_part_end;
>  	unsigned part_nr;
>  	int retval =3D 0;
> @@ -1429,21 +1428,22 @@ static int get_last_partition_end(int fd, unsigne=
d long long *endofpart)
>  	if (boot_sect.magic =3D=3D MBR_SIGNATURE_MAGIC) {
>  		retval =3D 1;
>  		/* found the correct signature */
> -		part =3D boot_sect.parts;
>=20=20
>  		for (part_nr =3D 0; part_nr < MBR_PARTITIONS; part_nr++) {
> +			/* Have to make every access through boot_sect rather than using a
> +			 * pointer to the partition table (or an entry), since the entries
> +			 * are not properly aligned. */
> +
>  			/* check for GPT type */
> -			if (part->part_type =3D=3D MBR_GPT_PARTITION_TYPE) {
> +			if (boot_sect.parts[part_nr].part_type =3D=3D MBR_GPT_PARTITION_TYPE)=
 {
>  				retval =3D get_gpt_last_partition_end(fd, endofpart);
>  				break;
>  			}
>  			/* check the last used lba for the current partition  */
> -			curr_part_end =3D __le32_to_cpu(part->first_sect_lba) +
> -				__le32_to_cpu(part->blocks_num);
> +			curr_part_end =3D __le32_to_cpu(boot_sect.parts[part_nr].first_sect_l=
ba) +
> +				__le32_to_cpu(boot_sect.parts[part_nr].blocks_num);
>  			if (curr_part_end > *endofpart)
>  				*endofpart =3D curr_part_end;
> -
> -			part++;
>  		}
>  	} else {
>  		/* Unknown partition table */
> --=20
> 2.10.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX8Yr3AAoJEDnsnt1WYoG5Ik8P/0gTFpwmTzfjCTsWKBPeNIPC
zwOrPVhpeM+0I9XggWqPRxaaKRFHCYNJLZb3nPBr4VMcHY+2zqjfPMmjMsObD2kP
tOHDGauEhBBSomSwck7x6UQqKrKuRAVzJLz+T2JpKU0ncSazvctErzR8POhI4DRR
l69SDRUynY+h4IQxnapoyT/UFwsAS8zCG3zgTc+4w6Q46RnObxcGz+N1KIB7nwxf
LcHljU6dOOb6l2VEImO83RyyieNHxnBHEsLjN+P0A8e0/Vo+aI8E3/QiH3Xw4RPP
yeoho5K6MZ3rikYGPkSDOqANEJKxb7kdn3JOsBQvgjjurEqOyAWHNIjZECdxjc+z
FcG3Dp39cBM07jICF54XMk/Cktkyto5PTZCPmfUZafzZb8srP8HlYeVS6NkuAP9R
BmslGq7C5Oo/GlNiH4tSFPoHFlSNYpil+2EEe0lTQHKSB0+9QuTgAbEMJOHw29qt
7Pq+N6l6mjGSP8Dct8+T+v6KoIU1vgcbjRYBc4EkLNeXgYRLFGT00bcqb0bHRVyZ
+VR6E0EMg6bxc0zNRHzC9dSQ0hL/14/Esuo0KOjVqofc4kddHN6H+Km6y01pz+iU
vj6E6bGNrShOwdAn/iXlw/yVIAT/3FWYAecsiiTO6tD/mONeteU/vgfrRLGNGVZ7
+/JVm7h7mmNiGvRKYn/H
=q7Pc
-----END PGP SIGNATURE-----
--=-=-=--
