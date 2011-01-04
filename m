From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 27/34] imsm: Update raid0 metadata for reshape
Date: Tue, 04 Jan 2011 15:39:11 +0100
Message-ID: <20110104143911.6697.74488.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When raid0 reshape is performed metadata has to be applied by mdadm.
(without mdmon)

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 565afd4..1be0e72 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6595,36 +6595,96 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		return ret_val;
 
 	/* verify reshape conditions
-	 * on container level we can only increase number of devices. */
+	 * on container level we can only increase number of devices.
+	 */
 	if (st->container_dev == st->devnum) {
 		/* check for delta_disks > 0
-		 *and supported raid levels 0 and 5 only in container */
+		 * and supported raid levels 0 and 5 only in container
+		 */
 		int old_raid_disks = 0;
 		if (imsm_reshape_is_allowed_on_container(
 			    st, &geo, &old_raid_disks)) {
 			struct imsm_update_reshape *u = NULL;
 			int len;
+			struct intel_super *super = st->sb;
+			void **space_list;
+			struct intel_dev *dl;
+			void **space_tail = (void **)&space_list;
+
 
 			len = imsm_create_metadata_update_for_reshape(
 				st, &geo, old_raid_disks, &u);
 
-			if (len) {
+			if (len <= 0) {
+				dprintf("imsm: Cannot prepare update\n");
+				goto exit_imsm_reshape_super;
+
+			}
+			if (mdmon_running(st->container_dev)) {
 				ret_val = 0;
-				if (mdmon_running(st->container_dev))
-					append_metadata_update(st, u, len);
-				else {
-					/* no mdmon - apply update
-					 */
+				append_metadata_update(st, u, len);
+				goto exit_imsm_reshape_super;
+			}
+
+			/* no mdmon - apply update
+			 */
+
+			dprintf("imsm:prepare space list for update_reshape\n");
+			for (dl = super->devlist; dl;
+			     dl = dl->next) {
+				int size = sizeof_imsm_dev(dl->dev, 1);
+				void *s;
+				if (u->new_raid_disks > u->old_raid_disks)
+					size += sizeof(__u32)*2*
+					(u->new_raid_disks - u->old_raid_disks);
+				s = malloc(size);
+				if (!s)
+					break;
+				*space_tail = s;
+				space_tail = s;
+				*space_tail = NULL;
+			}
+			ret_val = apply_reshape_container_disks_update(u, super,
+								&space_list, 1);
+			if (ret_val) {
+				/* reallocate anchor
+				 */
+				size_t buf_len = super->len;
+				size_t len =
+					disks_to_mpb_size(u->new_raid_disks);
+				struct imsm_super *mpb = super->anchor;
+				void *new_anchor;
+
+				if (__le32_to_cpu(mpb->mpb_size) + len >
+				    buf_len) {
+					buf_len = ROUND_UP(__le32_to_cpu(
+						mpb->mpb_size) + len, 512);
+					if (posix_memalign(&new_anchor,
+							   512, buf_len) == 0) {
+						memcpy(new_anchor, super->buf,
+						       super->len);
+						free(super->buf);
+						super->buf = new_anchor;
+						super->len = buf_len;
+					}
+					super->updates_pending++;
+					ret_val = 0;
+				}
+			} else {
+				while (space_list) {
+					void *space = space_list;
+					space_list = *space_list;
+					free(space);
 				}
-			} else
-				dprintf("imsm: Cannot prepare "\
-					"update\n");
+				free(u);
+			}
 		} else
 			fprintf(stderr, Name "imsm: Operation is not allowed "\
 				"on this container\n");
 	} else
 		dprintf("imsm: not a container operation\n");
 
+exit_imsm_reshape_super:
 	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
 	return ret_val;
 }

