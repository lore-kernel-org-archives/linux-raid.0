From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: imsm: do not accept too small sizes
Date: Thu, 20 Sep 2012 12:31:44 +1000
Message-ID: <20120920123144.26ea1089@notabene.brown>
References: <20120914142030.19105.28984.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_4WJcMsT+33zBoIaWW.sR80"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120914142030.19105.28984.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/_4WJcMsT+33zBoIaWW.sR80
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Sep 2012 16:20:31 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Inappriopriate error messages (e.g. mdadm: platform does not support
> raid5 with 0 disk) have been displayed when too small size was given.
> This patch fixes it.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 1d36613..107550f 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -9744,6 +9744,13 @@ enum imsm_reshape_type imsm_analyze_change(struct =
supertype *st,
>  				    get_imsm_raid_level(dev->vol.map),
>  				    chunk * 1024,
>  				    geo->size * 2);
> +		if (geo->size =3D=3D 0) {
> +			pr_err("Error. Size expansion is " \
> +				   "supported only (current size is %llu, " \
> +				   "requested size /rounded/ is 0).\n",
> +				   current_size);
> +			goto analyse_change_exit;
> +		}
>  	}
> =20
>  	if ((current_size !=3D geo->size) && (geo->size > 0)) {

Applied, thanks.

NeilBrown

--Sig_/_4WJcMsT+33zBoIaWW.sR80
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqAETnsnt1WYoG5AQLuEBAAtWnb3sVr1DPU2wm6+I+0N3Gk/J0zsrC9
mGd78VBwkyqpmoTkpj2h9bAL7UCuJsBScm1L2esQQK9nGiZ1HhSsi0AwZps6ZTof
qkEjKHKVvFgb4NLjf2NebnenKPg54HAGnuMqu/HDqLz4z+Sl1IuK9mo8OLXLWspX
HH36xx29d7zZLqgN6bAwMi3XGrGTbcQqwZjtjOIFs5UjlNrE75ZcTwxtFGpsqfAG
RB1hOwKkcfl/pFNV7j0564EC59J/chyxpIieZfljM3fJVJlT1RR4ruE/c8w1ubto
ynmw59q+RhIEkhYf5KLXXpSPYEsp/bE0ODVDKiEb8jkIV1C93P8OAJkdd+Wx971b
082tXWM5aFUktBNYYORne/EfgD6A0Wf+3SXxouEXHf2ua9+A9ykRAJll251JGCyd
cTS4EIrVK221hv44ISPa0/qUfxnVB4W5iwQzQwst+cSojBvz9WSgHRtJP6LKrxsK
rVYNiUdumrWGrCHbRCKxTgtl7FljvzayWIwMzeFlIQvm7NJiGx54F+SQSjvkQqc+
LMh6QkZAqgvYTeHIxl3p7aIgkCd9hRc++HoWB4xQztT5tS7iP1sJhL032YvK/RYO
TyGhhj7AgFJonWfh/QxSlb6F4Dd+Ul61T8eNCRA2cqh8uyuawF7qKcdGEY6ZUp4h
ocL+gwlSkYA=
=ILMI
-----END PGP SIGNATURE-----

--Sig_/_4WJcMsT+33zBoIaWW.sR80--
