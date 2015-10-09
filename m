From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] md: fix 32-bit build warning
Date: Fri, 09 Oct 2015 14:12:36 +0200
Message-ID: <5304496.D8N6u074t0@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

On 32-bit architectures, the md code produces this warning when CONFIG_LDAF
is set:

drivers/md/md.c: In function 'check_sb_changes':
drivers/md/md.c:8990:10: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'sector_t {aka long long unsigned int}' [-Wformat=]
   pr_info("%s:%d recovery_cp changed from %lu to %lu\n", __func__,

The code was only recently introduced, and uses the wrong format string
for sector_t. As a workaround, this patch adds an explicit cast to 'u64'
so we can use the %llu format string on all architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: e0212320066e ("md-cluster: Improve md_reload_sb to be less error prone")
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
---

I also noticed that some commmits in md/for-next including the one causing
the problem lack a Signed-off-by line. It might make sense to just fold this
patch and add the lines at the same time.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7fff1e6884d6..e13f72a3b561 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8987,9 +8987,9 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 
 	/* recovery_cp changed */
 	if (le64_to_cpu(sb->resync_offset) != mddev->recovery_cp) {
-		pr_info("%s:%d recovery_cp changed from %lu to %lu\n", __func__,
-				__LINE__, mddev->recovery_cp,
-				(unsigned long) le64_to_cpu(sb->resync_offset));
+		pr_info("%s:%d recovery_cp changed from %llu to %llu\n", __func__,
+				__LINE__, (u64)mddev->recovery_cp,
+				(u64) le64_to_cpu(sb->resync_offset));
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
 	}
 

