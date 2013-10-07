From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] md: Fix skipping recovery for read-only arrays.
Date: Mon, 07 Oct 2013 16:25:51 +0200
Message-ID: <20131007142551.14867.36809.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Since:
        commit 7ceb17e87bde79d285a8b988cfed9eaeebe60b86
        md: Allow devices to be re-added to a read-only array.

spares are activated on a read-only array. In case of raid1 and raid10
personalities it causes that not-in-sync devices are marked in-sync
without checking if recovery has been finished.

If a read-only array is degraded and one of its devices is not in-sync
(because the array has been only partially recovered) recovery will be skipped.

This patch adds checking if recovery has been finished before marking a device
in-sync for raid1 and raid10 personalities. In case of raid5 personality
such condition is already present (at raid5.c:6029).

Bug was introduced in 3.10 and causes data corruption.

Cc: stable@vger.kernel.org
Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d60412c..aacf6bf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1479,6 +1479,7 @@ static int raid1_spare_active(struct mddev *mddev)
 			}
 		}
 		if (rdev
+		    && rdev->recovery_offset == MaxSector
 		    && !test_bit(Faulty, &rdev->flags)
 		    && !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index df7b0a0..73dc8a3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1782,6 +1782,7 @@ static int raid10_spare_active(struct mddev *mddev)
 			}
 			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
 		} else if (tmp->rdev
+			   && tmp->rdev->recovery_offset == MaxSector
 			   && !test_bit(Faulty, &tmp->rdev->flags)
 			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;

