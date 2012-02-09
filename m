From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/12] Problems during restart container reshape
Date: Thu, 9 Feb 2012 12:39:23 +1100
Message-ID: <20120209123923.14638b58@notabene.brown>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q=eK9AbaWLbteZmnAu7kiM_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

--Sig_/Q=eK9AbaWLbteZmnAu7kiM_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Feb 2012 15:02:55 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> This series corrects problems occurred during restart multi arrays reshap=
e:
>  1. Assembled incrementally array during reshape is assembled degraded
>  2. Reshape cannot be continued after reboot. '--continue' gives  an error
>  3. When raid0 arrays are reshaped, first array is reshaped only
>  4. Size doesn't change on second raid0 array
> Please note that patch 'imsm: FIX: No new missing disks are allowed durin=
g general migration' can be easily extended by:
>  - Narrow it to incremental assembly only
>  - Array can be pushed to be assembled by using e.g. 'force' option durin=
g incremental assembly.
>=20
> Other issue addressed in this series is chunk size change from 128k to 4k=
 problem.
>=20
> BR
> Adam
>=20
> ---
>=20
> Adam Kwolek (12):
>       FIX: Do not try to (continue) reshape using inactive array
>       FIX: restart reshape when reshape process is stopped just between 2=
 reshapes
>       imsm: FIX: Clear migration record when migration switches to next v=
olume.
>       imsm: FIX: use md position to reshape restart
>       FIX: use md position to reshape restart
>       imsm: FIX: Chunk size migration problem
>       Flush mdmon before next reshape step during container operation
>       Fix: Sometimes mdmon throws core dump during reshape
>       imsm: FIX: imsm_get_allowed_degradation() doesn't count degradation=
 for raid1
>       FIX: Array is not run when expansion disks are added
>       imsm: FIX: No new missing disks are allowed during general migration
>       FIX: NULL pointer to strdup() can be passed
>=20
>=20
>  Assemble.c    |    2 -
>  Grow.c        |  124 ++++++++++++++++++++++++++++++++++++++++++++-------=
------
>  managemon.c   |    6 +++
>  msg.c         |   10 +++++
>  msg.h         |    1=20
>  super-intel.c |   47 +++++++++++++++++++---
>  util.c        |    5 +-
>  7 files changed, 159 insertions(+), 36 deletions(-)
>=20

Thanks for these.  I have provisionally applied them all however I won't pu=
sh
them out until I get confirmation about the '<=3D' or '<' issue that I
mentioned separately.

Thanks,

NeilBrown

--Sig_/Q=eK9AbaWLbteZmnAu7kiM_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzMjyznsnt1WYoG5AQJvPg//ULR2o9zNgGKr6pesmjrAj37BWlJAeFeN
j3x52eeh0wetQz9jArx8143cKdl/7oebcONn/+X0SXp51Z+v9SgpP9lt9RZVtm2E
z/rI/E5jnSV+NiTMlcJfb78IsyR2owkSpRjgNvDnFbTujp87g4eUDLW2JaswO6Cp
BOadrN8bwndKiKl0BeXEOxLWRrJqXG1W9t4Ncpwkd/GMJR3qarqy6BNepj2HahGT
BT3wzgR8FHxONJ+LON8BObmUGLn38atD11j6NuxGHAvwfAg8CutY+ETNtMpDjo25
hWJHbUyBIq+m2PFTcfctDpcHcA4SU6rt4SqGXUsIlax8Lr5AcUcVwrWa5LCGm4kG
AOWZoO0LNdbTRKaXEih9RIGbcGBo9sy/vnK24IawktedeS+xmkIFcK05dX4T2ooU
TsWjw8RbjVA32K2mOTioQIdiB41V8JXfqngDxn1h9vzFRb7AyAuU92IZHMDZyxGv
cvN3KyWAYozyhGZgyOHNKp778OCr/wIUXdNJv8dK81us6vxW8Bel9IZhXtoL9yfh
2PLQGmueq8Kb+WTNQmMwla2BjSdwBHd+H6JiXrBESdu19jaycYXHtBYxk+ceZ6A3
8Jc2cMP4oYa5G3n4ymUXzoxf9VF8Fd3MPH1OPbxDQbevsfHXJo7LIzxpgIZkxwe1
C0YWqsilKUU=
=4ybM
-----END PGP SIGNATURE-----

--Sig_/Q=eK9AbaWLbteZmnAu7kiM_--
