From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 09/31] Process reshape initialization by managemon
Date: Tue, 9 Nov 2010 17:00:59 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA98@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
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

 mdadm/mdadm/managemon.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++
 mdadm/mdadm/mdadm.h     |   26 ++++++++++++++++++
 2 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/managemon.c b/mdadm/mdadm/managemon.c index de5f14e..608ab4d 100644
--- a/mdadm/mdadm/managemon.c
+++ b/mdadm/mdadm/managemon.c
@@ -422,6 +422,74 @@ static void manage_member(struct mdstat_ent *mdstat,
 		}
 	}
 
+	if ((a->reshape_delta_disks != RESHAPE_NOT_ACTIVE) &&
+	    (a->reshape_delta_disks != RESHAPE_IN_PROGRESS)) {
+		dprintf("Reshape signals need to manage this member\n");
+		if (a->container->ss->reshape_array) {
+			struct metadata_update *updates = NULL;
+			struct mdinfo *newdev = NULL;
+			struct mdinfo *d;
+
+			newdev = a->container->ss->reshape_array(a, RESHAPE_IN_PROGRESS, &updates);
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
+						dprintf("Cannot aallocate memory for new disk.\n");
+						continue;
+					}
+					if (sysfs_add_disk(&newa->info, d, 0) < 0) {
+						free(newd);
+						status_ok = 0;
+						dprintf("Cannot add disk to array.\n");
+						continue;
+					}
+					disk_init_and_add(newd, d, newa);
+				}
+				/* go with reshape
+				 */
+				if (status_ok)
+					if (sysfs_set_num(&newa->info, NULL, "sync_max", 0) < 0)
+						status_ok = 0;
+				if (status_ok && sysfs_set_str(&newa->info, NULL, "sync_action", "reshape") == 0) {
+					/* reshape executed
+					 */
+					dprintf("Reshape was started\n");
+					replace_array(a->container, a, newa);
+					a = newa;
+				} else {
+					/* on problems cancelupdate
+					 */
+					free_aa(newa);
+					free_updates(&updates);
+					updates = NULL;
+					a->container->ss->reshape_array(a, RESHAPE_CANCEL_REQUEST, &updates);
+					sysfs_set_str(&a->info, NULL, "sync_action", "idle");
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
diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index 782d679..3a8115a 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -680,6 +680,32 @@ extern struct superswitch {
 	struct mdinfo *(*activate_spare)(struct active_array *a,
 					 struct metadata_update **updates);
 
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
+			     int request_type,
+			     struct metadata_update **updates);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */

