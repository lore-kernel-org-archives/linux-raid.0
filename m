From: NeilBrown <neilb@suse.de>
Subject: [PATCH-stable16] Fix a potential NULL dereference in md/raid1
Date: Mon, 21 Aug 2006 09:50:13 +1000
Message-ID: <1060820235013.22016@suse.de>
References: <20060821094833.21982.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

patch for 2.6.16 stable series

My applogies to people reading this with a window narrower than
111 characters :-(

NeilBrown

### Comments for Changeset

At the point where this 'atomic_add' is, rdev could be NULL,
as seen by the fact that we test for this in the very next 
statement.
Further is it is really the wrong place of the add.
We could add to the count of corrected errors 
once the are sure it was corrected, not before
trying to correct it.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2006-08-21 09:47:57.000000000 +1000
+++ ./drivers/md/raid1.c	2006-08-21 09:43:37.000000000 +1000
@@ -1467,7 +1467,6 @@ static void raid1d(mddev_t *mddev)
 							d = conf->raid_disks;
 						d--;
 						rdev = conf->mirrors[d].rdev;
-						atomic_add(s, &rdev->corrected_errors);
 						if (rdev &&
 						    test_bit(In_sync, &rdev->flags)) {
 							if (sync_page_io(rdev->bdev,
@@ -1490,6 +1489,9 @@ static void raid1d(mddev_t *mddev)
 									 s<<9, conf->tmppage, READ) == 0)
 								/* Well, this device is dead */
 								md_error(mddev, rdev);
+							else
+								atomic_add(s, &rdev->corrected_errors);
+
 						}
 					}
 				} else {
