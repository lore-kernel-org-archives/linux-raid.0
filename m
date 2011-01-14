From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 1/2] raid0->raid10 takeover- allocate memory for added disks
Date: Fri, 14 Jan 2011 16:57:24 +0100
Message-ID: <20110114155724.7904.49078.stgit@gklab-128-111.igk.intel.com>
References: <20110114155044.7904.91011.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110114155044.7904.91011.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Allocate memory will be used in process_update.
For raid0->raid10 takeover operation number of disks doubles
so we should allocate memory for additional disks
and one imsm_dev structure with extended order table.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 839b8d8..642feba 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6233,6 +6233,54 @@ static void imsm_prepare_update(struct supertype *st,
 	size_t len = 0;
 
 	switch (type) {
+	case update_takeover: {
+		struct imsm_update_takeover *u = (void *)update->buf;
+		if (u->direction == R0_TO_R10) {
+			void **tail = (void**)&update->space_list;
+			struct imsm_dev *dev = get_imsm_dev(super, u->subarray);
+			struct imsm_map *map = get_imsm_map(dev, 0);
+			int num_members = map->num_members;
+			void *space;
+			int size, i;
+			int err = 0;
+			/* allocate memory for added disks */
+			for (i = 0; i < num_members; i++) {
+				size = sizeof(struct dl);
+				space = malloc(size);
+				if (!space) {
+					err++;
+					goto update_takeover_exit;
+				}
+				*tail = space;
+				tail = space;
+				*tail = NULL;
+			}
+			/* allocate memory for new device */
+			size = sizeof_imsm_dev(super->devlist->dev, 0) +
+				(num_members * sizeof(__u32));
+			space = malloc(size);
+			if (!space) {
+				err++;
+				goto update_takeover_exit;
+			}
+			*tail = space;
+			tail = space;
+			*tail = NULL;
+update_takeover_exit:
+			if (!err) {
+				len = disks_to_mpb_size(num_members * 2);
+			} else {
+				/* if allocation didn't success, free buffer */
+				while (update->space_list) {
+					void **sp = update->space_list;
+					update->space_list = *sp;
+					free(sp);
+				}
+			}
+		}
+
+		break;
+	}
 	case update_reshape_container_disks: {
 		/* Every raid device in the container is about to
 		 * gain some more devices, and we will enter a

