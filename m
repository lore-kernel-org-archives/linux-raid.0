From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/6] raid5-cache fixes
Date: Thu, 08 Oct 2015 13:10:32 +1100
Message-ID: <87mvvu6rfr.fsf@notabene.neil.brown.name>
References: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> Hi,
>
> some fixes for raid5-cache.
> patch 1, a small fix
> patch 2-3, move reclaim teardown to quiesce handling and add trim support=
. I
> still need md_update_sb there and play the mddev_is_locked trick as the
> reconfig_mutex is already hold at md stop. The md_update_sb probably can =
move
> to md core later.
> patch 4-6, add error handling. For patch 4, I still need the journal bit =
check
> in in md core, otherwise there is no way to prevent 'echo remove > rdev/s=
tate'
> to delete journal disk. For patch 6, I didn't change has_failed() yet. Ha=
ndling
> assemble with miss/failed log disk is still on going.
>
> Next step is to make assemble correct with miss/failed log disk. This wil=
l need
> kernel/utilities cooperation. Song and I are working on it.
>
> Thanks,
> Shaohua
>
> Shaohua Li (6):
>   md: show journal for journal disk in disk state sysfs
>   raid5-cache: move reclaim stop to quiesce
>   raid5-cache: add trim support for log
>   md: don't export log device
>   md: set In_Sync for log disk
>   raid5-cache: IO error handling
>
>  drivers/md/md.c          |  9 ++++--
>  drivers/md/raid5-cache.c | 83 ++++++++++++++++++++++++++++++++++++++++--=
------
>  drivers/md/raid5.c       |  7 +++-
>  drivers/md/raid5.h       |  3 ++
>  4 files changed, 85 insertions(+), 17 deletions(-)
>
> --=20
> 2.4.6

Thanks.

I've applied 1, 2, and 5. Should appear in 'devel' shortly.
3 and 4 I've replies to separately, 6 depends on 3.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFdCYAAoJEDnsnt1WYoG5oEsP/3Jcx/zidJem9kp07rXdbIt1
d/bnjHHuqi2DghAgvLRF1rVWudK3PI5ILI8Bi6CzSF/5RkVsGWc9X/DWqUcs0r7S
jEr0PWrC5uBHHUx0EWlW/vV7UmqqgwvB7XQsYDwz9L/wwEBA2WdwnlUzBMDOyKZU
FV2Nr8wV5v1HNa5nXcTPcDLaGXcyqOYRUIqsdU9oREKKlJCfHdSOfhJAda6oBBWM
uubE1fErX01wuPj4J/E2qydf3GeT+Ks3O8bi6Dr0x0vSwmGt5gHgegsG4dbn1Gkp
trntp95q5sLhtJVSxozdI5S8Oj+BT5S89gHXxBmlh7D8eHY+QpIRK975KPDuNj2f
xbUhcSHZK9WkMInjBWnRkFuVSvEQmwJpFCsRE7V/KfIFX96zahDXE/hajGdJDe/K
oridrBCRmj7bmsmbzurD/wzscxi59mTXsqcIwscvqMyyUaNkJ+jvsfs2/irPuZ0y
7ao10L4+VhPY87AitQiqOGMr093Wmc89yeA1F/tV+H+XaLVml1qqNh74+qtCWZ2L
mi/3SJnOt3EBhxF/AMrv69OgSUaCN3uf3L11iVrQTrf3GOAdQq+dz94/pTjdJGCk
lXJF9A+kPAf2AQ51sp6ot4o4OWWA2gbYyEumFcheFFcMtHAM7d+G3s7wafeO/gIy
MANDtdrUTEyNkeMPXFmH
=/bkZ
-----END PGP SIGNATURE-----
--=-=-=--
