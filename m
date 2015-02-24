From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/5] Check return of stat() to avoid covscan complaining
Date: Wed, 25 Feb 2015 08:12:43 +1100
Message-ID: <20150225081243.1fe91420@notabene.brown>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
	<1424811640-26569-3-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ANeBo19zFbpiERoVau1eHuK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-3-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ANeBo19zFbpiERoVau1eHuK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Feb 2015 16:00:37 -0500 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  Assemble.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 131f871..b392214 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -688,7 +688,11 @@ static int load_devices(struct devs *devices, char *=
devmap,
>  			close(dfd);
>  		}
> =20
> -		stat(devname, &stb);
> +		if (stat(devname, &stb)) {
> +			pr_err("Unsable to stat(%s) - skipping device.\n",
> +			       devname);
> +			continue;
> +		}
> =20
>  		if (c->verbose > 0)
>  			pr_err("%s is identified as a member of %s, slot %d%s.\n",

I've applied the other 4.  I think I'd rather this one was fixed by changing
  stat(devname,
to
  fstat(dfd,
and keep dfd open a bit longer.

Does this look OK to you?

Thanks,
NeilBrown

diff --git a/Assemble.c b/Assemble.c
index 131f871a6d1e..1e529c1b3126 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -576,13 +576,13 @@ static int load_devices(struct devs *devices, char *d=
evmap,
 		struct stat stb;
 		struct supertype *tst;
 		int i;
+		int dfd;
=20
 		if (tmpdev->used !=3D 1)
 			continue;
 		/* looks like a good enough match to update the super block if needed */
 #ifndef MDASSEMBLE
 		if (c->update) {
-			int dfd;
 			/* prepare useful information in info structures */
 			struct stat stb2;
 			int err;
@@ -652,7 +652,6 @@ static int load_devices(struct devs *devices, char *dev=
map,
 			if (tst->ss->store_super(tst, dfd))
 				pr_err("Could not re-write superblock on %s.\n",
 				       devname);
-			close(dfd);
=20
 			if (strcmp(c->update, "uuid")=3D=3D0 &&
 			    ident->bitmap_fd >=3D 0 && !bitmap_done) {
@@ -666,9 +665,9 @@ static int load_devices(struct devs *devices, char *dev=
map,
 		} else
 #endif
 		{
-			int dfd =3D dev_open(devname,
-					   tmpdev->disposition =3D=3D 'I'
-					   ? O_RDWR : (O_RDWR|O_EXCL));
+			dfd =3D dev_open(devname,
+				       tmpdev->disposition =3D=3D 'I'
+				       ? O_RDWR : (O_RDWR|O_EXCL));
 			tst =3D dup_super(st);
=20
 			if (dfd < 0 || tst->ss->load_super(tst, dfd, NULL) !=3D 0) {
@@ -685,10 +684,10 @@ static int load_devices(struct devs *devices, char *d=
evmap,
 				return -1;
 			}
 			tst->ss->getinfo_super(tst, content, devmap + devcnt * content->array.r=
aid_disks);
-			close(dfd);
 		}
=20
-		stat(devname, &stb);
+		fstat(dfd, &stb);
+		close(dfd);
=20
 		if (c->verbose > 0)
 			pr_err("%s is identified as a member of %s, slot %d%s.\n",

--Sig_/ANeBo19zFbpiERoVau1eHuK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOzpTDnsnt1WYoG5AQIDqQ//VIuFEKmXiJbwccaAdX+e3cbqA7euyM05
KI23RAvM6FkRhOcSL6SbwCVJSxSDdl7POR2b1vgcpt3+J4HE3ilSrvxSZiBh7daA
e1B5HafzsT0kODp6HjLbQtQO4AH1InnsONLklY0j0MI8DGaov8GDw9gPb0reoKE6
seTwbuKEVRQnJ7Xr3BVRENGz8aK7ka0LTyX9WFKnUvcsBcWm+v57hxo5fTYr4N4A
eRntZS67YD50JlKKbS98XakbRWwTYZQ72NGP107cR2oB82VI2nEZ9k1i6R6iLiN6
PWmpxembiMfQrMPx3JOZFpU/Lke6SPr2v27osI4bMdUMRWaRVTMabU9J8WButObp
5C7mifayff4HTQAaJhF4Mr2AAgkwFNvWoVz6IrMitQBvyY9rlmXT94fTMdWnmqRo
VENw0E2R4+Mjv4dpmUov0mldYJvn7s08vhcBPlI8KaIZaq0ig3ld+8qerx0S3l3O
dC1wK7vNmBEXwEulSReL/hd9vyELB0h5ZlOvccFqbQRxBHC7RdVbb7+clntXlFFb
W0CwFCep1xi1mJWoy4DM/JknU3PejiAigFOokjViGJBgQ5LvznzH75Y6JN8dTM1y
s8/Rp930zatVt1NycQCv7jpBnu8gkQwgwAh5lLMc+f4vLldQ2jWIvtqrt5Lx1uLq
GnQRPg8RsHc=
=lbd4
-----END PGP SIGNATURE-----

--Sig_/ANeBo19zFbpiERoVau1eHuK--
