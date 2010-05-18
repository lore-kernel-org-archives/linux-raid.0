From: Neil Brown <neilb@suse.de>
Subject: Re: Spare drive won't spin down
Date: Tue, 18 May 2010 10:23:12 +1000
Message-ID: <20100518102312.01c85274@notabene.brown>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>
	<20100507162034.1370d645@notabene.brown>
	<717013.48748.qm@web31703.mail.mud.yahoo.com>
	<20100507194704.3ffcf17e@notabene.brown>
	<4BE83B75.8050709@tmr.com>
	<20100512065318.44e934d4@notabene.brown>
	<4BF186DE.5050502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BF186DE.5050502@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Joe Bryant <tenminjoe@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 17 May 2010 14:11:42 -0400
Doug Ledford <dledford@redhat.com> wrote:

> On 05/11/2010 04:53 PM, Neil Brown wrote:
> > Theoretically, when the spares are one behind the active array and we need to
> > update them all, we should update the spares first, then the rest.  If we
> > don't and there is a crash at the wrong time, some spares could be 2 events
> > behind the most recent device.  However that is a fairly unlikely race to
> > lose and the cost is only having a spare device fall out of the array, which
> > is quite easy to put back it, that I might not worry to much about it.
> > 
> > So if you haven't seen a patch to fix this in a week or two, please remind me.
> 
> They're spares.  They don't need to have an in-sync generation count.
> Change the semantics so that spares have a 0 generation count and only
> when they've been activated does their count get brought into sync with
> the rest of the array.  The only thing needed to make that work is to
> not kick them on assembly because their generation count doesn't match,
> but that should be trivial (and sane) to do based on the fact that if
> they are a spare, they don't contain data, so the generation count
> really is meaningless.
> 

Yes.
However current kernels will kick them on assembly and so I cannot make
future kernels leave the event count at zero, else people who try a new
kernel then revert to an old might find there spares drop off ... and could
well not be happy about that.

But I can certainly relax the requirement that the event count on a spare be
current now.  Maybe in a few years I can then stop updating the event count
on spares completely....

NeilBrown

From 589af914c85ebb8205ba315a1e78e76ec7bd9e99 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 18 May 2010 10:17:09 +1000
Subject: [PATCH] md: don't insist on valid event count for spare devices.

Devices which know that they are spares do not really need to have
an event count that matches the rest of the array, so there are no
data-in-sync issues. It is enough that the uuid matches.
So remove the requirement that the event count is up-to-date.

We currently still write out and event count on spares, but this
allows us in a year or 3 to stop doing that completely.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9ef21d9..26b3d28 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1070,10 +1070,13 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 				mddev->bitmap_info.default_offset;
 
 	} else if (mddev->pers == NULL) {
-		/* Insist on good event counter while assembling */
+		/* Insist on good event counter while assembling, except
+		 * for spares (which don't need an event count) */
 		++ev1;
-		if (ev1 < mddev->events) 
-			return -EINVAL;
+		if (sb->disks[rdev->desc_nr].state & (
+			    (1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)))
+			if (ev1 < mddev->events) 
+				return -EINVAL;
 	} else if (mddev->bitmap) {
 		/* if adding to array with a bitmap, then we can accept an
 		 * older device ... but not too old.
@@ -1469,10 +1472,14 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		}
 
 	} else if (mddev->pers == NULL) {
-		/* Insist of good event counter while assembling */
+		/* Insist of good event counter while assembling, except for
+		 * spares (which don't need an event count) */
 		++ev1;
-		if (ev1 < mddev->events)
-			return -EINVAL;
+		if (rdev->desc_nr >= 0 &&
+		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
+		    le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < 0xfffe)
+			if (ev1 < mddev->events)
+				return -EINVAL;
 	} else if (mddev->bitmap) {
 		/* If adding to array with a bitmap, then we can accept an
 		 * older device, but not too old.
