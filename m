From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 1 of 3 - Don't lock array for START_ARRAY
Date: Thu, 20 Jun 2002 10:04:32 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15633.7184.23273.128208@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Well, it looks like that bit patch bomb wasn't quite perfect..

Here are three more, against 2.5.23, that address:
 - "raidstart" would hang
 - compiler warning
 - compile failure when not SMP.

NeilBrown

###Comments for ChangeSet

... as autostart_array does it's own locking.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

--- ./drivers/md/md.c	2002/06/19 04:28:22	1.1
+++ ./drivers/md/md.c	2002/06/19 23:20:56	1.2
@@ -2546,6 +2546,20 @@
 		goto abort;
 	}
 
+
+	if (cmd == START_ARRAY) {
+		/* START_ARRAY doesn't need to lock the array as autostart_array
+		 * does the locking, and it could even be a different array
+		 */
+		err = autostart_array(val_to_kdev(arg));
+		if (err) {
+			printk(KERN_WARNING "md: autostart %s failed!\n",
+			       partition_name(val_to_kdev(arg)));
+			goto abort;
+		}
+		goto done;
+	}
+
 	err = mddev_lock(mddev);
 	if (err) {
 		printk(KERN_INFO "md: ioctl lock interrupted, reason %d, cmd %d\n",
@@ -2580,18 +2594,6 @@
 					printk(KERN_WARNING "md: couldnt set array info. %d\n", err);
 					goto abort_unlock;
 				}
-			}
-			goto done_unlock;
-
-		case START_ARRAY:
-			/*
-			 * possibly make it lock the array ...
-			 */
-			err = autostart_array(val_to_kdev(arg));
-			if (err) {
-				printk(KERN_WARNING "md: autostart %s failed!\n",
-					partition_name(val_to_kdev(arg)));
-				goto abort_unlock;
 			}
 			goto done_unlock;
 
