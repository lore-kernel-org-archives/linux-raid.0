From: NeilBrown <neilb@suse.com>
Subject: [PATCH - mdadm] examine: tidy up some code.
Date: Fri, 03 Mar 2017 10:57:00 +1100
Message-ID: <878tonnsfn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Michael Shigorin <mike@altlinux.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Michael Shigorin reports that the 'lcc' compiler isn't able
to deduce that 'st' must be initialized in

		if (c->SparcAdjust)
			st->ss->update_super(st, NULL, "sparc2.2",

just because the only times it isn't initialised, 'err' is set non-zero.

This results in a 'possibly uninitialised' warning.
While there is no bug in the code, this does suggest that maybe
the code could be made more obviously correct.

So this patch:
 1/ moves the "err" variable inside the for loop, so an error in
    one device doesn't stop the other devices from being processed
 2/ calls 'continue' early if the device cannot be opened, so that
    a level of indent can be removed, and so that it is clear that
    'st' is always initialised before being used
 3/ frees 'st' if an error occured in load_super or load_container.

Reported-by: Michael Shigorin <mike@altlinux.org>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 Examine.c | 75 +++++++++++++++++++++++++++++++++--------------------------=
----
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/Examine.c b/Examine.c
index 953b8eee2360..7013480d6dd8 100644
=2D-- a/Examine.c
+++ b/Examine.c
@@ -53,7 +53,6 @@ int Examine(struct mddev_dev *devlist,
 	 */
 	int fd;
 	int rv =3D 0;
=2D	int err =3D 0;
=20
 	struct array {
 		struct supertype *st;
@@ -66,6 +65,8 @@ int Examine(struct mddev_dev *devlist,
 	for (; devlist ; devlist =3D devlist->next) {
 		struct supertype *st;
 		int have_container =3D 0;
+		int err =3D 0;
+		int container =3D 0;
=20
 		fd =3D dev_open(devlist->devname, O_RDONLY);
 		if (fd < 0) {
@@ -74,44 +75,46 @@ int Examine(struct mddev_dev *devlist,
 				       devlist->devname, strerror(errno));
 				rv =3D 1;
 			}
=2D			err =3D 1;
+			continue;
 		}
=2D		else {
=2D			int container =3D 0;
=2D			if (forcest)
=2D				st =3D dup_super(forcest);
=2D			else if (must_be_container(fd)) {
=2D				/* might be a container */
=2D				st =3D super_by_fd(fd, NULL);
=2D				container =3D 1;
=2D			} else
=2D				st =3D guess_super(fd);
=2D			if (st) {
=2D				err =3D 1;
=2D				st->ignore_hw_compat =3D 1;
=2D				if (!container)
=2D					err =3D st->ss->load_super(st, fd,
=2D								 (c->brief||c->scan) ? NULL
=2D								 :devlist->devname);
=2D				if (err && st->ss->load_container) {
=2D					err =3D st->ss->load_container(st, fd,
=2D								 (c->brief||c->scan) ? NULL
=2D								 :devlist->devname);
=2D					if (!err)
=2D						have_container =3D 1;
=2D				}
=2D				st->ignore_hw_compat =3D 0;
=2D			} else {
=2D				if (!c->brief) {
=2D					pr_err("No md superblock detected on %s.\n", devlist->devname);
=2D					rv =3D 1;
=2D				}
=2D				err =3D 1;
+
+		if (forcest)
+			st =3D dup_super(forcest);
+		else if (must_be_container(fd)) {
+			/* might be a container */
+			st =3D super_by_fd(fd, NULL);
+			container =3D 1;
+		} else
+			st =3D guess_super(fd);
+		if (st) {
+			err =3D 1;
+			st->ignore_hw_compat =3D 1;
+			if (!container)
+				err =3D st->ss->load_super(st, fd,
+							 (c->brief||c->scan) ? NULL
+							 :devlist->devname);
+			if (err && st->ss->load_container) {
+				err =3D st->ss->load_container(st, fd,
+							     (c->brief||c->scan) ? NULL
+							     :devlist->devname);
+				if (!err)
+					have_container =3D 1;
 			}
=2D			close(fd);
+			st->ignore_hw_compat =3D 0;
+		} else {
+			if (!c->brief) {
+				pr_err("No md superblock detected on %s.\n", devlist->devname);
+				rv =3D 1;
+			}
+			err =3D 1;
 		}
=2D		if (err)
+		close(fd);
+
+		if (err) {
+			if (st)
+				st->ss->free_super(st);
 			continue;
+		}
=20
 		if (c->SparcAdjust)
 			st->ss->update_super(st, NULL, "sparc2.2",
@@ -121,7 +124,7 @@ int Examine(struct mddev_dev *devlist,
 		if (c->brief && st->ss->brief_examine_super =3D=3D NULL) {
 			if (!c->scan)
 				pr_err("No brief listing for %s on %s\n",
=2D					st->ss->name, devlist->devname);
+				       st->ss->name, devlist->devname);
 		} else if (c->brief) {
 			struct array *ap;
 			char *d;
=2D-=20
2.11.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli4sUwACgkQOeye3VZi
gbmBFA/9FjabLziLs1JZNAXg3ud9FOxE6opzmA7Gi5JZSBChSchX0WjcLHd97ylA
rG93hd5pkei1IT5EdkZHMgTh8OATDd88xqFhglkRn70UagLNRRhvKuQS0p/YQrhR
slqMUbtsq/Bx+ZSGzQnz8ltXRWLbB+vQxQJZTAU/tlLGAOnU97rxiom2oFXi0oYk
QA8pE8n5AkjlXujN4DSN+jIpdnlb2eokr4p2i5wQAWaPoV8ONzn5ez7OegFz4S0l
A/UPjIuLd3hBOWDpiZAdn92p3pgSYAjGwJvlwxHFQ2JcHtCLbZzAI2umLC9SVViu
FMrVCGgSHZYC67r7uj/l9Ag//68vz1WOMIGTb51GS8hXC9HGIshi1Oq+1P2EwdTd
zMnujkV/r4fJQKF/a/byM1PpXg0luw7dNsFgw/rLguelQep/fR72B8Gj9wYTKnNM
2F3dOyev03jFFzawghAi1TEFMkrxW8GKh4CLDVrYd6RzV7w+jcU8RWg5DRall5dh
Q8MZj4nfVSScM4CUD+ltj4SZ45nJVSq9HmJW31csM9O0btP+GCmKJO6TAlqyg5z+
tzldNhy7u+aIumNCdPx7cv28BwgUnjHWzu1coIjkDo8fY6Q6BQ3qBO1U3dKj1ED7
cApCb242pVxwCqkD0yoElNfkFqJmCBxBkI7Nxa0mX44UvVgyxj4=
=Dkvt
-----END PGP SIGNATURE-----
--=-=-=--
