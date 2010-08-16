From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 10/35] update domain search to new structures, added subset
 search
Date: Mon, 16 Aug 2010 10:43:28 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9C4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 8b07c27ee59665fc0ab874e5ad807b0cef8fef24 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Mon, 28 Jun 2010 15:52:55 +0100
Subject: [PATCH 10/35] update domain search to new structures, added subset search

new domain/subset model needs some changes in the interface of
existing domain solution. Finding domain for device needs additionally
the type of metadata we are looking for.
For subsets we need supertype with loaded superblock as argument, in
order to get internal spare group identifier of device (if available).
Patch contains also utility stuff to make use of conf_get_domain/subset
easier (e.g. get_active_array_domain allows to get domain/subset pair
for running array giving its name)

Conflicts:

	mapfile.c
---
 config.c |   29 ++++++++++++++++++++++++++---
 mdadm.h  |    4 +++-
 util.c   |   39 ++++++++++++++++++++++++++++++---------
 3 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/config.c b/config.c
index 6c90d26..5829182 100644
--- a/config.c
+++ b/config.c
@@ -1003,6 +1003,28 @@ static struct supertype *get_supertype_by_name(char *platform)
 	return NULL;
 }
 
+int match_platform(struct supertype *supertype, char *type)
+{
+	char *platform;
+	struct supertype *st;
+	int rv;
+
+	/* fix 1.x stored in super1.name */
+	platform = strdup(type);
+	if (!platform)
+		return 0;
+
+	if (!strcmp(platform, "1.x")) {
+		platform[2] = '0';
+	}
+	st = supertype->ss->match_metadata_desc(platform);
+	rv = (st != NULL);
+
+	free(st);
+	free(platform);
+
+	return rv;
+}
 /* returns domain basing on path matching and superblock type (in that order).
  * If st==NULL, just match paths.
  */
@@ -1024,7 +1046,8 @@ struct domain_ent *get_domain_from_devpath(char *devpath, char *platform)
 				st = get_supertype_by_name(de->platform);
 				if (!st)
 					continue;
-				if (st->ss->match_metadata_desc(platform)) {
+				
+				if (match_platform(st, platform)) {
 					st->ss->free_super(st);
 					free(st);
 					return de;
@@ -1241,8 +1264,8 @@ static void domain_make_platforms(struct domain_ent *de)
 				free_domain_list(&domain_list);
 				return;
 			}
-			free(de->platform);
-			de->platform = strdup(name);
+			free(de_new->platform);
+			de->platform = name;
 			de = de_new;
 		} else {
 			de->platform = name;
diff --git a/mdadm.h b/mdadm.h
index 0a84abd..8548a91 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1016,8 +1016,10 @@ extern int stat2devnum(struct stat *st);
 extern int fd2devnum(int fd);
 extern char *get_devpath_from_devname(char *devname);
 extern char *get_array_devname(char *array);
+extern char *get_array_devname_by_uuid(int (*uuid)[4]);
 extern struct supertype *dev_load_supertype(char *devname);
-extern int get_active_array_domain(char *array_name, struct domain_ent **domain,
+extern int get_active_array_domain(char *array_name, int fd,
+				   struct domain_ent **domain,
 				   struct subset **subset);
 extern int is_external(char *metadata_verison);
 
diff --git a/util.c b/util.c
index cf08add..62544fd 100644
--- a/util.c
+++ b/util.c
@@ -1820,17 +1820,19 @@ struct supertype *dev_load_supertype(char *devname)
 	strcpy(devpath, "/dev/");
 	strcat(devpath, devname);
 	fd = open(devpath, O_RDONLY);
-	if (!fd) {
+	if (fd < 0) {
 		free(devpath);
 		return NULL;
 	}
 	st = guess_super(fd);
 	if (!st) {
 		free(devpath);
+		close(fd);
 		return NULL;
 	}
 	if (st->ss->load_super(st, fd, devpath)) {
 		free(devpath);
+		close(fd);
 		return NULL;
 	}
 
@@ -1842,20 +1844,39 @@ struct supertype *dev_load_supertype(char *devname)
 /* Sets domain and subset appropriately to the domain/subset of first
  * accessible array member. Returns !0 for failure.
  */
-int get_active_array_domain(char *array_name, struct domain_ent **domain,
-			  struct subset **subset)
+int get_active_array_domain(char *array_name, int fd, struct domain_ent **domain,
+			    struct subset **subset)
 {
 	struct mdstat_ent *mds, *me;
 	struct supertype *st;
 	struct dev_member *dm;
-	char *name;
+	mdu_array_info_t array;
+	int md_opened = fd >= 0;
+
+	memset(&array, 0, sizeof(mdu_array_info_t));
 
-	if (!domain || !subset)
+	if (!domain || !subset || !array_name)
 		return 1;
 
-	name = strrchr(array_name, '/');
-	if (!name++)
-		name = array_name;
+	if (fd < 0) {
+		fd = open(array_name, O_RDONLY);
+		if (fd < 0) {
+			fprintf(stderr, Name ": error opening %s: %s\n",
+				array_name, strerror(errno));
+			return 1;
+		}
+	}
+
+	if (ioctl(fd, GET_ARRAY_INFO, &array)) {
+		fprintf(stderr, Name ": cannot get array info for %s\n",
+			array_name);
+		if (!md_opened)
+			close(fd);
+		return 1;
+	}
+
+	if (!md_opened)
+		close(fd);
 
 	mds = mdstat_read(0, 0);
 	if (!mds) {
@@ -1864,7 +1885,7 @@ int get_active_array_domain(char *array_name, struct domain_ent **domain,
 	}
 
 	for (me = mds; me; me = me->next) {
-		if (!strstr(me->dev, name))
+		if (array.md_minor != me->devnum)
 			continue;
 
 		/* try to obtain domain/subset for first available member */
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

