From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [PATCH] md: register new md sysfs file 'uuid' read-only
Date: Tue,  2 Oct 2012 15:42:10 +0200
Message-ID: <1349185330-9024-1-git-send-email-sebastian.riemer@profitbricks.com>
Reply-To: linux-raid <linux-raid@vger.kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

Report the UUID of the MD array in the following format:
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

This is useful if you don't want to wait for udev to
identify your MD array.

Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 308e87b..4e654d1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3730,6 +3730,14 @@ static struct md_sysfs_entry md_raid_disks =
 __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
 
 static ssize_t
+uuid_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%pU\n", mddev->uuid);
+}
+static struct md_sysfs_entry md_uuid =
+__ATTR(uuid, S_IRUGO, uuid_show, NULL);
+
+static ssize_t
 chunk_size_show(struct mddev *mddev, char *page)
 {
 	if (mddev->reshape_position != MaxSector &&
@@ -4667,6 +4675,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_layout.attr,
 	&md_raid_disks.attr,
+	&md_uuid.attr,
 	&md_chunk_size.attr,
 	&md_size.attr,
 	&md_resync_start.attr,
-- 
1.7.1

