From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: [bug?] raid1 integrity checking is broken on 2.6.18-rc4
Date: Sat, 12 Aug 2006 02:49:24 -0400
Message-ID: <200608120252_MC3-1-C7DD-BA91@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Doing this on a raid1 array:
        echo "check" >/sys/block/md0/md/sync_action

On 2.6.16.27:
        Activity lights on both mirrors show activity for a while,
        then the array status prints on the console.

On 2.6.18-rc4 + the below patch:
        Drive activity light blinks once on one drive, then the
        array status prints (obviously no checking takes place.)


Applied hotfix on 2.6.18-rc4:

--- .prev/drivers/md/md.c       2006-08-08 09:00:44.000000000 +1000
+++ ./drivers/md/md.c   2006-08-08 09:04:04.000000000 +1000
@@ -1597,6 +1597,19 @@ void md_update_sb(mddev_t * mddev)
 
 repeat:
        spin_lock_irq(&mddev->write_lock);
+
+       if (mddev->degraded && mddev->sb_dirty == 3)
+               /* If the array is degraded, then skipping spares is both
+                * dangerous and fairly pointless.
+                * Dangerous because a device that was removed from the array
+                * might have a event_count that still looks up-to-date,
+                * so it can be re-added without a resync.
+                * Pointless because if there are any spares to skip,
+                * then a recovery will happen and soon that array won't
+                * be degraded any more and the spare can go back to sleep then.
+                */
+               mddev->sb_dirty = 1;
+
        sync_req = mddev->in_sync;
        mddev->utime = get_seconds();
        if (mddev->sb_dirty == 3)
-- 
Chuck

