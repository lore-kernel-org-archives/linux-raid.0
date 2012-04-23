From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: correct extending size of raid0 array
Date: Mon, 23 Apr 2012 10:12:52 +1000
Message-ID: <20120423101252.3f337002@notabene.brown>
References: <20120420090025.32107.93930.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GipagxmAJ+hk9GRXOWYVKJe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420090025.32107.93930.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/GipagxmAJ+hk9GRXOWYVKJe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Apr 2012 11:00:25 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Setting "sync_action" to "idle" while extending size of raid0 array
> is racy and sometimes fails.
> "sync_action" should be set to "frozen" instead.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Grow.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 389992e..b4b9ff2 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1749,7 +1749,7 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>  			/* do not recync non-existing parity,
>  			 * we will drop it anyway
>  			 */
> -			sysfs_set_str(sra, NULL, "sync_action", "idle");
> +			sysfs_set_str(sra, NULL, "sync_action", "frozen");
>  			/* go back to raid0, drop parity disk
>  			 */
>  			sysfs_set_str(sra, NULL, "level", "raid0");

applied,
thanks,
NeilBrown

--Sig_/GipagxmAJ+hk9GRXOWYVKJe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5SehDnsnt1WYoG5AQIR+A//XAP7lF4uwDX91spvC6wUDCqqlf6LA0Xf
2M9eGQvDyxy31OglmljKNTRdu9SJoE7YpzrzFzcBzrcgzPg0Va+ToMe6QDKF5UgJ
iLlJakeP62fJJAZEDB2uDWJAzSxW2oVozQqzRLeynyjICGIjCjqW/EcDIMM/pGE5
hkniNwkISR8+Em9I/xwOqL9N2B45LvglmaV9wCq4oercrTSvfrgiooThVcdkzXls
z4++oILxIQiVIkHNQrSxTF7qXcJ2xk8sV431XUH4Jy2MAk2CCkbhw70V/IGk2Uws
PLJKyFA2/I4QtuLV03ke4g88nSirBPxLFOH/ceB9NuBvtcy5OO+lFQpGKPS22ev2
OyrDxIg42ZIitcyaWjDB737uI0ok9W0NEscLcHqdQ/+Nv36/dgMPZRQBcuO8HkTS
QqE0U/rjkfuG8lok5C/8GR0ETdMITvjP9xZ+cRQ3U4a6CXUkBaoOVRy68e7Tt+Mk
pgaM0ZAs6dlBAqt2qAR4oGl0b6BEl0s04qdlopRQvGIc+Y4fDDL7GdGJmN1oKM9K
rB/EkYZ2s2Ry+tM4cnFqdkAH7pRjF7ikxyJG28/7VUzm+h2iDIZTjDwtpacL7uWQ
YE2cMHbSo4lq8QOagz12GgM+gEuDV0qZijwcr0AKzE7CmHYPJOd49tX4ijt7TYCC
P05mDyAuNCI=
=XDIV
-----END PGP SIGNATURE-----

--Sig_/GipagxmAJ+hk9GRXOWYVKJe--
