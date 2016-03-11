From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] Grow: close fd earlier to avoid "cannot get excl access" when stopping
Date: Fri, 11 Mar 2016 13:49:07 +0100
Message-ID: <1457700547-13253-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

If this file descriptor is not closed here, it remains open during
reshape process and stopping process will end up with
"cannot get exclusive access to container".
Once this file descriptor is no longer needed - it can be closed.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Grow.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Grow.c b/Grow.c
index cf2750a..d9db00b 100755
--- a/Grow.c
+++ b/Grow.c
@@ -2070,6 +2070,10 @@ size_change_error:
 		 * number of devices (On-Line Capacity Expansion) must be
 		 * performed at the level of the container
 		 */
+		if (fd > 0) {
+			close(fd);
+			fd = -1;
+		}
 		rv = reshape_container(container, devname, -1, st, &info,
 				       c->force, c->backup_file, c->verbose, 0, 0, 0);
 		frozen = 0;
-- 
2.5.0

