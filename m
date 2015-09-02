From: Shaohua Li <shli@fb.com>
Subject: [PATCH 7/8] md: skip resync for raid array with journal
Date: Wed, 2 Sep 2015 13:49:50 -0700
Message-ID: <7c5622ab3335f31a27f807d8fee27f8bb60675ae.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If a raid array has journal, the journal can guarantee the consistency,
we can skip resync after a unclean shutdown. The exception is raid
creation or user initiated resync, which we still do a raid resync.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 4 ++++
 drivers/md/md.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b3f9eed..95824fb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1669,6 +1669,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			}
 			set_bit(Journal, &rdev->flags);
 			rdev->journal_tail = le64_to_cpu(sb->journal_tail);
+			if (mddev->recovery_cp == MaxSector)
+				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
 			break;
 		default:
 			rdev->saved_raid_disk = role;
@@ -1711,6 +1713,8 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->events = cpu_to_le64(mddev->events);
 	if (mddev->in_sync)
 		sb->resync_offset = cpu_to_le64(mddev->recovery_cp);
+	else if (test_bit(MD_JOURNAL_CLEAN, &mddev->flags))
+		sb->resync_offset = cpu_to_le64(MaxSector);
 	else
 		sb->resync_offset = cpu_to_le64(0);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 226f4ba..0288a0b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -236,6 +236,7 @@ struct mddev {
 #define MD_STILL_CLOSED	4	/* If set, then array has not been opened since
 				 * md_ioctl checked on it.
 				 */
+#define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean */
 
 	int				suspended;
 	atomic_t			active_io;
-- 
1.8.1

