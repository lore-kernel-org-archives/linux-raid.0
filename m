From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/21] block: remove alloc_part_info and free_part_info
Date: Tue, 24 Mar 2020 08:25:14 +0100
Message-ID: <20200324072530.544483-6-hch@lst.de>
References: <20200324072530.544483-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200324072530.544483-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

There isn't any good reason not to simply open code the allocation and
freeing of the partition_meta_info structure.  Especially as one of
the branches in alloc_part_info is entirely dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partition-generic.c |  6 ++++--
 include/linux/genhd.h     | 15 +--------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index e6fd2226a639..f2004f3bd6f7 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -249,7 +249,9 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	p->policy = get_disk_ro(disk);
 
 	if (info) {
-		struct partition_meta_info *pinfo = alloc_part_info(disk);
+		struct partition_meta_info *pinfo;
+
+		pinfo = kzalloc_node(sizeof(*pinfo), GFP_KERNEL, disk->node_id);
 		if (!pinfo) {
 			err = -ENOMEM;
 			goto out_free_stats;
@@ -308,7 +310,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	return p;
 
 out_free_info:
-	free_part_info(p);
+	kfree(p->info);
 out_free_stats:
 	free_part_stats(p);
 out_free:
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 612d38fce55c..77f8bb8edfcd 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -465,19 +465,6 @@ void part_dec_in_flight(struct request_queue *q, struct hd_struct *part,
 void part_inc_in_flight(struct request_queue *q, struct hd_struct *part,
 			int rw);
 
-static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)
-{
-	if (disk)
-		return kzalloc_node(sizeof(struct partition_meta_info),
-				    GFP_KERNEL, disk->node_id);
-	return kzalloc(sizeof(struct partition_meta_info), GFP_KERNEL);
-}
-
-static inline void free_part_info(struct hd_struct *part)
-{
-	kfree(part->info);
-}
-
 void update_io_ticks(struct hd_struct *part, unsigned long now);
 
 /* block/genhd.c */
@@ -755,7 +742,7 @@ static inline void hd_struct_kill(struct hd_struct *part)
 static inline void hd_free_part(struct hd_struct *part)
 {
 	free_part_stats(part);
-	free_part_info(part);
+	kfree(part->info);
 	percpu_ref_exit(&part->ref);
 }
 
-- 
2.25.1
