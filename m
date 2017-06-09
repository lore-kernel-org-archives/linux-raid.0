From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Grow: don't allow to enable PPL when reshape is in progress
Date: Fri,  9 Jun 2017 16:20:19 +0200
Message-ID: <1497018019-11809-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Don't allow to enable PPL consistency policy when reshape is in progress.
Current PPL implementation doesn't work when reshape is taking place.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Grow.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Grow.c b/Grow.c
index 4ecb1d8..1a93391 100644
--- a/Grow.c
+++ b/Grow.c
@@ -530,6 +530,7 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 	char *subarray = NULL;
 	int ret = 0;
 	char container_dev[PATH_MAX];
+	char buf[20];
 
 	if (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
 	    s->consistency_policy != CONSISTENCY_POLICY_PPL) {
@@ -577,6 +578,17 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 		goto free_info;
 	}
 
+	if (s->consistency_policy == CONSISTENCY_POLICY_PPL) {
+		if (sysfs_get_str(sra, NULL, "sync_action", buf, 20) <= 0) {
+			ret = 1;
+			goto free_info;
+		} else if (strcmp(buf, "reshape\n") == 0) {
+			pr_err("PPL cannot be enabled when reshape is in progress\n");
+			ret = 1;
+			goto free_info;
+		}
+	}
+
 	if (subarray) {
 		char *update;
 
-- 
1.8.3.1

