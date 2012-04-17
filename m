From: Shaohua Li <shli@kernel.org>
Subject: [patch]raid5: remove unused variables
Date: Tue, 17 Apr 2012 13:09:26 +0800
Message-ID: <4F8CFB06.4090908@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids


The two variables are useless.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  drivers/md/raid5.c |    4 ----
  1 file changed, 4 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-04-17 11:56:16.606009690 +0800
+++ linux/drivers/md/raid5.c	2012-04-17 11:57:47.026009295 +0800
@@ -3953,12 +3953,10 @@ static void make_request(struct mddev *m
  	plugged = mddev_check_plugged(mddev);
  	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
  		DEFINE_WAIT(w);
-		int disks, data_disks;
  		int previous;

  	retry:
  		previous = 0;
-		disks = conf->raid_disks;
  		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
  		if (unlikely(conf->reshape_progress != MaxSector)) {
  			/* spinlock is needed as reshape_progress may be
@@ -3973,7 +3971,6 @@ static void make_request(struct mddev *m
  			if (mddev->delta_disks < 0
  			    ? logical_sector < conf->reshape_progress
  			    : logical_sector >= conf->reshape_progress) {
-				disks = conf->previous_raid_disks;
  				previous = 1;
  			} else {
  				if (mddev->delta_disks < 0
@@ -3986,7 +3983,6 @@ static void make_request(struct mddev *m
  			}
  			spin_unlock_irq(&conf->device_lock);
  		}
-		data_disks = disks - conf->max_degraded;

  		new_sector = raid5_compute_sector(conf, logical_sector,
  						  previous,
