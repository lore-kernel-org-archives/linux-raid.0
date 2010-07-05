From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 30/33] Incremental for bare disks, checking routine +
 integration
Date: Mon, 5 Jul 2010 11:50:55 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC432@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C5D@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C5D@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:43 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 30/33] Incremental for bare disks, checking routine + i=
ntegration

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

The idea of this patch is to allow adding of bare device to the contain=
er if device is plugged into the same port as recently removed device.
=46unction 'bare_disk_match_array' has been added to look for special '=
cookie'
file (named after /dev/disk/by-path name of missing device) containing =
the name of valid array. If it is found, container device name is retur=
ned.
This container is used with Manage_subdevs() add, to add device.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0Incremental.c |=A0 180 +++++++++++++++++++++++++++++++++++++++++++++=
+++---------
=A0config.c=A0=A0=A0=A0=A0 |=A0=A0=A0 9 ++-
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 3 +-
=A03 files changed, 160 insertions(+), 32 deletions(-)

diff --git a/Incremental.c b/Incremental.c index adaefb9..3783e37 10064=
4
--- a/Incremental.c
+++ b/Incremental.c
@@ -29,6 +29,8 @@
=A0 */
=A0
=A0#include=A0=A0 "mdadm.h"
+#include=A0=A0 <sys/types.h>
+#include=A0=A0 <dirent.h>
=A0
=A0static int count_active(struct supertype *st, int mdfd, char **avail=
p,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct mdinfo *info=
);
@@ -40,6 +42,87 @@ static int IncrementalNewPart(char *devname, int ver=
bose, int export,=A0 static int IncrementalNewDisk(char *devname, int v=
erbose, int export,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 str=
uct domain_ent *domain);
=A0
+
+
+/* finds cookie file with matching path. If found, returns device name
+ * either for this array (native) or its parent container (external)=A0=
=20
+*/ char *bare_disk_match_array(char *devname, int fd, struct supertype=
=20
+**st) {
+=A0=A0=A0=A0 char *dev_path;
+=A0=A0=A0=A0 char cookie_path[PATH_MAX];
+=A0=A0=A0=A0 FILE *cookie;
+=A0=A0=A0=A0 struct mdstat_ent *mds =3D NULL, *ent =3D NULL;
+=A0=A0=A0=A0 char *mdname =3D NULL;
+
+=A0=A0=A0=A0 if (!devname)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+
+=A0=A0=A0=A0 mds =3D mdstat_read(0, 0);
+=A0=A0=A0=A0 /* no active arrays */
+=A0=A0=A0=A0 if (!mds)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+
+=A0=A0=A0=A0 dev_path =3D get_devpath_from_devname(devname);
+=A0=A0=A0=A0 if (!dev_path) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_mdstat(mds);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 snprintf(cookie_path, PATH_MAX, FAILED_SLOTS "/%s", dev_p=
ath);
+=A0=A0=A0=A0 if ((cookie =3D fopen(cookie_path, "r")) =3D=3D NULL) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name " : Cannot open %s=
 cookie. "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0=A0 "Bare disk spare action disabled\n.",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cookie_path);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(dev_path);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * find first active array using list instde 'cookie' file
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 while(fgets(cookie_path, PATH_MAX, cookie)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int devnum;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sscanf(cookie_path, "md%d", &devnum=
) !=3D 1)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ent =3D mdstat_by_devnum(&mds, devnum);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ent) /* found active array */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 if (ent) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char md_path[PATH_MAX];
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct mdstat_ent *parent =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int mdfd;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strcpy(md_path, "/dev/");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_external(ent->metadata_version))=
 {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 parent =3D mdstat_get=
_parent(ent);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!parent) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name " : Cannot find parent "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "container for array %s\n.",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 ent->dev);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 got=
o cleanup;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strncat(md_path + 5, =
parent->dev, PATH_MAX - 5);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_mdstat(parent);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strncat(md_path + 5, =
ent->dev, PATH_MAX - 5);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mdfd =3D open_mddev(md_path, 0);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (mdfd < 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto cleanup;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *st =3D guess_super(mdfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(mdfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!*st)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto cleanup;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mdname =3D strdup(md_path);
+=A0=A0=A0=A0 }
+cleanup:
+=A0=A0=A0=A0 fclose(cookie);
+=A0=A0=A0=A0 free_mdstat(mds);
+=A0=A0=A0=A0 free(dev_path);
+=A0=A0=A0=A0 return mdname;
+}
+
=A0int Incremental(char *devname, int verbose, int runstop,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct supertype *st, char *homehost,=
 int require_homehost,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int autof)
@@ -1044,10 +1127,19 @@ static int IncrementalNewPart(char *devname, in=
t verbose, int export,
=A0=A0=A0=A0=A0 struct mdstat_ent *mdstat, *md;
=A0=A0=A0=A0=A0 struct stat stb;
=A0=A0=A0=A0=A0 int dfd;
+=A0=A0=A0=A0 struct supertype *st =3D NULL;
+=A0=A0=A0=A0 char *mdname;
+=A0=A0=A0=A0 int mdfd;
+=A0=A0=A0=A0 int rv =3D 0;
+=A0=A0=A0=A0 struct mddev_dev_s devlist;
=A0
=A0=A0=A0=A0=A0 mdstat =3D arrays_in_domain(devname, domain);
=A0=A0=A0=A0=A0 for (md =3D mdstat; md; md =3D md->next)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf(Name ": %s\n", md->dev);
+
+=A0=A0=A0=A0 /* any arrays for this domain? */
+=A0=A0=A0=A0 if (!mdstat)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0 /* We've finished with the easy tests that allow us to =
kick drives
=A0=A0=A0=A0=A0 =A0* out without touching actual physical media, now we=
 need to start
=A0=A0=A0=A0=A0 =A0* the slower checks.
@@ -1072,7 +1164,34 @@ static int IncrementalNewPart(char *devname, int=
 verbose, int export,
=A0=A0=A0=A0=A0 =A0* or 0xff.
=A0=A0=A0=A0=A0 =A0*/
=A0
-=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 /* for bare action, check if 'cookie' exists for this dev=
ice,
+=A0=A0=A0=A0 * temporarily get metadata from matching array and invoke=
 standard
+=A0=A0=A0=A0 * Incremental with bare=3D1
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 if (conf_get_domain_action(devname, domain->platform) =3D=
=3D same_port_bare &&
+=A0=A0=A0=A0 =A0=A0=A0 !strstr(devname, "part") &&
+=A0=A0=A0=A0 =A0=A0=A0 (mdname =3D bare_disk_match_array(devname, dfd,=
 &st)) &&
+=A0=A0=A0=A0 =A0=A0=A0 !strcmp(st->ss->name, domain->platform)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(st);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mdfd =3D open_mddev(mdname, 0);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!mdfd) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name =
": cannot open array device %s.\n", mdname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(&devlist, 0, sizeof(devlist));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devlist.devname =3D devname;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devlist.disposition =3D 'a';
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D Manage_subdevs(mdname, mdfd, &de=
vlist, 0);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(mdname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mdname =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(mdfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rv;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 free(mdname);
+=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0 return 1;
=A0}
=A0
=A0/*
@@ -1103,7 +1222,7 @@ static int IncrementalNewDisk(char *devname, int =
verbose, int export,
=A0
=A0=A0=A0=A0=A0 if (domain->handler->check_table(dfd, verbose, export, =
domain) =3D=3D 0) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 /*
=A0=A0=A0=A0=A0 =A0* OK, at this point we have a valid block device wit=
hout a @@ -1138,33 +1257,38 @@ int IncrementalNew(char *devname, int ve=
rbose, int export)=A0 {
=A0=A0=A0=A0=A0 struct domain_ent *domain;
=A0=A0=A0=A0=A0 char *devpath;
-=A0=A0=A0=A0 int rv;
+=A0=A0=A0=A0 int rv =3D 1;
+=A0=A0=A0=A0 int i;
=A0
-=A0=A0=A0=A0 domain =3D conf_get_domain(devname, NULL);
-=A0=A0=A0=A0 if (!domain)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
-=A0=A0=A0=A0 if (action(domain) <=3D incremental)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Nothing to do.=A0 We only get called=
 in the case that there
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * is no current superblock on the devic=
e in question, and
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * since our matching domain says we sho=
uld either ignore or
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * use devices incrementally, they have =
to already have a
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * superblock.=A0 Since we don't, we're =
done.
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
-=A0=A0=A0=A0 devpath =3D get_devpath_from_devname(devname);
-=A0=A0=A0=A0 if (strstr(devpath, "part") || action(domain) !=3D partit=
ion)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* We are on a partition, not a whole d=
isk, or we are on a
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * whole disk but we want to use the who=
le disk instead
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * of partitioning it */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalNewPart(devname, verb=
ose, export, domain);
-=A0=A0=A0=A0 else
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Only use this if we are dealing with=
 a disk that would
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * need partitioned.=A0 This will get ca=
lled even when our
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * disk actually already belongs to all =
the right arrays
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * and there is nothing to be done, so o=
nly do work here
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * if we really need to */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalNewDisk(devname, verb=
ose, export, domain);
-=A0=A0=A0=A0 free(devpath);
+ =A0=A0=A0 for (i =3D 0; superlist[i]; i++) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 domain =3D conf_get_domain(devname, (ch=
ar *)superlist[i]->name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!domain)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (action(domain) <=3D incremental)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Nothing to do.=A0 =
We only get called in the case that there
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * is no current super=
block on the device in question, and
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * since our matching =
domain says we should either ignore or
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * use devices increme=
ntally, they have to already have a
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * superblock.=A0 Sinc=
e we don't, we're done.
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devpath =3D get_devpath_from_devname(de=
vname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (strstr(devpath, "part") || action(d=
omain) !=3D partition)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* We are on a partit=
ion, not a whole disk, or we are on a
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * whole disk but we w=
ant to use the whole disk instead
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * of partitioning it =
*/
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalNew=
Part(devname, verbose, export, domain);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Only use this if w=
e are dealing with a disk that would
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * need partitioned.=A0=
 This will get called even when our
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * disk actually alrea=
dy belongs to all the right arrays
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * and there is nothin=
g to be done, so only do work here
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * if we really need t=
o */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalNew=
Disk(devname, verbose, export, domain);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(devpath);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!rv)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 return rv;
=A0}
=A0
diff --git a/config.c b/config.c
index 5829182..ae06859 100644
--- a/config.c
+++ b/config.c
@@ -827,6 +827,9 @@ void domainline(char *line)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
e->action =3D grow;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (strncasecm=
p("par", w+offset, 3) =3D=3D 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
e->action =3D partition;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (strncasecmp(=
"bar", w+offset, 3) =3D=3D 0 ||
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 str=
ncasecmp("sam", w+offset, 3) =3D=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de-=
>action =3D same_port_bare;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (offset =3D=3D 1=
3)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
e->action |=3D force;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (strncasecmp("metadata=3D",=
 w, 9) =3D=3D 0) { @@ -1046,7 +1049,7 @@ struct domain_ent *get_domain_=
from_devpath(char *devpath, char *platform)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
t =3D get_supertype_by_name(de->platform);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (!st)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 continue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=20
+
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (match_platform(st, platform)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 st->ss->free_super(st);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 free(st);
@@ -1947,9 +1950,9 @@ struct mdstat_ent *arrays_in_domain(char *devname=
, struct domain_ent *domain)
=A0=A0=A0=A0=A0 return array_list;
=A0}
=A0
-int conf_get_domain_action(char *devname)
+int conf_get_domain_action(char *devname, char *platform)
=A0{
-=A0=A0=A0=A0 struct domain_ent *domain =3D conf_get_domain(devname, NU=
LL);
+=A0=A0=A0=A0 struct domain_ent *domain =3D conf_get_domain(devname, pl=
atform);
=A0=A0=A0=A0=A0 if (!domain)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return incremental;
=A0=A0=A0=A0=A0 return domain->action;
diff --git a/mdadm.h b/mdadm.h
index 6eeebd5..a1ec751 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -303,6 +303,7 @@ enum domain_actions {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 appropriate things wi=
th the partitions */
=A0=A0=A0=A0=A0 spare,
=A0=A0=A0=A0=A0 grow,
+=A0=A0=A0=A0 same_port_bare,
=A0=A0=A0=A0=A0 action_mask=3D511,
=A0=A0=A0=A0=A0 force=3D512, /* so we can bitwise & this with actions t=
o signify we
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 should forcibly take =
over drives even if they have @@ -955,7 +956,7 @@ extern mddev_dev_t co=
nf_get_devs(void);=A0 extern struct domain_ent *conf_get_domain(char *d=
evname, char *platform);=A0 extern struct subset *conf_get_subset(char =
*devname, struct supertype *st,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0=A0=A0 struct domain_ent *domain);
-extern int conf_get_domain_action(char *devname);
+extern int conf_get_domain_action(char *devname, char *platform);
=A0extern struct mdstat_ent *arrays_in_domain(char *devname,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =A0=A0 struct domain_ent *domain);
=A0extern struct subset *conf_get_any_subset(void);
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
