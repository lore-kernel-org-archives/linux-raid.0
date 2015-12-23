From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 2/2] imsm: abort reshape if sync_action is not "reshape"
Date: Wed, 23 Dec 2015 12:57:11 +0100
Message-ID: <1450871831-25452-2-git-send-email-artur.paszkiewicz@intel.com>
References: <1450871831-25452-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450871831-25452-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

When reshape was interrupted, an incorrect checkpoint would be saved in
the migration record. Change wait_for_reshape_imsm() to return -1 when
sync_action is not "reshape" to abort early in imsm_manage_reshape()
without writing the migration record.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e609e0c..c7efa98 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10300,8 +10300,10 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 		sysfs_wait(fd, NULL);
 		if (sysfs_get_str(sra, NULL, "sync_action",
 				  action, 20) > 0 &&
-				strncmp(action, "reshape", 7) != 0)
-			break;
+				strncmp(action, "reshape", 7) != 0) {
+			close(fd);
+			return -1;
+		}
 		if (sysfs_fd_get_ll(fd, &completed) < 0) {
 			dprintf("cannot read reshape_position (in loop)\n");
 			close(fd);
-- 
2.1.4

