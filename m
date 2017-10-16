From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/mdopen: create new function create_named_array for writing to new_array
Date: Mon, 16 Oct 2017 15:54:18 +0800
Message-ID: <1508140458-16435-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Split 'write to new_array' out into a function named create_named_array.
And fixed a trivial compiling warning 'warn_unused_result' against commit:
fdbf7aaa1956 (mdopen: call "modprobe md_mod" if it might be needed.)

Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---

Discussed this issue with mail: 
[mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.

 mdopen.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index dcdc6f2..4ec13f5 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -100,6 +100,31 @@ void make_parts(char *dev, int cnt)
 	free(name);
 }
 
+int create_named_array(char *devnm)
+{
+	int fd;
+	int n = -1;
+	static const char new_array_file[] = {
+		"/sys/module/md_mod/parameters/new_array"
+	};
+
+	fd = open(new_array_file, O_WRONLY);
+	if (fd < 0 && errno == ENOENT) {
+		if (system("modprobe md_mod") == 0)
+			fd = open(new_array_file, O_WRONLY);
+	}
+	if (fd >= 0) {
+		n = write(fd, devnm, strlen(devnm));
+		close(fd);
+	}
+	if (fd < 0 || n != (int)strlen(devnm)) {
+		pr_err("Fail create %s when using %s\n", devnm, new_array_file);
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * We need a new md device to assemble/build/create an array.
  * 'dev' is a name given us by the user (command line or mdadm.conf)
@@ -306,37 +331,19 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 
 	devnm[0] = 0;
 	if (num < 0 && cname && ci->names) {
-		int fd;
-		int n = -1;
 		sprintf(devnm, "md_%s", cname);
 		if (block_udev)
 			udev_block(devnm);
-		fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
-		if (fd < 0 && errno == ENOENT) {
-			system("modprobe md_mod");
-			fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
-		}
-		if (fd >= 0) {
-			n = write(fd, devnm, strlen(devnm));
-			close(fd);
-		}
-		if (n < 0) {
+		if (!create_named_array(devnm)) {
 			devnm[0] = 0;
 			udev_unblock();
 		}
 	}
 	if (num >= 0) {
-		int fd;
-		int n = -1;
 		sprintf(devnm, "md%d", num);
 		if (block_udev)
 			udev_block(devnm);
-		fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
-		if (fd >= 0) {
-			n = write(fd, devnm, strlen(devnm));
-			close(fd);
-		}
-		if (n < 0) {
+		if (!create_named_array(devnm)) {
 			devnm[0] = 0;
 			udev_unblock();
 		}
-- 
2.6.6

