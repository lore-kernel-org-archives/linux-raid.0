From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm] Clean up the directory mess
Date: Fri, 02 Apr 2010 10:56:43 -0400
Message-ID: <4BB605AB.9080207@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig005EE7140D17FEF8D278D95C"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig005EE7140D17FEF8D278D95C
Content-Type: multipart/mixed;
 boundary="------------000709040006020201080709"

This is a multi-part message in MIME format.
--------------000709040006020201080709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The confusion over directories in mdadm/mdmon is a nightmare.  Clean it
up some and leave it to distributions to pick a suitable directory for
use and the stick with it.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------000709040006020201080709
Content-Type: text/plain;
 name="mdadm-directory.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-directory.patch"

commit df3e08eaa7ee07528968bb7152dfaaeebd3c97cb
Author: Doug Ledford <dledford@redhat.com>
Date:   Fri Apr 2 10:53:47 2010 -0400

    Fix all the confusion over directories once and for all.  We now have=

    3 directory definitions: mdmon directory for its pid and sock files,
    mdmonitor directory which is for the mdadm monitor mode pid file and
    can only be passed in via command line, and the directory for the
    mdadm map file.  Only the mdadm map file still hunts multiple locatio=
ns,
    and the number of locations has been reduced to /var/run and the
    compile time specified location.  I could see lowering that to just
    1 location, but I didn't do that with this patch.
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/Makefile b/Makefile
index 2aafad0..30e52a7 100644
--- a/Makefile
+++ b/Makefile
@@ -58,16 +58,16 @@ CONFFILE =3D $(SYSCONFDIR)/mdadm.conf
 CONFFILE2 =3D $(SYSCONFDIR)/mdadm/mdadm.conf
 MAILCMD =3D/usr/sbin/sendmail -t
 CONFFILEFLAGS =3D -DCONFFILE=3D\"$(CONFFILE)\" -DCONFFILE2=3D\"$(CONFFIL=
E2)\"
-# ALT_RUN should be somewhere that persists across the pivotroot
-# from early boot to late boot.
+# Both MAP_DIR and MDMON_DIR should be somewhere that persists across th=
e
+# pivotroot from early boot to late boot.
 # If you don't have /lib/init/rw you might want to use /dev/.something
-#  e.g. make ALT_RUN=3D/dev/.mdadm
-ALT_RUN =3D /lib/init/rw
-ALT_MAPFILE =3D map
-VAR_RUN =3D /var/run
-ALTFLAGS =3D -DALT_RUN=3D\"$(ALT_RUN)\" -DALT_MAPFILE=3D\"$(ALT_MAPFILE)=
\"
-VARFLAGS =3D -DVAR_RUN=3D\"$(VAR_RUN)\"
-CFLAGS =3D $(CWFLAGS) $(CXFLAGS) -DSendmail=3D\""$(MAILCMD)"\" $(CONFFIL=
EFLAGS) $(ALTFLAGS) $(VARFLAGS)
+#  e.g. make MAP_DIR=3D/dev/.mdadm
+MAP_DIR =3D /lib/init/rw/mdadm
+MAP_FILE =3D map
+MDMON_DIR =3D /lib/init/rw/mdmon
+DIRFLAGS =3D -DMAP_DIR=3D\"$(MAP_DIR)\" -DMAP_FILE=3D\"$(MAP_FILE)\"
+DIRFLAGS +=3D -DMDMON_DIR=3D\"$(MDMON_DIR)\"
+CFLAGS =3D $(CWFLAGS) $(CXFLAGS) -DSendmail=3D\""$(MAILCMD)"\" $(CONFFIL=
EFLAGS) $(DIRFLAGS)
=20
 # If you want a static binary, you might uncomment these
 # LDFLAGS =3D -static
diff --git a/mapfile.c b/mapfile.c
index d47fde1..f4339db 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -52,28 +52,26 @@
 #include	<ctype.h>
=20
 #define mapnames(base) { base, base ".new", base ".lock"}
-char *mapname[3][3] =3D {
-	mapnames(VAR_RUN "/map"),
-	mapnames("/var/run/mdadm.map"),
-	mapnames(ALT_RUN "/" ALT_MAPFILE)
+char *mapname[2][3] =3D {
+	mapnames(MAP_DIR "/" MAP_FILE),
+	mapnames("/var/run/mdadm.map")
 };
-char *mapdir[3] =3D { VAR_RUN, NULL, ALT_RUN };
+char *mapdir[2] =3D { MAP_DIR, NULL };
=20
-int mapmode[3] =3D { O_RDONLY, O_RDWR|O_CREAT, O_RDWR|O_CREAT | O_TRUNC =
};
+int mapmode[3] =3D { O_RDONLY, O_RDWR|O_CREAT, O_RDWR|O_CREAT|O_TRUNC };=

 char *mapsmode[3] =3D { "r", "w", "w"};
=20
 FILE *open_map(int modenum, int *choice)
 {
 	int i;
=20
-	for (i =3D 0 ; i < 3 ; i++) {
+	for (i =3D 0 ; i < 2 ; i++) {
 		int fd;
-		if ((mapmode[modenum] & O_CREAT) &&
-		    mapdir[modenum])
+		if ((mapmode[modenum] & O_CREAT) && mapdir[i])
 			/* Attempt to create directory, don't worry about
 			 * failure.
 			 */
-			mkdir(mapdir[modenum], 0755);
+			mkdir(mapdir[i], 0755);
 		fd =3D open(mapname[i][modenum], mapmode[modenum], 0600);
 		if (fd >=3D 0) {
 			*choice =3D i;
diff --git a/mdadm.h b/mdadm.h
index 0386129..d8ab85f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -68,28 +68,30 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __=
offset, int __whence));
 #define DEFAULT_BITMAP_DELAY 5
 #define DEFAULT_MAX_WRITE_BEHIND 256
=20
-/* VAR_RUN is where pid and socket files used for communicating
- * with mdmon normally live.  It should be /var/run, but if
- * it is too hard to remount /var/run as read-only rather than
- * unmounting it at shutdown time, then it should be
- * redefined to some place that comfortably persists until
- * final shutdown, possibly in /dev if that is a tmpfs.
- * Note: VAR_RUN does not need to be writable at shutdown,
- * only during boot when "mdmon --takeover" is run.
- */
-#ifndef VAR_RUN
-#define VAR_RUN "/var/run/mdadm"
-#endif /* VAR_RUN */
-/* ALT_RUN should be somewhere that persists across the pivotroot
+/* MAP_DIR should be somewhere that persists across the pivotroot
  * from early boot to late boot.
  * If you don't have /lib/init/rw you might want to use /dev/.something
  */
-#ifndef ALT_RUN
-#define ALT_RUN "/lib/init/rw/mdadm"
-#endif /* ALT_RUN */
-#ifndef ALT_MAPFILE
-#define ALT_MAPFILE "map"
-#endif /* ALT_MAPFILE */
+#ifndef MAP_DIR
+#define MAP_DIR "/lib/init/rw/mdadm"
+#endif /* MAP_DIR */
+/* MAP_FILE is what we name the map file we put in MAP_DIR, in case you
+ * want something other than the default of "map"
+ */
+#ifndef MAP_FILE
+#define MAP_FILE "map"
+#endif /* MAP_FILE */
+/* MDMON_DIR is where pid and socket files used for communicating
+ * with mdmon normally live.  It *should* be /var/run, but when
+ * mdmon is needed at early boot then it needs to write there prior
+ * to /var/run being mounted read/write, and it also then needs to
+ * persist beyond when /var/run is mounter read-only.  So, to be
+ * safe, the default is somewhere that is read/write early in the
+ * boot process and stays up as long as possible during shutdown.
+ */
+#ifndef MDMON_DIR
+#define MDMON_DIR "/lib/init/rw/mdmon"
+#endif /* MDMON_DIR */
=20
 #include	"md_u.h"
 #include	"md_p.h"
@@ -910,7 +912,6 @@ extern int create_mddev(char *dev, char *name, int au=
tof, int trustworthy,
 extern int open_mddev(char *dev, int report_errors);
 extern int open_container(int fd);
=20
-extern char *pid_dir;
 extern int mdmon_running(int devnum);
 extern int mdmon_pid(int devnum);
 extern int check_env(char *name);
diff --git a/mdmon.c b/mdmon.c
index 69c320e..cbb72cc 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -120,10 +120,10 @@ static int make_pidfile(char *devname)
 	int fd;
 	int n;
=20
-	if (mkdir(pid_dir, 0700) < 0 &&
+	if (mkdir(MDMON_DIR, 0755) < 0 &&
 	    errno !=3D EEXIST)
 		return -errno;
-	sprintf(path, "%s/%s.pid", pid_dir, devname);
+	sprintf(path, "%s/%s.pid", MDMON_DIR, devname);
=20
 	fd =3D open(path, O_RDWR|O_CREAT|O_EXCL, 0600);
 	if (fd < 0)
@@ -189,13 +189,10 @@ void remove_pidfile(char *devname)
 {
 	char buf[100];
=20
-	sprintf(buf, "%s/%s.pid", pid_dir, devname);
+	sprintf(buf, "%s/%s.pid", MDMON_DIR, devname);
 	unlink(buf);
-	sprintf(buf, "%s/%s.sock", pid_dir, devname);
+	sprintf(buf, "%s/%s.sock", MDMON_DIR, devname);
 	unlink(buf);
-	if (strcmp(pid_dir, ALT_RUN) =3D=3D 0)
-		/* try to clean up when we are finished with this dir */
-		rmdir(pid_dir);
 }
=20
 static int make_control_sock(char *devname)
@@ -208,7 +205,7 @@ static int make_control_sock(char *devname)
 	if (sigterm)
 		return -1;
=20
-	sprintf(path, "%s/%s.sock", pid_dir, devname);
+	sprintf(path, "%s/%s.sock", MDMON_DIR, devname);
 	unlink(path);
 	sfd =3D socket(PF_LOCAL, SOCK_STREAM, 0);
 	if (sfd < 0)
@@ -445,12 +442,7 @@ static int mdmon(char *devname, int devnum, int must=
_fork, int takeover)
 	act.sa_handler =3D SIG_IGN;
 	sigaction(SIGPIPE, &act, NULL);
=20
-	pid_dir =3D VAR_RUN;
 	victim =3D mdmon_pid(container->devnum);
-	if (victim < 0) {
-		pid_dir =3D ALT_RUN;
-		victim =3D mdmon_pid(container->devnum);
-	}
 	if (victim >=3D 0)
 		victim_sock =3D connect_monitor(container->devname);
=20
@@ -474,16 +466,8 @@ static int mdmon(char *devname, int devnum, int must=
_fork, int takeover)
 	 */
 	if (victim > 0)
 		remove_pidfile(devname);
-	pid_dir =3D VAR_RUN;
 	if (make_pidfile(devname) < 0) {
-		/* Try the alternate */
-		pid_dir =3D ALT_RUN;
-		if (make_pidfile(devname) < 0) {
-			fprintf(stderr, "mdmon: Neither %s nor %s are writable\n"
-				"       cannot create .pid or .sock files.  Aborting\n",
-				VAR_RUN, ALT_RUN);
-			exit(3);
-		}
+		exit(3);
 	}
 	container->sock =3D make_control_sock(devname);
=20
diff --git a/msg.c b/msg.c
index d2d8445..aabfa8f 100644
--- a/msg.c
+++ b/msg.c
@@ -147,7 +147,7 @@ int connect_monitor(char *devname)
 	int pos;
 	char *c;
=20
-	pos =3D sprintf(path, "%s/", pid_dir);
+	pos =3D sprintf(path, "%s/", MDMON_DIR);
 	if (is_subarray(devname)) {
 		devname++;
 		c =3D strchr(devname, '/');
diff --git a/util.c b/util.c
index 79d2b0f..bdb19f9 100644
--- a/util.c
+++ b/util.c
@@ -1499,15 +1499,13 @@ int fd2devnum(int fd)
 	return NoMdDev;
 }
=20
-char *pid_dir =3D VAR_RUN;
-
 int mdmon_pid(int devnum)
 {
 	char path[100];
 	char pid[10];
 	int fd;
 	int n;
-	sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
+	sprintf(path, "%s/%s.pid", MDMON_DIR, devnum2devname(devnum));
 	fd =3D open(path, O_RDONLY | O_NOATIME, 0);
=20
 	if (fd < 0)

--------------000709040006020201080709--

--------------enig005EE7140D17FEF8D278D95C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku2BasACgkQg6WylM+/8ZS+xwCfYuzYg8WFuV3CuvnHwyHpwZ2J
1l8AniQuWiaast/PafvjpiSky+30TFqZ
=vYQ7
-----END PGP SIGNATURE-----

--------------enig005EE7140D17FEF8D278D95C--
