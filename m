From: NeilBrown <neilb@suse.de>
Subject: [PATCH 009 of 29] md: Don't try to make md arrays dirty if that is not meaningful.
Date: Fri, 27 Jun 2008 16:50:16 +1000
Message-ID: <1080627065016.10436@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Arrays personalities such as 'raid0' and 'linear' have no redundancy,
and so marking them as 'clean' or 'dirty' is not meaningful.
So always allow write requests without requiring a superblock update.

Such arrays types are detected by ->sync_request being NULL.  If it is
not possible to send a sync request we don't need a 'dirty' flag because
all a dirty flag does is trigger some sync_requests.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:31:35.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:33:00.000000000 +1000
@@ -5536,6 +5536,8 @@ void md_allow_write(mddev_t *mddev)
 		return;
 	if (mddev->ro)
 		return;
+	if (!mddev->pers->sync_request)
+		return;
 
 	spin_lock_irq(&mddev->write_lock);
 	if (mddev->in_sync) {
