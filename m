From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm memory leak?
Date: Wed, 6 Jul 2005 11:30:06 +1000
Message-ID: <17099.13342.229652.667901@cse.unsw.edu.au>
References: <42CA0B7E.4040109@shlrm.org>
	<17098.4949.378512.822529@cse.unsw.edu.au>
	<Pine.LNX.4.63.0507050831130.15691@cerberus>
	<17098.63205.207499.40820@cse.unsw.edu.au>
	<Pine.LNX.4.63.0507051458380.7296@cerberus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eric Sandall on Tuesday July 5
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandall <eric@sandall.us>
Cc: David Kowis <dkowis@shlrm.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 5, eric@sandall.us wrote:
> On Wed, 6 Jul 2005, Neil Brown wrote:
> > On Tuesday July 5, eric@sandall.us wrote:
> <snip>
> >>   Active / Total Objects (% used)    : 12080357 / 12132001 (99.6%)
> >>   Active / Total Slabs (% used)      : 176776 / 176776 (100.0%)
> >>   Active / Total Caches (% used)     : 66 / 101 (65.3%)
> >>   Active / Total Size (% used)       : 668099.80K / 671784.20K (99.5%)
> >>   Minimum / Average / Maximum Object : 0.01K / 0.05K / 128.00K
> >>
> >>    OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> >> 6013634 6013300  99%    0.02K  26609      226    106436K biovec-1
> >> 6013306 6013297  99%    0.09K 146666       41    586664K bio
> >
> > These two lines point to the problem - it is a leak of 'bio's.
> >
> > This patch fixes it.
> >
> > ### Diffstat output
> > ./drivers/md/md.c |    1 +
> > 1 files changed, 1 insertion(+)
> >
> > diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> > --- ./drivers/md/md.c~current~	2005-06-30 11:07:38.000000000 +1000
> > +++ ./drivers/md/md.c	2005-06-28 13:02:04.000000000 +1000
> > @@ -338,6 +338,7 @@ static int super_written(struct bio *bio
> >
> > 	if (atomic_dec_and_test(&rdev->mddev->pending_writes))
> > 		wake_up(&rdev->mddev->sb_wait);
> > +	bio_put(bio);
> > 	return 0;
> > }
> 
> Which kernel is that against? It doesn't apply against my 2.6.10-as7
> nor David Kowis' 2.6.12.1 and 2.6.11.12 kernel source trees
> (I don't even have the super_written function the patch is referring
> to)?

It was against ... 2.6.12-mm1 or similar I think.  Looks like the bug
didn't get to main-line until just before the fix, which it good.

2.6.10-as7 seems to have a different though related bug.
It contains the patch:
 http://www.acm.cs.rpi.edu/~dilinger/patches/2.6.10/as7/linux-2.6.10-as7/051-md_sync_page_io_max_vecs.patch

which contains:
diff -Nru a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c	2005-01-22 00:16:02 -08:00
+++ b/drivers/md/md.c	2005-01-22 00:16:02 -08:00
@@ -332,29 +332,26 @@
 static int sync_page_io(struct block_device *bdev, sector_t sector, int size,
 		   struct page *page, int rw)
 {
-	struct bio bio;
-	struct bio_vec vec;
+	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
 	struct completion event;
+	int ret;
+
+	bio_get(bio);
....
+	bio_put(bio);
+	return ret;
 }

bio_alloc sets the refcount to 1.
bio_get increments it to 2.
bio_put sets it back to 1.  But it never reaches zero.

You want to get rid of that bio_get near the top of sync_page_io.

NeilBrown
