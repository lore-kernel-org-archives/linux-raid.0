From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 13/23] imsm: Add support for finalize expansion in
 imsm_set_disk()
Date: Wed, 9 Jun 2010 15:35:38 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8D9@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
To expand disks number in array imsm uses general migration.
Function imsm_set_disk() is called to set migration status and it has to know how to finalize general migration.
This causes that metadata can return from migration to normal state.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   37 +++++++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c index 9d1afe3..7ec7ec5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2324,7 +2324,8 @@ static void migrate(struct imsm_dev *dev, __u8 to_state, int migr_type)
 
 	/* duplicate and then set the target end state in map[0] */
 	memcpy(dest, src, sizeof_imsm_map(src));
-	if (migr_type == MIGR_REBUILD) {
+	if ((migr_type == MIGR_REBUILD) ||
+	    (migr_type ==  MIGR_GEN_MIGR)) {
 		__u32 ord;
 		int i;
 
@@ -4321,6 +4322,17 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,  }  #endif /* MDASSEMBLE */
 
+static int is_gen_migration(struct imsm_dev *dev) {
+	if (!dev->vol.migr_state)
+		return 0;
+
+	if (migr_type(dev) == MIGR_GEN_MIGR)
+		return 1;
+
+	return 0;
+}
+
 static int is_rebuilding(struct imsm_dev *dev)  {
 	struct imsm_map *migr_map;
@@ -4396,8 +4408,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 		 * unsupported migration
 		 */
 		if (dev->vol.migr_state &&
-		    (migr_type(dev) == MIGR_GEN_MIGR ||
-		     migr_type(dev) == MIGR_STATE_CHANGE)) {
+		    (migr_type(dev) == MIGR_STATE_CHANGE)) {
 			fprintf(stderr, Name ": cannot assemble volume '%.16s':"
 				" unsupported migration in progress\n",
 				dev->volume);
@@ -4619,7 +4630,8 @@ static int is_resyncing(struct imsm_dev *dev)
 
 	migr_map = get_imsm_map(dev, 1);
 
-	if (migr_map->map_state == IMSM_T_STATE_NORMAL)
+	if ((migr_map->map_state == IMSM_T_STATE_NORMAL) &&
+	    (dev->vol.migr_type != MIGR_GEN_MIGR))
 		return 1;
 	else
 		return 0;
@@ -4818,6 +4830,23 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		dprintf("imsm: mark failed\n");
 		end_migration(dev, map_state);
 		super->updates_pending++;
+	} else if (is_gen_migration(dev)) {
+		dprintf("imsm: Detected General Migration in state: ");
+		if (map_state == IMSM_T_STATE_NORMAL) {
+			end_migration(dev, map_state);
+			map = get_imsm_map(dev, 0);
+			map->failed_disk_num = ~0;
+			dprintf("normal\n");
+		} else {
+			if (map_state == IMSM_T_STATE_DEGRADED) {
+				printf("degraded\n");
+				end_migration(dev, map_state);
+			} else {
+				dprintf("failed\n");
+			}
+			map->map_state = map_state;
+		}
+		super->updates_pending++;
 	}
 }
 

