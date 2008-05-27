From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 3] md: Do not compute parity unless it is on a failed drive
Date: Tue, 27 May 2008 16:32:17 +1000
Message-ID: <1080527063217.16444@suse.de>
References: <20080527162558.16305.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, stable@kernel.org
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

If a block is computed (rather than read) then a check/repair operation
may be lead to believe that the data on disk is correct, when infact it
isn't.  So only compute blocks for failed devices.

This issue has been around since at least 2.6.12, but has become harder to hit
in recent kernels since most reads bypass the cache.

echo repair > /sys/block/mdN/md/sync_action will set the parity blocks to the
correct state.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-05-27 16:24:18.000000000 +1000
+++ ./drivers/md/raid5.c	2008-05-27 16:24:41.000000000 +1000
@@ -2002,6 +2002,7 @@ static int __handle_issuing_new_read_req
 		 * have quiesced.
 		 */
 		if ((s->uptodate == disks - 1) &&
+		    (s->failed && disk_idx == s->failed_num) &&
 		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 			set_bit(R5_Wantcompute, &dev->flags);
@@ -2087,7 +2088,9 @@ static void handle_issuing_new_read_requ
 			/* we would like to get this block, possibly
 			 * by computing it, but we might not be able to
 			 */
-			if (s->uptodate == disks-1) {
+			if ((s->uptodate == disks - 1) &&
+			    (s->failed && (i == r6s->failed_num[0] ||
+					   i == r6s->failed_num[1]))) {
 				pr_debug("Computing stripe %llu block %d\n",
 				       (unsigned long long)sh->sector, i);
 				compute_block_1(sh, i, 0);
