From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 2] Fix careless bug in raid10
Date: Wed, 01 Dec 2004 11:49:58 +1100
Message-ID: <E1CZIgw-0002Hl-Jx@notabene.cse.unsw.edu.au>
References: <20041201112426.2971.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


raid10 performs resync by reading all blocks, comparing to look for 
differences, and over-writing blocks that were different.
The requires re-tasking a bio that was used to read, so that it can
be re-used for write.  So a number of fields need to be reset.

The bi_bdev field was not being reset. However when using on a 
partition of a device, it gets changed by generic_make_request.

This patch simply resets bi_bdev to the correct value.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid10.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-12-01 10:58:41.000000000 +1100
+++ ./drivers/md/raid10.c	2004-12-01 10:59:18.000000000 +1100
@@ -1150,6 +1150,7 @@ static void sync_request_write(mddev_t *
 		md_sync_acct(conf->mirrors[d].rdev->bdev, tbio->bi_size >> 9);
 
 		tbio->bi_sector += conf->mirrors[d].rdev->data_offset;
+		tbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		generic_make_request(tbio);
 	}
 
