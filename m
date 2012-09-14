From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH - v2] DM RAID: Fix for ineffective "sync" directive
Date: Fri, 14 Sep 2012 13:48:03 -0500
Message-ID: <1347648483.27926.8.camel@f16>
References: <1345735914.25206.8.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1345735914.25206.8.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

Neil,

I've taken your suggestion to not muck around with the BITMAP_STALE, and
instead simply clear the superblocks as a whole when the "sync"
directive is given.

 brassow

DM RAID: Fix for "sync" directive ineffectiveness

There are two table arguments that can be given to a DM RAID target that
control whether the array is forced to (re)synchronize or skip initialization:
"sync" and "nosync".  When "sync" is given, we set mddev->recovery_cp to 0
in order to cause the device to resynchronize.  This is insufficient if there
is a bitmap in use, because the array will simply look at the bitmap and see
that there is no recovery necessary.

The fix is to skip over the loading of the superblocks when "sync" is given,
causing new superblocks to be written that will force the array to go through
initialization (i.e. synchronization).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -960,6 +960,19 @@ static int analyse_superblocks(struct dm
 
 	freshest = NULL;
 	rdev_for_each_safe(rdev, tmp, mddev) {
+		/*
+		 * Skipping super_load due to DMPF_SYNC will cause
+		 * the array to undergo initialization again as
+		 * though it were new.  This is the intended effect
+		 * of the "sync" directive.
+		 *
+		 * When reshaping capability is added, we must ensure
+		 * that the "sync" directive is disallowed during the
+		 * reshape.
+		 */
+		if (rs->print_flags & DMPF_SYNC)
+			continue;
+
 		if (!rdev->meta_bdev)
 			continue;
 


