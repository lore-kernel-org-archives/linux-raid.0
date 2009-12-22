From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 07/13] mdmon: cleanup manage_member() leak
Date: Tue, 22 Dec 2009 16:59:55 -0700
Message-ID: <20091222235955.31628.72779.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

free() the results of activate_spare().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 managemon.c |   85 ++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/managemon.c b/managemon.c
index 5958e18..19effe4 100644
--- a/managemon.c
+++ b/managemon.c
@@ -209,16 +209,22 @@ struct metadata_update *update_queue = NULL;
 struct metadata_update *update_queue_handled = NULL;
 struct metadata_update *update_queue_pending = NULL;
 
-void check_update_queue(struct supertype *container)
+static void free_updates(struct metadata_update **update)
 {
-	while (update_queue_handled) {
-		struct metadata_update *this = update_queue_handled;
-		update_queue_handled = this->next;
+	while (*update) {
+		struct metadata_update *this = *update;
+
+		*update = this->next;
 		free(this->buf);
-		if (this->space)
-			free(this->space);
+		free(this->space);
 		free(this);
 	}
+}
+
+void check_update_queue(struct supertype *container)
+{
+	free_updates(&update_queue_handled);
+
 	if (update_queue == NULL &&
 	    update_queue_pending) {
 		update_queue = update_queue_pending;
@@ -376,8 +382,9 @@ static void manage_member(struct mdstat_ent *mdstat,
 
 	if (a->check_degraded) {
 		struct metadata_update *updates = NULL;
-		struct mdinfo *newdev;
+		struct mdinfo *newdev = NULL;
 		struct active_array *newa;
+		struct mdinfo *d;
 
 		a->check_degraded = 0;
 
@@ -385,34 +392,46 @@ static void manage_member(struct mdstat_ent *mdstat,
 		 * to check.
 		 */
 		newdev = a->container->ss->activate_spare(a, &updates);
-		if (newdev) {
-			struct mdinfo *d;
-			/* Cool, we can add a device or several. */
-			newa = duplicate_aa(a);
-			/* suspend recovery - maybe not needed */
-
-			/* Add device to array and set offset/size/slot.
-			 * and open files for each newdev */
-			for (d = newdev; d ; d = d->next) {
-				struct mdinfo *newd;
-				if (sysfs_add_disk(&newa->info, d, 0) < 0)
-					continue;
-				newd = malloc(sizeof(*newd));
-				*newd = *d;
-				newd->next = newa->info.devs;
-				newa->info.devs = newd;
-
-				newd->state_fd = sysfs_open(a->devnum,
-							    newd->sys_name,
-							    "state");
-				newd->prev_state
-					= read_dev_state(newd->state_fd);
-				newd->curr_state = newd->prev_state;
+		if (!newdev)
+			return;
+
+		newa = duplicate_aa(a);
+		if (!newa)
+			goto out;
+		/* Cool, we can add a device or several. */
+
+		/* Add device to array and set offset/size/slot.
+		 * and open files for each newdev */
+		for (d = newdev; d ; d = d->next) {
+			struct mdinfo *newd;
+
+			newd = malloc(sizeof(*newd));
+			if (!newd)
+				continue;
+			if (sysfs_add_disk(&newa->info, d, 0) < 0) {
+				free(newd);
+				continue;
 			}
-			queue_metadata_update(updates);
-			replace_array(a->container, a, newa);
-			sysfs_set_str(&a->info, NULL, "sync_action", "recover");
+			*newd = *d;
+			newd->next = newa->info.devs;
+			newa->info.devs = newd;
+
+			newd->state_fd = sysfs_open(a->devnum, newd->sys_name,
+						    "state");
+			newd->prev_state = read_dev_state(newd->state_fd);
+			newd->curr_state = newd->prev_state;
+		}
+		queue_metadata_update(updates);
+		updates = NULL;
+		replace_array(a->container, a, newa);
+		sysfs_set_str(&a->info, NULL, "sync_action", "recover");
+ out:
+		while (newdev) {
+			d = newdev->next;
+			free(newdev);
+			newdev = d;
 		}
+		free_updates(&updates);
 	}
 }
 

