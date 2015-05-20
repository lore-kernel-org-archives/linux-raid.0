From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] need read reshape_groress from sys
Date: Wed, 20 May 2015 15:20:42 +1000
Message-ID: <20150520152042.407313f9@notabene.brown>
References: <1431673637-10817-1-git-send-email-xni@redhat.com>
	<592729481.1396196.1432089335521.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/IxzE5f/1+D7J=Vlbl9a0BdV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <592729481.1396196.1432089335521.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/IxzE5f/1+D7J=Vlbl9a0BdV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2015 22:35:35 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Hi all
>=20
>    Send the patch again. Because I don't see them at http://www.spinics.n=
et/lists/raid/
>=20
>=20
> ----- Forwarded Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: linux-raid@vger.kernel.org
> Cc: "Xiao Ni" <xni@redhat.com>
> Sent: Friday, May 15, 2015 3:07:17 PM
> Subject: [PATCH] need read reshape_groress from sys
>=20
>=20


Please actually explain the purpose of the patch.
Then  re-read it to ensure it makes sense and remove obvious typos.

and don't just remove unrelated blank lines.
Only include in the patch things that need to be in the patch.


NeilBrown


> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c  |   18 ++++++++++++------
>  mdadm.h |    1 +
>  sysfs.c |   15 +++++++++++++++
>  3 files changed, 28 insertions(+), 6 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 568e399..44ee8a7 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -710,11 +710,17 @@ int start_reshape(struct mdinfo *sra, int already_r=
unning,
>  	err =3D sysfs_set_num(sra, NULL, "suspend_hi", sra->reshape_progress);
>  	err =3D err ?: sysfs_set_num(sra, NULL, "suspend_lo",
>  				   sra->reshape_progress);
> -	if (before_data_disks <=3D data_disks)
> -		sync_max_to_set =3D sra->reshape_progress / data_disks;
> -	else
> -		sync_max_to_set =3D (sra->component_size * data_disks
> -				   - sra->reshape_progress) / data_disks;
> +
> +	if (sra->reshape_progress =3D=3D UINT64_MAX) {
> +		err =3D err ?: sysfs_set_str(sra, NULL, "sync_max", "max");
> +	} else {
> +		if (before_data_disks <=3D data_disks)
> +			sync_max_to_set =3D sra->reshape_progress / data_disks;
> +		else
> +			sync_max_to_set =3D (sra->component_size * 2 * data_disks
> +										- sra->reshape_progress) / data_disks;
> +	}
> +
>  	if (!already_running)
>  		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
>  	err =3D err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
> @@ -3075,7 +3081,7 @@ static int reshape_array(char *container, int fd, c=
har *devname,
>  	}
>  	sra =3D sysfs_read(fd, NULL,
>  			 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|GET_CHUNK|
> -			 GET_CACHE);
> +			 GET_CACHE|GET_RESHAPE_PROGRESS);
>  	if (!sra) {
>  		pr_err("%s: Cannot get array details from sysfs\n",
>  			devname);
> diff --git a/mdadm.h b/mdadm.h
> index 141f963..6fb17e1 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -526,6 +526,7 @@ enum sysfs_read_flags {
>  	GET_DEGRADED	=3D (1 << 8),
>  	GET_SAFEMODE	=3D (1 << 9),
>  	GET_BITMAP_LOCATION =3D (1 << 10),
> +	GET_RESHAPE_PROGRESS =3D (1 << 11),
> =20
>  	GET_DEVS	=3D (1 << 20), /* gets role, major, minor */
>  	GET_OFFSET	=3D (1 << 21),
> diff --git a/sysfs.c b/sysfs.c
> index 18f3df9..09b0c93 100644
> --- a/sysfs.c
> +++ b/sysfs.c
> @@ -26,6 +26,7 @@
>  #include	"mdadm.h"
>  #include	<dirent.h>
>  #include	<ctype.h>
> +#include	<stdint.h>
> =20
>  int load_sys(char *path, char *buf)
>  {
> @@ -210,6 +211,19 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsig=
ned long options)
>  		msec =3D (msec * 1000) / scale;
>  		sra->safe_mode_delay =3D msec;
>  	}
> +
> +	if (options & GET_RESHAPE_PROGRESS) {
> +			 =20
> +		strcpy(base, "reshape_progress");
> +		if (load_sys(fname, buf))
> +			goto abort;
> +
> +		if (strncmp(buf, "max", 3) =3D=3D 0)
> +			sra->reshape_progress =3D UINT64_MAX;
> +		else
> +			sra->reshape_progress =3D strtol(buf, NULL, 10);
> +	}
> +
>  	if (options & GET_BITMAP_LOCATION) {
>  		strcpy(base, "bitmap/location");
>  		if (load_sys(fname, buf))
> @@ -224,6 +238,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsign=
ed long options)
>  			goto abort;
>  	}
> =20
> +
>  	if (! (options & GET_DEVS))
>  		return sra;
> =20


--Sig_/IxzE5f/1+D7J=Vlbl9a0BdV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVwZqjnsnt1WYoG5AQKLvRAAhN6RsJt5OPHPbaYdsDgWfqb1IrZo0MHg
35rb11P1twX510b5SZnM84Cwki1uOgi3wkyA2fD62qnkIG5bmZVb06kTLAvriHPP
Y3aukyD9aogmu+SrZWaAVYvp0C1WqCKVwzsgP6n2+vj8gSsGR+mFyvhhPar4neOJ
8d71lLl1P3hrmlnHj2q8Kkez+Qng/xw1zM6ymkmr3ZKmUcJStTDaDb9WHltEVMih
AMRrhqBOaN8fEziEvbGX+T3bsIoXhC3GQSSQD2bpfZMHv1GJGYBgW+N/w3GT8tTH
ot0dsObt6wH6oNyT63ITvstFuNc/ArqW+zdWNraeVn55LPqD2PaQr2KX5KYCZ1OX
yQ4X+kCVJW+xLoodO/l2zmC82eItX5TDyNEyDXKLNcdTBEMvzWLvsJCOjgaXG5X1
SCx5Fmd6goRI+j6INm+iSQ45/fndnF6gjp1eu+IhjUSDJTaG4pse+DcOOQ0AwOhC
ziXGoz49wQxHrla6qLHr0soRZd8Kp0FdR2GMwsVqfb+5owZYxti1DNbo8wJeMC37
57LzUdIuj0KBepNvCJ0luhlRSUoyMZux8nfy8GyytPY1SUujrCSjA1ephvWea1MT
shQs+okuXqXBCMCb3ZEzFeCLcLONMyz+d5PPRIiGfjK3xkdL1pDIAYmzPv5shnhm
6ttIcFoTvo0=
=FUPj
-----END PGP SIGNATURE-----

--Sig_/IxzE5f/1+D7J=Vlbl9a0BdV--
