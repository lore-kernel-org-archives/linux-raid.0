From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] V2 cast print arguments in super-ddf.c
Date: Tue, 5 Aug 2014 09:00:55 +1000
Message-ID: <20140805090055.2b0b6dd5@notabene.brown>
References: <1407145424-14116-1-git-send-email-normand@linux.vnet.ibm.com>
	<1407163983-29770-1-git-send-email-normand@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/89u4ha4T6zn9lZ5y3M1c7SG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1407163983-29770-1-git-send-email-normand@linux.vnet.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michel Normand <normand@linux.vnet.ibm.com>
Cc: linux-raid@vger.kernel.org, Guy Menanteau <menantea@linux.vnet.ibm.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

--Sig_/89u4ha4T6zn9lZ5y3M1c7SG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  4 Aug 2014 16:53:03 +0200 Michel Normand
<normand@linux.vnet.ibm.com> wrote:

> From: Guy Menanteau <menantea@linux.vnet.ibm.com>
>=20
> V2 differs only by correct From and Signe-off fields.
>=20
> as per rhbz https://bugzilla.redhat.com/show_bug.cgi?id=3D1125883
> the mdadm is failing on ppc64 and ppc64le architectures.
> =3D=3D=3D
> super-ddf.c: In function '_set_config_size':
> super-ddf.c:2849:4: error: format '%llx' expects argument of type 'long l=
ong unsigned int', but argument 6 has type '__u64' [-Werror=3Dformat=3D]
>     pr_err("%s: %x:%x: workspace size 0x%llx too big, ignoring\n",
>     ^
> super-ddf.c:2855:2: error: format '%llx' expects argument of type 'long l=
ong unsigned int', but argument 6 has type '__u64' [-Werror=3Dformat=3D]
>   dprintf("%s: %x:%x config_size %llx, DDF structure is %llx blocks\n",
>   ^
> cc1: all warnings being treated as errors
> <builtin>: recipe for target 'super-ddf.o' failed
> =3D=3D=3D

Thanks a lot of the patch.  I've applied it and it will be in mdadm-3.3.2.

NeilBrown


>=20
> Signed-off-by: <menantea@linux.vnet.ibm.com>
> Signed-off-by: Michel Normand <normand@linux.vnet.ibm.com>
> ---
>  super-ddf.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index 8957c2e..bc0ce2c 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2847,13 +2847,15 @@ static void _set_config_size(struct phys_disk_ent=
ry *pde, const struct dl *dl)
>  		__u64 wsp =3D cfs - t;
>  		if (wsp > 1024*1024*2ULL && wsp > dl->size / 16) {
>  			pr_err("%s: %x:%x: workspace size 0x%llx too big, ignoring\n",
> -			       __func__, dl->major, dl->minor, wsp);
> +			       __func__, dl->major, dl->minor,
> +			       (unsigned long long)wsp);
>  		} else
>  			cfs =3D t;
>  	}
>  	pde->config_size =3D cpu_to_be64(cfs);
>  	dprintf("%s: %x:%x config_size %llx, DDF structure is %llx blocks\n",
> -		__func__, dl->major, dl->minor, cfs, dl->size-cfs);
> +		__func__, dl->major, dl->minor,
> +		(unsigned long long)cfs, (unsigned long long)(dl->size-cfs));
>  }
> =20
>  /* Add a device to a container, either while creating it or while


--Sig_/89u4ha4T6zn9lZ5y3M1c7SG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+AQpznsnt1WYoG5AQLbuBAAnEKna1aTHCK42UBf6234x3n/2b4pAC0M
6k1ffESGgAvhH3NtDnU9smFrH4U1LGz2EtZ76G5F+vT4q9QAe8KHxMKGSPN92jdh
YHv3qBv/X2eFtjzGV96J21EN4rM6EWktPURR7851eli3JchBPCtJyCcBlBw32D1y
8/y3CoKORx+GR39QdyUGQBihT7+FLApF3juHsfoAmrcS16z9GFvG0nV4m4NuRdh/
duhRNXqeKUB1sPsvy10yjriq7djPviuHATfdS6tRUHsyk++fchjDBZC+vTJPCjcj
GpMcXZ1wd6nvsBJc5f1tyrZ6gWJkQ6FwX2l5HT2pg/NW8S0XLVZhVRBDI1P8ZB/X
WOYc1QXF1v2BWo4dE4IB0azNdfsCpBQAgoBcgGS6FtGficT6esHYFZqqGjuaQz6O
IUx6012AqCbN4jnUTtlJ5C+H3+vlY0IiOIq8MJaFcY5CYwMzvgo1m0F7gxFNyMo1
T9CiN5tfS3qieJta+aeN/4znxHg2cn/WO7/4wDfJhr6AU8mddzOYZ8fLXtBV3KqE
4JFeBCMQITqnjdHOLJholDVtMCbclJHlCG0eM3558FksuuCfGMt+Te3mHzZ/Qi+Q
S6mXDl6DDH9ZODYmp7OR+uI5VW5SLJwMPKwd2at+1pnfmgfGvlnsLGamd9N/nJ0q
OmkOKsmbeDk=
=Tfie
-----END PGP SIGNATURE-----

--Sig_/89u4ha4T6zn9lZ5y3M1c7SG--
