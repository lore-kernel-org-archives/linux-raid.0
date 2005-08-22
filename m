From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 003 of 8] raid1_quiesce is back to front, fix it.
Date: Mon, 22 Aug 2005 11:59:13 +1000
Message-ID: <E1E71aj-0001I6-CT@notabene.cse.unsw.edu.au>
References: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


A state of 0 mean 'not quiesced'
A state of 1 means 'is quiesced'

The original code got this wrong.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-08-22 11:48:18.000000000 +1000
+++ ./drivers/md/raid1.c	2005-08-22 11:49:41.000000000 +1000
@@ -1708,14 +1708,14 @@ void raid1_quiesce(mddev_t *mddev, int s
 	conf_t *conf = mddev_to_conf(mddev);
 
 	switch(state) {
-	case 0:
+	case 1:
 		spin_lock_irq(&conf->resync_lock);
 		conf->barrier++;
 		wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
 				    conf->resync_lock, raid1_unplug(mddev->queue));
 		spin_unlock_irq(&conf->resync_lock);
 		break;
-	case 1:
+	case 0:
 		spin_lock_irq(&conf->resync_lock);
 		conf->barrier--;
 		spin_unlock_irq(&conf->resync_lock);
