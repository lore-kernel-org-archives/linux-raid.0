From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/28] md: notify level changes through sysfs.
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.74331.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>
List-Id: linux-raid.ids

From: Maciej Trela <Maciej.Trela@intel.com>

Level changes can be very significant, so make sure
to notify them via sysfs.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03d6a52..afe1065 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3058,6 +3058,7 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	sysfs_notify(&mddev->kobj, NULL, "level");
 	return rv;
 }
 


