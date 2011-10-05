From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Fix freezing multiple arrays in container during
 assembly (2)
Date: Wed, 5 Oct 2011 13:34:22 +1100
Message-ID: <20111005133422.0c8eaeb8@notabene.brown>
References: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_KYOcJJ8FThxH9IlHN8WSsN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/_KYOcJJ8FThxH9IlHN8WSsN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 03 Oct 2011 18:13:30 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> The following series corrects freezing reshaped array in container during
> assembly while other arrays are present.
>=20
> The goal of the patches is to get entire assembled container (all arrays =
inside)
> to be blocked from monitoring when reshape is in progress /exactly as when
> reshape is initialized from mdadm command line/.
>=20
> This time, freezing decision is taken based upon information from metadat=
a,
> not /sysfs entries. For this purpose recovery_blocked field is added to m=
dinfo.
>=20
>=20
> Note: First patch in this series for mdadm throwing core file problem
>       is resent as reminder.
>=20
> BR
> Adam
>=20
> ---
>=20
> Adam Kwolek (4):
>       Remove freeze() call from Grow_continue()
>       imsm: Fill recovery_blocked field present in mdinfo
>       Add recovery blocked field to mdinfo

These three all applied - thanks.

>       FIX: restore_backup() throws core dump

Fixed differently as described in separate email.

Thanks,
NeilBrown


>=20
>=20
>  Assemble.c    |    2 +-
>  Grow.c        |   13 ++++++-------
>  mdadm.h       |    7 +++++++
>  super-ddf.c   |    2 ++
>  super-intel.c |    6 ++++--
>  super0.c      |    2 ++
>  super1.c      |    2 ++
>  7 files changed, 24 insertions(+), 10 deletions(-)
>=20


--Sig_/_KYOcJJ8FThxH9IlHN8WSsN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi8IuG5fc6gV+Wb0RAtDkAKCaz7n6UJfNyGbIdmiMV0ykGYCkaACgnTqk
2DlUVcSHfg7M0Qm68kyqQBM=
=SfAj
-----END PGP SIGNATURE-----

--Sig_/_KYOcJJ8FThxH9IlHN8WSsN--
