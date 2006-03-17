From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 13] md: Fix the 'failed' count for version-0 superblocks.
Date: Fri, 17 Mar 2006 15:47:30 +1100
Message-ID: <1060317044730.16035@suse.de>
References: <20060317154017.15880.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


We are counting failed devices twice, once of the device that is
failed, and once for the hole that has been left in the array.  Remove
the former so 'failed' matches 'missing'.  Storing these counts in the
superblock is a bit silly anyway....

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-03-17 11:48:08.000000000 +1100
+++ ./drivers/md/md.c	2006-03-17 11:48:08.000000000 +1100
@@ -893,10 +893,9 @@ static void super_90_sync(mddev_t *mddev
 			d->raid_disk = rdev2->raid_disk;
 		else
 			d->raid_disk = rdev2->desc_nr; /* compatibility */
-		if (test_bit(Faulty, &rdev2->flags)) {
+		if (test_bit(Faulty, &rdev2->flags))
 			d->state = (1<<MD_DISK_FAULTY);
-			failed++;
-		} else if (test_bit(In_sync, &rdev2->flags)) {
+		else if (test_bit(In_sync, &rdev2->flags)) {
 			d->state = (1<<MD_DISK_ACTIVE);
 			d->state |= (1<<MD_DISK_SYNC);
 			active++;
