From: Andre Noll <maan@systemlinux.org>
Subject: Re: [patch 1/1][mdadm] Fix needed to enable RAID device creation on SAS devices.
Date: Fri, 13 Nov 2009 20:35:45 +0100
Message-ID: <20091113193545.GW21495@skl-net.de>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPlaimQd/TpiYx8R"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Artur" <artur.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids


--yPlaimQd/TpiYx8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:43, Wojcik, Artur wrote:
> -                               char path[200];
> +                               char path[PATH_MAX];

PATH_MAX might be undefined if we're not using glibc. AFAIK the best
one can do is something like

	#ifdef PATH_MAX
		path_max =3D PATH_MAX;
	#else
		/*
		 * The result of pathconf(3) may be huge and unsuitable for
		 * mallocing memory. OTOH pathconf(3) may return -1 to signify
		 * that PATH_MAX is not bounded.
		 */
		path_max =3D pathconf(name, _PC_PATH_MAX);
		if (path_max <=3D 0 || path_max >=3D 4096)
			path_max =3D 4096;
	#endif


>                                 char vbuf[1024];
>                                 int nlen =3D strlen(sra->sys_name);
>                                 int dn;
>                                 if (de->d_name[0] =3D=3D '.')
>                                         continue;
> -                               sprintf(path, "/sys/block/%s/md/metadata_=
version",
> +                               snprintf(path, PATH_MAX, "/sys/block/%s/m=
d/metadata_version",
>                                         de->d_name);
>                                 if (load_sys(path, vbuf) < 0)
>                                         continue;

If you are really paranoid, you have to terminate the buffer when
using snprintf. Moreover, one should prefer sizeof(path) over the
explicit PATH_MAX because if you ever change the size of path again,
you avoid the risk to change it only in the definition of path but
not in the snprintf() call.

Best
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--yPlaimQd/TpiYx8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFK/bURWto1QDEAkw8RAiHaAJ0ZFx5obtiO510VklcDYXkxBhajwACeKrAh
FcqIVVqwDEagjyTYcY6/UZI=
=Gvqv
-----END PGP SIGNATURE-----

--yPlaimQd/TpiYx8R--
