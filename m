From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH] Use disk sector size value to set offset for reading GPT
Date: Thu,  8 Dec 2016 12:13:15 +0100
Message-ID: <1481195595-13140-1-git-send-email-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

mdadm is using invalid byte-offset while reading GPT header to get
partition info (size, first sector, last sector etc.). Now this offset
is hardcoded to 512 bytes and it is not valid for disks with sector
size different than 512 bytes because MBR and GPT headers are aligned
to LBA, so valid offset for 4k drives is 4096 bytes.

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
---
 super-gpt.c | 10 ++++++++++
 util.c      |  7 ++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/super-gpt.c b/super-gpt.c
index 1a2adce..8b080a0 100644
--- a/super-gpt.c
+++ b/super-gpt.c
@@ -73,6 +73,7 @@ static int load_gpt(struct supertype *st, int fd, char *devname)
 	struct MBR *super;
 	struct GPT *gpt_head;
 	int to_read;
+	unsigned int sector_size;
 
 	free_gpt(st);
 
@@ -81,6 +82,11 @@ static int load_gpt(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
+	if (!get_dev_sector_size(fd, devname, &sector_size)) {
+		free(super);
+		return 1;
+	}
+
 	lseek(fd, 0, 0);
 	if (read(fd, super, sizeof(*super)) != sizeof(*super)) {
 	no_read:
@@ -100,6 +106,8 @@ static int load_gpt(struct supertype *st, int fd, char *devname)
 		free(super);
 		return 1;
 	}
+	/* Set offset to second block (GPT header) */
+	lseek(fd, sector_size, SEEK_SET);
 	/* Seem to have GPT, load the header */
 	gpt_head = (struct GPT*)(super+1);
 	if (read(fd, gpt_head, sizeof(*gpt_head)) != sizeof(*gpt_head))
@@ -111,6 +119,8 @@ static int load_gpt(struct supertype *st, int fd, char *devname)
 
 	to_read = __le32_to_cpu(gpt_head->part_cnt) * sizeof(struct GPT_part_entry);
 	to_read =  ((to_read+511)/512) * 512;
+	/* Set offset to third block (GPT entries) */
+	lseek(fd, sector_size*2, SEEK_SET);
 	if (read(fd, gpt_head+1, to_read) != to_read)
 		goto no_read;
 
diff --git a/util.c b/util.c
index 883eaa4..818f839 100644
--- a/util.c
+++ b/util.c
@@ -1378,12 +1378,15 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
 	unsigned long long curr_part_end;
 	unsigned all_partitions, entry_size;
 	unsigned part_nr;
+	unsigned int sector_size = 0;
 
 	*endofpart = 0;
 
 	BUILD_BUG_ON(sizeof(gpt) != 512);
 	/* skip protective MBR */
-	lseek(fd, 512, SEEK_SET);
+	if (!get_dev_sector_size(fd, NULL, &sector_size))
+		return 0;
+	lseek(fd, sector_size, SEEK_SET);
 	/* read GPT header */
 	if (read(fd, &gpt, 512) != 512)
 		return 0;
@@ -1403,6 +1406,8 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
 
 	part = (struct GPT_part_entry *)buf;
 
+	/* set offset to third block (GPT entries) */
+	lseek(fd, sector_size*2, SEEK_SET);
 	for (part_nr = 0; part_nr < all_partitions; part_nr++) {
 		/* read partition entry */
 		if (read(fd, buf, entry_size) != (ssize_t)entry_size)
-- 
1.8.3.1

