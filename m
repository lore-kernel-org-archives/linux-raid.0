From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] Grow: goto release if Manage_subdevs failed
Date: Tue, 22 Mar 2016 17:03:44 +0800
Message-ID: <1458637424-13887-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

If failure happened when add disk to array
by grow mode, need to goto release instead
of continue the reshape.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Grow.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index cf2750a..1767a1e 100755
--- a/Grow.c
+++ b/Grow.c
@@ -3003,8 +3003,9 @@ static int reshape_array(char *container, int fd, char *devname,
 	 * level and frozen, we can safely add them.
 	 */
 	if (devlist)
-		Manage_subdevs(devname, fd, devlist, verbose,
-			       0,NULL, 0);
+		if (Manage_subdevs(devname, fd, devlist, verbose,
+				   0,NULL, 0))
+			goto release;
 
 	if (reshape.backup_blocks == 0 && data_offset != INVALID_SECTORS)
 		reshape.backup_blocks = reshape.before.data_disks * info->array.chunk_size/512;
-- 
2.6.2

