From: NeilBrown <neilb@suse.de>
Subject: [PATCH 2/5] md/raid1: clean up request counts properly in
 close_sync()
Date: Wed, 10 Sep 2014 16:20:44 +1000
Message-ID: <20140910062044.26400.80693.stgit@notabene.brown>
References: <20140910062039.26400.36745.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140910062039.26400.36745.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

If there are outstanding writes when close_sync is called,
the change to ->start_next_window might cause them to
decrement the wrong counter when they complete.  Fix this
by merging the two counters into the one that will be decremented.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f66f67e5a423..65afd8aa6608 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1544,8 +1544,13 @@ static void close_sync(struct r1conf *conf)
 	mempool_destroy(conf->r1buf_pool);
 	conf->r1buf_pool = NULL;
 
+	spin_lock_irq(&conf->resync_lock);
 	conf->next_resync = 0;
 	conf->start_next_window = MaxSector;
+	conf->current_window_requests +=
+		conf->next_window_requests;
+	conf->next_window_requests = 0;
+	spin_unlock_irq(&conf->resync_lock);
 }
 
 static int raid1_spare_active(struct mddev *mddev)


