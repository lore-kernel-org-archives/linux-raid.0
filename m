From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/13] md/raid5: use sysfs_notify_dirent_safe to avoid NULL
	pointer
Date: Wed, 12 Jan 2011 09:12:46 +1100
Message-ID: <20110111221246.12732.4023.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jonathan Brassow <jbrassow@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-raid.ids

From: Jonathan Brassow <jbrassow@redhat.com>

With the module parameter 'start_dirty_degraded' set,
raid5_spare_active() previously called sysfs_notify_dirent() with a NULL
argument (rdev->sysfs_state) when a rebuild finished.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---

 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 316fbe7..9212c07 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5338,7 +5338,7 @@ static int raid5_spare_active(mddev_t *mddev)
 		    && !test_bit(Faulty, &tmp->rdev->flags)
 		    && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;
-			sysfs_notify_dirent(tmp->rdev->sysfs_state);
+			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
 		}
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);


