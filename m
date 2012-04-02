From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] imsm: avoid overflows for disks over 1TB
Date: Mon, 2 Apr 2012 10:14:55 +1000
Message-ID: <20120402101455.189f614e@notabene.brown>
References: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205CE@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5_2GBe2uO2G9NDQdZ5_OcsN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205CE@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

--Sig_/5_2GBe2uO2G9NDQdZ5_OcsN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Mar 2012 12:43:00 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:


> +static unsigned long long total_blocks(struct imsm_disk *disk)
> +{
> +	if (disk =3D=3D 0)
> +		return 0;

I changed this and some others to
        if (disk =3D=3D NULL)
                return 0;


> +	return join_u32(disk->total_blocks_lo, disk->total_blocks_hi);
> +}
> +
> +static unsigned long long pba_of_lba0(struct imsm_map *map)
> +{
> +	if (map =3D=3D 0)
> +		return 0;
> +	return join_u32(map->pba_of_lba0_lo, map->pba_of_lba0_hi);
> +}
> +
> +static unsigned long long blocks_per_member(struct imsm_map *map)
> +{
> +	if (map =3D=3D 0)
> +		return 0;
> +	return join_u32(map->blocks_per_member_lo, map->blocks_per_member_hi);
> +}
> +
> +static unsigned long long num_data_stripes(struct imsm_map *map)
> +{
> +	if (map =3D=3D 0)
> +		return 0;
> +	return join_u32(map->num_data_stripes_lo, map->num_data_stripes_hi);
> +}
> +
> +static void set_total_blocks(struct imsm_disk *disk, unsigned long long =
n)
> +{
> +	split_ull(n, &disk->total_blocks_lo, &disk->total_blocks_hi);
> +}
> +
> +static void set_pba_of_lba0(struct imsm_map *map, unsigned long long n)
> +{
> +	split_ull(n, &map->pba_of_lba0_lo, &map->pba_of_lba0_hi);
> +}
> +
> +static void set_blocks_per_member(struct imsm_map *map, unsigned long lo=
ng n)
> +{
> +	split_ull(n, &map->blocks_per_member_lo, &map->blocks_per_member_hi);
> +}
> +
> +static void set_num_data_stripes(struct imsm_map *map, unsigned long lon=
g n)
> +{
> +	split_ull(n, &map->num_data_stripes_lo, &map->num_data_stripes_hi);
> +}
> +
>  static struct extent *get_extents(struct intel_super *super, struct dl *=
dl)
>  {
>  	/* find a list of used extents on the given physical device */
> @@ -897,8 +964,8 @@ static struct extent *get_extents(struct intel_super =
*super, struct dl *dl)
>  		struct imsm_map *map =3D get_imsm_map(dev, MAP_0);
> =20
>  		if (get_imsm_disk_slot(map, dl->index) >=3D 0) {
> -			e->start =3D __le32_to_cpu(map->pba_of_lba0);
> -			e->size =3D __le32_to_cpu(map->blocks_per_member);
> +			e->start =3D pba_of_lba0(map);
> +			e->size =3D blocks_per_member(map);
>  			e++;
>  		}
>  	}
> @@ -911,10 +978,9 @@ static struct extent *get_extents(struct intel_super=
 *super, struct dl *dl)
>  	 */
>  	if (memberships) {
>  		struct extent *last =3D &rv[memberships - 1];
> -		__u32 remainder;
> +		unsigned long long remainder;
> =20
> -		remainder =3D __le32_to_cpu(dl->disk.total_blocks) -=20
> -			    (last->start + last->size);
> +		remainder =3D total_blocks(&dl->disk) - (last->start + last->size);
>  		/* round down to 1k block to satisfy precision of the kernel
>  		 * 'size' interface
>  		 */
> @@ -925,7 +991,7 @@ static struct extent *get_extents(struct intel_super =
*super, struct dl *dl)
>  		if (reservation > remainder)
>  			reservation =3D remainder;
>  	}
> -	e->start =3D __le32_to_cpu(dl->disk.total_blocks) - reservation;
> +	e->start =3D total_blocks(&dl->disk) - reservation;
>  	e->size =3D 0;
>  	return rv;
>  }
> @@ -954,7 +1020,7 @@ static __u32 imsm_reserved_sectors(struct intel_supe=
r *super, struct dl *dl)
>  	for (i =3D 0; e[i].size; i++)
>  		continue;
> =20
> -	rv =3D __le32_to_cpu(dl->disk.total_blocks) - e[i].start;
> +	rv =3D total_blocks(&dl->disk) - e[i].start;
> =20
>  	free(e);
> =20
> @@ -984,7 +1050,8 @@ static __u32 imsm_min_reserved_sectors(struct intel_=
super *super)
>  {
>  	struct extent *e;
>  	int i;
> -	__u32 min_active, remainder;
> +	unsigned long long min_active;
> +	__u32 remainder;

I'm a bit concerned that 'remainder' is still a '__u32'.  It is calculated =
as
the difference of two 'unsigned long long'....
I'll take the patch as is, but you might like to fix this up.

Applied.

Thanks,
NeilBrown


--Sig_/5_2GBe2uO2G9NDQdZ5_OcsN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3jvfznsnt1WYoG5AQKJeg//RmOyCWSGa2udUNRW4NJbZzTPutFY+Di3
9tFnV0stN94n2IO5HMGHW0oJFBzHokZdwzBWGbquZJlkP6w0+wdw9dYTiT1mPYWX
tQRwupQkFFUHuj8l50M4+9aRBaJ+HJcL6PumJxPJcCay4sATrVsjdN5rC7x6gKrW
EZZEXErrFYNaeUjuoZnKBXpQeHVRJ2hIsgAsJx9pzjx+JbwZJtq0vuDm5HVeCboK
rD8tWGJWj4+pIqFLHWwZqN1A13lvkyBm5QEjlExu8JhuZd4UYzFIUqSfUQ+9ZJo6
XAbou3t7SM6+Qa0e6UFCpcQn8kYSoQfkOjrCY9RmAZR2i8L/yED1/MvmyCWDFKJ+
P5UEyAmQJ9YZdVQf0jLxHGGDoKof8tcC8YAxj6iflOAzSLLpHeGs3pW9Fuo+BUvY
ecKEQmgVEBfxKs9xg+Ciz6lddKxCwZ7jgMtfdPnr34XHU2NsRokihLy3CD3Is0Ih
bAAKf/5Mtx1BNEnrLKVttspQgeHUCk7puSZaM8xoCRHjCciyiKS/+v7btjOb1J23
K3g7CX5obDC585rIT0Az5Q0wR5mw4K/0Fux3wMI/faQ696+XF73MsEn5RQa7zOeV
Xj7HEUypbd0pEIEMWnfvo7j85cheEz12nXd28MnNrzNjXSfk04aoBjYpXUdnm/7/
ao8x8x7h+4o=
=qte7
-----END PGP SIGNATURE-----

--Sig_/5_2GBe2uO2G9NDQdZ5_OcsN--
