From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Grow: don't allow array geometry change with ppl enabled
Date: Thu,  8 Jun 2017 16:05:51 +0200
Message-ID: <1496930751-9220-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Don't allow array geometry change (size expand, disk adding) when PPL
consistency policy is enabled. Current PPL implementation doesn't work when
reshape is taking place.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Grow.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Grow.c b/Grow.c
index 4ecb1d8..f7325cb 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1880,6 +1880,13 @@ int Grow_reshape(char *devname, int fd,
 					free(subarray);
 					return 1;
 				}
+				if (content->consistency_policy ==
+				    CONSISTENCY_POLICY_PPL) {
+					pr_err("Operation not supported when ppl consistency policy is enabled\n");
+					sysfs_free(cc);
+					free(subarray);
+					return 1;
+				}
 			}
 			sysfs_free(cc);
 		}
-- 
1.8.3.1

