From: Doug Ledford <dledford@redhat.com>
Subject: Minor mdadm fixes
Date: Thu, 18 Mar 2010 22:13:06 -0400
Message-ID: <4BA2DDB2.2040508@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2C634F57949756252B23583B"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2C634F57949756252B23583B
Content-Type: multipart/mixed;
 boundary="------------020801030509060909010705"

This is a multi-part message in MIME format.
--------------020801030509060909010705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have several minor fixes against the 3.1.2 mdadm.

First attachment: mdadm-3.1.1-endian.patch
Problem: on ppc arches mdadm would fail to assemble arrays if you used
mdadm -Db /dev/<array> to populate the ARRAY line in mdadm.conf.  This
is because the code in Detail.c calls fname_from_uuid() which honors the
swapuuid setting in the superblock switch struct.  This is great for ddf
and imsm superblocks which call fname_from_uuid() all over the place and
are therefore consistent.  However, super1.c does *not* call
fname_from_uuid()...ever.  And super1.c does *not* perform the byte
swapping as per swapuuid in the switch struct.  At least not on
*display*, but it *does* honor swapuuid on actual analysis of the uuid
in terms of figuring out matches.  So, if you attempt to change the
value of swapuuid in the super1 switch struct, then uuid's never match
what's printed out (aka, the output of -D and -E both fail to match
against the detected uuid when assembling, although at least -D and -E
are now consistent).  Instead, I did a simple (and gross) hack to ignore
swapuuid in fname_from_uuid() only for version 1 superblocks.  The other
alternative might be to make super1.c call fname_from_uuid() all over
the place instead of printing things out itself, but that would involve
struct changes as the way it stores/accesses uuids in super1 is not per
char like fname_from_uuid and that's precisely part of the problem.

Second: mdadm-3.1.2-mapfile.patch
Problem: Neil's support for putting the mdadm map file wherever you need
it is nice, but one place in particular needs a special case.
Specifically, mdadm already creates /dev/md if needed to store symlinks,
or in the case of mdmon needing to create pid/sock files (if ALT_RUN is
set to /dev/md).  This creates an expectation in udev and friends that
mdadm will create /dev/md when needed, period.  We need it if we place
the mapfile in /dev/md prior to any symlinks or mdmon files being
created, so special case that one location in order to make us
consistent with both mdmon and mdopen.  If we don't, we will fail to
create our mapfile.

Third: mdadm-3.1.2-rebuild.patch
Problem: The above issue pointed out a different issue.  Specifically,
if we can't open our mapfile, then we call RebuildMap, and at the end of
the rebuild, we trigger a new change event on the raid device.  Well, if
the write of the new map file failed because the directory we wanted to
write into didn't exist, this creates an infinite loop where udev calls
mdadm, mdadm fails to open file, mdadm rebuils map, mdadm fails to write
new map, but mdadm triggers a change event to cause udev to rerun mdadm
on the belief that the map file *was* updated.  So, if we fail to write
the new mapfile, don't signal a change event, let the situation drop.
This avoids the infinite loop.

Fourth: mdadm-3.1.2-mapname.patch
Feature: If we are able to easily select the location of the mapfile via
the use of ALT_RUN at compile time, it makes sense to also be able to
set the filename.  This way you can make it something obvious such as
/dev/md + md-device-map which makes the file name both unlikely to
conflict with a device name (where as I could see map conflicting in
certain specialized scenarios, like the array holding map data at the
local governmental office) and obvious in purpose.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------020801030509060909010705
Content-Type: text/plain;
 name="mdadm-3.1.1-endian.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.1-endian.patch"

--- mdadm-3.1.1/util.c.endian	2010-02-21 19:13:56.253610477 -0500
+++ mdadm-3.1.1/util.c	2010-02-21 19:16:26.338375501 -0500
@@ -395,7 +395,12 @@ char *__fname_from_uuid(int id[4], int s
=20
 char *fname_from_uuid(struct supertype *st, struct mdinfo *info, char *b=
uf, char sep)
 {
-	return __fname_from_uuid(info->uuid, st->ss->swapuuid, buf, sep);
+	// dirty hack to work around an issue with super1 superblocks...
+	// super1 superblocks need swapuuid set in order for assembly to
+	// work, but can't have it set if we want this printout to match
+	// all the other uuid printouts in super1.c, so we force swapuuid
+	// to 1 to make our printout match the rest of super1
+	return __fname_from_uuid(info->uuid, (st->ss =3D=3D &super1) ? 1 : st->=
ss->swapuuid, buf, sep);
 }
=20
 #ifndef MDASSEMBLE

--------------020801030509060909010705
Content-Type: text/plain;
 name="mdadm-3.1.2-mapfile.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.2-mapfile.patch"

commit b25462c1bee1a01c6aae3c215e040bfb2f1c2fb7
Author: Doug Ledford <dledford@redhat.com>
Date:   Tue Mar 16 23:00:11 2010 -0400

    Create /dev/md in mapfile open like we do in mdopen if our ALT_RUN is=

    set to be /dev/md.  This keeps udev happy as it won't have to special=

    case our /dev/md directory needs.
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/mapfile.c b/mapfile.c
index 366ebe3..eed17c8 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -29,7 +29,7 @@
  */
=20
 /* /var/run/mdadm.map is used to track arrays being created in --increme=
ntal
- * more.  It particularly allows lookup from UUID to array device, but
+ * mode.  It particularly allows lookup from UUID to array device, but
  * also allows the array device name to be easily found.
  *
  * The map file is line based with space separated fields.  The fields a=
re:
@@ -64,6 +64,16 @@ char *mapsmode[3] =3D { "r", "w", "w"};
 FILE *open_map(int modenum, int *choice)
 {
 	int i;
+	struct stat sbuf;
+
+	/* Special case...if ALT_RUN is selected to be /dev/md, then
+	 * because we would normally create /dev/md ourselves in order to
+	 * stuff array symlinks in there as needed, udev and friends
+	 * expect us to create our own tree.  So, do so.
+	 */
+	if (strcmp(ALT_RUN, "/dev/md") =3D=3D 0 && stat(ALT_RUN, &sbuf) !=3D 0)=

+		mkdir(ALT_RUN, 0755);
+
 	for (i =3D 0 ; i < 3 ; i++) {
 		int fd =3D open(mapname[i][modenum], mapmode[modenum], 0600);
 		if (fd >=3D 0) {

--------------020801030509060909010705
Content-Type: text/plain;
 name="mdadm-3.1.2-rebuild.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.2-rebuild.patch"

commit 0d196a9dcab2e4eb0bce49b63c971d1e06cd9300
Author: Doug Ledford <dledford@redhat.com>
Date:   Wed Mar 17 09:28:07 2010 -0400

    Only signal a udev change event if we actually write a mapfile in Reb=
uildMap
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/mapfile.c b/mapfile.c
index eed17c8..950cf62 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -472,12 +472,14 @@ void RebuildMap(void)
 		}
 		sysfs_free(sra);
 	}
-	map_write(map);
+	/* Only trigger a change if we wrote a new map file */
+	if (map_write(map))
+		for (md =3D mdstat ; md ; md =3D md->next) {
+			struct mdinfo *sra =3D sysfs_read(-1, md->devnum,
+							GET_VERSION);
+			sysfs_uevent(sra, "change");
+			sysfs_free(sra);
+		}
 	map_free(map);
-	for (md =3D mdstat ; md ; md =3D md->next) {
-		struct mdinfo *sra =3D sysfs_read(-1, md->devnum, GET_VERSION);
-		sysfs_uevent(sra, "change");
-		sysfs_free(sra);
-	}
 	free_mdstat(mdstat);
 }

--------------020801030509060909010705
Content-Type: text/plain;
 name="mdadm-3.1.2-mapname.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.2-mapname.patch"

commit 9649a16e4c0e679c0e5bc3e33d816943b85dd910
Author: Doug Ledford <dledford@redhat.com>
Date:   Wed Mar 17 10:52:22 2010 -0400

    mapfile: if we putting the mapfile in a custom location via ALT_RUN, =
allow
    a custom filename too.
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/Makefile b/Makefile
index 1035ea8..2aafad0 100644
--- a/Makefile
+++ b/Makefile
@@ -63,8 +63,9 @@ CONFFILEFLAGS =3D -DCONFFILE=3D\"$(CONFFILE)\" -DCONFFI=
LE2=3D\"$(CONFFILE2)\"
 # If you don't have /lib/init/rw you might want to use /dev/.something
 #  e.g. make ALT_RUN=3D/dev/.mdadm
 ALT_RUN =3D /lib/init/rw
+ALT_MAPFILE =3D map
 VAR_RUN =3D /var/run
-ALTFLAGS =3D -DALT_RUN=3D\"$(ALT_RUN)\"
+ALTFLAGS =3D -DALT_RUN=3D\"$(ALT_RUN)\" -DALT_MAPFILE=3D\"$(ALT_MAPFILE)=
\"
 VARFLAGS =3D -DVAR_RUN=3D\"$(VAR_RUN)\"
 CFLAGS =3D $(CWFLAGS) $(CXFLAGS) -DSendmail=3D\""$(MAILCMD)"\" $(CONFFIL=
EFLAGS) $(ALTFLAGS) $(VARFLAGS)
=20
diff --git a/mapfile.c b/mapfile.c
index 950cf62..51d2b14 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -55,7 +55,7 @@
 char *mapname[3][3] =3D {
 	mapnames(VAR_RUN "/map"),
 	mapnames("/var/run/mdadm.map"),
-	mapnames(ALT_RUN "/map")
+	mapnames(ALT_RUN "/" ALT_MAPFILE)
 };
=20
 int mapmode[3] =3D { O_RDONLY, O_RDWR|O_CREAT, O_RDWR|O_CREAT | O_TRUNC =
};

--------------020801030509060909010705--

--------------enig2C634F57949756252B23583B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkui3bMACgkQg6WylM+/8ZQv8gCfSxEes1EvZmbY7Q0oACl/vWr0
WWoAoK28NPtroJ9EBN7mnS2E5M37E9xl
=3kBn
-----END PGP SIGNATURE-----

--------------enig2C634F57949756252B23583B--
