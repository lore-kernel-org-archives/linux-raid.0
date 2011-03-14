From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/3] External metadata has to be restored to initial state in
	error case
Date: Mon, 14 Mar 2011 15:09:38 +0100
Message-ID: <20110314140938.20478.52557.stgit@gklab-128-013.igk.intel.com>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When any error occurs in reshape_array(), mdadm should have ability
to rollback changes. Based on metadata knowledge abort_metadata_changes()
should decide:
1. metadata abort is allowed?
   In case of container operation abort can be allowed on first array only
   It depends on metadata implementation.
2. If rollback is possible, execute required action to prepare update.

Returned value is:
 1 if rollback succeed (send update)
 0 if rollback not possible (no action)
-1 for other error

Metadata handler can be called only if reshape is not started in md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c  |   26 ++++++++++++++++++++++++++
 mdadm.h |   10 ++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 40e693e..26fd7eb 100644
--- a/Grow.c
+++ b/Grow.c
@@ -594,6 +594,31 @@ static void sync_metadata(struct supertype *st)
 	}
 }
 
+static int abort_metadata_changes(struct supertype *st, struct mdinfo *sra,
+				  int restart)
+{
+	int ret_val = 0;
+	char action[40];
+
+	/* for not restarted external metadata only
+	 */
+	if (!st->ss->external || restart)
+		return ret_val;
+
+	/* check if reshape is not started in md
+	 */
+	if (sra && sysfs_get_str(sra, NULL, "sync_action", action, 40) > 0 &&
+	    strncmp(action, "reshape", 7) == 0)
+		return ret_val;
+
+	if (st->ss->abort_metadata_changes)
+		ret_val = st->ss->abort_metadata_changes(st);
+	if (ret_val > 0)
+		sync_metadata(st);
+
+	return ret_val;
+}
+
 static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int n)
 {
 	/* when dealing with external metadata subarrays we need to be
@@ -2187,6 +2212,7 @@ out:
 	exit(0);
 
 release:
+	abort_metadata_changes(st, sra, restart);
 	if (orig_level != UnSet && sra) {
 		c = map_num(pers, orig_level);
 		if (c && sysfs_set_str(sra, NULL, "level", c) == 0)
diff --git a/mdadm.h b/mdadm.h
index d3ed50a..d502b13 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -727,6 +727,16 @@ extern struct superswitch {
 		struct supertype *st, unsigned long blocks,
 		int *fds, unsigned long long *offsets,
 		int dests, int *destfd, unsigned long long *destoffsets);
+	/* abort_metadata_changes() will rollbacks metadata changes
+	 * in case of error.
+	 * It can be called for not restart case
+	 * and when reshape has not been started in md.
+	 * Function should return values:
+	 *    1 if abort succeed
+	 *    0 if abort not possible
+	 *   -1 for other error
+	 */
+	int (*abort_metadata_changes)(struct supertype *st);
 
 /* for mdmon */
 	int (*open_new)(struct supertype *c, struct active_array *a,

