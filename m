From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 18] Improve read speed to raid10 arrays using 'far copies'.
Date: Mon, 28 Nov 2005 10:39:40 +1100
Message-ID: <1051127233940.14744@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


raid10 has two different layouts.  One uses near-copies (so multiple
copies of a block are at the same or similar offsets of different
devices) and the other uses far-copies (so multiple copies of a block
are stored a greatly different offsets on different devices).  The
point of far-copies is that it allows the first section (normally first
half) to be layed out in normal raid0 style, and thus provide raid0
sequential read performance.

Unfortunately, the read balancing in raid10 makes some poor decisions
for far-copies arrays and you don't get the desired performance.  So
turn off that bad bit of read_balance for far-copies arrays.

With this patch, read speed of an 'f2' array is comparable with a
raid0 with the same number of devices, though write speed is ofcourse
still very slow.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./drivers/md/raid10.c	2005-11-28 10:08:26.000000000 +1100
@@ -552,7 +552,11 @@ static int read_balance(conf_t *conf, r1
 		    !test_bit(In_sync, &rdev->flags))
 			continue;
 
-		if (!atomic_read(&rdev->nr_pending)) {
+		/* This optimisation is debatable, and completely destroys
+		 * sequential read speed for 'far copies' arrays.  So only
+		 * keep it for 'near' arrays, and review those later.
+		 */
+		if (conf->near_copies > 1 && !atomic_read(&rdev->nr_pending)) {
 			disk = ndisk;
 			slot = nslot;
 			break;
