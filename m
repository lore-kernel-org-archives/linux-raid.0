From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Grow.c: Block any level migration with chunk size change
Date: Thu, 25 Jan 2018 15:12:50 +0100
Message-ID: <1516889570-16742-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

Mixing level and chunk changes in one grow operation is not supported.
Mdadm performs level migration correctly and ignores new chunk, but
after migration it tries to write this chunk to sysfs properties.
This is dangerous and can cause unexpected behaviours.

Block it before level migration starts.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Grow.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Grow.c b/Grow.c
index 3ee015b..8722969 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1794,6 +1794,11 @@ int Grow_reshape(char *devname, int fd,
 			devname);
 		return 1;
 	}
+	if (s->level != UnSet && s->chunk) {
+		pr_err("Cannot change array level in the same operation as changing chunk size.\n");
+		return 1;
+	}
+
 	if (data_offset != INVALID_SECTORS && array.level != 10 &&
 	    (array.level < 4 || array.level > 6)) {
 		pr_err("--grow --data-offset not yet supported\n");
-- 
1.8.3.1

