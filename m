From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 08/31] Send information to managemon about reshape request
Date: Tue, 9 Nov 2010 17:00:57 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA97@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

When monitor made metadata update and indicates request to managemon to continue reshape initialization, kick managemon to perform its action, unless array is not during deactivation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/monitor.c     |   15 ++++++++++++++-
 mdadm/mdadm/super-intel.c |   16 ++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/mdadm/mdadm/monitor.c b/mdadm/mdadm/monitor.c index 313c8af..e51bf7f 100644
--- a/mdadm/mdadm/monitor.c
+++ b/mdadm/mdadm/monitor.c
@@ -23,6 +23,7 @@
 #include <sys/syscall.h>
 #include <sys/select.h>
 #include <signal.h>
+#include <limits.h>
 
 static char *array_states[] = {
 	"clear", "inactive", "suspended", "readonly", "read-auto", @@ -353,8 +354,20 @@ static int read_and_act(struct active_array *a)
 		signal_manager();
 	}
 
-	if (deactivate)
+	if (deactivate) {
 		a->container = NULL;
+		/* break reshape also
+		 */
+		if (a->reshape_delta_disks !=  RESHAPE_IN_PROGRESS)
+			a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
+	}
+
+	/* signal manager when real delta_disks value is present
+	 */
+	if ((a->reshape_delta_disks != RESHAPE_NOT_ACTIVE) &&
+	    (a->reshape_delta_disks != RESHAPE_IN_PROGRESS)) {
+		signal_manager();
+	}
 
 	return dirty;
 }
diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index 100a19c..baf8ef4 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -4755,6 +4755,18 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	__u8 map_state = imsm_check_degraded(super, dev, failed);
 	__u32 blocks_per_unit;
 
+	if (a->reshape_delta_disks != RESHAPE_NOT_ACTIVE) {
+		/* array state change is blocked due to reshape action
+		 * if reshape_delta_disks is set there are no real
+		 * changes to array made so far, metadata changes
+		 * are during applying only before reshape.
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
@@ -5106,6 +5118,10 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 
 	dprintf("imsm: activate spare: inst=%d failed=%d (%d) level=%d\n",
 		inst, failed, a->info.array.raid_disks, a->info.array.level);
+
+	if (a->reshape_delta_disks != RESHAPE_NOT_ACTIVE)
+		return NULL;
+
 	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
 		return NULL;
 

