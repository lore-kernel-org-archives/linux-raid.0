From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Subject: [PATCH 1/2] imsm: add handling of sync_action is equal to 'idle'
Date: Thu, 16 Jun 2016 11:31:36 +0200
Message-ID: <1466069497-29503-2-git-send-email-aleksey.obitotskiy@intel.com>
References: <1466069497-29503-1-git-send-email-aleksey.obitotskiy@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1466069497-29503-1-git-send-email-aleksey.obitotskiy@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After resync is stopped sync_action value become 'idle'.
We treat this case as normal termination of waiting, not as error.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 7e2860c..7950bef 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10423,6 +10423,8 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 		if (sysfs_get_str(sra, NULL, "sync_action",
 				  action, 20) > 0 &&
 				strncmp(action, "reshape", 7) != 0) {
+			if (strncmp(action, "idle", 4) == 0)
+				break;
 			close(fd);
 			return -1;
 		}
@@ -10432,9 +10434,9 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 			return 1;
 		}
 	} while (completed < position_to_set);
+
 	close(fd);
 	return 0;
-
 }
 
 /*******************************************************************************
-- 
2.7.4

