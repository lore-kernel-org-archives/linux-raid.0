From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] util.c: two typos fixed
Date: Wed, 26 Oct 2011 08:50:17 +1100
Message-ID: <20111026085017.325fae6b@notabene.brown>
References: <20111025134225.21412.35652.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oO7ctfrzovDaGk0f0F_Wqqg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111025134225.21412.35652.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/oO7ctfrzovDaGk0f0F_Wqqg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Oct 2011 15:42:25 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Two typos fixed.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  util.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/util.c b/util.c
> index f785f03..2cf617d 100644
> --- a/util.c
> +++ b/util.c
> @@ -1709,7 +1709,8 @@ int experimental(void)
>  	if (check_env("MDADM_EXPERIMENTAL"))
>  		return 1;
>  	else {
> -		fprintf(stderr, Name ": To use this feature MDADM_EXPERIMENTAL envirom=
ent variable has to defined.\n");
> +		fprintf(stderr, Name ": To use this feature MDADM_EXPERIMENTAL"
> +				" environment variable has to be defined.\n");
>  		return 0;
>  	}
>  }
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

applied. Thanks,

NeilBrown

--Sig_/oO7ctfrzovDaGk0f0F_Wqqg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqcvGTnsnt1WYoG5AQJWog//WG2uuOH5iJuulHeu+GFGUfDeaX49SXou
I/2anPtQoW6L9dXghOCRm8vCRzLKpyR2KTVHcWbz0UWsotiSmyWebRWN3oAm7o8g
DRV4Ev2jVSiYmYOsFiix3rVlsCLF40aXzqxFghZQ+GNrTPHCH6O1T5rUY/RVEPFS
QoGCq7/4FYnKk/ACn8wiVoe7BROVA71YZNmwdvZcAJbHiLXEthNhN1gGhXukhn60
/onA6SQPOZ8Nr0fIo8n6IhsX8zFgbdWpmLQFsTwHxa5z7ZoaMswZYwTuNz0c1qvN
rrdalNZ1KFUQYDYQhd+XZsiAIhbYV+o5muZ1qKlPeXbfH9+LKBkfjSaBervxSpva
0Q7OThCGKK7bxg/mYRwFEjpJQH2PVaiNwq1mWnwE/00Cmo4MmBp0Wbk8ruNixd1t
NvnftqT6ynH49Zd84GVe8nRTLsSkFW0LGiXs6z/YnkdMXjMEaGyFOJXwCLVbKG6M
XHRmoVnszhXSeAAVpr0EVymRKNTJeXk2bYZVD9y2dey4rhounTygDtR62FAOi7GY
TTqqiiinXi6ObpOSpEEKS+ZbrpEa+Ytxw4XTNfCYQ+1mroR38eX94twh0Oy5saE9
FUroz9V+gFMGKY4eEsAiLndr4FTMrYa2eviNMLIrvp6XNRv5bwY/+4RTzZTInszY
pFjRJmLB9wA=
=NCQ0
-----END PGP SIGNATURE-----

--Sig_/oO7ctfrzovDaGk0f0F_Wqqg--
