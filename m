From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] imsm: prepare memory for level migration update
Date: Fri, 11 Feb 2011 14:44:07 +0100
Message-ID: <20110211134407.6212.52992.stgit@gklab-128-013.igk.intel.com>
References: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When level is changed from raid0 to raid5 memory is required for replace device
smaller device/array object. When update points to no spare device
(u->new_disks[0] == -1) memory for new missed disk will be required also.
This memory is allocated in manager context in prepare_update()

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fbc71ab..223019a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6536,6 +6536,55 @@ static void imsm_prepare_update(struct supertype *st,
 		break;
 	}
 	case update_reshape_migration: {
+		/* for migration level 0->5 we need to add disks
+		 * so the same as for container operation we will copy
+		 * device to the bigger location.
+		 * in memory prepared device and new disk area are prepared
+		 * for usage in process update
+		 */
+		struct imsm_update_reshape *u = (void *)update->buf;
+		struct intel_dev *id;
+		void **space_tail = (void **)&update->space_list;
+		int size;
+		void *s;
+
+		dprintf("imsm: imsm_prepare_update() for update_reshape\n");
+
+		/* add space for bigger array in update
+		 */
+		for (id = super->devlist; id; id = id->next) {
+			if (id->index == (unsigned)u->subdev) {
+				size = sizeof_imsm_dev(id->dev, 1);
+				if (u->new_raid_disks > u->old_raid_disks)
+					size += sizeof(__u32)*2*
+					(u->new_raid_disks - u->old_raid_disks);
+				s = malloc(size);
+				if (!s)
+					break;
+				*space_tail = s;
+				space_tail = s;
+				*space_tail = NULL;
+				break;
+			}
+		}
+		if (update->space_list == NULL)
+			break;
+
+		/* add space for disk in update
+		 */
+		size = sizeof(struct dl);
+		s = malloc(size);
+		if (!s) {
+			free(update->space_list);
+			update->space_list = NULL;
+			break;
+		}
+		*space_tail = s;
+		space_tail = s;
+		*space_tail = NULL;
+
+		len = disks_to_mpb_size(u->new_raid_disks);
+		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
 	case update_create_array: {

