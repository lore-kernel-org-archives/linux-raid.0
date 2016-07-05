From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Monitor: release /proc/mdstat fd when no arrays present
Date: Tue,  5 Jul 2016 09:12:51 +0200
Message-ID: <1467702771-1375-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

If md kernel module is reloaded, /proc/mdstat cannot be accessed ("cat:
/proc/mdstat: No such file or directory"). The reason is mdadm monitor
still holds a file descriptor to previous /proc/mdstat instance. It
leads to really confusing outcome of the following operations - mdadm
seems to run without errors, however some udev rules don't get executed
and new array doesn't work.

Add a check if lseek was successful as it fails if md kernel module has
been unloaded - close a file descriptor then. The problem is mdadm
monitor doesn't always do it before next operation takes place. To
prevent it monitor always releases /proc/mdstat descriptor when there
are no arrays to be monitored, just in case driver unload happens in a
moment.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Monitor.c | 2 ++
 mdstat.c  | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index 4adc237..802a9d9 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -213,6 +213,8 @@ int Monitor(struct mddev_dev *devlist,
 		if (mdstat)
 			free_mdstat(mdstat);
 		mdstat = mdstat_read(oneshot?0:1, 0);
+		if (!mdstat)
+			mdstat_close();
 
 		for (st=statelist; st; st=st->next)
 			if (check_array(st, mdstat, c->test, &info,
diff --git a/mdstat.c b/mdstat.c
index 2972cdf..3962896 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -133,7 +133,11 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 	int fd;
 
 	if (hold && mdstat_fd != -1) {
-		lseek(mdstat_fd, 0L, 0);
+		off_t offset = lseek(mdstat_fd, 0L, 0);
+		if (offset == (off_t)-1) {
+			mdstat_close();
+			return NULL;
+		}
 		fd = dup(mdstat_fd);
 		if (fd >= 0)
 			f = fdopen(fd, "r");
-- 
1.8.3.1

