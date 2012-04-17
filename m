From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/14] imsm: volume expand
Date: Tue, 17 Apr 2012 12:56:25 +1000
Message-ID: <20120417125625.3646c646@notabene.brown>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CjaYllj3WdOB3B8XTJFGtg9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com
List-Id: linux-raid.ids

--Sig_/CjaYllj3WdOB3B8XTJFGtg9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Apr 2012 16:51:54 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> This patch series introduces the possibility to increase volume size using
> existing free space in container without adding spare disks to imsm metad=
ata.
>=20
> Adam Kwolek (14):
>   imsm: FIX: Update function imsm_num_data_members() for Raid1/10
>   imsm: FIX: Add volume size expand support to imsm_analyze_change()
>   imsm: Add new metadata update for volume size expansion
>   imsm: Execute size change for external metatdata
>   FIX: Support metadata changes rollback
>   imsm: FIX: Support metadata changes rollback
>   FIX: Extend size of raid0 array
>   FIX: Respect metadata size limitations
>   FIX: Detect error and rollback metadata
>   imsm: Add function imsm_get_free_size()
>   imsm: Support setting max size for size change operation
>   imsm: FIX: Component size alignment check
>   FIX: Size change is possible as standalone change only
>   FIX: Assembled second array is in read only state during reshape
>=20
>  Assemble.c    |   29 ++++--
>  Grow.c        |  163 ++++++++++++++++++++++-------
>  mdadm.h       |    4 +
>  super-intel.c |  318 +++++++++++++++++++++++++++++++++++++++++++++++++++=
-----
>  4 files changed, 438 insertions(+), 76 deletions(-)


Thanks,
I've applied these patches.

NeilBrown


--Sig_/CjaYllj3WdOB3B8XTJFGtg9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4zb2Tnsnt1WYoG5AQLbMBAApObHBwYqAbfbf6B+q6oje6MggsnwuBth
Sxj83q34lcrnUBbFmzQmYDZzvaTkw0Kb5N4Y/Iv5hiilKV0IavS/PMkNu8PcMkX9
Aho+BjH3iqtQDwoeukOQdaPuX7Hcjz6h4kzEdkLQpQYHBhn5wNc2K6luIDWl1Zwh
85+ci+wZFVW9DgVW9kmQRzPlm3mpEomZ2t55X0g1NvEAZxrXl5TtbeUdoy6Ir3Lf
or1m++IHDFQfYLlVbdOYQJjCf4s4FVk/SHyydPGgvcKLgU5EvA/YVuM2wmt6whRM
nzAf3oZwocnyPl5/jdZS6Nz1zStosQGMKBwh/sVNxjQNVPsYtnbIwRYOYI8XkH15
CM42hagdpEUoourYGTaWkCsyeNYuysWyLWsYYRi3m6vtTUCM18LVqNJDFDgd2i08
MWgoPf6a8RU6epG9t3Bw8fS3kYI3c2DcXt99mNd8ghiG65Al8qOjJZs1/5p60Ngj
HFHW9HnfgIvHoCH3URDo/32ME4WmgAkjmuKeX5Emj8oWXA0NYFmf/pMN+QdeFbeT
qkwzIjag0UiEOLhtfzuo3m1uOHnZffpBzLKZ3vIGnQTbLOLSrJaE0L0eBzTav8o3
vLXbQ4T1QqC4ZmdaVwO8J5Y/Y/GH5xAqAbMInw3WPqLuufvZ8W+Py9Yn/Odw0qPy
mpOF/6SVE3s=
=mjFE
-----END PGP SIGNATURE-----

--Sig_/CjaYllj3WdOB3B8XTJFGtg9--
