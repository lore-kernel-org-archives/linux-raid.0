From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: MD RAID 1 fail/remove/add corruption in 3.10
Date: Tue, 16 Jul 2013 14:49:20 -0400
Message-ID: <20130716144920.39f428b7@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Martin Wilck <mwilck@arcor.de>
List-Id: linux-raid.ids

Hi Neil, Martin,

While testing patches to fix RAID1 repair GPF crash w/3.10-rc7
( http://thread.gmane.org/gmane.linux.raid/43351 ), I encountered disk
corruption when repeatedly failing, removing, and adding MD RAID1
component disks to their array.  The RAID1 was created with an internal
write bitmap and the test was run against alternating disks in the
set.  I bisected this behavior back to commit 7ceb17e8 "md: Allow
devices to be re-added to a read-only array", specifically these lines
of code:

remove_and_add_spares:

+		if (rdev->saved_raid_disk >= 0 && mddev->in_sync) {
+			spin_lock_irq(&mddev->write_lock);
+			if (mddev->in_sync)
+				/* OK, this device, which is in_sync,
+				 * will definitely be noticed before
+				 * the next write, so recovery isn't
+				 * needed.
+				 */
+				rdev->recovery_offset = mddev->recovery_cp;
+			spin_unlock_irq(&mddev->write_lock);
+		}
+		if (mddev->ro && rdev->recovery_offset != MaxSector)
+			/* not safe to add this disk now */
+			continue;

when I #ifdef 0 these lines out, leaving rdev->recovery_offset = 0,
then my tests run without incident.

If there is any instrumentation I can apply to remove_and_add_spares
I'll be happy to gather more data.  I'll send an attached copy of
my test programs in a reply so this mail doesn't get bounced by
any spam filters.

Thanks,

-- Joe
