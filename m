From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 3] Fix BUG when raid10 rebuilds without enough drives.
Date: Tue, 6 Sep 2005 13:53:12 +1000
Message-ID: <1050906035312.19333@suse.de>
References: <20050906134923.19249.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This shouldn't be a BUG.  We should cope.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-09-06 13:09:22.000000000 +1000
+++ ./drivers/md/raid10.c	2005-09-06 13:11:23.000000000 +1000
@@ -1474,7 +1474,13 @@ static sector_t sync_request(mddev_t *md
 					}
 				}
 				if (j == conf->copies) {
-					BUG();
+					/* Cannot recover, so abort the recovery */
+					put_buf(r10_bio);
+					r10_bio = rb2;
+					if (!test_and_set_bit(MD_RECOVERY_ERR, &mddev->recovery))
+						printk(KERN_INFO "raid10: %s: insufficient working devices for recovery.\n",
+						       mdname(mddev));
+					break;
 				}
 			}
 		if (biolist == NULL) {
