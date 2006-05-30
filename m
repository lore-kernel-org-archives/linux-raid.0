From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Fix badness in sysfs_notify caused by md_new_event
Date: Tue, 30 May 2006 15:48:45 +1000
Message-ID: <1060530054845.4649@suse.de>
References: <20060530152626.4554.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Here is a patch for a bug in 2.6.17-rc that just came to light.  It
should get into 2.6.17 if possible and so is in 'obviously correct'
form rather than "correct final fix" form (see comments).
The patch was actually generated agains -rc4-mm3, but applies to
-rc4-git9 with a moderate offset for one of the chunks (no fuzz).

Thanks,
NeilBrown


### Comments for Changeset

If an error is reported by a drive in a RAID array
(which is done via bi_end_io - in interrupt context),
we call md_error and md_new_event which calls
sysfs_notify.
However sysfs_notify grabs a mutex and so cannot be called
in interrupt context.

This patch just creates a variant of md_new_event which
avoids the sysfs call, and uses that.
A better fix for later is to arrange for the event to be
called from user-context.

Note: avoiding the sysfs call isn't a problem as an error
will not, by itself, modify the sync_action attribute.
(We do still need to wake_up(&md_event_waiters) as an
error by itself will modify /proc/mdstat).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-05-30 15:14:20.000000000 +1000
+++ ./drivers/md/md.c	2006-05-30 15:23:26.000000000 +1000
@@ -172,6 +172,15 @@ void md_new_event(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
+/* Alternate version that can be called from interrupts
+ * when calling sysfs_notify isn't needed.
+ */
+void md_new_event_inintr(mddev_t *mddev)
+{
+	atomic_inc(&md_event_count);
+	wake_up(&md_event_waiters);
+}
+
 /*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
@@ -4268,7 +4277,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-	md_new_event(mddev);
+	md_new_event_inintr(mddev);
 }
 
 /* seq_file implementation /proc/mdstat */
