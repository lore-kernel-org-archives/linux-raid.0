From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 04/33] Support for new disk hot plug actions with DOMAINs.
Date: Mon, 5 Jul 2010 11:43:40 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3E4@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C03@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C03@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:23 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 04/33] Support for new disk hot plug actions with DOMAI=
Ns.

=46rom: Doug Ledford <dledford@redhat.com>

=A0 Nowhere near complete, just the initial stages.
=A0 Added support for the call to mdadm.c, some
=A0 sanity checks, helper functions, etc.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
=A0Incremental.c |=A0 131 +++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++
=A0config.c=A0=A0=A0=A0=A0 |=A0=A0=A0 5 +-
=A0mdadm.c=A0 =A0=A0=A0=A0=A0|=A0=A0 32 ++++++++++++--
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 5 ++
=A0util.c=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 24 ++++++++++
=A05 files changed, 189 insertions(+), 8 deletions(-)

diff --git a/Incremental.c b/Incremental.c index a99811d..d1d9ee1 10064=
4
--- a/Incremental.c
+++ b/Incremental.c
@@ -35,6 +35,10 @@ static int count_active(struct supertype *st, int md=
fd, char **availp,=A0 static void find_reject(int mdfd, struct supertyp=
e *st, struct mdinfo *sra,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int number, __u64 e=
vents, int verbose,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char *array_name);
+static int IncrementalNewPart(char *devname, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 struc=
t domain_ent *domain);
+static int IncrementalNewDisk(char *devname, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 struc=
t domain_ent *domain);
=A0
=A0int Incremental(char *devname, int verbose, int runstop,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct supertype *st, char *homehost,=
 int require_homehost, @@ -888,3 +892,130 @@ int IncrementalRemove(char=
 *devname, int verbose)
=A0=A0=A0=A0=A0 devlist.disposition =3D 'r';
=A0=A0=A0=A0=A0 return Manage_subdevs(ent->dev, mdfd, &devlist, verbose=
);=A0 }
+
+/*
+ * IncrementalNewPart - We have a partition or a whole disk device, an=
d=20
+we
+ * have a domain that says not to partition the device, so we will=20
+either
+ * use the whole disk or the partition directly.
+ */
+static int IncrementalNewPart(char *devname, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 struc=
t domain_ent *domain)
+{
+=A0=A0=A0=A0 struct mdstat_ent *mdstat, *md;
+=A0=A0=A0=A0 struct stat stb;
+=A0=A0=A0=A0 int dfd;
+
+=A0=A0=A0=A0 mdstat =3D arrays_in_domain(devname, domain);
+=A0=A0=A0=A0 for (md =3D mdstat; md; md =3D md->next)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printf(Name ": %s\n", md->dev);
+=A0=A0=A0=A0 /* We've finished with the easy tests that allow us to ki=
ck drives
+=A0=A0=A0=A0 * out without touching actual physical media, now we need=
 to start
+=A0=A0=A0=A0 * the slower checks.
+=A0=A0=A0=A0 */
+=A0=A0=A0=A0 dfd =3D dev_open_check(devname, O_RDONLY|O_EXCL, &stb);
+=A0=A0=A0=A0 if (dfd < 0)=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 if (guess_super(dfd) !=3D NULL) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* This won't happen with our udev rule=
s, but someone might
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * try this by hand, make them use norma=
l incremental mode
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * instead if the device has a superbloc=
k already */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": superblock pres=
ent on %s.\n", devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * OK, at this point we have a valid block device without =
a
+=A0=A0=A0=A0 * superblock.=A0 If we aren't in force mode, then don't u=
se the
+=A0=A0=A0=A0 * device unless it's "clean", meaning no filesystems, no =
lvm,
+=A0=A0=A0=A0 * no anything.=A0 The requirement here is that both the f=
irst and
+=A0=A0=A0=A0 * last 4k of the device must be one of three patterns: 0x=
00, 0x5a,
+=A0=A0=A0=A0 * or 0xff.
+=A0=A0=A0=A0 */
+
+=A0=A0=A0=A0 return 0;
+}
+
+/*
+ * IncrementalNewDisk - We have a whole disk device, and we have a=20
+domain
+ * that says to partition the disk.=A0 However, we will get called=20
+whether
+ * the partition is the correct partition or not, so we need to skip=20
+devs
+ * that already have the right partition and partition bare devs or
+ * repartition devs with stuff already on them only if the force optio=
n
+ * is present on our domain.
+ */
+static int IncrementalNewDisk(char *devname, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 struc=
t domain_ent *domain)
+{
+=A0=A0=A0=A0 struct stat stb;
+=A0=A0=A0=A0 int dfd;
+
+=A0=A0=A0=A0 dfd =3D dev_open_check(devname, O_RDONLY|O_EXCL, &stb);
+=A0=A0=A0=A0 if (dfd < 0)=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 if (guess_super(dfd) !=3D NULL) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* This won't happen with our udev rule=
s, but someone might
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * try this by hand, make them use norma=
l incremental mode
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * instead if the device has a superbloc=
k already */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": superblock pres=
ent on %s.\n", devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 /*
+=A0=A0=A0=A0 * OK, at this point we have a valid block device without =
a
+=A0=A0=A0=A0 * superblock.=A0 If we aren't in force mode, then don't u=
se the
+=A0=A0=A0=A0 * device unless it's "clean", meaning no filesystems, no =
lvm,
+=A0=A0=A0=A0 * no anything.=A0 The requirement here is that both the f=
irst and
+=A0=A0=A0=A0 * last 4k of the device must be one of three patterns: 0x=
00, 0x5a,
+=A0=A0=A0=A0 * or 0xff.
+=A0=A0=A0=A0 */
+
+=A0=A0=A0=A0 return 0;
+}
+
+/*
+ * IncrementalNew - We've got a device that doesn't appear to have any
+ * current existing raid superblock on it, check to see if we should b=
e
+ * claiming it based on DOMAIN entries in the config file.
+ *
+ * @devname - The device to investigate
+ *
+ * Special note: if we have partitioned devices, the whole disk device=
=20
+is
+ * going to get called into this code, we need to detect that the=20
+device
+ * is already in use and leave it be, where as if we get a truly new
+ * device we may need to partition it and set it up for the partitions=
=20
+to
+ * be added to various arrays later on in the hot plug process.
+ */
+int IncrementalNew(char *devname, int verbose, int export) {
+=A0=A0=A0=A0 struct domain_ent *domain;
+=A0=A0=A0=A0 char *devpath;
+=A0=A0=A0=A0 int rv;
+
+=A0=A0=A0=A0 domain =3D conf_get_domain(devname);
+=A0=A0=A0=A0 if (!domain)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (action(domain) <=3D incremental)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Nothing to do.=A0 We only get called=
 in the case that there
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * is no current superblock on the devic=
e in question, and
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * since our matching domain says we sho=
uld either ignore or
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * use devices incrementally, they have =
to already have a
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * superblock.=A0 Since we don't, we're =
done.
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 devpath =3D get_devpath_from_devname(devname);
+=A0=A0=A0=A0 if (strstr(devpath, "part") || action(domain) !=3D partit=
ion)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* We are on a partition, not a whole d=
isk, or we are on a
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * whole disk but we want to use the who=
le disk instead
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * of partitioning it */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalNewPart(devname, verb=
ose, export, domain);
+=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Only use this if we are dealing with=
 a disk that would
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * need partitioned.=A0 This will get ca=
lled even when our
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * disk actually already belongs to all =
the right arrays
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * and there is nothing to be done, so o=
nly do work here
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * if we really need to */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalNewDisk(devname, verb=
ose, export, domain);
+=A0=A0=A0=A0 free(devpath);
+=A0=A0=A0=A0 return rv;
+}
+
diff --git a/config.c b/config.c
index 10c10e2..bd80cd6 100644
--- a/config.c
+++ b/config.c
@@ -810,8 +810,7 @@ void domainline(char *line)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 /* Some sanity checks now that all the options are pars=
ed */
-=A0=A0=A0=A0 if ((de->action & force) &&
-=A0=A0=A0=A0 =A0=A0=A0 ((de->action & action_mask) <=3D incremental)) =
{
+=A0=A0=A0=A0 if (force(de) && (action(de) <=3D incremental)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": force makes n=
o sense with ignore or "
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "incremental, remov=
ing.\n");
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de->action &=3D action_mask;
@@ -822,7 +821,7 @@ void domainline(char *line)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(de->spare_group);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de->spare_group =3D NULL;
=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0 if ((de->action & action_mask) =3D=3D partition) {
+=A0=A0=A0=A0 if (action(de) =3D=3D partition) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (prev_path =3D NULL, path =3D de-=
>paths; path; )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((strstr(path->p=
ath, "part") !=3D NULL) ||
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 (path->pa=
th[strlen(path->path) - 1] =3D=3D '*')) { diff --git a/mdadm.c b/mdadm.=
c index 770fdfd..a111b47 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -73,6 +73,7 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0 int test =3D 0;
=A0=A0=A0=A0=A0 int export =3D 0;
=A0=A0=A0=A0=A0 int assume_clean =3D 0;
+=A0=A0=A0=A0 int new_disk =3D 0;
=A0=A0=A0=A0=A0 char *symlinks =3D NULL;
=A0=A0=A0=A0=A0 /* autof indicates whether and how to create device nod=
e.
=A0=A0=A0=A0=A0 =A0* bottom 3 bits are style.=A0 Rest (when shifted) ar=
e number of parts @@ -909,6 +910,9 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case O(INCREMENTAL, 'r'):
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rebuild_map =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 case O(INCREMENTAL, 'g'):
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 new_disk =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* We have now processed all the vali=
d options. Anything else is
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* an error
@@ -1513,6 +1517,11 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (rebuild_map) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 RebuildMap();
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (export && !new_disk) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ": --incremental --export only supporte=
d with --grab.\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (scan) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (runstop <=3D 0)=
 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
printf(stderr, Name
@@ -1524,8 +1533,18 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0": --incremental=
 --scan --fail not supported.\n");
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 b=
reak;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (new_disk > 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ": --incremental --sc=
an --grab not supported.\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bre=
ak;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalS=
can(verbose);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (devmode =3D=3D 'f' && new_disk) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ": --incremental --fail --grab makes no=
 sense.\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!devlist) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!rebuild_map &&=
 !scan) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
printf(stderr, Name
@@ -1540,12 +1559,15 @@ int main(int argc, char *argv[])
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (devmode =3D=3D 'f') {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (devmode =3D=3D 'f')
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalR=
emove(devlist->devname, verbose-quiet);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D Incremental(devlist->devname, ve=
rbose-quiet, runstop,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ss,=
 homehost, require_homehost, autof);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (new_disk > 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D IncrementalNew=
(devlist->devname, verbose-quiet,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0 export);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D Incremental(de=
vlist->devname, verbose-quiet,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 runstop, ss, homehost,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 require_homehost, autof);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0 case AUTODETECT:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 autodetect();
diff --git a/mdadm.h b/mdadm.h
index 4d5a630..3862853 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -292,6 +292,9 @@ enum domain_actions {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 other metadata on the=
m */
=A0};
=A0
+#define action(domain) ((domain)->action & action_mask) #define=20
+force(domain) ((domain)->action & force)
+
=A0struct domain_ent {
=A0=A0=A0=A0=A0 char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *spare_grou=
p; /* only set this in monitor mode
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0when we know what arrays we
@@ -854,6 +857,7 @@ extern int Incremental_container(struct supertype *=
st, char *devname,=A0 extern void RebuildMap(void);=A0 extern int Incre=
mentalScan(int verbose);=A0 extern int IncrementalRemove(char *devname,=
 int verbose);
+extern int IncrementalNew(char *devname, int verbose, int export);
=A0extern int CreateBitmap(char *filename, int force, char uuid[16],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long chunk=
size, unsigned long daemon_sleep,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long write=
_behind,
@@ -876,6 +880,7 @@ extern int check_partitions(int fd, char *dname, un=
signed long long freesize);
=A0
=A0extern int get_mdp_major(void);
=A0extern int dev_open(char *dev, int flags);
+extern int dev_open_check(char *dev, int flags, struct stat *stb);
=A0extern int open_dev(int devnum);
=A0extern int open_dev_excl(int devnum);
=A0extern int is_standard(char *dev, int *nump); diff --git a/util.c b/=
util.c index 1793b68..b93e21d 100644
--- a/util.c
+++ b/util.c
@@ -975,6 +975,30 @@ int dev_open(char *dev, int flags)
=A0=A0=A0=A0=A0 return fd;
=A0}
=A0
+int dev_open_check(char *devname, int flags, struct stat *stb) {
+=A0=A0=A0=A0 int dfd;
+
+=A0=A0=A0=A0 dfd =3D dev_open(devname, flags);
+=A0=A0=A0=A0 if (dfd < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": cannot open %s:=
 %s.\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devname, strerror(err=
no));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 if (fstat(dfd, stb) < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": fstat failed on=
 %s: %s.\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devname, strerror(err=
no));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 if ((stb->st_mode & S_IFMT) !=3D S_IFBLK) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": %s is not a blo=
ck device.\n", devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -1;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 return dfd;
+}
+
=A0int open_dev(int devnum)
=A0{
=A0=A0=A0=A0=A0 char buf[20];
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
