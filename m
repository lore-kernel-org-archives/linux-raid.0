From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 1/5] md: register new md sysfs file 'uuid' read-only
Date: Tue, 28 Jul 2020 12:01:39 +0200
Message-ID: <20200728100143.17813-2-guoqing.jiang@cloud.ionos.com>
References: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

From: Sebastian Parschauer <s.parschauer@gmx.de>

Report the UUID of the MD array in the following format:
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

This is useful if you don't want to wait for udev to identify array.
And it is also easy for script to monitor it with the format.

Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
[Guoqing: mention the change in md.rst]
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 Documentation/admin-guide/md.rst | 4 ++++
 drivers/md/md.c                  | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index d973d469ffc4..cc8781b96b4d 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -426,6 +426,10 @@ All md devices contain:
      The accepted values when writing to this file are ``ppl`` and ``resync``,
      used to enable and disable PPL.
 
+  uuid
+     This indicates the UUID of the array in the following format:
+     xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
+
 
 As component devices are added to an md array, they appear in the ``md``
 directory as new directories named::
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ea48bc25cce1..0c2a0e65b4f1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4225,6 +4225,14 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_raid_disks =
 __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
 
+static ssize_t
+uuid_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%pU\n", mddev->uuid);
+}
+static struct md_sysfs_entry md_uuid =
+__ATTR(uuid, S_IRUGO, uuid_show, NULL);
+
 static ssize_t
 chunk_size_show(struct mddev *mddev, char *page)
 {
@@ -5481,6 +5489,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_layout.attr,
 	&md_raid_disks.attr,
+	&md_uuid.attr,
 	&md_chunk_size.attr,
 	&md_size.attr,
 	&md_resync_start.attr,
-- 
2.17.1
