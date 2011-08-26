From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/9] imsm: fix, stop metadata updates to newly failed devices
Date: Thu, 25 Aug 2011 19:14:09 -0700
Message-ID: <20110826021409.28015.4084.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, Krzysztof Wojcik <krzysztof.wojcik@intel.com>, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

We already refrain from updating metadata on disks that are failed at
load, need to do the same for new failures.  This also reverts b4add146
as we *do* want to update other disks' view of the failed device as out of
date.

Cc: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a921cbc..2f11698 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4584,7 +4584,7 @@ static int write_super_imsm(struct supertype *st, int doclose)
 
 	/* write the mpb for disks that compose raid devices */
 	for (d = super->disks; d ; d = d->next) {
-		if (d->index < 0)
+		if (d->index < 0 || is_failed(&d->disk))
 			continue;
 		if (store_imsm_mpb(d->fd, mpb))
 			fprintf(stderr, "%s: failed for device %d:%d %s\n",
@@ -5840,6 +5840,8 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	__u32 ord;
 	int slot;
 	struct imsm_map *map;
+	char buf[MAX_RAID_SERIAL_LEN+3];
+	unsigned int len, shift = 0;
 
 	/* new failures are always set in map[0] */
 	map = get_imsm_map(dev, 0);
@@ -5852,6 +5854,11 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
 		return 0;
 
+	sprintf(buf, "%s:0", disk->serial);
+	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
+		shift = len - MAX_RAID_SERIAL_LEN + 1;
+	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);
+
 	disk->status |= FAILED_DISK;
 	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
 	if (map->failed_disk_num == 0xff)

