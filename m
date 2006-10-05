From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Fix bug where new drives added to an md array sometimes don't sync properly.
Date: Thu, 5 Oct 2006 17:13:26 +1000
Message-ID: <1061005071326.6578@suse.de>
References: <20061005171233.6542.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

There is a nasty bug in md in 2.6.18 affecting at least raid1.
This fixes it (and has already been sent to stable@kernel.org).

### Comments for Changeset

This fixes a bug introduced in 2.6.18. 

If a drive is added to a raid1 using older tools (mdadm-1.x or
raidtools) then it will be included in the array without any resync
happening.

It has been submitted for 2.6.18.1.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-09-29 11:51:39.000000000 +1000
+++ ./drivers/md/md.c	2006-10-05 16:40:51.000000000 +1000
@@ -3849,6 +3849,7 @@ static int hot_add_disk(mddev_t * mddev,
 	}
 	clear_bit(In_sync, &rdev->flags);
 	rdev->desc_nr = -1;
+	rdev->saved_raid_disk = -1;
 	err = bind_rdev_to_array(rdev, mddev);
 	if (err)
 		goto abort_export;
