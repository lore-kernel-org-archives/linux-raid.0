From: gqjiang@suse.com
Subject: [PATCH V2 07/11] Skip clustered devices in incremental
Date: Fri,  8 May 2015 16:50:25 +0800
Message-ID: <1431075029-5484-8-git-send-email-gqjiang@suse.com>
References: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

We want the clustered devices to be started exclusively by a cluster
resource-agent. So, avoid starting using the incremental option.

This also skips a clustered md from starting during boot in inactive mode.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Incremental.c | 5 +++++
 super1.c      | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/Incremental.c b/Incremental.c
index 0c9a9a4..5450a5c 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -232,6 +232,11 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 				devname);
 		goto out;
 	}
+	/* Skip the clustered ones. This should be started by
+	 * clustering resource agents
+	 */
+	if (info.array.state & (1 << MD_SB_CLUSTERED))
+		goto out;
 
 	/* 3a/ if not, check for homehost match.  If no match, continue
 	 * but don't trust the 'name' in the array. Thus a 'random' minor
diff --git a/super1.c b/super1.c
index 57b1526..246d34e 100644
--- a/super1.c
+++ b/super1.c
@@ -891,6 +891,8 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	info->array.state =
 		(__le64_to_cpu(sb->resync_offset) == MaxSector)
 		? 1 : 0;
+	if (__le32_to_cpu(bsb->nodes) > 1)
+		info->array.state |= (1 << MD_SB_CLUSTERED);
 
 	info->data_offset = __le64_to_cpu(sb->data_offset);
 	info->component_size = __le64_to_cpu(sb->size);
-- 
1.7.12.4

