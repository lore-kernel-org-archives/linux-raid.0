From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow.c: change size to be unsigned and use '0' in case
 of 'no change'
Date: Mon, 13 Aug 2012 08:07:23 +1000
Message-ID: <20120813080723.4de82932@notabene.brown>
References: <20120810140634.13510.1639.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FepmJKbl/LTCV2OB8gOX0SF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120810140634.13510.1639.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

--Sig_/FepmJKbl/LTCV2OB8gOX0SF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Aug 2012 16:06:34 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> The 'size' has been changed to be unsigned recently.
> Analogous changes should be made to reshape_super().
> '0' should be used in case of 'no change' now.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Grow.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index d13b7f3..f1ce284 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -639,8 +639,8 @@ static void wait_reshape(struct mdinfo *sra)
>  	close(fd);
>  }
> =20
> -static int reshape_super(struct supertype *st, long long size, int level,
> -			 int layout, int chunksize, int raid_disks,
> +static int reshape_super(struct supertype *st, unsigned long long size,
> +			 int level, int layout, int chunksize, int raid_disks,
>  			 int delta_disks, char *backup_file, char *dev,
>  			 int direction, int verbose)
>  {
> @@ -1987,7 +1987,7 @@ size_change_error:
>  		/* Impose these changes on a single array.  First
>  		 * check that the metadata is OK with the change. */
> =20
> -		if (reshape_super(st, -1, info.new_level,
> +		if (reshape_super(st, 0, info.new_level,
>  				  info.new_layout, info.new_chunk,
>  				  info.array.raid_disks, info.delta_disks,
>  				  c->backup_file, devname, APPLY_METADATA_CHANGES,
> @@ -2672,10 +2672,10 @@ int reshape_container(char *container, char *devn=
ame,
>  	int last_devnum =3D -1;
> =20
>  	/* component_size is not meaningful for a container,
> -	 * so pass '-1' meaning 'no change'
> +	 * so pass '0' meaning 'no change'
>  	 */
>  	if (!restart &&
> -	    reshape_super(st, -1, info->new_level,
> +	    reshape_super(st, 0, info->new_level,
>  			  info->new_layout, info->new_chunk,
>  			  info->array.raid_disks, info->delta_disks,
>  			  backup_file, devname, APPLY_METADATA_CHANGES,


Applied - thanks (and sorry for the delay).

NeilBrown

--Sig_/FepmJKbl/LTCV2OB8gOX0SF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCgpHDnsnt1WYoG5AQIe0BAAnAEiPt7Vh5N7+KyZwJs1wOaiL/zyZLuG
82sUdWbfFiFcXgE1g3Mrfbx125S2c2Ymy6LhQCHT8R57bctQn++9YsaJJNUSIhpZ
Abl6F1NJUWV90exMXyBwv/oyGyLbwCtouyYfPuJMWf3TzmnmTGW8zgzk9VILtn6K
978ijsdjfi61bGKiIvMH7IVOO4prKdYyHFAfALpJmEmYT3FT01c9jnwu3cRMkczn
IbcxK8cYkFjMw/qeNS6AjCaG6f02vpiDwGIcvKT+zvtU8VYwGvzd3xNvA0E+ThG5
8GbRMV1EIxkl+WOW6/MCdDIx9w6nTcAhXzGA+yNLU0bcYQzsyB48oMhe9TSzX1/M
nsTcxB6QeS6s7w0uCNXQSUVZx8jfpXvhNZTYAfSEJ4JJsIEi6Erq5KXcNyV5d03a
VLdW9gECt5gld8WuOrfU398MyOnpanFtj/1GfPVlpAYhnPRB4YKJ9GnigG+2Jxa7
4uUgHm4DubiOpqlqoCrLK1XgbOxlH2fJZIvwooE36NfzGASyUOemlpb7AvLg+9wZ
27Zc+Qo/MpFJnFVFCoQpnXH9oWWiBkzvA2BM3QOyPnWNsmr1qbn2GKvzMyUpDnBZ
Nkwsg4HKfgDw1jG6qHDGUF2het2lVJ0i8wRWOsUnPEtl/7FTe99re865eIUWLAxl
oiAKo2JNZBc=
=dhj2
-----END PGP SIGNATURE-----

--Sig_/FepmJKbl/LTCV2OB8gOX0SF--
