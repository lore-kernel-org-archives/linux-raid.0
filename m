From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 1/4] imsm: monitor: do not finish migration if there are no
 failed disks
Date: Thu, 05 Apr 2012 17:29:48 +0200
Message-ID: <20120405152948.19851.16491.stgit@linux.site>
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

Transition from "degraded" to "recovery" made in OROM is slightly different
than the same transision in mdadm. Missing disk is not removed from list of
raid devices, but just from map. Therefore mdadm should not end migration
basing on existence of list of missing disks but should rely on count of
failed disks.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index dad4c4d..e1cd9b8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6953,6 +6953,12 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 	if (!super->missing)
 		return;
 
+	/* When orom adds replacement for missing disk it does
+	 * not remove entry of missing disk, but just updates map with
+	 * new added disk. So it is not enough just to test if there is
+	 * any missing disk, we have to look if there are any failed disks
+	 * in map to stop migration */
+
 	dprintf("imsm: mark missing\n");
 	/* end process for initialization and rebuild only
 	 */
@@ -6963,7 +6969,8 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 		failed = imsm_count_failed(super, dev, MAP_0);
 		map_state = imsm_check_degraded(super, dev, failed, MAP_0);
 
-		end_migration(dev, super, map_state);
+		if (failed)
+			end_migration(dev, super, map_state);
 	}
 	for (dl = super->missing; dl; dl = dl->next)
 		mark_missing(dev, &dl->disk, dl->index);

