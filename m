From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/9] imsm: FIX: Add array map state transition for failures
	during initialization
Date: Wed, 07 Dec 2011 13:58:15 +0100
Message-ID: <20111207125814.25279.17592.stgit@gklab-128-013.igk.intel.com>
References: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

During initialization disk failure can occur also. Add code for such case
in imsm_set_disk() to support such event.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 973b22f..217a196 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5718,6 +5718,25 @@ static int is_rebuilding(struct imsm_dev *dev)
 		return 0;
 }
 
+static int is_initializing(struct imsm_dev *dev)
+{
+	struct imsm_map *migr_map;
+
+	if (!dev->vol.migr_state)
+		return 0;
+
+	if (migr_type(dev) != MIGR_INIT)
+		return 0;
+
+	migr_map = get_imsm_map(dev, 1);
+
+	if (migr_map->map_state == IMSM_T_STATE_UNINITIALIZED)
+		return 1;
+
+	return 0;
+
+}
+
 static void update_recovery_start(struct intel_super *super,
 					struct imsm_dev *dev,
 					struct mdinfo *array)
@@ -6501,6 +6520,12 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 			super->updates_pending++;
 			break;
 		}
+		if (is_initializing(dev)) {
+			dprintf("while initialization.");
+			map->map_state = map_state;
+			super->updates_pending++;
+			break;
+		}
 	break;
 	case IMSM_T_STATE_FAILED: /* transition to failed state */
 		dprintf("failed: ");

