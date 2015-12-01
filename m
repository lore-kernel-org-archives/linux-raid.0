From: Xiao Ni <xni@redhat.com>
Subject: [mdadm PATCH] Grow raid disks without backup file fail
Date: Tue,  1 Dec 2015 15:42:22 +0800
Message-ID: <1448955742-8317-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

When add one new disk to a raid5 and try to grow the number members,
it's failed to start reshape.

Because before echo "reshape" to sync_action, raid5d will miss the 
chance to clear MD_RECOVERY_NEEDED. The method is as same as
start_reshape.

Signed-off-by : Xiao Ni (xni@redhat.com)
---
 Grow.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 80d7b22..a5bed3c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2796,6 +2796,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	int done;
 	struct mdinfo *sra = NULL;
 	char buf[20];
+	int cnt = 5;
 
 	/* when reshaping a RAID0, the component_size might be zero.
 	 * So try to fix that up.
@@ -3114,7 +3115,12 @@ static int reshape_array(char *container, int fd, char *devname,
 		if (impose_reshape(sra, info, st, fd, restart,
 				   devname, container, &reshape) < 0)
 			goto release;
-		if (sysfs_set_str(sra, NULL, "sync_action", "reshape") < 0) {
+		do {
+			err = sysfs_set_str(sra, NULL, "sync_action", "reshape");
+			if (err)
+				sleep(1);
+		} while (err && errno == EBUSY && cnt-- > 0);
+		if (err < 0) {
 			struct mdinfo *sd;
 			if (errno != EINVAL) {
 				pr_err("Failed to initiate reshape!\n");
-- 
2.4.3

