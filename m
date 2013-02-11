From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Modernize udev rules
Date: Mon, 11 Feb 2013 11:20:16 +1100
Message-ID: <20130211112016.3059ef95@notabene.brown>
References: <1360432119-15910-1-git-send-email-thomas@archlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/36muHo9t0175i=L92BX_0BT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1360432119-15910-1-git-send-email-thomas@archlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/36muHo9t0175i=L92BX_0BT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat,  9 Feb 2013 18:48:38 +0100 Thomas B=C3=A4chler <thomas@archlinux.or=
g>
wrote:

> * $tempnode is deprecated, use $devnode
> * blkid -o udev output is deprecated, use IMPORT{builtin}=3D"blkid" inste=
ad
> ---
>  udev-md-raid.rules | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/udev-md-raid.rules b/udev-md-raid.rules
> index cc7f5ef..ea97261 100644
> --- a/udev-md-raid.rules
> +++ b/udev-md-raid.rules
> @@ -10,7 +10,7 @@ LABEL=3D"md_inc"
> =20
>  # remember you can limit what gets auto/incrementally assembled by
>  # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
> -ACTION=3D=3D"add", RUN+=3D"/sbin/mdadm --incremental $tempnode --offroot"
> +ACTION=3D=3D"add", RUN+=3D"/sbin/mdadm --incremental $devnode --offroot"
>  ACTION=3D=3D"remove", ENV{ID_PATH}=3D=3D"?*", RUN+=3D"/sbin/mdadm -If $n=
ame --path $env{ID_PATH}"
>  ACTION=3D=3D"remove", ENV{ID_PATH}!=3D"?*", RUN+=3D"/sbin/mdadm -If $nam=
e"
> =20
> @@ -31,7 +31,7 @@ TEST!=3D"md/array_state", ENV{SYSTEMD_READY}=3D"0", GOT=
O=3D"md_end"
>  ATTR{md/array_state}=3D=3D"|clear|inactive", ENV{SYSTEMD_READY}=3D"0", G=
OTO=3D"md_end"
>  LABEL=3D"md_ignore_state"
> =20
> -IMPORT{program}=3D"/sbin/mdadm --detail --export $tempnode"
> +IMPORT{program}=3D"/sbin/mdadm --detail --export $devnode"
>  ENV{DEVTYPE}=3D=3D"disk", ENV{MD_NAME}=3D=3D"?*", SYMLINK+=3D"disk/by-id=
/md-name-$env{MD_NAME}", OPTIONS+=3D"string_escape=3Dreplace"
>  ENV{DEVTYPE}=3D=3D"disk", ENV{MD_UUID}=3D=3D"?*", SYMLINK+=3D"disk/by-id=
/md-uuid-$env{MD_UUID}"
>  ENV{DEVTYPE}=3D=3D"disk", ENV{MD_DEVNAME}=3D=3D"?*", SYMLINK+=3D"md/$env=
{MD_DEVNAME}"
> @@ -40,7 +40,7 @@ ENV{DEVTYPE}=3D=3D"partition", ENV{MD_UUID}=3D=3D"?*", =
SYMLINK+=3D"disk/by-id/md-uuid-$env
>  ENV{DEVTYPE}=3D=3D"partition", ENV{MD_DEVNAME}=3D=3D"*[^0-9]", SYMLINK+=
=3D"md/$env{MD_DEVNAME}%n"
>  ENV{DEVTYPE}=3D=3D"partition", ENV{MD_DEVNAME}=3D=3D"*[0-9]", SYMLINK+=
=3D"md/$env{MD_DEVNAME}p%n"
> =20
> -IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"
> +IMPORT{builtin}=3D"blkid"
>  OPTIONS+=3D"link_priority=3D100"
>  OPTIONS+=3D"watch"
>  ENV{ID_FS_USAGE}=3D=3D"filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=3D=
=3D"?*", SYMLINK+=3D"disk/by-uuid/$env{ID_FS_UUID_ENC}"

Applied, thanks.

NeilBrown

--Sig_/36muHo9t0175i=L92BX_0BT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURg5QDnsnt1WYoG5AQLeYg/9FcxuiSTRUoGBLtK1Gce4ZpRJBP/Et7KC
o0h9/PL6RCBYlz0KKMKtlztb0YPZsX5AZHJ49CKQUdibcx/roncUTW2X3bzNG9TW
F64Tq0cCenEmMWT92cwnqCcD2W+UEs6CluB5im3Lo4IOZC41AHVl7JhcR99dg+n4
fss/LWxJnhpHrpwKcawxV9PI84I0GSSq43HnsMMdEvOnaf0EL0OcGYjcpIk/44uA
ORV6vyNpsjaY3ccTbNh6TcnQ2q2CUD+NZVpPOQQvM41oOMMn4RfUuxSpY9uhhfn+
6XmfankRb7fjpq1r5gpu2xqfZGBfyhcDf/corJwrdRQYK9101J6lcWeTqshskFF3
o2OPGnxTweeE1+pSfRfkTeq14wtAD8dgKSfAfrHR6y4Pcj7X8q/wtjPVhSTdtVKx
5x3Ka3nher9FwW9ys5c3GR96cbK/ZorQNVkKypVQ0tZFihISOpwkKrbN/GW9s6Sg
5Y7J6TZgXr6Cm3l1cbptGwjwJPSqk+1Pe/K5fjANOVmO8LTk0+mNGUIOdHJAwfjI
JByyykLhqv9xpKqaTG/YIgA4dakGlfh/OwY4KGlzlMMcnI8RHwmyMkBtzBejr+/H
VxKE2lsQbDtzu7fG1FVSvoRwAxhPwkIdJNoqiGmaioCty+Tyc49cxEEWA02ikLtn
QDKyhlaRBPk=
=Yuyt
-----END PGP SIGNATURE-----

--Sig_/36muHo9t0175i=L92BX_0BT--
