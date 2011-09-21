From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fixed: Part of output missing during RAID creation
Date: Wed, 21 Sep 2011 14:40:14 +1000
Message-ID: <20110921144014.4f2aa20f@notabene.brown>
References: <20110920151841.25886.80030.stgit@gklab-128-192.igk.intel.com>
	<20110920152127.25886.75665.stgit@gklab-128-192.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SrM+du3TX3Za_L5dNiGJN3K"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110920152127.25886.75665.stgit@gklab-128-192.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Orlowski <lukasz.orlowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SrM+du3TX3Za_L5dNiGJN3K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Sep 2011 17:21:27 +0200 Lukasz Orlowski
<lukasz.orlowski@intel.com> wrote:

> Having a container created consisting of 2 disks, when one tried to create
> two volumes of the same RAID level, after attempt of creating the second
> one, part of the message was missing:
>=20
> #mdadm -C /dev/md/imsm0 -amd -e imsm -n 2 /dev/sda /dev/sdb -R
> #mdadm -C /dev/md/MyVolume1 -amd -l0 -c128 -n 2 /dev/sda /dev/sdb -R
> #mdadm -C /dev/md/MyVolume2 -amd -l0 -c128 -n 2 /dev/sda /dev/sdb -R
>=20
> After calling the last command, the output was:
> mdadm: create aborted
>=20
> Now it's:
> mdadm: device /dev/sdb not suitable for this style of array
> mdadm: create aborted
>=20
> Removed a piece of code attempting to exclusively open a file just to
> check whether it's possible. The reason is that that check was performed
> when it was already determined that a volume cannot be created. Put
> a prompt about the device not being suitable instead.
>=20
> Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>
> ---
>  Create.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index baadd9f..b5d35e8 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -349,14 +349,10 @@ int Create(struct supertype *st, char *mddev,
>  			}
> =20
>  			if (!st) {
> -				int dfd =3D open(dname, O_RDONLY|O_EXCL);
> -				if (dfd >=3D 0) {
> -					fprintf(stderr,
> -						Name ": device %s not suitable"
> -						" for any style of array\n",
> -						dname);
> -					close(dfd);
> -				}
> +				fprintf(stderr,
> +					Name ": device %s not suitable"
> +					" for this style of array\n",
> +					dname);
>  				fail =3D 1;
>  				break;
>  			}
>=20

I think I get what you are trying to do here, but I don't like the approach.
The problem is that validate_geometry should be reporting errors but it is
told not to.

I have just committed the following patch.  See if it helps.

NeilBrown


=46rom ecbd9e8160e9de9cc28ad869d303506b1dc69715 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 21 Sep 2011 14:39:01 +1000
Subject: [PATCH] Create: improve messages from validate_geometry.

When validate_geometry finds that we haven't committed to
a metadata yet and that the subdev is a member of 'our'
container, it needs to report any errors it finds as Create()
cannot report them effectively.

So make a slight change to the semantics of the 'verbose' flag
and allow validate_geometry to report if it printed any error
messages.

Signed-off-by: NeilBrown  <neilb@suse.de>

diff --git a/Create.c b/Create.c
index 8d88aa1..79564c5 100644
--- a/Create.c
+++ b/Create.c
@@ -332,15 +332,25 @@ int Create(struct supertype *st, char *mddev,
 			char *name =3D "default";
 			for(i=3D0; !st && superlist[i]; i++) {
 				st =3D superlist[i]->match_metadata_desc(name);
+				if (!st)
+					continue;
 				if (do_default_layout)
 					layout =3D default_layout(st, level, verbose);
-				if (st && !st->ss->validate_geometry
-					    	(st, level, layout, raiddisks,
-						 &chunk, size*2, dname, &freesize,
-						 verbose > 0)) {
+				switch (st->ss->validate_geometry(
+						st, level, layout, raiddisks,
+						&chunk, size*2, dname, &freesize,
+						verbose > 0)) {
+				case -1: /* Not valid, message printed, and not
+					  * worth checking any further */
+					exit(2);
+					break;
+				case 0: /* Geometry not valid */
 					free(st);
 					st =3D NULL;
 					chunk =3D do_default_chunk ? UnSet : chunk;
+					break;
+				case 1:	/* All happy */
+					break;
 				}
 			}
=20
diff --git a/mdadm.h b/mdadm.h
index bd3063b..8dd37d9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -702,6 +702,12 @@ extern struct superswitch {
 	 * inter-device dependencies, it should record sufficient details
 	 * so these can be validated.
 	 * Both 'size' and '*freesize' are in sectors.  chunk is KiB.
+	 * Return value is:
+	 *  1: everything is OK
+	 *  0: not OK for some reason - if 'verbose', then error was reported.
+	 * -1: st->sb was NULL, 'subdev' is a member of a container of this
+	 *     types, but array is not acceptable for some reason
+	 *     message was reported even if verbose is 0.
 	 */
 	int (*validate_geometry)(struct supertype *st, int level, int layout,
 				 int raiddisks,
diff --git a/super-intel.c b/super-intel.c
index e57d18f..e9d9af8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5369,7 +5369,8 @@ static int validate_geometry_imsm(struct supertype *s=
t, int level, int layout,
 			return validate_geometry_imsm_volume(st, level, layout,
 							     raiddisks, chunk,
 							     size, dev,
-							     freesize, verbose);
+							     freesize, 1)
+				? 1 : -1;
 		}
 	}
=20


--Sig_/SrM+du3TX3Za_L5dNiGJN3K
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeWquG5fc6gV+Wb0RAjTKAKDKMf88Pcp1GZzzJez2gT4nsNsAiwCgwPig
SE7FL/AJ2oerj3tho7hGyJo=
=I+gj
-----END PGP SIGNATURE-----

--Sig_/SrM+du3TX3Za_L5dNiGJN3K--
