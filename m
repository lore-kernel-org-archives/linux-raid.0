From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 6 of 7] Fix two little bugs in raid10
Date: Wed, 08 Sep 2004 12:48:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C4sVG-0005dt-3d@notabene.cse.unsw.edu.au>
References: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


These can cause resync to spin when there is a faulty drive.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid10.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-09-08 11:57:21.000000000 +1000
+++ ./drivers/md/raid10.c	2004-09-08 11:58:02.000000000 +1000
@@ -1496,6 +1496,7 @@ static int sync_request(mddev_t *mddev, 
 					rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 			}
 			put_buf(r10_bio);
+			biolist = NULL;
 			goto giveup;
 		}
 	}
@@ -1557,7 +1558,7 @@ static int sync_request(mddev_t *mddev, 
 		}
 	}
 
-	return nr_sectors;
+	return sectors_skipped + nr_sectors;
  giveup:
 	/* There is nowhere to write, so all non-sync
 	 * drives must be failed, so try the next chunk...
