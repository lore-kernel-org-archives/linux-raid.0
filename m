From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 6] md: Change a few 'int' to 'size_t' in md
Date: Mon, 14 Jan 2008 12:45:37 +1100
Message-ID: <1080114014537.20371@suse.de>
References: <20080114123726.19968.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


As suggested by Andrew Morton.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:24:17.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 12:24:31.000000000 +1100
@@ -1802,7 +1802,7 @@ static ssize_t
 state_show(mdk_rdev_t *rdev, char *page)
 {
 	char *sep = "";
-	int len=0;
+	size_t len = 0;
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		len+= sprintf(page+len, "%sfaulty",sep);
@@ -2320,7 +2320,7 @@ level_show(mddev_t *mddev, char *page)
 static ssize_t
 level_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	int rv = len;
+	ssize_t rv = len;
 	if (mddev->pers)
 		return -EBUSY;
 	if (len == 0)
@@ -2807,7 +2807,7 @@ metadata_store(mddev_t *mddev, const cha
 		return len;
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
-		int namelen = len-9;
+		size_t namelen = len-9;
 		if (namelen >= sizeof(mddev->metadata_type))
 			namelen = sizeof(mddev->metadata_type)-1;
 		strncpy(mddev->metadata_type, buf+9, namelen);
