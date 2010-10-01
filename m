From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [AUTOREBUILD 8/8] Monitor: Helper functions added for spare_sharing
 in monitor
Date: Fri, 1 Oct 2010 13:59:21 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D171D09998@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

=46rom f423b226f10cfe3b416c5e0580dde45cd8ca887d Mon Sep 17 00:00:00 200=
1
=46rom: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 29 Sep 2010 05:39:53 +0200
Subject: [AUTOREBUILD 8/8] Monitor: Helper functions added for spare_sh=
aring in monitor

Helper functions added:
check_domain_match - checks domain policy matching of potential spare d=
isk
check_donor - checks if container/volume is eligible to give a spare di=
sk

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
=A0Monitor.c |=A0 122 +++++++++++++++++++++++++++++++++++++------------=
-----------
=A01 files changed, 75 insertions(+), 47 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index dd9e707..c6f9565 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -751,6 +751,70 @@ static struct supertype *get_super(struct state *s=
t)
=A0=A0=A0=A0=A0 return super;
=A0}
=A0
+/* checks if domains of potential spare disk and
+ * a volume/container domain under rebuild match
+ */
+static int check_domain_match(struct domainlist *dl,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 unsig=
ned devid,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 struc=
t supertype *super)
+{
+=A0=A0=A0=A0 struct dev_policy *policy =3D NULL;
+=A0=A0=A0=A0 struct mdinfo dinfo;
+=A0=A0=A0=A0 enum policy_action action;
+
+=A0=A0=A0=A0 dinfo.disk.major =3D major(devid);
+=A0=A0=A0=A0 dinfo.disk.minor =3D minor(devid);
+
+=A0=A0=A0=A0 policy =3D disk_policy(&dinfo);
+=A0=A0=A0=A0 /* Can only add a spare if device has at least one domain=
s */
+=A0=A0=A0=A0 if (pol_find(policy, pol_domain) =3D=3D NULL)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+
+=A0=A0=A0=A0 if (!domain_test(dl, policy, super->ss->name)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dprintf("domain test fails: %s"
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "(name: %s value: %s =
metadata: %s)\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dl->dom,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (policy) ? policy->na=
me : "NULL",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (policy) ? policy->va=
lue : "NULL",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->ss->name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* domain test fails */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 /* check if spare sharing allowed */
+=A0=A0=A0=A0 action =3D policy_action(policy, super->ss->name);
+=A0=A0=A0=A0 if (action < act_spare)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 return 1;
+}
+
+/* check if donoring volume/container:
+ * - has the same metadata
+ * - has not error reported
+ * - has not degraded volume
+ * Returns:
+ *=A0=A0 0 - do not use the volume/container
+ *=A0=A0 1 - volume/container can be potetial spare disk donor
+ */
+static int check_donor(struct state *st2, struct state *stp)
+{
+=A0=A0=A0=A0 struct state *vol;
+=A0=A0=A0=A0 int ext =3D (stp->volumes !=3D NULL);
+
+=A0=A0=A0=A0 if (st2->err || st2 =3D=3D stp)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if ((ext && st2->parent !=3D NULL) ||
+=A0=A0=A0=A0 =A0=A0=A0 (strcmp(stp->metadata_version, st2->metadata_ve=
rsion) !=3D 0))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (ext) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* if container has degraded volume
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * we can't remove spares */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (vol =3D st2->volumes; vol; vol =3D=
 vol->volumes)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (vol->active < vol=
->raid)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn 0;
+=A0=A0=A0=A0 } else if (st2->active < st2->raid)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 return 1;
+}
=A0
=A0/* If an array has active < raid && spare =3D=3D 0
=A0 * Look for another array/container with unused, unfailed spare
@@ -760,8 +824,8 @@ static struct supertype *get_super(struct state *st=
)
=A0static void spare_sharing(struct state *statelist, char *mailaddr,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 char *mailfrom,=
 char *alert_cmd, int dosyslog)
=A0{
-=A0=A0=A0=A0 struct state *st, *stp, *vol, *st2 =3D NULL;
-=A0=A0=A0=A0 int i, ext, found;
+=A0=A0=A0=A0 struct state *st, *stp, *st2 =3D NULL;
+=A0=A0=A0=A0 int i, found;
=A0=A0=A0=A0=A0 struct mdinfo *sra =3D NULL;
=A0=A0=A0=A0=A0 struct domainlist *dl =3D NULL;
=A0=A0=A0=A0=A0 struct supertype *super =3D NULL;
@@ -770,7 +834,7 @@ static void spare_sharing(struct state *statelist, =
char *mailaddr,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (st->err || st->active =3D=3D st->=
raid || st->spare > 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 found =3D 0;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ext =3D is_external(st->metadata_versio=
n);
+
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* for exernal metadata spare will =
be moved to parent container
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0*/
@@ -811,65 +875,29 @@ static void spare_sharing(struct state *statelist=
, char *mailaddr,
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* search for an array/container with=
 unused spare */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (st2 =3D statelist; st2; st2 =3D =
st2->next) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (st2->err || st2 =3D=
=3D stp)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((ext && st2->pare=
nt !=3D NULL) ||
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 (strcmp(stp=
->metadata_version,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0 st2->metadata_version) !=3D 0))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* check if donor con=
tainer/volume */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!check_donor(st2,=
 stp))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 c=
ontinue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ext) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
if container has degraded volume
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * w=
e can't remove spares */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for=
 (vol =3D st2->volumes; vol; vol =3D vol->volumes)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 if (vol->active < vol->raid)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(vol)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(st2->active < st2->raid)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* update the disk =
info in st2 state */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sra =3D get_raid_di=
sk_info(st2);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!sra) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, "no sra for device: %s\n",
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 st2->devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "Cannot retrive the disk states "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "for device: %s\n", st2->devname);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 c=
ontinue;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_free(sra);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < s=
t2->total; i++) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 str=
uct dev_policy *policy =3D NULL;
-=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struc=
t mdinfo dinfo;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enu=
m policy_action action;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (!dev_suitable(st2->devid[i],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 st2->devstate[i],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 st->min_size))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 continue;
-
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 din=
fo.disk.major =3D major(st2->devid[i]);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 din=
fo.disk.minor =3D minor(st2->devid[i]);
-
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pol=
icy =3D disk_policy(&dinfo);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
Can only add a spare if device has at least
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 one domains */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(pol_find(policy, pol_domain) =3D=3D NULL)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(!check_domain_match(dl,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st2->devid[i],
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 continue;
=A0
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(!domain_test(dl, policy, super->ss->name)) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 /* domain test fails */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 dprintf("domain test fails: %s"
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "(name: %s value: %s metadata: %s)\n",
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dl->dom,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (policy) ? policy->name : "NULL",
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (policy) ? policy->value : "NULL",
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->ss->name);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
check if spare sharing alowed */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 act=
ion =3D policy_action(policy, super->ss->name);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(action < act_spare)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (move_spare(st2, stp, &st2->devid[i],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0 mailaddr, mailfrom, alert_cmd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0 dosyslog)) {
--=20
1.6.4.2



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
