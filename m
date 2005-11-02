From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 006 of 10] Only try to print recovery/resync status for personalities that support recovery
Date: Wed, 2 Nov 2005 21:15:25 +1100
Message-ID: <1051102101525.23922@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The introduction of 'resync=PENDING' (for read-only devices) caused that
message to appear for non-syncable arrays like raid0 and linear.
Simplest thing is to not try to print any resync info unless
the personality clearly supports it.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:33:22.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:33:26.000000000 +1100
@@ -3722,13 +3722,15 @@ static int md_seq_show(struct seq_file *
 		if (mddev->pers) {
 			mddev->pers->status (seq, mddev);
 	 		seq_printf(seq, "\n      ");
-			if (mddev->curr_resync > 2) {
-				status_resync (seq, mddev);
-				seq_printf(seq, "\n      ");
-			} else if (mddev->curr_resync == 1 || mddev->curr_resync == 2)
-				seq_printf(seq, "\tresync=DELAYED\n      ");
-			else if (mddev->recovery_cp < MaxSector)
-				seq_printf(seq, "\tresync=PENDING\n      ");
+			if (mddev->pers->sync_request) {
+				if (mddev->curr_resync > 2) {
+					status_resync (seq, mddev);
+					seq_printf(seq, "\n      ");
+				} else if (mddev->curr_resync == 1 || mddev->curr_resync == 2)
+					seq_printf(seq, "\tresync=DELAYED\n      ");
+				else if (mddev->recovery_cp < MaxSector)
+					seq_printf(seq, "\tresync=PENDING\n      ");
+			}
 		} else
 			seq_printf(seq, "\n       ");
 
