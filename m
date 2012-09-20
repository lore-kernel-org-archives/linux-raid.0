From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix segfaults in Detail()
Date: Thu, 20 Sep 2012 11:06:44 +1000
Message-ID: <20120920110644.463c2fd9@notabene.brown>
References: <20120906154119.754.88103.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Aoy5G9jOiE6GDYvOI7PN8T1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120906154119.754.88103.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

--Sig_/Aoy5G9jOiE6GDYvOI7PN8T1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Sep 2012 17:41:19 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> If disk has been removed, 'st' and 'info' can be NULL. It causes segfault.
> 'st' and 'info' should be checked against being NULL before being used.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Detail.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/Detail.c b/Detail.c
> index 17aa516..79b1047 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -430,7 +430,7 @@ int Detail(char *dev, struct context *c)
>  		}
>  		free_mdstat(ms);
> =20
> -		if (st->sb && info->reshape_active) {
> +		if ((st && st->sb) && (info && info->reshape_active)) {
>  #if 0
>  This is pretty boring
>  			printf("  Reshape pos'n : %llu%s\n", (unsigned long long) info->resha=
pe_progress<<9,
> @@ -596,7 +596,8 @@ This is pretty boring
>  	if (spares && c->brief && array.raid_disks) printf(" spares=3D%d", spar=
es);
>  	if (c->brief && st && st->sb)
>  		st->ss->brief_detail_super(st);
> -	st->ss->free_super(st);
> +	if (st && st->ss)
> +		st->ss->free_super(st);
> =20
>  	if (c->brief > 1 && devices) printf("\n   devices=3D%s", devices);
>  	if (c->brief)
>=20

applied, thanks.
Though I removed the test on 'st->ss' - that is never NULL.

NeilBrown

--Sig_/Aoy5G9jOiE6GDYvOI7PN8T1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFpsJDnsnt1WYoG5AQLqgRAAqEAQExK/RlzCUN1W/5FGarRLfrsvCQMy
if8smmA0/WXQ5cgZUfK6H6TORcDowp04c7vfgaj6fyoWRKC1xzDd480DykI/7PN1
I5ar0lZQ/AmGtTjNqHWVXKEW8YKkZRMVCoKJmpyOj9gZFs08TqdMC0CW0Hb6UN8j
XfYipK486nmxDpiKHfmrYWS2qCImn57eEU6JJLRncvm0HlylIHwoQ1yIZaa0rkVo
WbJOW9MOjZa9OWFQRDn4lgHeD2/6qeEp5aMM+bg3uPwTdUbijISudrtn9/Rq7R8O
NhxiFir2PLgCUuWjDGt++3ytGYod41q/08NUEzopXOi7+CoGdVS61HYvLDlIFipl
hHiuYGoTgdTUvedTPJUFSGX3P9wLxYSl9xo7uC2cDawk3+paY1yXVl338S5mxeGP
6rBvpxcBKp5nh6qEKw8qIYNuvdWRxHjeuhCJKQ+KQfmAbVYcPiJh3lhiHxhnBjPH
1ideoluFH/rVNU9heS4Hf2MRwCrPOsl7BJQ6IDQ5paJz5xf7yKJID8o1yUGcswFx
07RAV5LbonZH9Q4YC/bppSC+F6SBrqlQ6KHYlQzcYeu3ImFxaAuYsOg005XBvXUg
vQxqKp9gOhdmfShkrpJuRNitLdYjaVy0VW1SsWbedhOJBUFO0DebYn51EH2ohAcK
HXrqQVPxm4g=
=FgJ9
-----END PGP SIGNATURE-----

--Sig_/Aoy5G9jOiE6GDYvOI7PN8T1--
