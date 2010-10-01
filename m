From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [AUTOREBUILD 7/8] Monitor: Respect policy in auto-rebuild in
 mdadm monitoring.
Date: Fri, 1 Oct 2010 13:58:13 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D171D09993@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

=46rom 92f0a71f94a4568647e137f8f0d857be7fd482df Mon Sep 17 00:00:00 200=
1
=46rom: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 29 Sep 2010 05:32:29 +0200
Subject: [AUTOREBUILD 7/8] Monitor: Respect policy in auto-rebuild in m=
dadm monitoring.

Respect policy definition from mdadm.conf.
=46or each degraded volume/container, its policy is retrieved. In next =
steps
potential donor container/volume is searched for a spare disk,
=46or each spare disk we check if the domain matches and verify is the =
action
token allows for spare sharing. *spare* action is minimum to let spare =
sharing=20
in the same policy domain.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
=A0Monitor.c |=A0=A0 97 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++-------
=A01 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 62cbe98..dd9e707 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -724,6 +724,33 @@ static int dev_suitable(unsigned devid, int devsta=
te, unsigned long long size)
=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
+struct state *get_parent(struct state *st)
+{
+=A0=A0=A0=A0 if (is_external(st->metadata_version))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return st->parent;
+=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return st;
+}
+
+static struct supertype *get_super(struct state *st)
+{
+=A0=A0=A0=A0 struct supertype *super =3D NULL;
+=A0=A0=A0=A0 char *metadata =3D NULL;
+=A0=A0=A0=A0 int i;
+
+=A0=A0=A0=A0 if (is_external(st->metadata_version)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st =3D st->parent;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!st)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 metadata =3D st->metadata_version + str=
len("external:");
+=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 metadata =3D st->metadata_version;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 for (i =3D 0; !super && superlist[i]; i++)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super =3D superlist[i]->match_metadata_=
desc(metadata);
+=A0=A0=A0=A0 return super;
+}
+
=A0
=A0/* If an array has active < raid && spare =3D=3D 0
=A0 * Look for another array/container with unused, unfailed spare
@@ -736,40 +763,51 @@ static void spare_sharing(struct state *statelist=
, char *mailaddr,
=A0=A0=A0=A0=A0 struct state *st, *stp, *vol, *st2 =3D NULL;
=A0=A0=A0=A0=A0 int i, ext, found;
=A0=A0=A0=A0=A0 struct mdinfo *sra =3D NULL;
+=A0=A0=A0=A0 struct domainlist *dl =3D NULL;
+=A0=A0=A0=A0 struct supertype *super =3D NULL;
=A0
=A0=A0=A0=A0=A0 for (st =3D statelist; st; st =3D st->next) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (st->err || st->active =3D=3D st->=
raid || st->spare > 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
-
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 found =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ext =3D is_external(st->metadata_vers=
ion);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* for exernal metadata spare will =
be moved to parent container
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0*/
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ext) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stp =3D st->parent;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!stp)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stp =3D st;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* get member device state updated */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stp =3D get_parent(st);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!stp)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super =3D get_super(st);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!super)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* get the disk state updated */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sra =3D get_raid_disk_info(stp);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!sra) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dprintf("no sra for=
 device: %s\n", stp->devname);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_free(sra);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < stp->total; i++)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (dev_suitable(st=
p->devid[i], stp->devstate[i],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =A0st->min_size))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 b=
reak;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (i < stp->total)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (i < stp->total) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* there is a spare=
 in array/parent container,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* it was probabl=
y just added
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* but mdmon has =
not started recovery yet
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0* we will not ad=
d any more spares for now */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_free(sra);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* get the array/volume domain */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dl =3D domain_from_array(sra, super->ss=
->name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_free(sra);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!dl) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dprintf("domain: %p n=
ame: %s dev: %s meta: %s\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dl,=
 (dl) ? dl->dom : "NULL", stp->devname,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sup=
er->ss->name);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* search for an array/container with=
 unused spare */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (st2 =3D statelist; st2; st2 =3D =
st2->next) {
@@ -791,12 +829,47 @@ static void spare_sharing(struct state *statelist=
, char *mailaddr,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (st2->active < st2->raid)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 continue;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* support for domain=
 comparision needed */
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* update the disk in=
fo in st2 state */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sra =3D get_raid_disk=
_info(st2);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!sra) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, "no sra for device: %s\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 st2->devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_free(sra);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < s=
t2->total; i++) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 str=
uct dev_policy *policy =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 str=
uct mdinfo dinfo;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enu=
m policy_action action;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (!dev_suitable(st2->devid[i],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0st2->devstate[i],
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 st->min_size))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 din=
fo.disk.major =3D major(st2->devid[i]);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 din=
fo.disk.minor =3D minor(st2->devid[i]);
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pol=
icy =3D disk_policy(&dinfo);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
Can only add a spare if device has at least
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0 one domains */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(pol_find(policy, pol_domain) =3D=3D NULL)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(!domain_test(dl, policy, super->ss->name)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 /* domain test fails */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 dprintf("domain test fails: %s"
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "(name: %s value: %s metadata: %s)\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dl->dom,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (policy) ? policy->name : "NULL",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (policy) ? policy->value : "NULL",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 super->ss->name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
check if spare sharing alowed */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 act=
ion =3D policy_action(policy, super->ss->name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(action < act_spare)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
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
