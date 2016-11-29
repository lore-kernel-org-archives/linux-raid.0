From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Introduce enum flag_mode for setting and clearing flags.
Date: Wed, 30 Nov 2016 09:02:11 +1100
Message-ID: <877f7m7xng.fsf@notabene.neil.brown.name>
References: <147944614789.3302.1959091446949640579.stgit@noble> <20161122020238.qtuxwo5etcwmts4r@kernel.org> <87polka0vu.fsf@notabene.neil.brown.name> <wrfjfumbpv7f.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjfumbpv7f.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


We currently use '1' to indicate that a flag (writemostly or failfast)
needs to be set, and '2' to indicate that it needs to be cleared.

Using magic number like this is not a best-practice.

So replaced them with values from a enum.

No functional change.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Ask, and you shall receive :-)

NeilBrown

 Build.c       |  2 +-
 Create.c      |  4 ++--
 Incremental.c |  4 ++--
 Manage.c      | 32 ++++++++++++++++----------------
 mdadm.c       | 12 ++++++------
 mdadm.h       |  8 ++++++--
 6 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/Build.c b/Build.c
index 8603c710aea2..74a440e78965 100644
=2D-- a/Build.c
+++ b/Build.c
@@ -192,7 +192,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 			disk.number =3D i;
 			disk.raid_disk =3D i;
 			disk.state =3D (1<<MD_DISK_SYNC) | (1<<MD_DISK_ACTIVE);
=2D			if (dv->writemostly =3D=3D 1)
+			if (dv->writemostly =3D=3D FlagSet)
 				disk.state |=3D 1<<MD_DISK_WRITEMOSTLY;
 			disk.major =3D major(stb.st_rdev);
 			disk.minor =3D minor(stb.st_rdev);
diff --git a/Create.c b/Create.c
index bd114eabafc1..2721884efabc 100644
=2D-- a/Create.c
+++ b/Create.c
@@ -888,9 +888,9 @@ int Create(struct supertype *st, char *mddev,
 				else
 					inf->disk.state =3D 0;
=20
=2D				if (dv->writemostly =3D=3D 1)
+				if (dv->writemostly =3D=3D FlagSet)
 					inf->disk.state |=3D (1<<MD_DISK_WRITEMOSTLY);
=2D				if (dv->failfast =3D=3D 1)
+				if (dv->failfast =3D=3D FlagSet)
 					inf->disk.state |=3D (1<<MD_DISK_FAILFAST);
=20
 				if (have_container)
diff --git a/Incremental.c b/Incremental.c
index 75d95ccc497a..0f507bb32c9e 100644
=2D-- a/Incremental.c
+++ b/Incremental.c
@@ -1034,8 +1034,8 @@ static int array_try_spare(char *devname, int *dfdp, =
struct dev_policy *pol,
 			char chosen_devname[24]; // 2*11 for int (including signs) + colon + nu=
ll
 			devlist.next =3D NULL;
 			devlist.used =3D 0;
=2D			devlist.writemostly =3D 0;
=2D			devlist.failfast =3D 0;
+			devlist.writemostly =3D FlagDefault;
+			devlist.failfast =3D FlagDefault;
 			devlist.devname =3D chosen_devname;
 			sprintf(chosen_devname, "%d:%d", major(stb.st_rdev),
 				minor(stb.st_rdev));
diff --git a/Manage.c b/Manage.c
index 429d8631cd23..5c3d2b9b1a9f 100644
=2D-- a/Manage.c
+++ b/Manage.c
@@ -679,17 +679,17 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev =
*dv,
 			else
 				disc.state |=3D (1 << MD_DISK_CLUSTER_ADD);
 		}
=2D		if (dv->writemostly =3D=3D 1)
+		if (dv->writemostly =3D=3D FlagSet)
 			disc.state |=3D 1 << MD_DISK_WRITEMOSTLY;
=2D		if (dv->writemostly =3D=3D 2)
+		if (dv->writemostly =3D=3D FlagClear)
 			disc.state &=3D ~(1 << MD_DISK_WRITEMOSTLY);
=2D		if (dv->failfast =3D=3D 1)
+		if (dv->failfast =3D=3D FlagSet)
 			disc.state |=3D 1 << MD_DISK_FAILFAST;
=2D		if (dv->failfast =3D=3D 2)
+		if (dv->failfast =3D=3D FlagClear)
 			disc.state &=3D ~(1 << MD_DISK_FAILFAST);
 		remove_partitions(tfd);
=2D		if (update || dv->writemostly > 0
=2D			|| dv->failfast > 0) {
+		if (update || dv->writemostly !=3D FlagDefault
+			|| dv->failfast !=3D FlagDefault) {
 			int rv =3D -1;
 			tfd =3D dev_open(dv->devname, O_RDWR);
 			if (tfd < 0) {
@@ -697,19 +697,19 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev =
*dv,
 				return -1;
 			}
=20
=2D			if (dv->writemostly =3D=3D 1)
+			if (dv->writemostly =3D=3D FlagSet)
 				rv =3D dev_st->ss->update_super(
 					dev_st, NULL, "writemostly",
 					devname, verbose, 0, NULL);
=2D			if (dv->writemostly =3D=3D 2)
+			if (dv->writemostly =3D=3D FlagClear)
 				rv =3D dev_st->ss->update_super(
 					dev_st, NULL, "readwrite",
 					devname, verbose, 0, NULL);
=2D			if (dv->failfast =3D=3D 1)
+			if (dv->failfast =3D=3D FlagSet)
 				rv =3D dev_st->ss->update_super(
 					dev_st, NULL, "failfast",
 					devname, verbose, 0, NULL);
=2D			if (dv->failfast =3D=3D 2)
+			if (dv->failfast =3D=3D FlagClear)
 				rv =3D dev_st->ss->update_super(
 					dev_st, NULL, "nofailfast",
 					devname, verbose, 0, NULL);
@@ -975,9 +975,9 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		int dfd;
 		if (dv->disposition =3D=3D 'j')
 			disc.state |=3D (1 << MD_DISK_JOURNAL) | (1 << MD_DISK_SYNC);
=2D		if (dv->writemostly =3D=3D 1)
+		if (dv->writemostly =3D=3D FlagSet)
 			disc.state |=3D 1 << MD_DISK_WRITEMOSTLY;
=2D		if (dv->failfast =3D=3D 1)
+		if (dv->failfast =3D=3D FlagSet)
 			disc.state |=3D 1 << MD_DISK_FAILFAST;
 		dfd =3D dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
 		if (tst->ss->add_to_super(tst, &disc, dfd,
@@ -1022,9 +1022,9 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			disc.state |=3D (1 << MD_DISK_CLUSTER_ADD);
 	}
=20
=2D	if (dv->writemostly =3D=3D 1)
+	if (dv->writemostly =3D=3D FlagSet)
 		disc.state |=3D (1 << MD_DISK_WRITEMOSTLY);
=2D	if (dv->failfast =3D=3D 1)
+	if (dv->failfast =3D=3D FlagSet)
 		disc.state |=3D (1 << MD_DISK_FAILFAST);
 	if (tst->ss->external) {
 		/* add a disk
@@ -1801,8 +1801,8 @@ int move_spare(char *from_devname, char *to_devname, =
dev_t devid)
=20
 	devlist.next =3D NULL;
 	devlist.used =3D 0;
=2D	devlist.writemostly =3D 0;
=2D	devlist.failfast =3D 0;
+	devlist.writemostly =3D FlagDefault;
+	devlist.failfast =3D FlagDefault;
 	devlist.devname =3D devname;
 	sprintf(devname, "%d:%d", major(devid), minor(devid));
=20
diff --git a/mdadm.c b/mdadm.c
index 3c8f273c8254..c3a265b80947 100644
=2D-- a/mdadm.c
+++ b/mdadm.c
@@ -89,8 +89,8 @@ int main(int argc, char *argv[])
 	int oneshot =3D 0;
 	int spare_sharing =3D 1;
 	struct supertype *ss =3D NULL;
=2D	int writemostly =3D 0;
=2D	int failfast =3D 0;
+	enum flag_mode writemostly =3D FlagDefault;
+	enum flag_mode failfast =3D FlagDefault;
 	char *shortopt =3D short_options;
 	int dosyslog =3D 0;
 	int rebuild_map =3D 0;
@@ -412,20 +412,20 @@ int main(int argc, char *argv[])
 		case O(CREATE,'W'):
 		case O(CREATE,WriteMostly):
 			/* set write-mostly for following devices */
=2D			writemostly =3D 1;
+			writemostly =3D FlagSet;
 			continue;
=20
 		case O(MANAGE,'w'):
 			/* clear write-mostly for following devices */
=2D			writemostly =3D 2;
+			writemostly =3D FlagClear;
 			continue;
=20
 		case O(MANAGE,FailFast):
 		case O(CREATE,FailFast):
=2D			failfast =3D 1;
+			failfast =3D FlagSet;
 			continue;
 		case O(MANAGE,NoFailFast):
=2D			failfast =3D 2;
+			failfast =3D FlagClear;
 			continue;
=20
 		case O(GROW,'z'):
diff --git a/mdadm.h b/mdadm.h
index d47de01f725b..a85b5ad8149d 100644
=2D-- a/mdadm.h
+++ b/mdadm.h
@@ -424,6 +424,10 @@ enum bitmap_update {
     NodeNumUpdate,
 };
=20
+enum flag_mode {
+	FlagDefault, FlagSet, FlagClear,
+};
+
 /* structures read from config file */
 /* List of mddevice names and identifiers
  * Identifiers can be:
@@ -517,8 +521,8 @@ struct mddev_dev {
 				 * 'A' for re_add.
 				 * Not set for names read from .config
 				 */
=2D	char writemostly;	/* 1 for 'set writemostly', 2 for 'clear writemostly'=
 */
=2D	char failfast;		/* Ditto but for 'failfast' flag */
+	enum flag_mode writemostly;
+	enum flag_mode failfast;
 	int used;		/* set when used */
 	long long data_offset;
 	struct mddev_dev *next;
=2D-=20
2.10.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlg9+uMACgkQOeye3VZi
gbnNgg/+Lw/l4WhISUFV4nxlgHfoJS7Q7VF7n3fNYxZYo0kDvzSoeEqOISF47DTP
v3yVSI3bl+Wosa7HuT4fbUw0f7CxL5zcnknXqv/Baq/LKOBSbrEWTZ/jBLNtP0CU
/aQ95qfryrj5EG2WlgRo8Y7y7WW5SumvpwYrebSCdTXykXAadMXMUI5Yhe2WgoDl
LE97R9xsA1PYyTOHu87IDjlW93i5Kpzdy9qSWuqrP7y5UQytQLvLXi8Z214+lB2d
UdxHwPOHyMnD4v/Xnh/nQhY5WGcb9IKbP6mNlhSoflyTIzUNXESxTOoLq8/QVcf8
EZsMq7vDb3fYA7ytuYt/fFaE9mx+zTEUjSC+h+xc3WjCzd0RGg0zBVXa5B9xjbUh
whh6vNWg3c0kYuffy/jgosqJBeShX8yGproz0w0gtNsC2jXmTUXAe4RbTq2UEdsk
RFIcPqqWOIjYwbrH23Ac5MgxlrCkoPwCdv4dDhSr4M7nMoNze1V/rt1WvaDbS9OR
L3zXAO3xyv+rf3DSSB5oI7NsVqr861mGA9cBuB7wUGyvHE46s4zv/hCtxBgJzx9U
dQABiNQ4l8LTtEkWvkMiuKZR+eCcGKw6bQYnnLHABOhoKBlrAH9qyKegrOgOSFYg
eOHI3zPnhUlrjb4hIxnDNU9JyuvNe1426FAXD7rDftTgsfjvU40=
=dyRn
-----END PGP SIGNATURE-----
--=-=-=--
