From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: MD Raid1, ext4 and write same
Date: Mon, 10 Dec 2012 18:14:17 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1212101810420.30895@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1212101704450.30895@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1212101704450.30895@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>
List-Id: linux-raid.ids

A second experiment I ran was to detect and copy the REQ_WRITE_SAME flag 
in the raid1 make_request.

I bench-tested this with a quick mkfs / mount / copy and didn't see any 
ill effects.  I'm sure there must be more to adding support (like that 
sector math just north of the bio clone), but I figured I'd post it as 
part of my "what I did today" post.

Thanks,

-- Joe

From 1a77ac87ef15b751f0c7fd74e2d5443d4c30c16f Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Mon, 10 Dec 2012 17:38:18 -0500
Subject: [PATCH] MD Raid1 make_request needs to copy REQ_WRITE_SAME into
 bio clones.

MD Raid1 doesn't apply the REQ_WRITE_SAME bit to cloned bio writes.  The block
and SCSI layers now support this flag, with the former utilitizing it if the
device queue limits contain a non-zero max_write_same_sectors value.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/raid1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 636bae0..d77d272 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1001,6 +1001,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1302,7 +1303,7 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard;
+		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard | do_same;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
-- 
1.7.11.7

