From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH v2] Monitor: Include containers in spare migration
Date: Wed, 16 Aug 2017 14:59:46 +0200
Message-ID: <1502888386-15946-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

Spare migration doesn't work for external metadata. mdadm skips
a container with spare device because it is inactive. It used to work
because GET_ARRAY_INFO ioctl returned valid structure for a container
and mdadm treated such response as active container. Current
implementation checks it in sysfs where container is shown as inactive.

Adapt sysfs implementation to work the same way as ioctl.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index f70e5b5..497e364 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -497,7 +497,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	if (mse->level == NULL)
 		is_container = 1;
 
-	if (!md_array_active(fd))
+	if (!is_container && !md_array_active(fd))
 		goto disappeared;
 
 	fcntl(fd, F_SETFD, FD_CLOEXEC);
-- 
1.8.3.1

