From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 9] md: Do not freeze md threads for suspend.
Date: Wed, 8 Nov 2006 09:09:36 +1100
Message-ID: <1061107220936.12501@suse.de>
References: <20061108085917.12064.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753529AbWKGWKE@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids


From:  "Rafael J. Wysocki" <rjw@sisk.pl>

If there's a swap file on a software RAID, it should be possible to use this
file for saving the swsusp's suspend image.  Also, this file should be
available to the memory management subsystem when memory is being freed before
the suspend image is created.

For the above reasons it seems that md_threads should not be frozen during
the suspend and the appended patch makes this happen, but then there is the
question if they don't cause any data to be written to disks after the
suspend image has been created, provided that all filesystems are frozen
at that time.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-11-06 11:28:44.000000000 +1100
+++ ./drivers/md/md.c	2006-11-06 11:29:00.000000000 +1100
@@ -4488,6 +4488,7 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
+	current->flags |= PF_NOFREEZE;
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
@@ -4504,7 +4505,6 @@ static int md_thread(void * arg)
 			 test_bit(THREAD_WAKEUP, &thread->flags)
 			 || kthread_should_stop(),
 			 thread->timeout);
-		try_to_freeze();
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 
