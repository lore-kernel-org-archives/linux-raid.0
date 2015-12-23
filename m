From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 1/2] Grow: close file descriptor earlier to avoid "still in use" when stopping
Date: Wed, 23 Dec 2015 12:57:10 +0100
Message-ID: <1450871831-25452-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

Close fd2 as soon as it is no longer needed, before calling
Grow_continue(). Otherwise, we won't be able to stop an array with
external metadata during reshape, because mdadm running in background
will be keeping it open.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Grow.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Grow.c b/Grow.c
index 80d7b22..f65b36a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -4873,6 +4873,9 @@ int Grow_continue_command(char *devname, int fd,
 
 		sysfs_init(content, fd2, mdstat->devnm);
 
+		close(fd2);
+		fd2 = -1;
+
 		/* start mdmon in case it is not running
 		 */
 		if (!mdmon_running(container))
-- 
2.1.4

