From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Changes in '0' case for reshape position
 verification
Date: Mon, 20 Feb 2012 14:14:00 +1100
Message-ID: <20120220141400.4f8bbf7f@notabene.brown>
References: <20120216131604.4985.58287.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lEt8OoqTKPQgyERUw8CJWgD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120216131604.4985.58287.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, anna.czarnowska@intel.com
List-Id: linux-raid.ids

--Sig_/lEt8OoqTKPQgyERUw8CJWgD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Feb 2012 14:16:04 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Reading sysfs entry that is '0' long should cause an error.
> Reshape position cannot be empty.
>=20
> Absence of reshape position should be ignored. It is possible
> that we are about raid0 reshape continuation and it is before takeover.
> This means that according metadata (changed by mdmon) it should be reshap=
ed
> but md knows nothing about it at this moment. Reshape continuation
> in reshape_array() will change it to raid4 and reshape position appears
> in sysfs.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Thanks.  Applied.

NeilBrown


> ---
>=20
>  Grow.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 53a7cad..239b50d 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1876,9 +1876,12 @@ static int verify_reshape_position(struct mdinfo *=
info, int level)
>  {
>  	int ret_val =3D 0;
>  	char buf[40];
> +	int rv;
> =20
>  	/* read sync_max, failure can mean raid0 array */
> -	if (sysfs_get_str(info, NULL, "sync_max", buf, 40) > 0) {
> +	rv =3D sysfs_get_str(info, NULL, "sync_max", buf, 40);
> +
> +	if (rv > 0) {
>  		char *ep;
>  		unsigned long long position =3D strtoull(buf, &ep, 0);
> =20
> @@ -1906,6 +1909,11 @@ static int verify_reshape_position(struct mdinfo *=
info, int level)
>  				ret_val =3D 1;
>  			}
>  		}
> +	} else if (rv =3D=3D 0) {
> +		/* for valid sysfs entry, 0-length content
> +		 * should be indicated as error
> +		 */
> +		ret_val =3D -1;
>  	}
> =20
>  	return ret_val;
> @@ -3975,7 +3983,7 @@ int Grow_continue_command(char *devname, int fd,
>  	 * correct position
>  	 */
>  	if (verify_reshape_position(content,
> -				    map_name(pers, mdstat->level)) <=3D 0) {
> +				    map_name(pers, mdstat->level)) < 0) {
>  		ret_val =3D 1;
>  		goto Grow_continue_command_exit;
>  	}
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/lEt8OoqTKPQgyERUw8CJWgD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0G6eDnsnt1WYoG5AQJd+Q/9Fm+tPliDscIxtrHmzVEMeebM4dEJjGEq
FVy2BIpV5xcIZnGAkuVbB2YBbBwdlbXgAlZ7Q3OcQPJu5aIXL91xNqItD4zg5JEp
ScGtg/LNrDg22ZcQMTOH8yZy2EtZIAZfJAmIhJV+8wL3beeLKhJG3aLlb/pq+78k
440LFrnzlP4+T4Jw2Okd0VWpegAzo6TFi1v8a7XkYDWw296GiDuzGfOGCTfdTexl
tQUaXwx28yKP2G/Gs2dW/xkVyIAdHEzpa50IfSAobzqoZbMEF2YwJ3Z1K/RaXXFB
2kKcVJFTB4D8BIZdWIRCEgiCLSHkZvfKf+cMjvBdzFlchut4AjPA+MhK/ZuiMvt0
ZX9kFVQ0Myhlr7USSN//3Qbm2+MmxZX2wbPOKWAVLIwrKPctq+rD9Dg4yZa/m1Or
MHaQ99HX3QVIVBgX7PQBIijfesjnYOB3wi1zm2YG0JWOp8MghWu3TWnEAy2JSGGp
KpI+XZ4rwYCvoF81hE2nUmSSDOT5XetlOs8ovtuFKNOGImIOTi+uKyVS18Ra/NuD
+xKvf0IDGlEovrEMJIv66wP/46zte4WAI2mWRVunZU2k2CyTvY0UFdm6AVsD1doR
HJIFYvCQgCpHf3VirI3Fco+U8SMlT+20U/cc1LJ/hfmhpYA41NDVw+x34h31Rm6l
QxwPSMJvJ7Y=
=M6Og
-----END PGP SIGNATURE-----

--Sig_/lEt8OoqTKPQgyERUw8CJWgD--
