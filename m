From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 2/2] imsm: don't update migration record when reshape is interrupted
Date: Tue,  5 Jan 2016 17:16:16 +0100
Message-ID: <1452010576-10733-2-git-send-email-artur.paszkiewicz@intel.com>
References: <1452010576-10733-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1452010576-10733-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Abort imsm_manage_reshape() without updating the migration record if any
error occurs when checking progress. If reshape is interrupted and the
migration record is then updated, the checkpoint will be wrong and will
cause reshape to fail when the array is restarted.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 68cc8d6..abf48c0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10277,7 +10277,7 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 	if (sysfs_fd_get_ll(fd, &completed) < 0) {
 		dprintf("cannot read reshape_position (no reshape in progres)\n");
 		close(fd);
-		return 0;
+		return 1;
 	}
 
 	if (completed > position_to_set) {
@@ -10566,7 +10566,7 @@ static int imsm_manage_reshape(
 		sra->reshape_progress = next_step;
 
 		/* wait until reshape finish */
-		if (wait_for_reshape_imsm(sra, ndata) < 0) {
+		if (wait_for_reshape_imsm(sra, ndata)) {
 			dprintf("wait_for_reshape_imsm returned error!\n");
 			goto abort;
 		}
-- 
2.1.4

