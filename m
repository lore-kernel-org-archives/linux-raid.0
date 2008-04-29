From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 9] md: Remove a stray command from a copy and paste error in resync_start_store
Date: Tue, 29 Apr 2008 13:35:20 +1000
Message-ID: <1080429033520.20373@suse.de>
References: <20080429133104.20146.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 -
 1 file changed, 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
@@ -2459,7 +2459,6 @@ resync_start_show(mddev_t *mddev, char *
 static ssize_t
 resync_start_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	/* can only set chunk_size if array is not yet active */
 	char *e;
 	unsigned long long n = simple_strtoull(buf, &e, 10);
 
