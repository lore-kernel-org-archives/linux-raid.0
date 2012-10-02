From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] md/raid10: use correct limit variable
Date: Tue, 2 Oct 2012 11:04:22 +0300
Message-ID: <20121002080422.GA12398@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

Clang complains that we are assigning a variable to itself.  This should
be using bad_sectors like the similar earlier check does.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 56149ce..4448624 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3219,7 +3219,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				else {
 					bad_sectors -= (sector - first_bad);
 					if (max_sync > bad_sectors)
-						max_sync = max_sync;
+						max_sync = bad_sectors;
 					continue;
 				}
 			}
