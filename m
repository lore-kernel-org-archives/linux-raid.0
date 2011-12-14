From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] FIX: Do not allow for multiple reshape_array()
 execution during reshape_container() call
Date: Wed, 14 Dec 2011 19:08:57 +1100
Message-ID: <20111214190857.7ab891dd@notabene.brown>
References: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OwaMlpExMzatIp/JJfCWiVd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/OwaMlpExMzatIp/JJfCWiVd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Dec 2011 11:12:10 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> It can happen during reshape restart that reshape_array() can exit without
> error (e.g. Grow.c:1915) and reshape is not moved to next array.
> reshape_array() is called again for the same device.
> Do not allow for such execution and check if last reshaped array is not
> the current one.
> This patch can be treat not as solution, but it allows for such errors
> detection.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Hi Adam.
 I'm afraid I understand the problem that requires this patch.
Could you please outline how it can happen that "reshape_array() can exit
without error (e.g. Grow.c:1915) and reshape is not moved to next array."

Also the comment in the code seems to be incomplete.  Could you complete it
please?
Thanks.

The other 2 patches in the series are fine.

Thanks,
NeilBrown

> ---
>=20
>  Grow.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 184a973..1828f83 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2462,6 +2462,7 @@ int reshape_container(char *container, char *devnam=
e,
>  {
>  	struct mdinfo *cc =3D NULL;
>  	int rv =3D restart;
> +	int last_devnum =3D -1;
> =20
>  	/* component_size is not meaningful for a container,
>  	 * so pass '-1' meaning 'no change'
> @@ -2546,6 +2547,17 @@ int reshape_container(char *container, char *devna=
me,
>  		if (!adev)
>  			adev =3D content->text_version;
> =20
> +		if (last_devnum =3D=3D mdstat->devnum) {
> +			/* do not allow for reentry reshape_array()
> +			 * for the same device. It can happen when resahpe_array
This one.  Should there be more to this sentence?

NB


> +			 */
> +			printf(Name ": Multiple reshape execution detected for "
> +			       "device  %s.", adev);
> +			close(fd);
> +			break;
> +		}
> +		last_devnum =3D mdstat->devnum;
> +
>  		sysfs_init(content, fd, mdstat->devnum);
> =20
>  		rv =3D reshape_array(container, fd, adev, st,


--Sig_/OwaMlpExMzatIp/JJfCWiVd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuhZmTnsnt1WYoG5AQKs+g/9FFP0apGZPl0VNX7S66eOGYZA4660mXRg
QnlFp+EF6dOO9gwwPZOlCMG0JLQMWoR+pmTg3LeX0fQMOoOl50ne6Pfuk7CPhSRI
09nvLvejkBMH+E8+HL/d/2cJq+m+e3r2Ly+OwE4NI9wmjmhNVNQodnU/p4TAqp7t
Ve83vUAtH3EgllOMZlutR6ZyEX0hyCAlAnVSrDsqg0hunLhfYq0SYvfSsb+benar
4VTbpJFINf6/ijCD3tY61QRpW7iFvNoQ7QhdOuS2+CHea+4PdUKJq8v7mDZ7zB/B
RGwg4k35qCWwEvL/85dR35lfpHWBwRM/HBKlYxTq6VgSVqPafClpY+3I18/9fBhN
LVTF1voJ7HxXXgQZPtdEYDN2cGEAnDFysKBQfxh8L/O+hhVyH4GrXxGMGfEf+iT+
MP04JOazOUqBX0jrwepJ6NdYNsvowlfTrTrzZ8MpzUXBeFd21GBHQ/orwKsLM+mZ
E060J7bsqZbx0NQSV5BmM6USxVnsVQUs5/fOz7lAfEcgYzXTSAyMSiz9OdakmSCx
qP3SO8FwgpINPurDyGKw6nV8+ZxwNsDRnH15cVcUd7AXVkapxJ58EXYU1qBPUIMJ
Ee5+hB5R8ZWqinmettMP1H2TcthYzLPqNXvvjJkZPxVxZEmc2GgqFETYulX9m8G7
ql8lRDz93cc=
=yqzd
-----END PGP SIGNATURE-----

--Sig_/OwaMlpExMzatIp/JJfCWiVd--
