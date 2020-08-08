From: Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH v4] mdadm/Detail: show correct state for cluster-md array
Date: Sat,  8 Aug 2020 17:01:19 +0800
Message-ID: <1596877279-21355-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com
List-Id: linux-raid.ids

After kernel md module commit 480523feae581, in md-cluster env,
mddev->in_sync always zero, it will make array.state never set
up MD_SB_CLEAN. it causes "mdadm -D /dev/mdX" show state 'active'
all the time.

bitmap.c: add a new API IsBitmapDirty() to support inquiry bitmap
dirty or clean.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
v4:
- Detail.c: follow Jes comment, split if into 2 lines
v3:
- Detail.c: fix error logic: v2 code didn't check bitmap when dv is null.
v2:
- Detail.c: change to read only one device.
- bitmap.c: modify IsBitmapDirty() to check all bitmap on the selected device.

---
 Detail.c | 21 ++++++++++++++++++++-
 bitmap.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.h  |  1 +
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index 24eeba0..2682e87 100644
--- a/Detail.c
+++ b/Detail.c
@@ -495,8 +495,27 @@ int Detail(char *dev, struct context *c)
 							  sra->array_state);
 				else
 					arrayst = "clean";
-			} else
+			} else {
 				arrayst = "active";
+				if (array.state & (1<<MD_SB_CLUSTERED)) {
+					for (d = 0; d < max_disks * 2; d++) {
+						char *dv;
+						mdu_disk_info_t disk = disks[d];
+
+						if (d >= array.raid_disks * 2 &&
+							disk.major == 0 && disk.minor == 0)
+							continue;
+						if ((d & 1) && disk.major == 0 && disk.minor == 0)
+							continue;
+						dv = map_dev_preferred(disk.major, disk.minor, 0,
+												c->prefer);
+						if (!dv)
+							continue;
+						arrayst = IsBitmapDirty(dv) ? "active" : "clean";
+						break;
+					}
+				}
+			}
 
 			printf("             State : %s%s%s%s%s%s%s \n",
 			       arrayst, st,
diff --git a/bitmap.c b/bitmap.c
index e38cb96..1095dc8 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -368,6 +368,61 @@ free_info:
 	return rv;
 }
 
+int IsBitmapDirty(char *filename)
+{
+	/*
+	 * Read the bitmap file
+	 * This function is currently for cluster-md only.
+	 * Return: 1(dirty), 0 (clean), -1(error)
+	 */
+
+	int fd = -1, rv = 0, i;
+	struct supertype *st = NULL;
+	bitmap_info_t *info = NULL;
+	bitmap_super_t *sb = NULL;
+
+	fd = bitmap_file_open(filename, &st, 0);
+	free(st);
+	if (fd < 0)
+		goto out;
+
+	info = bitmap_fd_read(fd, 0);
+	close(fd);
+	if (!info)
+		goto out;
+
+	sb = &info->sb;
+	for (i = 0; i < (int)sb->nodes; i++) {
+		st = NULL;
+		free(info);
+		info = NULL;
+
+		fd = bitmap_file_open(filename, &st, i);
+		free(st);
+		if (fd < 0)
+			goto out;
+
+		info = bitmap_fd_read(fd, 0);
+		close(fd);
+		if (!info)
+			goto out;
+
+		sb = &info->sb;
+		if (sb->magic != BITMAP_MAGIC) { /* invalid bitmap magic */
+			free(info);
+			goto out;
+		}
+
+		if (info->dirty_bits)
+			rv = 1;
+	}
+
+	free(info);
+	return rv;
+out:
+	return -1;
+}
+
 int CreateBitmap(char *filename, int force, char uuid[16],
 		 unsigned long chunksize, unsigned long daemon_sleep,
 		 unsigned long write_behind,
diff --git a/mdadm.h b/mdadm.h
index 399478b..ba8ba91 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1447,6 +1447,7 @@ extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long long array_size,
 			int major);
 extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
+extern int IsBitmapDirty(char *filename);
 extern int Write_rules(char *rule_name);
 extern int bitmap_update_uuid(int fd, int *uuid, int swap);
 
-- 
2.25.0
