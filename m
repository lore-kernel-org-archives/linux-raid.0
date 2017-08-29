From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2] mdadm: set journal_clean after scanning all disks
Date: Wed, 30 Aug 2017 06:45:19 +1000
Message-ID: <87h8wqgl28.fsf@notabene.neil.brown.name>
References: <20170829165302.3526230-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170829165302.3526230-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 29 2017, Song Liu wrote:

> Summary:
> In Incremental.c:count_active(), max_events is tracked to show to
> which devices are up to date. If a device has events=3D=3Dmax_events+1,
> getinfo_super() is called to reload the superblock from this
> device. getinfo_super1() blindly set journal_clean to 0, which is
> wrong.
>
> This patch fixes this by tracking max_journal_events for all the
> disks. After scanning all disks, journal_clean is set if
> max_journal_events >=3D max_events-1.

Thanks.  That makes sense now.
Reviewed-by: NeilBrown <neilb@suse.com>


>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Incremental.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/Incremental.c b/Incremental.c
> index 6cf2174..91301eb 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -684,6 +684,7 @@ static int count_active(struct supertype *st, struct =
mdinfo *sra,
>  	int cnt =3D 0;
>  	int replcnt =3D 0;
>  	__u64 max_events =3D 0;
> +	__u64 max_journal_events =3D 0;
>  	char *avail =3D NULL;
>  	int *best =3D NULL;
>  	char *devmap =3D NULL;
> @@ -714,8 +715,9 @@ static int count_active(struct supertype *st, struct =
mdinfo *sra,
>=20=20
>  		info.array.raid_disks =3D raid_disks;
>  		st->ss->getinfo_super(st, &info, devmap + raid_disks * devnum);
> -		if (info.disk.raid_disk =3D=3D MD_DISK_ROLE_JOURNAL)
> -			bestinfo->journal_clean =3D 1;
> +		if (info.disk.raid_disk =3D=3D MD_DISK_ROLE_JOURNAL &&
> +		    info.events > max_journal_events)
> +			max_journal_events =3D info.events;
>  		if (!avail) {
>  			raid_disks =3D info.array.raid_disks;
>  			avail =3D xcalloc(raid_disks, 1);
> @@ -765,6 +767,8 @@ static int count_active(struct supertype *st, struct =
mdinfo *sra,
>  			replcnt++;
>  		st->ss->free_super(st);
>  	}
> +	if (max_journal_events >=3D max_events - 1)
> +		bestinfo->journal_clean =3D 1;
>=20=20
>  	if (!avail)
>  		return 0;
> --=20
> 2.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlml0mEACgkQOeye3VZi
gbkx0Q//TrwauWValHzpnTPFcPXP5LGUB7NjGdW89KjCo1cRsPzo1vehSzeo/IA4
Zr/iV6z4T9SZEIl5nj1iqVo8WJgErW+s6rBFfzyqsOERzgBIPgkUOvthONg/8BL1
XEB5szAImXFLLhjKoy/Co34t75QbzUdHPql0ig+kX1r/bBFXzlJIe1U9wPotlBx5
epzxzOns5ZLD83IqKD+vazLoT+gEz6bD+MJCjYaSUFpvxcIOkHjC6mZtE/kWHiI9
rGf5+YXxdEIIZex/3cUwFaiK3jcIwWMLrmLQt5d210dz3KoqjJm4qUGGTOYfGGQ+
QLZT+6MfXZIUVZbYJSOXkJxLtqStl4GQZeEG6j+eDKyAY+y3Z+SFdOgouRBs8q/H
eS72hA0I/pgAec3TZIxXaohX5A4j47r1M2g5USXWgzQerSNdrvivXLK3ARhBcxsz
fkz29nJ6qqBkHnxjFkcLr44K9F6FJu1MUylPoJPJBrocipnC+FGapqKUaEsgrqhi
Ng/E0gYMIiXvNvF9N2aiWs2NIsxLZfVjKijTi+zjBWCwFDrj19ZpSt6+0EatOd3Z
eh+pxf1T/bpNQ4fZvqQH7PC0ITkuYcTtHq/zAa/XoHIRYWHuUZfpDZzPHsiFk7K+
ji/qZLh3NLnrGNbhuukLj8tY14x0mZNEtUQmcFiKSrbcEo59B/E=
=Zui+
-----END PGP SIGNATURE-----
--=-=-=--
