From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 22/53] Send information to managemon about reshape request
Date: Fri, 26 Nov 2010 09:06:45 +0100
Message-ID: <20101126080645.5221.32785.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When monitor made metadata update and indicates request to managemon to continue reshape initialization, kick managemon to perform its action, unless array is not during deactivation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c     |   14 +++++++++++++-
 super-intel.c |   14 ++++++++++++++
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index 5705a9b..05bd96c 100644
--- a/monitor.c
+++ b/monitor.c
@@ -399,8 +399,20 @@ static int read_and_act(struct active_array *a)
 		signal_manager();
 	}
 
-	if (deactivate)
+	if (deactivate) {
 		a->container = NULL;
+		/* break reshape also
+		 */
+		if (a->reshape_state !=  reshape_in_progress)
+			a->reshape_state = reshape_not_active;
+	}
+
+	/* signal manager when real delta_disks value is present
+	 */
+	if ((a->reshape_state != reshape_not_active) &&
+	    (a->reshape_state != reshape_in_progress)) {
+		signal_manager();
+	}
 
 	return dirty;
 }
diff --git a/super-intel.c b/super-intel.c
index 1231fa8..56f7ea4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4755,6 +4755,16 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	__u8 map_state = imsm_check_degraded(super, dev, failed);
 	__u32 blocks_per_unit;
 
+	if (a->reshape_state != reshape_not_active) {
+		/* array state change is blocked due to reshape action
+		 * metadata changes are during applying only before reshape.
+		 *
+		 * '1' is returned to indicate that array is clean
+		 */
+		dprintf("imsm: prepare to reshape\n");
+		return 1;
+	}
+
 	/* before we activate this array handle any missing disks */
 	if (consistent == 2)
 		handle_missing(super, dev);
@@ -5106,6 +5116,10 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 
 	dprintf("imsm: activate spare: inst=%d failed=%d (%d) level=%d\n",
 		inst, failed, a->info.array.raid_disks, a->info.array.level);
+
+	if (a->reshape_state != reshape_not_active)
+		return NULL;
+
 	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
 		return NULL;
 

