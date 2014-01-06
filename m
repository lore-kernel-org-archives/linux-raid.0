From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] policy: NULL path isn't really acceptable - use the
 devname
Date: Mon, 6 Jan 2014 17:12:07 +1100
Message-ID: <20140106171207.2a7b83cc@notabene.brown>
References: <20131219120212.16976.96892.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IL/kYgB+v+1mjH5gv3uRofQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131219120212.16976.96892.stgit@gklab-154-244.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/IL/kYgB+v+1mjH5gv3uRofQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Dec 2013 13:02:12 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> According to:
> 	commit b451aa4846c5ccca5447a6b6d45e5623b8c8e961
> 	Fix handling for "auto" line in mdadm.conf
>=20
> a NULL path isn't really acceptable and the devname should be used instea=
d.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  policy.c |   35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
>=20
> diff --git a/policy.c b/policy.c
> index b4f3943..104695d 100644
> --- a/policy.c
> +++ b/policy.c
> @@ -200,26 +200,25 @@ static char *disk_path(struct mdinfo *disk)
>  	int rv;
> =20
>  	by_path =3D opendir(symlink);
> -	if (!by_path)
> -		return NULL;
> -	prefix_len =3D strlen(symlink);
> -
> -	while ((ent =3D readdir(by_path)) !=3D NULL) {
> -		if (ent->d_type !=3D DT_LNK)
> -			continue;
> -		strncpy(symlink + prefix_len,
> -			ent->d_name,
> -			sizeof(symlink) - prefix_len);
> -		if (stat(symlink, &stb) < 0)
> -			continue;
> -		if ((stb.st_mode & S_IFMT) !=3D S_IFBLK)
> -			continue;
> -		if (stb.st_rdev !=3D makedev(disk->disk.major, disk->disk.minor))
> -			continue;
> +	if (by_path) {
> +		prefix_len =3D strlen(symlink);
> +		while ((ent =3D readdir(by_path)) !=3D NULL) {
> +			if (ent->d_type !=3D DT_LNK)
> +				continue;
> +			strncpy(symlink + prefix_len,
> +					ent->d_name,
> +					sizeof(symlink) - prefix_len);
> +			if (stat(symlink, &stb) < 0)
> +				continue;
> +			if ((stb.st_mode & S_IFMT) !=3D S_IFBLK)
> +				continue;
> +			if (stb.st_rdev !=3D makedev(disk->disk.major, disk->disk.minor))
> +				continue;
> +			closedir(by_path);
> +			return xstrdup(ent->d_name);
> +		}
>  		closedir(by_path);
> -		return xstrdup(ent->d_name);
>  	}
> -	closedir(by_path);
>  	/* A NULL path isn't really acceptable - use the devname.. */
>  	sprintf(symlink, "/sys/dev/block/%d:%d", disk->disk.major, disk->disk.m=
inor);
>  	rv =3D readlink(symlink, nm, sizeof(nm)-1);


Applied, thanks.

NeilBrown

--Sig_/IL/kYgB+v+1mjH5gv3uRofQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUspJNznsnt1WYoG5AQITTg/+NXM+zP38JiaUCK2S3vrFMz6rvE2rK1ih
Sn6QpaGDGy/KuVY009kY+RePMpz8yk/dkJWsYO6SPavjAC20i/65DTe/UP0Aabvg
5LTWmd0XNlzJM14zMVpWSG3QLT7zAUwQOr7HsF+1ria8ec8jk9FGYWpEPikZ/NuA
P1r/JiqjaRQAafN/VqhKrfnZqwZNNIHnoXLul1SfFcmIdil8pJmkZYG+W/98B9Ao
W3C0MlDunJmoeE9anD7VjhtjMM37HS5jPNSS4npGcGsLmxt9/vDOTC3DofqNxGWN
K8MVlstaiLGb6Io/bKdRkB6loDbuWkcWU1VH9lNzCdMqzTMuL4sVnYme2x5MM6f/
rT9D1Y/JefPnUkMxasehBzl+qtdmv4FEBGbVY4lYjIfC5kujNl27GelyE3tIdoS2
rF7q6NR67/rTY8QihjiBuxOkptiPfmTtUKrevZjNFIxw6ROagWmH4g850k3PjyIg
67xB2iiQEt9DfgF4HnjX1t+n69KnLGste0ypIAosiCpvDXBuYjhBSuDWhpO9Mub4
aDjTJwHCp7qJYiJmQDq+17PMa0jzbKGy7pghRTgMm/AfSC7G8Vi/aBxYVjsU58Bi
SwYTeJx4RA1vLcHu/bUDNlNGGJEtABqWdxMEk0w27IpfuYH/Xq1SL6JmaRux/TxG
3YAcucRUOgY=
=IeHX
-----END PGP SIGNATURE-----

--Sig_/IL/kYgB+v+1mjH5gv3uRofQ--
