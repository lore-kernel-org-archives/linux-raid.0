From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 7/7] FIX: array is frozen after reshape
Date: Tue, 01 Mar 2011 15:57:39 +0100
Message-ID: <20110301145739.10678.83893.stgit@gklab-128-013.igk.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When we fork() process, we do not need another fork inside reshape_array().
We can indicate it by fork flag.
In such case Grow_continue() is responsible for unfreezing array
after return from reshape_array() function.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   10 ++++++++--
 msg.c  |    2 +-
 msg.h  |    1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1470a91..fc90aa5 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3331,6 +3331,7 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	char buf[40];
 	char *container = NULL;
 	int err;
+	int forked = 0;
 
 	if (backup_file == NULL) {
 		fprintf(stderr, Name ": Backup file name has to be specified "
@@ -3354,11 +3355,16 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		case 0:
 			dprintf(Name ": Continue bacground reshape "
 				"after assemblation\n");
+			forked = 1;
 		}
 	}
 
-	return reshape_array(container, mdfd, "array", st, info, 1,
-			     backup_file, 0, 0, 1);
+	err = reshape_array(container, mdfd, "array", st, info, 1,
+			     backup_file, 0, forked, 1);
+	if (forked)
+		unblock_subarray(info, 0);
+
+	return err;
 }
 
 
diff --git a/msg.c b/msg.c
index ce2ce00..a1f4bc6 100644
--- a/msg.c
+++ b/msg.c
@@ -235,7 +235,7 @@ static char *ping_monitor_version(char *devname)
 	return msg.buf;
 }
 
-static int unblock_subarray(struct mdinfo *sra, const int unfreeze)
+int unblock_subarray(struct mdinfo *sra, const int unfreeze)
 {
 	char buf[64];
 	int rc = 0;
diff --git a/msg.h b/msg.h
index 090d3f6..91a7798 100644
--- a/msg.h
+++ b/msg.h
@@ -28,6 +28,7 @@ extern int wait_reply(int fd, int tmo);
 extern int connect_monitor(char *devname);
 extern int ping_monitor(char *devname);
 extern int block_subarray(struct mdinfo *sra);
+extern int unblock_subarray(struct mdinfo *sra, const int unfreeze);
 extern int block_monitor(char *container, const int freeze);
 extern void unblock_monitor(char *container, const int unfreeze);
 extern int fping_monitor(int sock);

