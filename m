From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 1/3] Use one function chosing spares from container
Date: Tue, 4 Jan 2011 15:04:02 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759FE0@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 1c6a89cda7f5f4b05ca0f9760d444f6e9e877559 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 23 Dec 2010 14:51:08 +0100
Subject: [PATCH 1/3] Use one function chosing spares from container
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

container_chose_spares in Monitor.c and
get_spares_for_grow in super-intel.c
do the same thing: search for spares in a container.

Another version will also be needed for Incremental
so a more general solution is presented here and
applied in two previous contexts.

Normally domlist==NULL would lead an empty list but
this is typically checked earlier so here it is interpreted
as "do not test domains".

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c     |   51 +++++++++++++--------------------------------------
 mdadm.h       |    6 +++++-
 super-intel.c |   46 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 55 insertions(+), 48 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index e79f658..428c227 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -828,59 +828,34 @@ static dev_t container_choose_spare(struct state *from, struct state *to,
 	/* This is similar to choose_spare, but we cannot trust devstate,
 	 * so we need to read the metadata instead
 	 */
-
+	struct mdinfo *list;
 	struct supertype *st = from->metadata;
 	int fd = open(from->devname, O_RDONLY);
 	int err;
-	struct mdinfo *disks, *d;
 	dev_t dev = 0;
 
 	if (fd < 0)
 		return 0;
-	if (!st->ss->getinfo_super_disks)
+	if (!st->ss->getinfo_super_disks) {
+		close(fd);
 		return 0;
+	}
 	
 	err = st->ss->load_container(st, fd, NULL);
 	close(fd);
 	if (err)
 		return 0;
-
-	disks = st->ss->getinfo_super_disks(st);
-	st->ss->free_super(st);
-
-	if (!disks)
-		return 0;
 	
-	for (d = disks->devs ; d && !dev ; d = d->next) {
-		if (d->disk.state == 0) {
-			struct dev_policy *pol;
-			unsigned long long dev_size;
-			dev = makedev(d->disk.major,d->disk.minor);
-			
-			if (min_size &&
-			    dev_size_from_id(dev,  &dev_size) &&
-			    dev_size < min_size) {
-				dev = 0;
-				continue;
-			}
-			if (from == to)
-				/* Just checking if destination already has
-				 * a spare, no need to check policy, we are
-				 * done.
-				 */
-				break;
-
-			pol = devnum_policy(dev);
-			if (from->spare_group)
-				pol_add(&pol, pol_domain,
-					from->spare_group, NULL);
-			if (!domain_test(domlist, pol, to->metadata->ss->name))
-				dev = 0;
-
-			dev_policy_free(pol);
-		}
+	/* We only need one spare so full list not needed */
+	list = container_chose_spares(st, min_size, domlist, from->spare_group,
+				      to->metadata->ss->name, 1);
+	if (list) {
+		struct mdinfo *disks = list->devs;
+		if (disks)
+			dev = makedev(disks->disk.major, disks->disk.minor);
+		sysfs_free(list);
 	}
-	sysfs_free(disks);
+	st->ss->free_super(st);
 	return dev;
 }
 
diff --git a/mdadm.h b/mdadm.h
index d3e88bc..dd5c901 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1095,7 +1095,11 @@ extern void append_metadata_update(struct supertype *st, void *buf, int len);
 extern int assemble_container_content(struct supertype *st, int mdfd,
 				      struct mdinfo *content, int runstop,
 				      char *chosen_name, int verbose);
-
+extern struct mdinfo *container_chose_spares(struct supertype *st,
+					     unsigned long long min_size,
+					     struct domainlist *domlist,
+					     char *spare_group,
+					     const char *metadata, int get_one);
 extern int add_disk(int mdfd, struct supertype *st,
 		    struct mdinfo *sra, struct mdinfo *info);
 extern int remove_disk(int mdfd, struct supertype *st,
diff --git a/super-intel.c b/super-intel.c
index c4100ef..a30dfaa 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6241,12 +6241,26 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
  */
 static struct mdinfo *get_spares_for_grow(struct supertype *st)
 {
-	dev_t dev = 0;
-	struct mdinfo *disks, *d, **dp;
 	unsigned long long min_size = min_acceptable_spare_size_imsm(st);
+	return container_chose_spares(st, min_size, NULL, NULL, NULL, 0);
+}
+
+/* Pick all spares matching given criteria from a container
+ * if min_size == 0 do not check size
+ * if domlist == NULL do not check domains
+ * if spare_group given add it to domains of each spare
+ * metadata allows to test domains using metadata of destination array */
+struct mdinfo *container_chose_spares(struct supertype *st,
+				      unsigned long long min_size,
+				      struct domainlist *domlist,
+				      char *spare_group,
+				      const char *metadata, int get_one)
+{
+	struct mdinfo *d, **dp, *disks = NULL;
 
-	/* get list of alldisks in container */
-	disks = getinfo_super_disks_imsm(st);
+	/* get list of all disks in container */
+	if (st->ss->getinfo_super_disks)
+		disks = st->ss->getinfo_super_disks(st);
 
 	if (!disks)
 		return NULL;
@@ -6259,17 +6273,31 @@ static struct mdinfo *get_spares_for_grow(struct supertype *st)
 		if (d->disk.state == 0) {
 			/* check if size is acceptable */
 			unsigned long long dev_size;
-			dev = makedev(d->disk.major,d->disk.minor);
-			if (min_size &&
-			    dev_size_from_id(dev,  &dev_size) &&
-			    dev_size >= min_size) {
-				dev = 0;
+			dev_t dev = makedev(d->disk.major,d->disk.minor);
+
+			if (!min_size ||
+			   (dev_size_from_id(dev,  &dev_size) &&
+			    dev_size >= min_size))
 				found = 1;
+			/* check if domain matches */
+			if (found && domlist) {
+				struct dev_policy *pol = devnum_policy(dev);
+				if (spare_group)
+					pol_add(&pol, pol_domain,
+						spare_group, NULL);
+				if (!domain_test(domlist, pol, metadata))
+					found = 0;
+				dev_policy_free(pol);
 			}
 		}
 		if (found) {
 			dp = &d->next;
 			disks->array.spare_disks++;
+			if (get_one) {
+				sysfs_free(*dp);
+				d->next = NULL;
+				return(disks);
+			}
 		} else {
 			*dp = d->next;
 			d->next = NULL;
-- 
1.7.1

