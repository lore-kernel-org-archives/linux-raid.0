From: Shaohua Li <shli@fb.com>
Subject: [PATCH 7/9] MD: kick out journal disk if it's not fresh
Date: Thu, 8 Oct 2015 21:54:11 -0700
Message-ID: <516ad20ad053b122348a5f78bb70fea23f745c5c.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

From: Song Liu <songliubraving@fb.com>

When journal disk is faulty and we are reassemabling the raid array, the
journal disk is old. We don't allow the journal disk added to the raid
array. Since journal disk is missing in the array, the raid5 will mark
the array readonly.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a5b0bbd..a8db2e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1608,7 +1608,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		++ev1;
 		if (rdev->desc_nr >= 0 &&
 		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
-		    le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX)
+		    (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
+		     le16_to_cpu(sb->dev_roles[rdev->desc_nr]) == MD_DISK_ROLE_JOURNAL))
 			if (ev1 < mddev->events)
 				return -EINVAL;
 	} else if (mddev->bitmap) {
-- 
2.4.6

