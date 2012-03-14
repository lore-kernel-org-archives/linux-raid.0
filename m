From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/23] md/raid5: make sure reshape_position is cleared on
 error path.
Date: Wed, 14 Mar 2012 15:40:39 +1100
Message-ID: <20120314044039.7978.21916.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leaving a valid reshape_position value in place could be confusing.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 360f2b9..8b3eb41 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5592,6 +5592,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 		spin_lock_irq(&conf->device_lock);
 		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
 		conf->reshape_progress = MaxSector;
+		mddev->reshape_position = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
 		return -EAGAIN;
 	}


