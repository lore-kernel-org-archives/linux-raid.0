From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 1/3] imsm: set imsm spare uuid to 0
Date: Thu, 23 Dec 2010 15:12:22 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E5CFB9B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 27465b3b5beb86ecbfae8ffee6bdeb51109592b2 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 23 Dec 2010 12:01:26 +0100
Subject: [PATCH 1/3] imsm: set imsm spare uuid to 0
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

uuid_match_any is replaced by uuid_zero for imsm spares.

Function fixup_container_spare_uuid not needed as it gives
unwanted uuid to spares.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Detail.c      |    6 +++---
 mdadm.h       |    2 +-
 super-intel.c |   38 ++------------------------------------
 util.c        |    7 ++-----
 4 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/Detail.c b/Detail.c
index 9415628..e68a88a 100644
--- a/Detail.c
+++ b/Detail.c
@@ -159,16 +159,16 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 			continue;
 		}
 		/* some formats (imsm) have free-floating-spares
-		 * with a uuid of uuid_match_any, they don't
+		 * with a uuid of uuid_zero, they don't
 		 * have very good info about the rest of the
 		 * container, so keep searching when
 		 * encountering such a device.  Otherwise, stop
 		 * after the first successful call to
 		 * ->load_super.
 		 */
-		if (memcmp(uuid_match_any,
+		if (memcmp(uuid_zero,
 			   info->uuid,
-			   sizeof(uuid_match_any)) == 0) {
+			   sizeof(uuid_zero)) == 0) {
 			st->ss->free_super(st);
 			continue;
 		}
diff --git a/mdadm.h b/mdadm.h
index 36124de..d3e88bc 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1074,7 +1074,7 @@ extern int experimental(void);
 extern void free_line(char *line);
 extern int match_oneof(char *devices, char *devname);
 extern void uuid_from_super(int uuid[4], mdp_super_t *super);
-extern const int uuid_match_any[4];
+extern const int uuid_zero[4];
 extern int same_uuid(int a[4], int b[4], int swapuuid);
 extern void copy_uuid(void *a, int b[4], int swapuuid);
 extern char *__fname_from_uuid(int id[4], int swap, char *buf, char sep);
diff --git a/super-intel.c b/super-intel.c
index 3fc1c82..a3e68e9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1625,38 +1625,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	}
 }
 
-/* check the config file to see if we can return a real uuid for this spare */
-static void fixup_container_spare_uuid(struct mdinfo *inf)
-{
-	struct mddev_ident *array_list;
-
-	if (inf->array.level != LEVEL_CONTAINER ||
-	    memcmp(inf->uuid, uuid_match_any, sizeof(int[4])) != 0)
-		return;
-
-	array_list = conf_get_ident(NULL);
-
-	for (; array_list; array_list = array_list->next) {
-		if (array_list->uuid_set) {
-			struct supertype *_sst; /* spare supertype */
-			struct supertype *_cst; /* container supertype */
-
-			_cst = array_list->st;
-			if (_cst)
-				_sst = _cst->ss->match_metadata_desc(inf->text_version);
-			else
-				_sst = NULL;
-
-			if (_sst) {
-				memcpy(inf->uuid, array_list->uuid, sizeof(int[4]));
-				free(_sst);
-				break;
-			}
-		}
-	}
-}
-
-
 static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev, int failed);
 static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev);
 
@@ -1771,10 +1739,8 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	 */
 	if (info->disk.state & (1 << MD_DISK_SYNC) || super->anchor->num_raid_devs)
 		uuid_from_super_imsm(st, info->uuid);
-	else {
-		memcpy(info->uuid, uuid_match_any, sizeof(int[4]));
-		fixup_container_spare_uuid(info);
-	}
+	else
+		memcpy(info->uuid, uuid_zero, sizeof(uuid_zero));
 
 	/* I don't know how to compute 'map' on imsm, so use safe default */
 	if (map) {
diff --git a/util.c b/util.c
index 7544ce1..c4c31a3 100644
--- a/util.c
+++ b/util.c
@@ -375,13 +375,10 @@ int enough_fd(int fd)
 }
 
 
-const int uuid_match_any[4] = { ~0, ~0, ~0, ~0 };
+const int uuid_zero[4] = { 0, 0, 0, 0 };
+
 int same_uuid(int a[4], int b[4], int swapuuid)
 {
-	if (memcmp(a, uuid_match_any, sizeof(int[4])) == 0 ||
-	    memcmp(b, uuid_match_any, sizeof(int[4])) == 0)
-		return 1;
-
 	if (swapuuid) {
 		/* parse uuids are hostendian.
 		 * uuid's from some superblocks are big-ending
-- 
1.7.1

