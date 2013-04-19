From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID: Explicitly turn off bad block support
Date: Fri, 19 Apr 2013 08:30:24 -0500
Message-ID: <1366378224.14427.1.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID:  Explicitly turn off bad block support

DM RAID does not currently use the bad block tracking available in
MD.  'badblocks.shift' must be set to '-1' in order to explicitly
tell MD not to perform bad block related functions, like
narrow_write_error().

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -170,8 +170,10 @@ static struct raid_set *context_alloc(st
 	rs->md.delta_disks = 0;
 	rs->md.recovery_cp = 0;
 
-	for (i = 0; i < raid_devs; i++)
+	for (i = 0; i < raid_devs; i++) {
 		md_rdev_init(&rs->dev[i].rdev);
+		rs->dev[i].rdev.badblocks.shift = -1; /* No bad block support */
+	}
 
 	/*
 	 * Remaining items to be initialized by further RAID params:


