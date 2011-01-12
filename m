From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/8] imsm: FIX: mdadm should process local data
Date: Wed, 12 Jan 2011 14:54:34 +0100
Message-ID: <20110112135434.15045.40376.stgit@gklab-128-013.igk.intel.com>
References: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When update is created by mdadm, local information should be updated also.
This makes us to prepare one update for mdmon and second "update" to maintain local changes.
we can use prepared update for "local/mdadm" metadata update purposes.
We have 2 cases:
1. when metadata is updated by mdmon, we avoid metadata reloading in mdadm.
   we proceed the same updtate 2 times:
	- one time in mdadm for "local update"
        - second time in mdmon for real metadat update
2. when metadata is updated by mdadm (no mdmon running) updates are processed in the same
   way.
	- one time in mdadm for "local update"
	- there is no "second time" update but mdadm just flushes
          metadata to array
   This let us to avoid code duplication by using prepare and process update functions
   as for update via mdmon. This makes update preparing mdmon independent
   and there is no need to maintain the same thing in 2 places in code.


Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   82 ++++++++++++++++++---------------------------------------
 1 files changed, 26 insertions(+), 56 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a4a4497..7038433 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6523,6 +6523,27 @@ abort:
 	return 0;
 }
 
+static void imsm_update_metadata_locally(struct supertype *st,
+				     struct metadata_update *mu)
+{
+	void **space_list;
+
+	if ((!mu) || (!st))
+		return;
+
+	imsm_prepare_update(st, mu);
+	imsm_process_update(st, mu);
+
+	if (mu->space_list) {
+		space_list = (void **)*mu->space_list;
+		while (space_list) {
+			void *space = space_list;
+			space_list = *space_list;
+			free(space);
+		}
+		mu->space_list = NULL;
+	}
+}
 
 static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			      int layout, int chunksize, int raid_disks,
@@ -6565,11 +6586,6 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			    st, &geo, &old_raid_disks)) {
 			struct imsm_update_reshape *u = NULL;
 			int len;
-			struct intel_super *super = st->sb;
-			void **space_list;
-			struct intel_dev *dl;
-			void **space_tail = (void **)&space_list;
-
 
 			len = imsm_create_metadata_update_for_reshape(
 				st, &geo, old_raid_disks, &u);
@@ -6579,58 +6595,12 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 				goto exit_imsm_reshape_super;
 			}
 
-			/* As well as creating update, we apply update.
-			 */
+			ret_val = 0;
+			append_metadata_update(st, u, len);
 
-			dprintf("imsm:prepare space list for update_reshape\n");
-			for (dl = super->devlist; dl;
-			     dl = dl->next) {
-				int size = sizeof_imsm_dev(dl->dev, 1);
-				void *s;
-				if (u->new_raid_disks > u->old_raid_disks)
-					size += sizeof(__u32)*2*
-					(u->new_raid_disks - u->old_raid_disks);
-				s = malloc(size);
-				if (!s)
-					break;
-				*space_tail = s;
-				space_tail = s;
-				*space_tail = NULL;
-			}
-			ret_val = apply_reshape_container_disks_update(
-				u, super, &space_list);
-			if (ret_val) {
-				/* reallocate anchor
-				 */
-				size_t buf_len = super->len;
-				size_t len =
-					disks_to_mpb_size(u->new_raid_disks);
-				struct imsm_super *mpb = super->anchor;
-				void *new_anchor;
-
-				if (__le32_to_cpu(mpb->mpb_size) + len >
-				    buf_len) {
-					buf_len = ROUND_UP(__le32_to_cpu(
-						mpb->mpb_size) + len, 512);
-					if (posix_memalign(&new_anchor,
-							   512, buf_len) == 0) {
-						memcpy(new_anchor, super->buf,
-						       super->len);
-						free(super->buf);
-						super->buf = new_anchor;
-						super->len = buf_len;
-					}
-					super->updates_pending++;
-					ret_val = 0;
-				}
-			} else {
-				while (space_list) {
-					void *space = space_list;
-					space_list = *space_list;
-					free(space);
-				}
-				free(u);
-			}
+			/* update metadata locally
+			 */
+			imsm_update_metadata_locally(st, st->updates);
 		} else
 			fprintf(stderr, Name "imsm: Operation is not allowed "
 				"on this container\n");

