From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Monitor: Include containers in spare migration
Date: Fri, 21 Jul 2017 14:58:04 +0200
Message-ID: <1500641884-13924-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

md_array_active used GET_ARRAY_INFO ioctl to find out if array is
active. If called for a container, it also returned true as ioctl for
container was successful. sysfs implementation of md_array_active
returns false for container and spare migration for external metadata
doesn't work.

One option would be to make sysfs implementation work the same way as
ioctl implementation, however md_array_active is a misleading function
name to return true for inactive containers. As ioctl implementation is
supposed to be abandoned one day, let's keep different (but correct)
behaviour. Most of the callers of md_array_active don't use it on a
containers anyway so change the only place where it matters.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Reviewed-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index 8d753ca..ac9e421 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -494,7 +494,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 
 	is_container = mse->level == NULL;
 
-	if (!md_array_active(fd))
+	if (!is_container && !md_array_active(fd))
 		goto disappeared;
 
 	fcntl(fd, F_SETFD, FD_CLOEXEC);
-- 
1.8.3.1

