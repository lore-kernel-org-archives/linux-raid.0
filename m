From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH - RFC] MD: Sync thread not properly shutdown after
 mddev_suspend()
Date: Thu, 02 May 2013 15:19:23 -0500
Message-ID: <1367525963.23442.4.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

MD: Sync thread not properly shutdown after mddev_suspend()

After performing an 'md_stop_writes' followed by an 'mddev_suspend',
it is possible to have 'MD_RECOVERY_RUNNING' set in mddev->recovery.
It doesn't happen often, but when it does, the recovery thread does
not restart properly after a resume.

The problem seems to come from 'md_stop_writes'.  This function is a
wrapper around '__md_stop_writes' - surrounding it with mddev_[un]lock
calls.  While '__md_stop_writes' properly cleans up the sync thread,
the subsequent 'mddev_unlock' call will wake up the personality thread,
which in turn calls 'md_check_recovery' - a function that sets
mddev->recovery flags and potentially launches the sync thread.
Effectively, this can undo what has just been done.

When 'mddev_suspend' is called, it sets the mddev->suspended variable.
This variable causes 'md_check_recovery' to simply return if set.  Thus,
it is better to reap the sync thread in mddev_suspend, because it cannot
be respawned until mddev_resume is called.

There are probably several ways to solve this problem.  The simplest way
was to add 'md_reap_sync_thread' to mddev_suspend.  It may be
better fixed in 'md_stop_writes' though.  We could also combine
'md_stop_writes' and 'mddev_suspend' by calling '__md_stop_writes' from
within 'mddev_suspend' after mddev->suspended has been set.

Thoughts?

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/md.c
===================================================================
--- linux-upstream.orig/drivers/md/md.c
+++ linux-upstream/drivers/md/md.c
@@ -360,6 +360,7 @@ void mddev_suspend(struct mddev *mddev)
 	mddev->pers->quiesce(mddev, 1);
 
 	del_timer_sync(&mddev->safemode_timer);
+	md_reap_sync_thread(mddev);
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 


