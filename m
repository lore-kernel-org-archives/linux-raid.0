From: Neil Brown <neilb@suse.de>
Subject: Re: Kernel bug?
Date: Mon, 6 Apr 2009 14:43:19 +1000
Message-ID: <18905.34919.541782.615845@notabene.brown>
References: <49D777BC.4090009@tozzi.eu>
	<b4d41c1ac8bd783b1a62b73b4efc4200.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from NeilBrown on Sunday April 5
Sender: linux-raid-owner@vger.kernel.org
To: Gabriele Tozzi <gabriele@tozzi.eu>
Cc: linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

On Sunday April 5, neilb@suse.de wrote:
> On Sun, April 5, 2009 1:07 am, Gabriele Tozzi wrote:
> > Hello,
> >
> > I guess I've found a kernel bug: I get an oops when rebuilding a raid1
> > array (/dev/md5) on an SMP system. The md5_resync process then hangs.
> 
> Yes, it appears you have found a bug.  Thanks for reporting it.
> 
> It looks like an alloc_page failed in r1buf_pool_alloc and when trying
> to clean up we tried to free pages that had never been allocated.
> 
> The code in raid1.c assumes that newly allocated 'bios' have their
> bvec initialised to NULLs, but that apparently changed recently
> with commit d3f761104b097738932afcc310fbbbbfb007ef92
> 
> I'll post a patch after the weekend.

And here it is.   Applying this patch will mean that you are resync a
raid1 array safely.   It will send it upstream shortly and hopefully
it will be in 2.6.29.1

Thanks again,
NeilBrown

From 303a0e11d0ee136ad8f53f747f3c377daece763b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 6 Apr 2009 14:40:38 +1000
Subject: [PATCH] md/raid1 - don't assume newly allocated bvecs are initialised.

Since commit d3f761104b097738932afcc310fbbbbfb007ef92
newly allocated bvecs aren't initialised to NULL, so we have
to be more careful about freeing a bio which only managed
to get a few pages allocated to it.  Otherwise the resync
process crashes.

This patch is appropriate for 2.6.29-stable.

Cc: stable@kernel.org
Cc: "Jens Axboe" <jens.axboe@oracle.com>
Reported-by: Gabriele Tozzi <gabriele@tozzi.eu>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b4f4bad..f2247b0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -123,6 +123,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 				goto out_free_pages;
 
 			bio->bi_io_vec[i].bv_page = page;
+			bio->bi_vcnt = i+1;
 		}
 	}
 	/* If not user-requests, copy the page pointers to all bios */
@@ -138,9 +139,9 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	return r1_bio;
 
 out_free_pages:
-	for (i=0; i < RESYNC_PAGES ; i++)
-		for (j=0 ; j < pi->raid_disks; j++)
-			safe_put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
+	for (j=0 ; j < pi->raid_disks; j++)
+		for (i=0; i < r1_bio->bios[j]->bi_vcnt ; i++)
+			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
 	while ( ++j < pi->raid_disks )
-- 
1.6.2.1

