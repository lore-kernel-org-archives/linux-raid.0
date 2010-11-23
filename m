From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v2] md: Call blk_queue_flush() to establish flush/fua
	support
Date: Tue, 23 Nov 2010 11:01:03 -0800
Message-ID: <20101123190103.GW14383@tux1.beaverton.ibm.com>
References: <20101122232208.GU14383@tux1.beaverton.ibm.com> <20101123105000.331b40f8@notabene.brown>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101123105000.331b40f8@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Here's a shorter version that sets up flush/fua unconditionally.
---
Before 2.6.37, the md layer had a mechanism for catching I/Os with the barrier
flag set, and translating the barrier into barriers for all the underlying
devices.  With 2.6.37, I/O barriers have become plain old flushes, and the md
code was updated to reflect this.  However, one piece was left out -- the md
layer does not tell the block layer that it supports flushes or FUA access at
all, which results in md silently dropping flush requests.

Since the support already seems there, just add this one piece of bookkeeping.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/md/md.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 324a366..43243a4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4338,6 +4338,8 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		printk(KERN_DEBUG "pointless warning\n");
+
+	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
