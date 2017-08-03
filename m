From: jcejka@suse.com
Subject: [PATCH] mdopen: prevent named arrays devices from buffer overflow
Date: Thu,  3 Aug 2017 18:48:16 +0200
Message-ID: <20170803164816.29998-1-jcejka@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Josef Cejka <jcejka@suse.com>
List-Id: linux-raid.ids

From: Josef Cejka <jcejka@suse.com>

Device names md_XXX for named arrays must fit into 32 bytes
and longer strings provided by user should be rejected. Now they
corrupt the stack (overwrite following devname[] buffer) and
(if not detected) create arrays using old create_on_open
mechanism because write to new_array fails with E2BIG.

Reproducer:
mdadm -A /dev/md/abcdefghijklmnopqrstuvwxyz123 --uuid=...

Signed-off-by: Josef Cejka <jcejka@suse.com>
---
 mdopen.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 0f3a244..fd8a1db 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -314,7 +314,10 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	if (num < 0 && cname && ci->names) {
 		int fd;
 		int n = -1;
-		sprintf(devnm, "md_%s", cname);
+		if (snprintf(devnm, sizeof(devnm), "md_%s", cname) >= sizeof(devnm)) {
+			pr_err("Device name md_%s must be shorter than %d bytes.\n", cname, sizeof(devnm));
+			return -1;
+		}
 		if (block_udev)
 			udev_block(devnm);
 		fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
@@ -364,7 +367,10 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 			udev_block(devnm);
 	}
 
-	sprintf(devname, "/dev/%s", devnm);
+	if (snprintf(devname, sizeof(devname), "/dev/%s", devnm) >= sizeof(devname)) {
+		pr_err("Device path /dev/%s must be shorter than %d bytes.\n", devnm, sizeof(devname));
+		return -1;
+	}
 
 	if (dev && dev[0] == '/')
 		strcpy(chosen, dev);
-- 
2.12.3

