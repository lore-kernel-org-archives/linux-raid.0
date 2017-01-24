From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 1/2] md: add bad block flag to disk state
Date: Tue, 24 Jan 2017 13:03:38 +0100
Message-ID: <1485259419-2308-2-git-send-email-tomasz.majchrzak@intel.com>
References: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Jes.Sorensen@redhat.com, jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Add a new flag to report that bad blocks are present on a disk. It will
allow userspace to notify the user of the problem.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/md.c                | 2 ++
 include/uapi/linux/raid/md_p.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0abb147..1a807ec 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6034,6 +6034,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 			info.state |= (1<<MD_DISK_WRITEMOSTLY);
 		if (test_bit(FailFast, &rdev->flags))
 			info.state |= (1<<MD_DISK_FAILFAST);
+		if (rdev->badblocks.count)
+			info.state |= (1<<MD_DISK_BB_PRESENT);
 	} else {
 		info.major = info.minor = 0;
 		info.raid_disk = -1;
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 9930f3e..b151e93 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -93,6 +93,7 @@
 				   * read requests will only be sent here in
 				   * dire need
 				   */
+#define MD_DISK_BB_PRESENT	11 /* disk has bad blocks */
 #define MD_DISK_JOURNAL		18 /* disk is used as the write journal in RAID-5/6 */
 
 #define MD_DISK_ROLE_SPARE	0xffff
-- 
1.8.3.1

