From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 2/4 v2] mdmon: bad block support for external metadata - sysfs file open
Date: Thu, 27 Oct 2016 10:53:43 +0200
Message-ID: <1477558425-13332-2-git-send-email-tomasz.majchrzak@intel.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Open 'badblocks' and 'unacknowledged_bad_blocks' sysfs files for each
disk in the array. Add them to the list of files observed by monitor.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 managemon.c | 17 +++++++++++++++++
 mdadm.h     |  2 ++
 monitor.c   |  7 ++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/managemon.c b/managemon.c
index 6d1b3d8..3c1d4cb 100644
--- a/managemon.c
+++ b/managemon.c
@@ -115,6 +115,8 @@ static void close_aa(struct active_array *aa)
 	for (d = aa->info.devs; d; d = d->next) {
 		close(d->recovery_fd);
 		close(d->state_fd);
+		close(d->bb_fd);
+		close(d->ubb_fd);
 	}
 
 	if (aa->action_fd >= 0)
@@ -433,6 +435,21 @@ static int disk_init_and_add(struct mdinfo *disk, struct mdinfo *clone,
 		close(disk->recovery_fd);
 		return -1;
 	}
+	disk->bb_fd = sysfs_open2(aa->info.sys_name, disk->sys_name,
+				 "bad_blocks");
+	if (disk->bb_fd < 0) {
+		close(disk->recovery_fd);
+		close(disk->state_fd);
+		return -1;
+	}
+	disk->ubb_fd = sysfs_open2(aa->info.sys_name, disk->sys_name,
+				  "unacknowledged_bad_blocks");
+	if (disk->ubb_fd < 0) {
+		close(disk->recovery_fd);
+		close(disk->state_fd);
+		close(disk->bb_fd);
+		return -1;
+	}
 	disk->prev_state = read_dev_state(disk->state_fd);
 	disk->curr_state = disk->prev_state;
 	disk->next = aa->info.devs;
diff --git a/mdadm.h b/mdadm.h
index 5156ea4..1a1c7af 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -311,6 +311,8 @@ struct mdinfo {
 	/* Device info for mdmon: */
 	int recovery_fd;
 	int state_fd;
+	int bb_fd;
+	int ubb_fd;
 	#define DS_FAULTY	1
 	#define	DS_INSYNC	2
 	#define	DS_WRITE_MOSTLY	4
diff --git a/monitor.c b/monitor.c
index 4c79ce2..56c6500 100644
--- a/monitor.c
+++ b/monitor.c
@@ -454,6 +454,8 @@ static int read_and_act(struct active_array *a)
 				dprintf_cont(" %d:removed", mdi->disk.raid_disk);
 				close(mdi->state_fd);
 				close(mdi->recovery_fd);
+				close(mdi->bb_fd);
+				close(mdi->ubb_fd);
 				mdi->state_fd = -1;
 			} else
 				ret |= ARRAY_BUSY;
@@ -583,8 +585,11 @@ static int wait_and_act(struct supertype *container, int nowait)
 		add_fd(&rfds, &maxfd, a->info.state_fd);
 		add_fd(&rfds, &maxfd, a->action_fd);
 		add_fd(&rfds, &maxfd, a->sync_completed_fd);
-		for (mdi = a->info.devs ; mdi ; mdi = mdi->next)
+		for (mdi = a->info.devs ; mdi ; mdi = mdi->next) {
 			add_fd(&rfds, &maxfd, mdi->state_fd);
+			add_fd(&rfds, &maxfd, mdi->bb_fd);
+			add_fd(&rfds, &maxfd, mdi->ubb_fd);
+		}
 
 		ap = &(*ap)->next;
 	}
-- 
1.8.3.1

