From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/11] imsm: FIX: Finalize degraded migration
Date: Thu, 24 Nov 2011 13:17:42 +0100
Message-ID: <20111124121742.5254.87669.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Currently mdadm for IMSM can finalize not-degraded migration only.
Add support for IMSM  for migration finalization when array
are is degraded state.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 7587c8c..a3ca78a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6417,20 +6417,24 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		a->last_checkpoint = 0;
 	} else if (is_gen_migration(dev)) {
 		dprintf("imsm: Detected General Migration in state: ");
-		if (map_state == IMSM_T_STATE_NORMAL) {
-			end_migration(dev, map_state);
+
+		switch (map_state) {
+		case IMSM_T_STATE_NORMAL:
+			dprintf("normal\n");
+			if (a->last_checkpoint >= a->info.component_size)
+				end_migration(dev, map_state);
 			map = get_imsm_map(dev, 0);
 			map->failed_disk_num = ~0;
-			dprintf("normal\n");
-		} else {
-			if (map_state == IMSM_T_STATE_DEGRADED) {
-				printf("degraded\n");
+		break;
+		case IMSM_T_STATE_DEGRADED:
+			dprintf("degraded\n");
+			if (a->last_checkpoint >= a->info.component_size)
 				end_migration(dev, map_state);
-			} else {
-				dprintf("failed\n");
-			}
-			map->map_state = map_state;
+		break;
+		default:
+			dprintf("failed\n");
 		}
+		map->map_state = map_state;
 		super->updates_pending++;
 	}
 }

