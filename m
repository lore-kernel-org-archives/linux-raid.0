From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/raid5: fix typo
Date: Thu, 30 Apr 2015 17:14:26 +1000
Message-ID: <20150430171426.46d03aa1@notabene.brown>
References: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/x5oxh4PewixR9V7o1pzc7yG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/x5oxh4PewixR9V7o1pzc7yG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2015 15:01:16 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> bion -> bios
>=20
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 697d77a..2651bda 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2919,7 +2919,7 @@ schedule_reconstruction(struct stripe_head *sh, str=
uct stripe_head_state *s,
>  }
> =20
>  /*
> - * Each stripe/dev can have one or more bion attached.
> + * Each stripe/dev can have one or more bios attached.
>   * toread/towrite point to the first in a chain.
>   * The bi_next chain must be in order.
>   */

That was intentional.  "bios" as a plural looks too much like "BIOS" which =
is
in the ROM of computers.

Children and oxen are plurals with an 'n' at the end.  So I used 'bion'.
Private joke?

I'd rather leave it as it is.

Thanks,
NeilBrown

--Sig_/x5oxh4PewixR9V7o1pzc7yG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUHWUjnsnt1WYoG5AQL8MQ/+OMMuIvb2RokE8ytvxjdnEjF07wfkoDLB
Ubmi4o6OnI/H5DEfGLSU7oBssxStrDAuivvDHNuFr6c+DkGsDw4F6Go4Dd1U0QH2
R61xMOiPpfW0elh0SXPACDocTumNKu8KFdDe2hc5h3NYy17rhMMlIX4WCbGJWMWm
YfOdu2xt7QXh9aM1SLqJAvFzeFFOvTAJ/ydJpGuvrylEFWSCYYl5Xj622wtCV4EC
JxaqyS0qnq/Wgb10rqkFIp0HMQXK5iNpPN2eqjRJMsBWpeCHBshrWTOBUxvhOWxj
D4shpM/nA4KcKbWkGJyVJNNAHfPGogvU329pF0Wt5dmHhyHnFZ37fJzihtDTVOT0
zIjV2EQF+gSNGlOJmfBezFTY7agPZCBgjMIQ++OewblkOD0Pja80ZrGherfZ8eff
F3uNI3DJ3h95N1yJqfGpIE/hBps7pZTqvTVKCORzWposGqfBH1GpJ7jV1o6lH+Im
XZ9A0TD9Kn55r8pta5RVDsIWQlEwBBJwE0DwF5mAh2g608EP5H9RfU/JKMc6pBY6
PFbmHUzfeX6nlWRjjYKVpGegmuQgI9zy+n11wrwTRui6g7rPqXuIMcK9Fnr11lad
cXZDuCHe7cyblynvk0rirvtPSEzZ0ExnrcZHSBtNkfgdpgHtkIw2+nMWqN+/D+6P
PuPn9Ps6Dqo=
=8jyA
-----END PGP SIGNATURE-----

--Sig_/x5oxh4PewixR9V7o1pzc7yG--
