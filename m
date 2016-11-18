From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md: add block tracing for bio_remapping
Date: Fri, 18 Nov 2016 09:50:05 -0800
Message-ID: <20161118175005.dodwcprytycwyuyq@kernel.org>
References: <87shqpfrxv.fsf@notabene.neil.brown.name>
 <20161118172622.hzvmtt5rbtmdh7hh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161118172622.hzvmtt5rbtmdh7hh@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 18, 2016 at 09:26:22AM -0800, Shaohua Li wrote:
> On Fri, Nov 18, 2016 at 01:22:04PM +1100, Neil Brown wrote:
> > 
> > The block tracing infrastructure (accessed with blktrace/blkparse)
> > supports the tracing of mapping bios from one device to another.
> > This is currently used when a bio in a partition is mapped to the
> > whole device, when bios are mapped by dm, and for mapping in md/raid5.
> > Other md personalities do not include this tracing yet, so add it.
> > 
> > When a read-error is detected we redirect the request to a different device.
> > This could justifiably be seen as a new mapping for the originial bio,
> > or a secondary mapping for the bio that errors.  This patch uses
> > the second option.
> > 
> > When md is used under dm-raid, the mappings are not traced as we do
> > not have access to the block device number of the parent.
> 
> thanks, applied patch 1, 3, 4.

BTW, I added below patch


commit 504634f60f463e73e7d58c6810a04437da942dba
Author: Shaohua Li <shli@fb.com>
Date:   Fri Nov 18 09:44:08 2016 -0800

    md: add blktrace event for writes to superblock
    
    superblock write is an expensive operation. With raid5-cache, it can be called
    regularly. Tracing to help performance debug.
    
    Signed-off-by: Shaohua Li <shli@fb.com>
    Cc: NeilBrown <neilb@suse.com>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1f1c7f0..d3cef77 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -64,6 +64,7 @@
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
 #include <linux/slab.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "bitmap.h"
 #include "md-cluster.h"
@@ -2403,6 +2404,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	pr_debug("md: updating %s RAID superblock on device (in sync %d)\n",
 		 mdname(mddev), mddev->in_sync);
 
+	if (mddev->queue)
+		blk_add_trace_msg(mddev->queue, "md md_update_sb");
 	bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
 		char b[BDEVNAME_SIZE];
