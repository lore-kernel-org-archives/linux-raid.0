From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 02/13] map file: extract record update routine from
 map_update
Date: Thu, 22 Apr 2010 23:10:39 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3B3@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Routine modifying existing record in map file is now moved to new to new map_do_update() function. It allows to modify particular map_ent entry and use it with locking enabled.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 mapfile.c |   31 +++++++++++++++++++++----------
 mdadm.h   |    2 ++
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/mapfile.c b/mapfile.c
index 366ebe3..fe885c5 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -197,18 +197,15 @@ void map_free(struct map_ent *map)
 	}
 }
 
-int map_update(struct map_ent **mpp, int devnum, char *metadata,
-	       int *uuid, char *path)
+void map_do_update(struct map_ent **mpp, int devnum, char *metadata,
+		  int *uuid, char *path)
 {
-	struct map_ent *map, *mp;
-	int rv;
+	struct map_ent *mp;
 
-	if (mpp && *mpp)
-		map = *mpp;
-	else
-		map_read(&map);
+	if (!mpp)
+		return;
 
-	for (mp = map ; mp ; mp=mp->next)
+	for (mp = *mpp ; mp ; mp=mp->next)
 		if (mp->devnum == devnum) {
 			strcpy(mp->metadata, metadata);
 			memcpy(mp->uuid, uuid, 16);
@@ -217,7 +214,21 @@ int map_update(struct map_ent **mpp, int devnum, char *metadata,
 			break;
 		}
 	if (!mp)
-		map_add(&map, devnum, metadata, uuid, path);
+		map_add(mpp, devnum, metadata, uuid, path);
+}
+
+int map_update(struct map_ent **mpp, int devnum, char *metadata,
+	       int *uuid, char *path)
+{
+	struct map_ent *map;
+	int rv;
+
+	if (mpp && *mpp)
+		map = *mpp;
+	else
+		map_read(&map);
+
+	map_do_update(&map, devnum, metadata, uuid, path);
 	if (mpp)
 		*mpp = NULL;
 	rv = map_write(map);
diff --git a/mdadm.h b/mdadm.h
index 362b66b..f8a9e0c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -367,6 +367,8 @@ struct map_ent {
 	int	bad;
 	char	*path;
 };
+extern void map_do_update(struct map_ent **map, int devnum, char *metadata,
+			  int uuid[4], char *path);
 extern int map_update(struct map_ent **mpp, int devnum, char *metadata,
 		      int uuid[4], char *path);
 extern struct map_ent *map_by_uuid(struct map_ent **map, int uuid[4]);
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


