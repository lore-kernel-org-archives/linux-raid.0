From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 09/36] md: make it easier to wait for bad blocks to be acknowledged.
Date: Wed, 27 Jul 2011 01:04:15 +0900
Message-ID: <87livldo5c.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025848.8422.68600.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025848.8422.68600.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> It is only safe to choose not to write to a bad block if that bad
> block is safely recorded in metadata - i.e. if it has been
> 'acknowledged'.
>
> If it hasn't we need to wait for the acknowledgement.
>
> We support that using rdev->blocked wait and
> md_wait_for_blocked_rdev by introducing a new device flag
> 'BlockedBadBlock'.
>
> This flag is only advisory.
> It is cleared whenever we acknowledge a bad block, so that a waiter
> can re-check the particular bad blocks that it is interested it.
>
> It should be set by a caller when they find they need to wait.
> This (set after test) is inherently racy, but as
> md_wait_for_blocked_rdev already has a timeout, losing the race will
> have minimal impact.
>
> When we clear "Blocked" was also clear "BlockedBadBlocks" incase it
> was set incorrectly (see above race).
>
> We also modify the way we manage 'Blocked' to fit better with the new
> handling of 'BlockedBadBlocks' and to make it consistent between
> externally managed and internally managed metadata.   This requires
> that each raidXd loop checks if the metadata needs to be written and
> triggers a write (md_check_recovery) if needed.  Otherwise a queued
> write request might cause raidXd to wait for the metadata to write,
> and only that thread can write it.
>
> Before writing metadata, we set FaultRecorded for all devices that
> are Faulty, then after writing the metadata we clear Blocked for any
> device for which the Fault was certainly Recorded.
>
> The 'faulty' device flag now appears in sysfs if the device is faulty
> *or* it has unacknowledged bad blocks.  So user-space which does not
> understand bad blocks can continue to function correctly.
> User space which does, should not assume a device is faulty until it
> sees the 'faulty' flag, and then sees the list of unacknowledged bad
> blocks is empty.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Probably you also need this patch:

From 76320c4fdaed91f26a083a9337bb5a5503300e0e Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@gmail.com>
Date: Wed, 27 Jul 2011 00:59:26 +0900
Subject: [PATCH] md: update documentation for md/rdev/state sysfs interface

Previous patches in the bad block series extended behavior of
rdev's 'state' interface but lacked documentation update.
Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 Documentation/md.txt |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index 923a6bddce7c..fc94770f44ab 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -360,18 +360,20 @@ Each directory contains:
         A file recording the current state of the device in the array
 	which can be a comma separated list of
 	      faulty   - device has been kicked from active use due to
-                         a detected fault
+                         a detected fault or it has unacknowledged bad
+                         blocks
 	      in_sync  - device is a fully in-sync member of the array
 	      writemostly - device will only be subject to read
 		         requests if there are no other options.
 			 This applies only to raid1 arrays.
-	      blocked  - device has failed, metadata is "external",
-	                 and the failure hasn't been acknowledged yet.
+	      blocked  - device has failed, and the failure hasn't been
+			 acknowledged yet by the metadata handler.
 			 Writes that would write to this device if
 			 it were not faulty are blocked.
 	      spare    - device is working, but not a full member.
 			 This includes spares that are in the process
 			 of being recovered to
+	      write_error - device has ever seen a write error.
 	This list may grow in future.
 	This can be written to.
 	Writing "faulty"  simulates a failure on the device.
@@ -379,9 +381,11 @@ Each directory contains:
 	Writing "writemostly" sets the writemostly flag.
 	Writing "-writemostly" clears the writemostly flag.
 	Writing "blocked" sets the "blocked" flag.
-	Writing "-blocked" clears the "blocked" flag and allows writes
-		to complete.
+	Writing "-blocked" clears the "blocked" flags and allows writes
+		to complete and possibly simulates an error.
 	Writing "in_sync" sets the in_sync flag.
+	Writing "write_error" sets writeerrorseen flag.
+	Writing "-write_error" clears writeerrorseen flag.
 
 	This file responds to select/poll. Any change to 'faulty'
 	or 'blocked' causes an event.
-- 
1.7.6

