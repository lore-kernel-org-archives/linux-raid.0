From: Guoqing Jiang <gqjiang@suse.com>
Subject: [mdadm PATCH v3] To support clustered raid10
Date: Mon, 30 Oct 2017 17:09:51 +0800
Message-ID: <1509354591-28264-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids

We are now considering to extend clustered raid to
support raid10. But only near layout is supported,
so make the check when create the array or switch
the bitmap from internal to clustered.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Grow.c  |  6 ++++++
 mdadm.c |  9 +++++++--
 mdadm.h |  1 +
 util.c  | 11 +++++++++++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0f9e89bcc5ba..80176e32c52f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -359,6 +359,12 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 
 		ncopies = (array.layout & 255) * ((array.layout >> 8) & 255);
 		bitmapsize = bitmapsize * array.raid_disks / ncopies;
+
+		if (strcmp(s->bitmap_file, "clustered") == 0 &&
+		    !is_near_layout_10(array.layout)) {
+			pr_err("only near layout is supported with clustered raid10\n");
+			return 1;
+		}
 	}
 
 	st = super_by_fd(fd, &subarray);
diff --git a/mdadm.c b/mdadm.c
index 7cdcdba7c652..87cb33f84ac2 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1542,8 +1542,13 @@ int main(int argc, char *argv[])
 				break;
 			}
 
-			if (s.level != 1) {
-				pr_err("--bitmap=clustered is currently supported with RAID mirror only\n");
+			if (s.level != 1 && s.level != 10) {
+				pr_err("--bitmap=clustered is currently supported with raid1/10 only\n");
+				rv = 1;
+				break;
+			}
+			if (s.level == 10 && !is_near_layout_10(s.layout)) {
+				pr_err("only near layout is supported with clustered raid10\n");
 				rv = 1;
 				break;
 			}
diff --git a/mdadm.h b/mdadm.h
index 85947bf62ff0..3cbf82f18d9e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1434,6 +1434,7 @@ extern int get_linux_version(void);
 extern int mdadm_version(char *version);
 extern unsigned long long parse_size(char *size);
 extern int parse_uuid(char *str, int uuid[4]);
+extern int is_near_layout_10(int layout);
 extern int parse_layout_10(char *layout);
 extern int parse_layout_faulty(char *layout);
 extern long parse_num(char *num);
diff --git a/util.c b/util.c
index c11729e3260e..543ec6cf46ef 100644
--- a/util.c
+++ b/util.c
@@ -397,6 +397,17 @@ unsigned long long parse_size(char *size)
 	return s;
 }
 
+int is_near_layout_10(int layout)
+{
+	int fc, fo;
+
+	fc = (layout >> 8) & 255;
+	fo = layout & (1 << 16);
+	if (fc > 1 || fo > 0)
+		return 0;
+	return 1;
+}
+
 int parse_layout_10(char *layout)
 {
 	int copies, rv;
-- 
2.6.6

