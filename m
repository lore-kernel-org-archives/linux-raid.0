From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 33/34] MD: raid1
 s/sysfs_notify_dirent/sysfs_notify_dirent_safe
Date: Thu, 21 Jul 2011 12:32:28 +1000
Message-ID: <20110721023228.6728.55519.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

From: Jonathan Brassow <jbrassow@redhat.com>

If device-mapper creates a RAID1 array that includes devices to
be rebuilt, it will deref a NULL pointer when finished because
sysfs is not used by device-mapper instantiated RAID devices.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a7e6908..3cbf0ac 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1031,7 +1031,7 @@ static int raid1_spare_active(mddev_t *mddev)
 		    && !test_bit(Faulty, &rdev->flags)
 		    && !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
-			sysfs_notify_dirent(rdev->sysfs_state);
+			sysfs_notify_dirent_safe(rdev->sysfs_state);
 		}
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);


