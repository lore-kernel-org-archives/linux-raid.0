From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 012 of 14] Break out of a loop that doesn't need to run to completion.
Date: Thu, 1 Dec 2005 14:23:51 +1100
Message-ID: <1051201032351.29697@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-01 13:59:53.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-01 14:03:16.000000000 +1100
@@ -1672,8 +1672,10 @@ static sector_t sync_request(mddev_t *md
 				for (j=0; j<conf->copies;j++) {
 					int d = r10_bio->devs[j].devnum;
 					if (conf->mirrors[d].rdev == NULL ||
-					    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
+					    test_bit(Faulty, &conf->mirrors[d].rdev->flags)) {
 						still_degraded = 1;
+						break;
+					}
 				}
 				must_sync = bitmap_start_sync(mddev->bitmap, sect,
 							      &sync_blocks, still_degraded);
