From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/2] md/raid5: skip wait for MD_CHANGE_DEVS acknowledgement in
	the external case
Date: Fri, 22 Oct 2010 11:03:54 -0700
Message-ID: <20101022180354.6563.52476.stgit@localhost6.localdomain6>
References: <20101022180311.6563.6666.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101022180311.6563.6666.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

mdmon is orchestrating the reshape progress and we rely on it to manage the
reshape position and metadata updates.

Reported-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 69b0a16..9e8ecd5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4243,7 +4243,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait, mddev->flags == 0 ||
-			   kthread_should_stop());
+			   !mddev->persistent || kthread_should_stop());
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
@@ -4344,8 +4344,8 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
-			   !test_bit(MD_CHANGE_DEVS, &mddev->flags)
-			   || kthread_should_stop());
+			   !test_bit(MD_CHANGE_DEVS, &mddev->flags) ||
+			   !mddev->persistent || kthread_should_stop());
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);

