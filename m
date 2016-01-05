From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 1/2] imsm: use timeout when waiting for reshape progress
Date: Tue,  5 Jan 2016 17:16:15 +0100
Message-ID: <1452010576-10733-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Waiting for reshape progress is done by using select() on sync_completed
to block until an exception condition is signalled on the
filedescriptor. This happens when the attribute's value is updated by
the kernel, but if the array is stopped when mdadm is blocked on
select() this will never happen, because this attribute is then removed
and apparently the kernel doesn't do sysfs_notify() when removing a
sysfs attribute. So set a 3 second timeout for the sysfs_wait() call.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 98fe835..68cc8d6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10297,7 +10297,8 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 
 	do {
 		char action[20];
-		sysfs_wait(fd, NULL);
+		int timeout = 3000;
+		sysfs_wait(fd, &timeout);
 		if (sysfs_get_str(sra, NULL, "sync_action",
 				  action, 20) > 0 &&
 				strncmp(action, "reshape", 7) != 0) {
-- 
2.1.4

