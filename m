From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: SW-RAID1 and 2.5.34
Date: Fri, 13 Sep 2002 10:44:17 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15745.13537.81300.413518@notabene.cse.unsw.edu.au>
References: <1031835624.1155.3.camel@aragorn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dirk Meul on  September 12
To: Dirk Meul <dirk.meul@epost.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  September 12, dirk.meul@epost.de wrote:
> Hello.
> 
> I'm not able to boot plain 2.5.34 with RAID1 enabled. My root partition
> is RAID1 and with 2.4.19 everything is ok. But bug on md.c:3153 in
> md_queue_proc. What can i do to fix it?

The patch just went it Linus' BK tree.
It is below.
I don't promise that this fixes everything, just that if fixes the
"bug at md.c:3153".

NeilBrown


Remove BUG in md.c that change in 2.5.33 triggers.

Since 2.5.33, the blk_dev[].queue is called without
the device open, so md_queue_proc can no-longer assume
that the device is open.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

--- ./drivers/md/md.c	2002/09/11 00:27:10	1.1
+++ ./drivers/md/md.c	2002/09/11 00:37:33	1.2
@@ -3149,11 +3149,11 @@ request_queue_t * md_queue_proc(kdev_t d
 {
 	mddev_t *mddev = mddev_find(minor(dev));
 	request_queue_t *q = BLK_DEFAULT_QUEUE(MAJOR_NR);
-	if (!mddev || atomic_read(&mddev->active)<2)
-		BUG();
-	if (mddev->pers)
-		q = &mddev->queue;
-	mddev_put(mddev); /* the caller must hold a reference... */
+	if (mddev) {
+		if (mddev->pers)
+			q = &mddev->queue;
+		mddev_put(mddev);
+	}
 	return q;
 }
 
