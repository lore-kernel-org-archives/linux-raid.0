From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Fix a bug that recently crept into md/linear
Date: Tue, 1 Aug 2006 14:08:47 +1000
Message-ID: <1060801040847.11976@suse.de>
References: <20060801140742.11940.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Simon Kirby <sim@netnation.com>
List-Id: linux-raid.ids

This patch fixed a bug in 2.6.18-rc3 It would be good if it can get
into -final.

Thanks,
NeilBrown


### Comments for Changeset

A recent patch that allowed linear arrays to be reconfigured on-line
allowed in a bug which results in divide by zero - not all
mddev->array_size were converted to conf->array_size.

This patch finished the conversion and fixed the bug.

The offending patch was commit 7c7546ccf6463edbeee8d9aac6de7be1cd80d08a.

Thanks to Simon Kirby <sim@netnation.com> for the bug report.

Cc: Simon Kirby <sim@netnation.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/linear.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2006-08-01 11:06:15.000000000 +1000
+++ ./drivers/md/linear.c	2006-08-01 11:06:23.000000000 +1000
@@ -162,7 +162,7 @@ static linear_conf_t *linear_conf(mddev_
 		goto out;
 	}
 
-	min_spacing = mddev->array_size;
+	min_spacing = conf->array_size;
 	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
 
 	/* min_spacing is the minimum spacing that will fit the hash
@@ -171,7 +171,7 @@ static linear_conf_t *linear_conf(mddev_
 	 * that is larger than min_spacing as use the size of that as
 	 * the actual spacing
 	 */
-	conf->hash_spacing = mddev->array_size;
+	conf->hash_spacing = conf->array_size;
 	for (i=0; i < cnt-1 ; i++) {
 		sector_t sz = 0;
 		int j;
@@ -228,7 +228,7 @@ static linear_conf_t *linear_conf(mddev_
 	curr_offset = 0;
 	i = 0;
 	for (curr_offset = 0;
-	     curr_offset < mddev->array_size;
+	     curr_offset < conf->array_size;
 	     curr_offset += conf->hash_spacing) {
 
 		while (i < mddev->raid_disks-1 &&
