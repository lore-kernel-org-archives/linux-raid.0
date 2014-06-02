From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Do not set default 'before.layout' when reshaping from
 RAID4 to RAID4
Date: Mon, 2 Jun 2014 12:30:21 +1000
Message-ID: <20140602123021.1184b461@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918CE9@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rHDZO4=_6SGxhFBPlqq6FF1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F07918CE9@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/rHDZO4=_6SGxhFBPlqq6FF1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 30 May 2014 14:38:09 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> Commit fdcad551e9a54c4aa8c4b63160b76e2c539a0441
> brings some changes to reshape process.
> Setting 'before.layout' when reshaping from RAID4 to another RAID4 is
> not really necessary.
> If reshape is restarted 'before.layout' will be compared with
> 'info->array.layout' in reshape_array(). Changes brought by mentioned
> commit will cause this comparation return as false, becouse 'array.layout'
> is always set to 'ALGORITHM_PARITY_N' in analyse_change() for RAID4, so
> reshape will not be continued after reboot/stop.
> This patch reverts unnecessary changes.
>=20
> Signed-off-by: Pawel Baldysiak pawel.baldysiak@intel.com
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>=20
> ---
> Grow.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 487111e..9dc157a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1338,7 +1338,6 @@ char *analyse_change(char *devname, struct mdinfo *=
info, struct reshape *re)
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (re->level) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 4:
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re->before.layout =3D 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re->after.layout =3D=
 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 5:

Applied, thanks.  Though you seem to have forgotten how to make patches
properly.  That one was totally white-space damaged.

NeilBrown

--Sig_/rHDZO4=_6SGxhFBPlqq6FF1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4vhvTnsnt1WYoG5AQKwJxAAkKvtZ/1M2cvxCIusQFZItCbP5Dn4Up6u
vUA+T6Sl3SByOdQ8c5ABTkNvn5pG2IM5FRxeT9Vygk0i2QLpPOzkDRqiEFQnP7i1
YHogV0mhaBPgpHH29JKUC/5s6kfmSKsAxi2OsIPq78Zrd+puQRj4rDmYSk5LRZh4
xNreWDGivwX00UA9w8H0e61G+DHYMkle/X3h7kcbZ9qbAKIu500rQtFX28+rnTVg
JNr6knHwUz62DmbQIagaxpBgrntODaftQBJsa4XsZYCuI7Px1v+E3k26Gti9RnGn
1fy/AtgWRUmMVqh9YT6xmatxhA5vzZ9kw8Yxk8zY1D3OBADhalm4wfM7Fc5U821o
OasurwjcdL26fRO/pl9/yfqPmD/cDlBMhY+HuXoFtYzwTwhad1gCGYtZJI020ogz
+dJc69/FLau9JOUFp80uHUb9gePTZSXGom6fTpLrRKYYE+a/DqavdrKiG0CI34Xr
/OiJxyAv8Bk8yzKQXLaRMNh9TZAeenFgxJSOABa4jsaWVUp1b7JfdmLmi4E9bNvv
tmRTtOQvCwJpAlK3aeT7xmVRZMt/1vaWqsgHoQKy7y93U4E5kbU5O0MSRbzmyMMQ
fB5nUm7mz4kPO9u4VTwxbse5FLW47vC0punHO8K6AuJwwhFRG/a69xQyc12Gqqqk
iyyyHDVE+40=
=dvSm
-----END PGP SIGNATURE-----

--Sig_/rHDZO4=_6SGxhFBPlqq6FF1--
