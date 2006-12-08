From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 5] md: Allow mddevs to live a bit longer to avoid a loop with udev.
Date: Fri, 8 Dec 2006 12:05:52 +1100
Message-ID: <1061208010552.21344@suse.de>
References: <20061208120132.21203.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1164250AbWLHBFq@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


As md devices a automatically created on first open, and automatically
destroyed on last close if they have no significant state, a loop can
be caused with udev.

If you open/close an md device that will generate add and remove
events to udev.  udev will open the device, notice nothing is there
and close it again ... which generates another pair of add/remove events. 
Ad infinitum.

So: Change md to only destroy a device if an explicity MD_STOP was
requested.  This means that md devices might hang around longer than
you would like, but it is easy to get rid of them, and that could even
be automated in user-space (e.g. by mdadm --monitor).


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-12-07 21:01:11.000000000 +1100
+++ ./drivers/md/md.c	2006-12-08 10:22:46.000000000 +1100
@@ -292,7 +292,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
-	new->dead = 1;
+	new->dead = 0;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
