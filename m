From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/5] imsm: prepare memory for level migration update
Date: Mon, 14 Feb 2011 14:13:05 +0100
Message-ID: <20110214131305.8540.39317.stgit@gklab-128-013.igk.intel.com>
References: <20110214130213.8540.57401.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214130213.8540.57401.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When level is changed from raid0 to raid5 memory is required for replace device
smaller device/array object. When update points to no spare device
(u->new_disks[0] == -1) memory for new missed disk will be required also.
This memory is allocated in manager context in prepare_update()

Prepare_update() is called in manager context so memory allocation are allowed
here. This allows us to look for spare devices for meta update.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 489340f..b7ef428 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6439,6 +6439,8 @@ static void imsm_process_update(struct supertype *st,
 	}
 }
 
+static struct mdinfo *get_spares_for_grow(struct supertype *st);
+
 static void imsm_prepare_update(struct supertype *st,
 				struct metadata_update *update)
 {
@@ -6537,6 +6539,91 @@ static void imsm_prepare_update(struct supertype *st,
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
+		int current_level = -1;
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
+		/* add spare device to update
+		 */
+		for (id = super->devlist ; id; id = id->next)
+			if (id->index == (unsigned)u->subdev) {
+				struct imsm_dev *dev;
+				struct imsm_map *map;
+
+				dev = get_imsm_dev(super, u->subdev);
+				map = get_imsm_map(dev, 0);
+				current_level = map->raid_level;
+				break;
+			}
+		if ((u->new_level == 5) && (u->new_level != current_level)) {
+			struct mdinfo *spares;
+
+			u->new_raid_disks++;
+			spares = get_spares_for_grow(st);
+			if (spares) {
+				struct dl *dl;
+				struct mdinfo *dev;
+
+				dev = spares->devs;
+				if (dev) {
+					u->new_disks[0] = 
+						makedev(dev->disk.major,
+							dev->disk.minor);
+					dl = get_disk_super(super,
+							    dev->disk.major,
+							    dev->disk.minor);
+					dl->index = u->old_raid_disks;
+					dev = dev->next;
+				}
+				sysfs_free(spares);
+			}
+		}
+		len = disks_to_mpb_size(u->new_raid_disks);
+		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
 	case update_create_array: {

