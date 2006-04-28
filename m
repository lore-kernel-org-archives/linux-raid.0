From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 5] md: Avoid oops when attempting to fix read errors on raid10
Date: Fri, 28 Apr 2006 12:50:15 +1000
Message-ID: <1060428025015.30731@suse.de>
References: <20060428124313.29510.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids


We should add to the counter for the rdev *after* checking
if the rdev is NULL !!!

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2006-04-28 12:13:20.000000000 +1000
+++ ./drivers/md/raid10.c	2006-04-28 12:13:20.000000000 +1000
@@ -1435,9 +1435,9 @@ static void raid10d(mddev_t *mddev)
 						sl--;
 						d = r10_bio->devs[sl].devnum;
 						rdev = conf->mirrors[d].rdev;
-						atomic_add(s, &rdev->corrected_errors);
 						if (rdev &&
 						    test_bit(In_sync, &rdev->flags)) {
+							atomic_add(s, &rdev->corrected_errors);
 							if (sync_page_io(rdev->bdev,
 									 r10_bio->devs[sl].addr +
 									 sect + rdev->data_offset,
