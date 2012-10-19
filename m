From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] md faulty: use disk_stack_limits()
Date: Fri, 19 Oct 2012 18:43:45 -0500
Message-ID: <5081E5B1.3070903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

in:
fe86cdce block: do not artificially constrain max_sectors for stacking drivers

max_sectors defaults to UINT_MAX.  md faulty wasn't using
disk_stack_limits(), so inherited this large value as well.
This triggered a bug in XFS when stressed over md_faulty, when
a very large bio_alloc() failed.

That was on an older kernel, and I can't reproduce exactly the
same thing upstream, but I think the fix is appropriate in any
case.

Thanks to Mike Snitzer for pointing out the problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 45135f6..5e7dc77 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -315,8 +315,11 @@ static int run(struct mddev *mddev)
 	}
 	conf->nfaults = 0;
 
-	rdev_for_each(rdev, mddev)
+	rdev_for_each(rdev, mddev) {
 		conf->rdev = rdev;
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
+	}
 
 	md_set_array_sectors(mddev, faulty_size(mddev, 0, 0));
 	mddev->private = conf;

