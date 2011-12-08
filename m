From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/9] Array degradation during reshape and rebuild
 (cont.)
Date: Thu, 8 Dec 2011 14:15:15 +1100
Message-ID: <20111208141515.39ca955c@notabene.brown>
References: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N3_CpxxbKIdWbAia9B_s+gY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/N3_CpxxbKIdWbAia9B_s+gY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011 13:57:35 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> The following series adds implementation details for array
> degradation during reshape and rebuild/initialization.
>=20
> Series fixes problems in handling degradation during rebuild
> in imsm metadata and fixes problems noticed in applied changes..
>=20
> Failing disks using sysfs (echo 1 > /sys/block/sdX/device/delete)
> mdadm does his job correctly.
> The problem is when disks are pulled physically from system.
> As workaround BBM disabling can be used /sent previously/.
>=20
>=20
> BR
> Adam
>  =20
>=20
> ---
>=20
> Adam Kwolek (9):
>       imsm: FIX: Use defines for device map access
>       imsm: FIX: Check correct slots on disk failure
>       imsm: FIX: Finish rebuild and initialization when missing drive is =
handled
>       imsm: FIX: Mark failure for rebuild
>       imsm: FIX: Add array map state transition for failures during initi=
alization
>       imsm: FIX: Do not allow spare activation during rebuild
>       imsm: Function imsm_set_disk() rework
>       imsm: FIX: Correct ords merging in end_migration()
>       imsm: FIX: Remove longer map request
>=20
>=20
>  super-intel.c |  475 ++++++++++++++++++++++++++++++++++-----------------=
------
>  1 files changed, 285 insertions(+), 190 deletions(-)
>=20

Thanks.
I've applied all of these.

I can't claim to have understood them all completely, but there was nothing
obviously wrong, so I'll assume they are right :-)

Thanks,
NeilBrown



--Sig_/N3_CpxxbKIdWbAia9B_s+gY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuAryTnsnt1WYoG5AQJY/Q//cxQZVATt/7givbqqemR9IRxc+BR8eq4w
5sDfdvR1dVm6CuOeFLBItQqB1Ut1GzAKL/nSbBTj7HJNZ7HKIGPRswBfkZn1AN7n
8Yng+BazbZASGIb9/+DEDyVZz/IxBDriNK/ncarsHWH7pUdaZ29cPCjx7HX/5E1b
r9wx00/M5vzG2NbrGIUEAyIJFBzVB8H1VEFrjg/aYnAWn9ckZqLn2ZT3PWH2ghzR
iagLoTMwkI37nT3suGeGA9BtY7AVrYZNvv7/FZ9x2BWCBuzWE8WF51ilLKbuOO0j
wZhq2LIxGe7yLEvBucP0Os/J9OVpfhVeo3MP055znVusGbouZrTRSqRuRjNZkepc
sEwFJthUgzRwAAf1/k064onRyKUxWLdjyzD7n3QepiFdi3jY01LI581niIPctZpj
vUkIgcLJhqMmWoRhjMPC3NmhAkHEXl6OBdSZdltKI0M5B58stClDhyc3327y4GIm
ooeyr0VKPmpU90rkzZaUHDJPqTEYgRV+VCsjpBIWXTJVYnpeL+NSMgc2i5q8Elnt
mLXcd2dgBjHcT8/ypGdkMD09e79jzzElm2zmWG3COerqpSCXdNMRCHTCSeDTM4QE
KYtGk/bWZNoIDLdjf45tRHUX4IitaTDXiqNo6czRC1jH+gUAzlIfMU9OeFhLGcjA
h1uFIuVVxrM=
=XBpv
-----END PGP SIGNATURE-----

--Sig_/N3_CpxxbKIdWbAia9B_s+gY--
