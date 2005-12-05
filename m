From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 2] Remove inappropriate limits in md/bitmap configuration.
Date: Mon, 5 Dec 2005 14:17:10 +1100
Message-ID: <1051205031710.21052@suse.de>
References: <20051205141310.20937.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The kernel should not be imposing these policy limits:
 The time between bitmap updates should certainly be allowed
 to be more than 15 seconds, and if someone wants a bitmap chunk size
 in excess of 4MB, the kernel isn't the place to stop them.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-12-05 10:22:31.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-12-05 10:28:09.000000000 +1100
@@ -485,12 +485,12 @@ static int bitmap_read_sb(struct bitmap 
 	else if (le32_to_cpu(sb->version) < BITMAP_MAJOR_LO ||
 		 le32_to_cpu(sb->version) > BITMAP_MAJOR_HI)
 		reason = "unrecognized superblock version";
-	else if (chunksize < 512 || chunksize > (1024 * 1024 * 4))
-		reason = "bitmap chunksize out of range (512B - 4MB)";
+	else if (chunksize < PAGE_SIZE)
+		reason = "bitmap chunksize too small";
 	else if ((1 << ffz(~chunksize)) != chunksize)
 		reason = "bitmap chunksize not a power of 2";
-	else if (daemon_sleep < 1 || daemon_sleep > 15)
-		reason = "daemon sleep period out of range (1-15s)";
+	else if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT / HZ)
+		reason = "daemon sleep period out of range";
 	else if (write_behind > COUNTER_MAX)
 		reason = "write-behind limit out of range (0 - 16383)";
 	if (reason) {
