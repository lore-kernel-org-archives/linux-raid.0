From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 03/27] DDF: load_ddf_headers: use secondary header as
 fallback
Date: Mon, 8 Jul 2013 15:43:22 +1000
Message-ID: <20130708154322.4ff65e03@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
	<1372883287-8859-4-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cs3EQsMwxMfR8iYKAsnb49o"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-4-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cs3EQsMwxMfR8iYKAsnb49o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jul 2013 22:27:43 +0200 mwilck@arcor.de wrote:

> When the primary header can't be read, use the secondary header
> as fallback.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index c445df2..45522f2 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -601,15 +601,15 @@ static int load_ddf_headers(int fd, struct ddf_supe=
r *super, char *devname)
>  				DDF_REVISION_2, super->anchor.revision,devname);
>  		return 2;
>  	}
> +	super->active =3D NULL;
>  	if (load_ddf_header(fd, __be64_to_cpu(super->anchor.primary_lba),
>  			    dsize >> 9,  1,
>  			    &super->primary, &super->anchor) =3D=3D 0) {
>  		if (devname)
>  			pr_err("Failed to load primary DDF header "
>  			       "on %s\n", devname);
> -		return 2;
> -	}
> -	super->active =3D &super->primary;
> +	} else
> +		super->active =3D &super->primary;
>  	if (load_ddf_header(fd, __be64_to_cpu(super->anchor.secondary_lba),
>  			    dsize >> 9,  2,
>  			    &super->secondary, &super->anchor)) {
> @@ -619,9 +619,14 @@ static int load_ddf_headers(int fd, struct ddf_super=
 *super, char *devname)
>  		    || (__be32_to_cpu(super->primary.seq)
>  			=3D=3D __be32_to_cpu(super->secondary.seq) &&
>  			super->primary.openflag && !super->secondary.openflag)
> +		    || super->active =3D=3D NULL
>  			)
>  			super->active =3D &super->secondary;
> -	}
> +	} else if (devname)
> +		pr_err("Failed to load secondary DDF header on %s\n",
> +		       devname);
> +	if (super->active =3D=3D NULL)
> +		return 2;
>  	return 0;
>  }
> =20

Should that "|| super->active =3D=3D NULL" test go at the beginning of the =
'if'
rather than the set?  Currently it comparing sequence numbers between the
successfully read secondary and the (possibly) badly read primary.

Changing wouldn't actually affect the outcome so I'll apply the patch as-is,
but if you agree that it makes sense earlier, then I'd happily access a
follow-up patch which moves the test.

Thanks,
NeilBrown

--Sig_/cs3EQsMwxMfR8iYKAsnb49o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdpRejnsnt1WYoG5AQIj5w/9GWSpbGuQwC8Ok9s9Tte+GggYY01Jwv7P
Knv+51Uw2087qxcF07gPDGzjQaZuWV8D4Hd1VceXas8gm+hCGaGi7PYb/smVOPyh
FHltCg8e/ER12No4j4Ys3ecN6Oue7Q2PrDS8OL6bzbgyKBOQlutc5tnRyjcA+Q0O
IW9THAwPAypLagqLqzsVkFaMKwslknXWJ/dEUYZX3qZABSo4k4YwF2b6mT/Spkr+
XcP8PovpPSkQ7R3yoe2F0djAPEhQsNTqqjZDoYwZvK4R1EvFFrYhVSnirjNOFpK9
2q2moLFOqS9pdPlUn21wYAS94v135xdjueL3q1TSoPeYTSPpo43RCXpYVeuBxiF9
d14lbF32SswjcFtpX0Go43HK0NWJSpaNC2sk5nnqqiXGG8S/VdyqN4NPCi57mXrg
CNDNaWiMUtoz+h+wlKhlr4CL+4hLKsZccAzW6FFebdxVUBnVVzQ/Od2g0JaP/Y4f
oLyavTetKZ2XI1hxlNrj679zsmb7seZcuwH3Bxzvu+L93E9/YB/tk/F+Re8SZiW7
nQF+wLf4USIUjtKFgSzZqEzT+rJ1/mSdcuC/nml6PRTVBih1uKvZL7GRGQLBF6CZ
EQ6Yrmoj85c3AepS9XVpqy9OHp64qse1Yhx/LOY4+3DGwOrS0+eY4zQ70Vcf0z3h
jcfeYebuVLw=
=Cf+p
-----END PGP SIGNATURE-----

--Sig_/cs3EQsMwxMfR8iYKAsnb49o--
