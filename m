From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH 1/2] fcntl: fix typo in RWH_WRITE_LIFE_NOT_SET r/w hint
Date: Sat, 6 Oct 2018 19:51:22 +0200
Message-ID: <20181006175122.GA16521@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

According to commit message in the original commit v4.13-rc1~212^2~51,
as well as userspace library[1] and man page update[2], R/W hint constants
are intended to have RWH_* prefix. However, RWF_WRITE_LIFE_NOT_SET retained
"RWF_*" prefix used in earlyy versions of the proposed patch set[3].
Rename it and provide the old name as a synonym for the new one
for backward compatibility.

[1] https://github.com/axboe/fio/commit/bd553af6c849
[2] https://github.com/mkerrisk/man-pages/commit/580082a186fd
[3] https://www.mail-archive.com/linux-block@vger.kernel.org/msg09638.html

Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 fs/fcntl.c                       | 2 +-
 include/uapi/linux/fcntl.h       | 9 ++++++++-
 tools/include/uapi/linux/fcntl.h | 9 ++++++++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 4137d96..8f312fc 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -261,7 +261,7 @@ static int f_getowner_uids(struct file *filp, unsigned long arg)
 static bool rw_hint_valid(enum rw_hint hint)
 {
 	switch (hint) {
-	case RWF_WRITE_LIFE_NOT_SET:
+	case RWH_WRITE_LIFE_NOT_SET:
 	case RWH_WRITE_LIFE_NONE:
 	case RWH_WRITE_LIFE_SHORT:
 	case RWH_WRITE_LIFE_MEDIUM:
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 6448cdd..e8f878a 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -57,7 +57,7 @@
  * Valid hint values for F_{GET,SET}_RW_HINT. 0 is "not set", or can be
  * used to clear any hints previously set.
  */
-#define RWF_WRITE_LIFE_NOT_SET	0
+#define RWH_WRITE_LIFE_NOT_SET	0
 #define RWH_WRITE_LIFE_NONE	1
 #define RWH_WRITE_LIFE_SHORT	2
 #define RWH_WRITE_LIFE_MEDIUM	3
@@ -65,6 +65,13 @@
 #define RWH_WRITE_LIFE_EXTREME	5
 
 /*
+ * The originally introduced spelling remained from the first
+ * versions of the patch set that introduced the feature,
+ * v4.13-rc1~212^2~51.
+ */
+#define RWF_WRITE_LIFE_NOT_SET	RWH_WRITE_LIFE_NOT_SET
+
+/*
  * Types of directory notifications that may be requested.
  */
 #define DN_ACCESS	0x00000001	/* File accessed */
diff --git a/tools/include/uapi/linux/fcntl.h b/tools/include/uapi/linux/fcntl.h
index 6448cdd..e8f878a 100644
--- a/tools/include/uapi/linux/fcntl.h
+++ b/tools/include/uapi/linux/fcntl.h
@@ -57,7 +57,7 @@
  * Valid hint values for F_{GET,SET}_RW_HINT. 0 is "not set", or can be
  * used to clear any hints previously set.
  */
-#define RWF_WRITE_LIFE_NOT_SET	0
+#define RWH_WRITE_LIFE_NOT_SET	0
 #define RWH_WRITE_LIFE_NONE	1
 #define RWH_WRITE_LIFE_SHORT	2
 #define RWH_WRITE_LIFE_MEDIUM	3
@@ -65,6 +65,13 @@
 #define RWH_WRITE_LIFE_EXTREME	5
 
 /*
+ * The originally introduced spelling remained from the first
+ * versions of the patch set that introduced the feature,
+ * v4.13-rc1~212^2~51.
+ */
+#define RWF_WRITE_LIFE_NOT_SET	RWH_WRITE_LIFE_NOT_SET
+
+/*
  * Types of directory notifications that may be requested.
  */
 #define DN_ACCESS	0x00000001	/* File accessed */
-- 
2.1.4
