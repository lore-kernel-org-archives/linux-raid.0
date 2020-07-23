From: Xiao Ni <xni@redhat.com>
Subject: [PATCH v2 mdadm 1/1] Specify nodes number when updating cluster nodes
Date: Thu, 23 Jul 2020 19:20:05 +0800
Message-ID: <1595503205-11129-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc: ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids

Now it allow updating cluster nodes without specify --nodes. It can write superblock
with zero nodes. It can break the current cluster. Add this check to avoid this problem.

v2: It needs check c.update first to void NULL pointer reference

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdadm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index 51e16f3..e6f0e0b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1341,6 +1341,11 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (c.update && strcmp(c.update, "nodes") == 0 && c.nodes == 0) {
+		pr_err("Please specify nodes number with --nodes\n");
+		exit(1);
+	}
+
 	if (c.backup_file && data_offset != INVALID_SECTORS) {
 		pr_err("--backup-file and --data-offset are incompatible\n");
 		exit(2);
-- 
2.7.5
