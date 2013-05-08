From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2/2] DM RAID:  Fix raid_resume not reviving failed devices
 in all cases
Date: Wed, 08 May 2013 18:00:54 -0500
Message-ID: <1368054054.2890.9.camel@f16>
References: <1368053697.2890.5.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1368053697.2890.5.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID:  Fix raid_resume not reviving failed devices in all cases

When a device fails in a RAID array, it is marked as Faulty.  Later,
md_check_recovery is called which (through the call chain) calls
'hot_remove_disk' in order to have the personalities remove the device
from use in the array.

Sometimes, it is possible for the array to be suspended before the
personalities get their chance to perform 'hot_remove_disk'.  This is
normally not an issue.  If the array is deactivated, then the failed
device will be noticed when the array is reinstantiated.  If the
array is resumed and the disk is still missing, md_check_recovery will
be called upon resume and 'hot_remove_disk' will be called at that
time.  However, (for dm-raid) if the device has been restored,
a resume on the array would cause it to attempt to revive the device
by calling 'hot_add_disk'.  If 'hot_remove_disk' had not been called,
a situation is then created where the device is thought to concurrently
be the replacement and the device to be replaced.  Thus, the device
is first sync'ed with the rest of the array (because it is the replacement
device) and then marked Faulty and removed from the array (because
it is also the device being replaced).

The solution is to check and see if the device had properly been removed
before the array was suspended.  This is done by seeing whether the
device's 'raid_disk' field is -1 - a condition that implies that
'md_check_recovery -> remove_and_add_spares (where raid_disk is set to -1)
-> hot_remove_disk' has been called.  If 'raid_disk' is not -1, then
'hot_remove_disk' must be called to complete the removal of the previously
faulty device before it can be revived via 'hot_add_disk'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1587,6 +1587,21 @@ static void attempt_restore_of_faulty_de
 			DMINFO("Faulty %s device #%d has readable super block."
 			       "  Attempting to revive it.",
 			       rs->raid_type->name, i);
+
+			/*
+			 * Faulty bit may be set, but sometimes the array can
+			 * be suspended before the personalities can respond
+			 * by removing the device from the array (i.e. calling
+			 * 'hot_remove_disk').  If they haven't yet removed
+			 * the failed device, its 'raid_disk' number will be
+			 * '>= 0' - meaning we must call this function
+			 * ourselves.
+			 */
+			if ((r->raid_disk >= 0) &&
+			    (r->mddev->pers->hot_remove_disk(r->mddev, r) != 0))
+				/* Failed to revive this device, try next */
+				continue;
+
 			r->raid_disk = i;
 			r->saved_raid_disk = i;
 			flags = r->flags;


