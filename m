From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH] Always return last partition end address in 512B blocks
Date: Thu,  8 Dec 2016 12:13:26 +0100
Message-ID: <1481195606-13227-1-git-send-email-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

For 4K disks 'endofpart' is an index of the last 4K sector used by partition.
mdadm is using number of 512-byte sectors, so value returned by
get_last_partition_end must be multiplied by 8 for devices with 4K sectors.
Also, unused 'ret' variable has been removed.

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
---
 util.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/util.c b/util.c
index 883eaa4..46c1280 100644
--- a/util.c
+++ b/util.c
@@ -1430,6 +1430,7 @@ static int get_last_partition_end(int fd, unsigned long long *endofpart)
 	struct MBR boot_sect;
 	unsigned long long curr_part_end;
 	unsigned part_nr;
+	unsigned int sector_size;
 	int retval = 0;
 
 	*endofpart = 0;
@@ -1469,6 +1470,9 @@ static int get_last_partition_end(int fd, unsigned long long *endofpart)
 		/* Unknown partition table */
 		retval = -1;
 	}
+	/* calculate number of 512-byte blocks */
+	if (get_dev_sector_size(fd, NULL, &sector_size))
+		*endofpart *= sector_size/512;
  abort:
 	return retval;
 }
@@ -1480,9 +1484,8 @@ int check_partitions(int fd, char *dname, unsigned long long freesize,
 	 * Check where the last partition ends
 	 */
 	unsigned long long endofpart;
-	int ret;
 
-	if ((ret = get_last_partition_end(fd, &endofpart)) > 0) {
+	if (get_last_partition_end(fd, &endofpart) > 0) {
 		/* There appears to be a partition table here */
 		if (freesize == 0) {
 			/* partitions will not be visible in new device */
-- 
1.8.3.1

