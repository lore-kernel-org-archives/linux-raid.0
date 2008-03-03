From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 9] md: Make sure a reshape is started when device switches to read-write.
Date: Mon, 3 Mar 2008 11:17:30 +1100
Message-ID: <1080303001730.23637@suse.de>
References: <20080303111240.23302.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


A resync/reshape/recovery thread will refuse to progress when the
array is marked read-only.  So whenever it mark it not read-only, it
is important to wake up thread resync thread.
There is one place we didn't do this.

The problem manifests if the start_ro module parameters is set, and a
raid5 array that is in the middle of a reshape (restripe) is started.
The array will initially be semi-read-only (meaning it acts like it is
readonly until the first write).  So the reshape will not proceed.

On the first write, the array will become read-write, but the reshape
will not be started, and there is no event which will ever restart
that thread.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:25.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:46:52.000000000 +1100
@@ -5356,6 +5356,7 @@ void md_write_start(mddev_t *mddev, stru
 		mddev->ro = 0;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
+		md_wakeup_thread(mddev->sync_thread);
 	}
 	atomic_inc(&mddev->writes_pending);
 	if (mddev->in_sync) {
