From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/4] mdadm:triggers core dump when stat2devnm return NULL
Date: Mon, 13 Mar 2017 10:00:23 +1100
Message-ID: <8760jef6d4.fsf@notabene.neil.brown.name>
References: <20170308074831.24683-1-zlliu@suse.com> <20170308075221.24965-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308075221.24965-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08 2017, Zhilong Liu wrote:

> ensure that the device should be a block device when uses
> --wait parameter, such as the 'f' and 'd' type file would
> be triggered core dumped.
> ./mdadm --wait /dev/md/, happened core dump.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>
> diff --git a/Monitor.c b/Monitor.c
> index 802a9d9..1900db3 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -1002,6 +1002,10 @@ int Wait(char *dev)
>  			strerror(errno));
>  		return 2;
>  	}
> +	if ((S_IFMT & stb.st_mode) !=3D S_IFBLK) {
> +		pr_err("%s is not a block device.\n", dev);
> +		return 2;
> +	}
>  	strcpy(devnm, stat2devnm(&stb));

Surely it would be cleaner to do something like:

  tmp =3D stat2devnm(&stb);
  if (!tmp) {
      pr_err("%s is not a block device.\n", dev);
      return 2;
  }
  strcpy(devnm, tmp);

This makes it more obvious how you have fixed the crash.

>=20=20
>  	while(1) {
> diff --git a/lib.c b/lib.c
> index b640634..7116298 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -89,9 +89,6 @@ char *devid2kname(int devid)
>=20=20
>  char *stat2kname(struct stat *st)
>  {
> -	if ((S_IFMT & st->st_mode) !=3D S_IFBLK)
> -		return NULL;
> -
>  	return devid2kname(st->st_rdev);
>  }

Why are you removing this test?  It has nothing to do with the other
part of the patch.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljF0wcACgkQOeye3VZi
gblkdRAAuMPFr6pLZOULN0RIF6wSOC+1uhLXZwzs0QG52LCngqacZqbFa2uMA+vy
+WRR2ArDwLXP/Grffo3dZtXurvH8RApl3TjpXYLWB8rgghZteFxLuKwx2X1M/W1H
crSH4cw6Uu8kcz8ZArKTWZdd0kOiF14xK4JL0+45biKEY7OrnJhn4emR7qWLVyDo
C9PMwpJrnLERxkY3Ua0wLQUGajUFQAiNuP3iQw3r63TnC4amx5AtP85GM+QeQnQv
VxRx7sbVxC8VxP9WUmZKHdT/YRsZG/AeD4uLINXg1N6lDyAfmILNroahvcNXYisW
tZZbk0J/OzKg9KWRj8WPtg0/5fSPXSzgTfBpIB8RbDeT1n6V0ITPY7PCAzbg6rxK
qpai+4WFQTVoyqyu7tkTZYRFURxYCmhut1JfTDkCphHCMiVUrsrG+RSRJYRBdJ+7
VyoCvw6E6m1KogAtDecNoABIs7fzqEIAVwH4XRLWERlPU29YNYJWN7lOT33tpnwd
w3t8igznaQQbXX2qG1jbXjBWOyw5nRM5Hwkzu6jHnOPWmEc752/aNjBFlaipEdqL
i5Hdb+nH5OUTyOf70b0fMMtTMUlXYwAbSesyqnL8xI18be+wgj27qBfXhaU/B4WF
iN2xqApVeqa7ba4845yGiuEb5iJkqG+vicdeG77IcFicNrbSGpM=
=bx/q
-----END PGP SIGNATURE-----
--=-=-=--
