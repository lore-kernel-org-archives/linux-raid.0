From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 13/35] manage: domains support in Manage_subdev
Date: Mon, 16 Aug 2010 10:47:53 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9D8@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 11c805b9d7d7b875d15fc4bcf5ff42e3aef56553 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Thu, 17 Jun 2010 14:00:27 +0200
Subject: [PATCH 13/35] manage: domains support in Manage_subdev

if disk is added to array, it must belong the same domain as
current members of this array.
---
 Manage.c |   33 +++++++++++++++++++++++++++++++++
 util.c   |   15 ++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index 67bef11..e733c2d 100644
--- a/Manage.c
+++ b/Manage.c
@@ -354,6 +354,8 @@ int Manage_subdevs(char *devname, int fd,
 	int ouuid[4];
 	int lfd = -1;
 	int sysfd = -1;
+	struct domain_ent *arrdomain, *devdomain;
+	struct subset *arrsubset, *devsubset;
 
 	if (ioctl(fd, GET_ARRAY_INFO, &array)) {
 		fprintf(stderr, Name ": cannot get array info for %s\n",
@@ -361,6 +363,12 @@ int Manage_subdevs(char *devname, int fd,
 		return 1;
 	}
 
+	if (get_active_array_domain(devname, fd, &arrdomain, &arrsubset)) {
+		fprintf(stderr, Name " : Cannot determine domain for %s!\n",
+				     devname);
+		return 1;
+	}
+
 	/* array.size is only 32 bit and may be truncated.
 	 * So read from sysfs if possible, and record number of sectors
 	 */
@@ -531,6 +539,31 @@ int Manage_subdevs(char *devname, int fd,
 
 			st = dup_super(tst);
 
+			devdomain = conf_get_domain(dv->devname,
+						    (char *)st->ss->name);
+			if (!devdomain) {
+				fprintf(stderr, Name " : Cannot determine domain "
+						     " of device: %s\n", dv->devname);
+				close(tfd);
+				free(st);
+				return 1;
+			}
+			devsubset = conf_get_subset(dv->devname, st, devdomain);
+			if (!devsubset) {
+				fprintf(stderr, Name " : Cannot determine subset "
+						     " of device: %s\n", dv->devname);
+				close(tfd);
+				free(st);
+				return 1;
+			}
+			if (arrdomain != devdomain ||
+			    arrsubset != devsubset) {
+				fprintf(stderr, Name " : Domain/subdomain of "
+						     "disk differs of arrays'.");
+				close(tfd);
+				free(st);
+				return 1;
+			}
 			if (array.not_persistent==0)
 				st->ss->load_super(st, tfd, NULL);
 
diff --git a/util.c b/util.c
index 62544fd..a746b83 100644
--- a/util.c
+++ b/util.c
@@ -1893,7 +1893,20 @@ int get_active_array_domain(char *array_name, int fd, struct domain_ent **domain
 			st = dev_load_supertype(dm->name);
 			if (!st)
 				continue;
-			*domain = conf_get_domain(dm->name, me->metadata_version);
+			if (!strncmp(me->metadata_version, "external:", 9) &&
+			    is_subarray(me->metadata_version+9)) {
+				struct mdstat_ent *m;
+				for (m = mds; m; m = m->next)
+					if (devname2devnum(me->metadata_version+10) == m->devnum)
+						break;
+				if (!m)
+					continue;
+				*domain = conf_get_domain(dm->name,
+							  m->metadata_version);
+			} else {
+				*domain = conf_get_domain(dm->name,
+							  me->metadata_version);
+			}
 			if (!*domain) {
 				st->ss->free_super(st);
 				free(st);
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

