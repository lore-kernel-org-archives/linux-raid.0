From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID: Fix comparison of index and quantity for "rebuild"
 parameter
Date: Wed, 05 Sep 2012 10:53:20 -0500
Message-ID: <1346860400.10156.50.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

DM RAID: Fix comparison of index and quantity for "rebuild" parameter

The "rebuild" parameter takes an index argument that starts counting from
zero.  The conditional used to validate the index was using '>' rather than
'>=', leaving the door open for an index value that would be 1 too large.

Reported-by: Neil Brown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -539,7 +539,7 @@ static int parse_raid_params(struct raid
 
 		/* Parameters that take a numeric value are checked here */
 		if (!strcasecmp(key, "rebuild")) {
-			if (value > rs->md.raid_disks) {
+			if (value >= rs->md.raid_disks) {
 				rs->ti->error = "Invalid rebuild index given";
 				return -EINVAL;
 			}


