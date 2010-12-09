From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/29] Process reshape initialization by managemon
Date: Thu, 09 Dec 2010 16:19:22 +0100
Message-ID: <20101209151922.26876.66752.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Monitor signals request to managemon (using reshape_delta_disks variable).
This caused call to reshape_array() vector. It prepares second metadata update for added disks slot verification.
Slots are set by md during reshape start and they are unknown to user space so far.
Second update is sent after reshape is started. During this update processing, metadata is checked against slot numbers set by md and in mismatch case information metadata is updated.

The reshape is being stared in delayed state due to sync_max was set to 0. After this reshape_delta_disk is set to 'in progress' value to avoid reentry.
Reshape process is continued in mdadm.

If reshape cannot be started or any failure condition occurs, 'cancel' message is prepared by reshape_array() and send to monitor, to rollback metadata changes.
Mdadm is informed about failure by idle array state.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.h     |   27 +++++++++++++++++++
 2 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index 945b173..c48b114 100644
--- a/managemon.c
+++ b/managemon.c
@@ -398,6 +398,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 	 */
 	char buf[64];
 	int frozen;
+	struct active_array *newa = NULL;
 
 	// FIXME
 	a->info.array.raid_disks = mdstat->raid_disks;
@@ -409,6 +410,91 @@ static void manage_member(struct mdstat_ent *mdstat,
 	else
 		frozen = 1; /* can't read metadata_version assume the worst */
 
+	if ((a->reshape_state != reshape_not_active) &&
+	    (a->reshape_state != reshape_in_progress)) {
+		dprintf("Reshape signals need to manage this member\n");
+		if (a->container->ss->reshape_array) {
+			struct metadata_update *updates = NULL;
+			struct mdinfo *newdev = NULL;
+			struct mdinfo *d;
+
+			newdev = newa->container->ss->reshape_array(newa,
+							reshape_in_progress,
+							&updates);
+			if (newdev) {
+				int status_ok = 1;
+				newa = duplicate_aa(a);
+				if (newa == NULL)
+					goto reshape_out;
+
+				for (d = newdev; d ; d = d->next) {
+					struct mdinfo *newd;
+
+					newd = malloc(sizeof(*newd));
+					if (!newd) {
+						status_ok = 0;
+						dprintf("Cannot allocate "\
+							"memory\n");
+						continue;
+					}
+					if (sysfs_add_disk(&newa->info,
+							   d,
+							   0) < 0) {
+						free(newd);
+						status_ok = 0;
+						dprintf("Cannot add disk "\
+							"to array.\n");
+						continue;
+					}
+					disk_init_and_add(newd, d, newa);
+				}
+				/* go with reshape
+				 */
+				if (status_ok)
+					if (sysfs_set_num(&newa->info,
+							  NULL,
+							  "sync_max",
+							  0) < 0)
+						status_ok = 0;
+				if (status_ok && sysfs_set_str(&newa->info,
+							      NULL,
+							      "sync_action",
+							      "reshape") == 0) {
+					/* reshape executed
+					 */
+					dprintf("Reshape was started\n");
+					replace_array(a->container, a, newa);
+					a = newa;
+				} else {
+					/* on problems cancel update
+					 */
+					free_aa(newa);
+					free_updates(&updates);
+					updates = NULL;
+					a->container->ss->reshape_array(a,
+							reshape_cancel_request,
+							&updates);
+					sysfs_set_str(&a->info,
+						      NULL,
+						      "sync_action",
+						      "idle");
+				}
+			}
+			dprintf("Send metadata update for reshape.\n");
+
+			queue_metadata_update(updates);
+			updates = NULL;
+			wakeup_monitor();
+reshape_out:
+			while (newdev) {
+				d = newdev->next;
+				free(newdev);
+				newdev = d;
+			}
+			free_updates(&updates);
+		}
+	}
+
 	if (a->check_degraded && !frozen) {
 		struct metadata_update *updates = NULL;
 		struct mdinfo *newdev = NULL;
diff --git a/mdadm.h b/mdadm.h
index ba3a9c5..e2f273f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -520,6 +520,7 @@ extern char *map_dev(int major, int minor, int create);
 
 struct active_array;
 struct metadata_update;
+enum state_of_reshape;
 
 /* A superswitch provides entry point the a metadata handler.
  *
@@ -747,6 +748,32 @@ extern struct superswitch {
 	 */
 	const char *(*get_disk_controller_domain)(const char *path);
 
+	/* reshape_array() will
+	 * 1. check is sync_max is set to 0
+	 * 2. prepare device list that has to be added
+	 * 3. prepare metadata update message to set disks slots
+	 *    after reshape is started
+	 * request_type:
+	 * 1. RESHAPE_CANCEL_REQUEST
+	 *    In error case it prepares metadata roll back message.
+	 *    Such error case message should be prepared when
+	 *    passed request_type is set to RESHAPE_CANCEL_REQUEST.
+	 * 1. RESHAPE_IN_PROGRESS
+	 *    requests transition to RESHAPE_IN_PROGRESS state
+	 *    so proper update has to be prepared
+	 * In active array structure can appear values:
+	 * 1. RESHAPE_NOT_ACTIVE
+	 * 2. RESHAPE_IN_PROGRESS
+	 * 3. any other value indicates requested disk number if array change
+	 *    this is visible only during reshape and metadata initialization
+	 *    after initialization RESHAPE_IN_PROGRESS has to be placed
+	 *    in reshape_delta_disks. When reshape is finished it is replaced
+	 *    by RESHAPE_NOT_ACTIVE
+	 */
+	struct mdinfo *(*reshape_array)(struct active_array *a,
+			     enum state_of_reshape request_type,
+			     struct metadata_update **updates);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */

