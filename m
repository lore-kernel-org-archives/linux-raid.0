From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] imsm: 2TB disks/volumes support
Date: Mon, 2 Apr 2012 10:20:24 +1000
Message-ID: <20120402102024.2e0183ae@notabene.brown>
References: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205C6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BSktsIesD09HiC+XJturloZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205C6@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

--Sig_/BSktsIesD09HiC+XJturloZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Mar 2012 12:42:53 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> Hi Neil,
> this patch series provides initial support for 2TB disk and volumes for i=
msm metadata.
> Patches 1,2 ensure correct representation and interpretation of sizes in =
metadata
> Patch 3 refactors code a little to make calc_array_size usable for all le=
vels
> Patch 4 gives the user information about large disks/volumes support in o=
rom
> Patches 4,5 prevent creation of volume/container when not supported by or=
om
>=20
> There are more cases to be checked, for example creation of small volume =
on existing container using large disks,
> adding large disks to container, olce leading to large volume etc. =20
>=20
> [PATCH 1/6] imsm: avoid overflows for disks over 1TB
> [PATCH 2/6] clear hi bits if not used after loading metadata from disk
> [PATCH 3/6] simplify calculating array_blocks
> [PATCH 4/6] show 2TB volumes/disks support in --detail-platform
> [PATCH 5/6] check volume size in validate_geometry_imsm_orom
> [PATCH 6/6] check that no disk over 2TB is used to create container when =
no support
>=20
> platform-intel.h |    1 +
> super-intel.c    |  271 +++++++++++++++++++++++++++++++++++++------------=
-----
> util.c           |    2 +
> 3 files changed, 191 insertions(+), 83 deletions(-)


All applied,
thanks,

NeilBrown


--Sig_/BSktsIesD09HiC+XJturloZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3jwyDnsnt1WYoG5AQL31w//WEuuren5Pwuk+kf81aUoUH4r1YuDp5bO
ZQ4YS/87uj1FL2UyWvr8NJg0ITrO74mSeeB6+XTYSOlgYVNy+e5j/Yipabz3o/hv
JqcivxrwH5jonB20HX0wLiN0orCRUmzDsBi4OSTjEJbspd/C2x62YDX+tdnsuU6S
Oa8gZjDBCMCBZlqg+P9q7J7Fv2B8ij7rS6+AUp83KQkeg0vdvuBWltAEd8hZSH9F
atLdRfugrbDasbI/Lsuzly2he2Rqe/Y22IQl2OhX4SGGT+9DS4+QYfNQ9VjFt/ZD
TBAaFCoNsQUIo8trcG0uvRIJpG3BnVqYVD2TVdZUS6BXI5JBWnov83XeAYF8LvyZ
ccsUh5viybK1aFav5S+Q5L2Y4kXZ4XLmfR68RUpswYOIsmvf2FrcxtNdrbMDHJB0
t1OCZedZExl5M38WGdwXqBZlBO2LxmJ1ADs4FR6VcEXbG4ji8A/O2Cbw4kYu8TBC
ax/T4TXZPZaCw6JaGv55tVcFTQF2FLfymjYuie4NpUxOMcTdjA2BiefzDBMgrbwe
O9ZeWJfjOV4QiLDvqo00EQhD7Wqy+ujOJEOvL8vCMmwmtj8zLySfsAas7x6MhTSx
FdhssdWI9hUHVo2sOf5OUWqctG6ndlTFPCnCWN2bbdvrHwlvkYA2t/Gp9N+0nQ4Q
b0CzUX8pLq0=
=D8jx
-----END PGP SIGNATURE-----

--Sig_/BSktsIesD09HiC+XJturloZ--
