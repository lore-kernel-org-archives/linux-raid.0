From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md in 2.4.19-pre - Correctly abort recovery if raid personality indicates an error
Date: Wed, 15 May 2002 15:42:53 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15585.62814.687.214906@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When a raid personality reports an error we should make sure
that recovery is aborted.
Normally it would be anyway, as an IO error will cause
md_error to be called which aborts recovery.

However, in raid5, if two drives fail before recovery starts, then no
error will actually happen during recovery, but the raid5 module
will report each resync request as failing.  We really shouldn't
ignore this...


 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 ++++
 1 files changed, 4 insertions(+)

--- ./drivers/md/md.c	2002/05/15 05:36:13	1.1
+++ ./drivers/md/md.c	2002/05/15 05:38:05	1.2
@@ -3332,6 +3332,10 @@
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
 		// stop recovery, signal do_sync ....
+		if (mddev->pers->stop_resync)
+			mddev->pers->stop_resync(mddev);
+		if (mddev->recovery_running)
+			md_interrupt_thread(md_recovery_thread);
 	}
 }
 
