From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 09/12] raid5-ppl: read PPL signature from IMSM metadata
Date: Thu, 24 Nov 2016 13:28:44 +0100
Message-ID: <20161124122847.16456-10-artur.paszkiewicz@intel.com>
References: <20161124122847.16456-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124122847.16456-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

The PPL signature is used to determine if the stored PPL is valid for a
given array. With IMSM, the PPL signature should match the
orig_family_num field of the superblock. To avoid passing this value
from userspace, it can be read from the IMSM MPB when initializing the
log.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 2132823..2cc4ee9 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -373,6 +373,75 @@ static void __ppl_stripe_write_finished(struct r5l_io_unit *io)
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 }
 
+#define IMSM_MPB_SIG "Intel Raid ISM Cfg Sig. "
+#define IMSM_MPB_ORIG_FAMILY_NUM_OFFSET 64
+
+static int ppl_find_signature_imsm(struct mddev *mddev, u32 *signature)
+{
+	struct md_rdev *rdev;
+	char *buf;
+	int ret = 0;
+	u32 orig_family_num = 0;
+	struct page *page;
+	struct mddev *container;
+
+	container = mddev_find_container(mddev);
+	if (!container || strncmp(container->metadata_type, "imsm", 4)) {
+		pr_err("Container metadata type is not imsm\n");
+		return -EINVAL;
+	}
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	buf = page_address(page);
+
+	rdev_for_each(rdev, container) {
+		u32 tmp;
+		struct md_rdev *rdev2;
+		bool found = false;
+
+		/* only use rdevs that are both in container and mddev */
+		rdev_for_each(rdev2, mddev)
+			if (rdev2->bdev == rdev->bdev) {
+				found = true;
+				break;
+			}
+
+		if (!found)
+			continue;
+
+		if (!sync_page_io(rdev, 0,
+				queue_logical_block_size(rdev->bdev->bd_queue),
+				page, REQ_OP_READ, 0, true)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		if (strncmp(buf, IMSM_MPB_SIG, strlen(IMSM_MPB_SIG)) != 0) {
+			dbg("imsm mpb signature does not match\n");
+			ret = 1;
+			goto out;
+		}
+
+		tmp = le32_to_cpu(*(u32 *)(buf + IMSM_MPB_ORIG_FAMILY_NUM_OFFSET));
+
+		if (orig_family_num && orig_family_num != tmp) {
+			dbg("orig_family_num is not the same on all disks\n");
+			ret = 1;
+			goto out;
+		}
+
+		orig_family_num = tmp;
+	}
+
+	*signature = orig_family_num;
+out:
+	__free_page(page);
+	return ret;
+}
+
 static void ppl_exit_log_child(struct r5l_log *log)
 {
 	clear_bit(JournalPpl, &log->rdev->flags);
@@ -467,9 +536,17 @@ static int __ppl_init_log(struct r5l_log *log, struct r5conf *conf)
 		return -ENOMEM;
 	log->private = ppl_conf;
 
-	if (!mddev->external)
+	if (mddev->external) {
+		ret = ppl_find_signature_imsm(mddev, &log->uuid_checksum);
+		if (ret) {
+			pr_err("Failed to read imsm signature\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	} else {
 		log->uuid_checksum = crc32c_le(~0, mddev->uuid,
 					       sizeof(mddev->uuid));
+	}
 
 	if (mddev->bitmap) {
 		pr_err("PPL is not compatible with bitmap\n");
-- 
2.10.1

