From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: Forbid spanning between multiple controllers.
Date: Mon, 19 Nov 2012 11:08:00 +1100
Message-ID: <20121119110800.5ba2b63e@notabene.brown>
References: <20121109144636.2215.91684.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZSd3ehWwh6Cfr5s94B=KsG2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121109144636.2215.91684.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Tomczak <marcin.tomczak@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

--Sig_/ZSd3ehWwh6Cfr5s94B=KsG2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 09 Nov 2012 15:46:36 +0100 Marcin Tomczak <marcin.tomczak@intel.com>
wrote:

> Attaching disks to multiple controllers of the same type has been
> allowed so far. Now spanning between multiple controllers is disallowed
> at all by IMSM metadata.
>=20
> Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
> Reviewed-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |   25 ++++++++-----------------
>  1 files changed, 8 insertions(+), 17 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 544cb05..db437b9 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -558,20 +558,11 @@ static int attach_hba_to_super(struct intel_super *=
super, struct sys_dev *device
>  	if (super->hba =3D=3D NULL) {
>  		super->hba =3D alloc_intel_hba(device);
>  		return 1;
> -	}
> -
> -	hba =3D super->hba;
> -	/* Intel metadata allows for all disks attached to the same type HBA.
> -	 * Do not sypport odf HBA types mixing
> -	 */
> -	if (device->type !=3D hba->type)
> +	} else
> +		/* IMSM metadata disallows to attach disks to multiple
> +		 * controllers.
> +		 */
>  		return 2;
> -
> -	while (hba->next)
> -		hba =3D hba->next;
> -
> -	hba->next =3D alloc_intel_hba(device);
> -	return 1;
>  }
> =20
>  static struct sys_dev* find_disk_attached_hba(int fd, const char *devnam=
e)
> @@ -3018,11 +3009,11 @@ static int compare_super_imsm(struct supertype *s=
t, struct supertype *tst)
>  	 */
>  	if (!check_env("IMSM_NO_PLATFORM")) {
>  		if (!first->hba || !sec->hba ||
> -		    (first->hba->type !=3D sec->hba->type))  {
> +		    strcmp(first->hba->path, sec->hba->path) !=3D 0)  {
>  			fprintf(stderr,
>  				"HBAs of devices does not match %s !=3D %s\n",
> -				first->hba ? get_sys_dev_type(first->hba->type) : NULL,
> -				sec->hba ? get_sys_dev_type(sec->hba->type) : NULL);
> +				first->hba ? first->hba->path : NULL,
> +				sec->hba ? sec->hba->path : NULL);
>  			return 3;
>  		}
>  	}
> @@ -3800,7 +3791,7 @@ static int find_intel_hba_capability(int fd, struct=
 intel_super *super, char *de
>  			}
> =20
>  			fprintf(stderr, ").\n"
> -				"    Mixing devices attached to different controllers "
> +				"    Mixing devices attached to multiple controllers "
>  				"is not allowed.\n");
>  		}
>  		free_sys_dev(&hba_name);
>=20

applied, thanks.

NeilBrown


--Sig_/ZSd3ehWwh6Cfr5s94B=KsG2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKl4YDnsnt1WYoG5AQKP5Q//SbNgH2rj/OUK3E84CyVv2lug9gTg0vsO
Qm/zIksx44oS7qs4X/X2L6r24KZug4rDzCc8HyMnYUA6G8A05Qv0fp0pMErJO37f
/Ll6vjC7hlIQLNWs8iVlH7pr2w7+uD8wdWt11YM+Zntt435m6eT2qHCDRMCkoiX1
HZRfd3rnGBrkbGUc45tgPzvqAbu26UR4AQEDFcgRXRBJGVhqsJYuGNDPcgxWXnVq
OzjFFrXIww7E5Ae4msy7jiVvO1wkdg5F+HVhQc1Gdtgdt0/1k8Lt5cwoASzfq8ZT
u9Z6rxkGnFKNXGERHKpRufa1jnc96uoHlqddHqR6S4malSV3WiC+syFbb86OZ9IC
kcD4CqMtzzzYT500RFJOHKUmq6DKr6nxHXLi6mqMO+C0E17UpNL0JVKMJnW/6A9o
JGXjM1zy76R3qRvNl8N7PXVQcNc5Hv/mfdVBsONZDHRhhPyinhFVqhQAz2ERsRPl
5MWCq0NTZSSIyLxC2dgfBtB0BaFIIC+Qji+ImzkJ1JvJC1gX2DQqN3GciP7vjN11
9ush0VlvAROrd8BOOAGIYnCSAb+g8pmjp73XNxN78p9EqFJ/XyKvR5sLPT4kbhMM
Cvfli6vYCOKDVVzxAt/Wo1TUs+Q0fi17voeolrQuM5wWTnUp9OwN9BHy2uWvpx6g
lvGvTbyhCXE=
=1rD5
-----END PGP SIGNATURE-----

--Sig_/ZSd3ehWwh6Cfr5s94B=KsG2--
