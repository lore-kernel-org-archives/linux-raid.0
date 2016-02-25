From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] RAID5: check_reshape() shouldn't call mddev_suspend
Date: Fri, 26 Feb 2016 09:08:40 +1100
Message-ID: <87a8mol9xz.fsf@notabene.neil.brown.name>
References: <b228d35f9a8e94969d667edbcc9d7f613d706b02.1456424579.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b228d35f9a8e94969d667edbcc9d7f613d706b02.1456424579.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 26 2016, Shaohua Li wrote:

> check_reshape() is called from raid5d thread. raid5d thread shouldn't
> call mddev_suspend(), because mddev_suspend() waits for all IO finish
> but IO is handled in raid5d thread, we could easily deadlock here.
>
> Artur,
> It would be great if you can verify this works for your test.
>
> Reported-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 18 ++++++++++++++++++
>  drivers/md/raid5.h |  2 ++
>  2 files changed, 20 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7f770b0..c7fd070 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2089,6 +2089,14 @@ static int resize_chunks(struct r5conf *conf, int =
new_disks, int new_sectors)
>  	unsigned long cpu;
>  	int err =3D 0;
>=20=20
> +	/*
> +	 * Never shrink. And mddev_suspend() could deadlock if this is called
> +	 * from raid5d. In that case, scribble_disks and scribble_sectors
> +	 * should equal to new_disks and new_sectors
> +	 */
> +	if (conf->scribble_disks >=3D new_disks &&
> +	    conf->scribble_sectors >=3D new_sectors)
> +		return 0;
>  	mddev_suspend(conf->mddev);
>  	get_online_cpus();
>  	for_each_present_cpu(cpu) {
> @@ -2110,6 +2118,10 @@ static int resize_chunks(struct r5conf *conf, int =
new_disks, int new_sectors)
>  	}
>  	put_online_cpus();
>  	mddev_resume(conf->mddev);
> +	if (!err) {
> +		conf->scribble_disks =3D new_disks;
> +		conf->scribble_sectors =3D new_sectors;
> +	}
>  	return err;
>  }
>=20=20
> @@ -6413,6 +6425,12 @@ static int raid5_alloc_percpu(struct r5conf *conf)
>  	}
>  	put_online_cpus();
>=20=20
> +	if (!err) {
> +		conf->scribble_disks =3D max(conf->raid_disks,
> +			conf->previous_raid_disks);
> +		conf->scribble_sectors =3D max(conf->chunk_sectors,
> +			conf->prev_chunk_sectors) / STRIPE_SECTORS;

Here we set ->scribble_sectors to a number of stripes rather than a
number of sectors.  I think you need to remove the "/ STRIPE_SECTORS".

Otherwise:
  Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown


> +	}
>  	return err;
>  }
>=20=20
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index a415e1c..ae6068d 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -510,6 +510,8 @@ struct r5conf {
>  					      * conversions
>  					      */
>  	} __percpu *percpu;
> +	int scribble_disks;
> +	int scribble_sectors;
>  #ifdef CONFIG_HOTPLUG_CPU
>  	struct notifier_block	cpu_notify;
>  #endif
> --=20
> 2.6.5

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWz3toAAoJEDnsnt1WYoG5AysP/Rhqupr1iLlPnip2Nyqy83+G
y02/KvTJvz2LY/cSpckn0W+sI1W0F7O0IVmohJlJ466ceV8pFz9hsNeddqs1Xuu/
aJqroobhM4a2yo7E8KFn1BbbQwCxndN3ePGQR7M4j8sm5rxdnMb0hgQBd5nrCZGz
TT7izaj8Q27Vigywy/9JEkYb2qNyYd3JChbZeKE5GzQE+3gLw3Tv94BbzXzLpBML
vGZtmr4TwCXQqIKFAhGZ7l0NlgzU7U+4VeKxjpov4Zdh1fxiuSEX9JjVBQFrVP/B
rVwESg5nTnXx+DlCiym0NutC8+W91coPj8ltPAdNkgQGiQqwRFEIfc5vesQ+ogUK
MPqN6xhLGZGMxHJUaoxz6RMYQwzmItG+xwRN1EoTsJgfPivBifIBdXxoObfruAKu
6uWj4jUP/Xl85qOzF9CFYDOUaGOx9BfddhsAber0HoTvKy1V7gZ4jnoTrtEkwmr1
y0aLu4/jDn+DPMPManOH08QwUcQqyYHbOOQ0usj2zV0hbwwXLcuznWvzgAvCyI5Z
oU7Vbk+qQIZQ4nDuFU6ZKx6JJzVngRg2y66zdPSJkEnPn9HxlglQf4frANVcINFR
Vhrjqjlsw/RbLCxREHrna5cmzimB69Hh3byYG3Ans0PAH7E+/8HuHuEVXRvXZAt8
LmXv1dmfnNJ+K5teAGEZ
=1O1F
-----END PGP SIGNATURE-----
--=-=-=--
