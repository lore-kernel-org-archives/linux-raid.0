From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] Monitor: fix for regression with container devices
Date: Tue, 23 Dec 2014 14:55:16 +0100
Message-ID: <1419342916-10760-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This patch fixes 2 problems introduced by commit 9a518d8: not closing a
file descriptor and ignoring container devices. Array state is always
'inactive' for containers, so we make sure that the device is not a
container by reading the "level" sysfs entry.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Monitor.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 971d2ec..66d67ba 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -483,11 +483,17 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		    strncmp(buf,"inact",5) == 0) {
 			if (fd >= 0)
 				close(fd);
-			if (!st->err)
-				alert("DeviceDisappeared", dev, NULL, ainfo);
-			st->err++;
-			return 0;
+			fd = sysfs_open(st->devnm, NULL, "level");
+			if (fd < 0 || read(fd, buf, 10) != 0) {
+				if (fd >= 0)
+					close(fd);
+				if (!st->err)
+					alert("DeviceDisappeared", dev, NULL, ainfo);
+				st->err++;
+				return 0;
+			}
 		}
+		close(fd);
 	}
 	fd = open(dev, O_RDONLY);
 	if (fd < 0) {
-- 
2.1.2

