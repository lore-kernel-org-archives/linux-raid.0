From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/2] Introduce sysfs_set_num_signed() and use it to set bitmap/offset
Date: Thu, 26 Apr 2012 17:12:57 +0200
Message-ID: <1335453177-8515-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, joe.lawrence@stratus.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

mdinfo->bitmap_offset is a signed long and needs to be treated as
such when passed to the kernel.

This resolves the problem with adding internal bitmaps to a 1.0 array.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c  |    4 ++--
 mdadm.h |    2 ++
 sysfs.c |    8 ++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index b4b9ff2..0b0d718 100644
--- a/Grow.c
+++ b/Grow.c
@@ -424,8 +424,8 @@ int Grow_addbitmap(char *devname, int fd, char *file, int chunk, int delay, int
 		if (offset_setable) {
 			st->ss->getinfo_super(st, mdi, NULL);
 			sysfs_init(mdi, fd, -1);
-			rv = sysfs_set_num(mdi, NULL, "bitmap/location",
-					   mdi->bitmap_offset);
+			rv = sysfs_set_num_signed(mdi, NULL, "bitmap/location",
+						  mdi->bitmap_offset);
 		} else {
 			array.state |= (1<<MD_SB_BITMAP_PRESENT);
 			rv = ioctl(fd, SET_ARRAY_INFO, &array);
diff --git a/mdadm.h b/mdadm.h
index e60a706..0c91a34 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -473,6 +473,8 @@ extern int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val);
 extern int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, unsigned long long val);
+extern int sysfs_set_num_signed(struct mdinfo *sra, struct mdinfo *dev,
+				char *name, long long val);
 extern int sysfs_uevent(struct mdinfo *sra, char *event);
 extern int sysfs_get_fd(struct mdinfo *sra, struct mdinfo *dev,
 			char *name);
diff --git a/sysfs.c b/sysfs.c
index a1007cf..8e9d0c5 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -428,6 +428,14 @@ int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
 	return sysfs_set_str(sra, dev, name, valstr);
 }
 
+int sysfs_set_num_signed(struct mdinfo *sra, struct mdinfo *dev,
+			 char *name, long long val)
+{
+	char valstr[50];
+	sprintf(valstr, "%lli", val);
+	return sysfs_set_str(sra, dev, name, valstr);
+}
+
 int sysfs_uevent(struct mdinfo *sra, char *event)
 {
 	char fname[50];
-- 
1.7.7.6

