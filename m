From: Adrian Drzewiecki <adriand@vmware.com>
Subject: [PATCH] Notify sysfs when RAID1 disk is In_sync.
Date: Mon, 26 Jul 2010 15:49:44 -0400
Message-ID: <20100726194943.GD6720@adriand-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: egoggin@vmware.com
List-Id: linux-raid.ids

When RAID1 is done syncing disks, it'll update the state
of synced rdevs to In_sync. But it neglected to notify
sysfs that the attribute changed. So any programs that
are waiting for an rdev's state to change will not be
woken.

Signed-off-by: Adrian Drzewiecki <adriand@vmware.com>
---
 drivers/md/raid1.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a948da8..fe241fc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1136,6 +1136,7 @@ static int raid1_spare_active(mddev_t *mddev)
                        spin_lock_irqsave(&conf->device_lock, flags);
                        mddev->degraded--;
                        spin_unlock_irqrestore(&conf->device_lock, flags);
+                       sysfs_notify_dirent(rdev->sysfs_state);
                }
        }
 

