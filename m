From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: MD Raid1, ext4 and write same
Date: Wed, 12 Dec 2012 17:33:42 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1212121719540.30895@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1212101704450.30895@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1212121250340.30895@jlaw-desktop.mno.stratus.com> <yq1txrrf86i.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1txrrf86i.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, 12 Dec 2012, Martin K. Petersen wrote:

> >>>>> "Joe" == Joe Lawrence <Joe.Lawrence@stratus.com> writes:
> 
> Joe> I can confirm the same issue with 3.7.0.  If anyone else is running
> Joe> with raid1 and disks that support write same, can you give this a
> Joe> try?
> 
> Your patch looks good to me (the do_same one). We'll need raid10.c and
> raid5.c to be fixed up in a similar fashion.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering

Hi Martin,

I took a look at raid5 and I don't think it suffers from the same problem 
(ie, cloned write bios missing the flag).  A quick mkfs/mount test showed 
that the blkdev_issue_write_same() calls all succeeded anyway.

So I added the same logic to raid10 and it similarly passes my quick 
tests.  I don't know what else might create WRITE SAME cmds at the moment 
(I tried dd'ing a bunch of zeros and that didn't seem to spawn any), so 
all I did was to mkfs/mount/fio/umount/fsck.  MD recovery seemed happy if 
did this with a degraded array and brought the partner in later.

One question I do have though, I'm not sure about any write bitmap 
implications of this.  I noticed in raid0_run you call:

  blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);

which should keep the acceptable LBA range inside a bitmap 'chunk'?  Am I 
right in understanding that this would keep any write same from ranging 
across bitmap bits?  In my testing, my MD chunksize was 512K but my SAS 
disks write_same_sectors was only 64K... so I think I inadvertently missed 
this necessary step.

Thanks,

-- Joe


From c3ebb7a21850f1ff83c5498655e4f5a18aa883fd Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Wed, 12 Dec 2012 17:03:40 -0500
Subject: [PATCH] md: raid1,10: Copy REQ_WRITE_SAME flag in cloned write
 bios

If the mddev's max_write_same_sectors are non-zero, the block layer may send
WRITE_SAME requests.  When cloning these bios in raid1,10 write cases, make
sure we add this flag to the new bios.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/raid1.c  | 4 +++-
 drivers/md/raid10.c | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a0f7309..85aba6a 100644
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
@@ -1302,7 +1303,8 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard;
+		mbio->bi_rw =
+			WRITE | do_flush_fua | do_sync | do_discard | do_same;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c9acbd7..fdb4a6e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1106,6 +1106,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
@@ -1461,7 +1462,8 @@ retry_write:
 							      rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1503,7 +1505,8 @@ retry_write:
 						   r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
-- 
1.7.11.7

