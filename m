From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 6/8] md/raid5: set reshape_position correctly when reshape
	starts.
Date: Mon, 03 Aug 2009 07:58:18 +1000
Message-ID: <20090802215818.4198.79858.stgit@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215444.4198.83094.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

As the internal reshape_progress counter is the main driver
for reshape, the fact that reshape_position sometimes starts with the
wrong value has minimal effect.  It is visible in sysfs and that
is all.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3937423..659151e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5000,7 +5000,7 @@ static int raid5_start_reshape(mddev_t *mddev)
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	mddev->raid_disks = conf->raid_disks;
-	mddev->reshape_position = 0;
+	mddev->reshape_position = conf->reshape_progress;
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);


