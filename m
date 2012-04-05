From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2/4] imsm: clean up missing disks if there are any left after
 migration
Date: Thu, 05 Apr 2012 17:30:21 +0200
Message-ID: <20120405153021.19851.74528.stgit@linux.site>
References: <20120405152553.19851.48052.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405152553.19851.48052.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

It is for compatibility with OROM way to set "recovery" state.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e1cd9b8..f843997 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7211,6 +7211,8 @@ skip_mark_checkpoint:
 	return consistent;
 }
 
+static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned index);
+
 static void imsm_set_disk(struct active_array *a, int n, int state)
 {
 	int inst = a->info.container_member;
@@ -7260,6 +7262,11 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 			dprintf("while rebuilding");
 			end_migration(dev, super, map_state);
 			map = get_imsm_map(dev, MAP_0);
+			/* sweep list of missing disks, OROM might leave
+			 * some residuals from old members */
+			while (super->missing) {
+				imsm_delete(super, &super->missing, super->missing->index);
+			}
 			map->failed_disk_num = ~0;
 			super->updates_pending++;
 			a->last_checkpoint = 0;
@@ -7792,8 +7799,6 @@ static int remove_disk_super(struct intel_super *super, int major, int minor)
 	return 0;
 }
 
-static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned index);
-
 static int add_remove_disk_update(struct intel_super *super)
 {
 	int check_degraded = 0;

