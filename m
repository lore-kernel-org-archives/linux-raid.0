From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Wed, 11 Feb 2009 16:06:30 +1100
Message-ID: <18834.23766.46860.265639@notabene.brown>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
	<18832.43882.839120.846061@notabene.brown>
	<cccedfc60902091607j4f37420s64898e4994d2607e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday February 9
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday February 9, jnelson-linux-raid@jamponi.net wrote:
> On Mon, Feb 9, 2009 at 4:17 PM, Neil Brown <neilb@suse.de> wrote:
> ...
> 
> > I've managed to reproduce this.
> >
> > If you fail the write-mostly device when the array is 'clean' (as
> > reported by --examine), it works as expected.
> > If you fail it when the array is 'active', you get the full recovery.
> >
> > The array is 'active' if there have been any writes in the last 200
> > msecs, and clean otherwise.
> >
> > I'll have to have a bit of a think about this and figure out where
> > what the correct fix is.   Nag me if you haven't heard anything by the
> > end of the week.

See below...

> 
> 
> Can-do. Here are some more wrinkles:
> 
> Wrinkle "A". I can't un-do "write-mostly". I used the md.txt docs that
> ship with the kernel which suggest that the following should work:


You want mdadm 2.6.8
  mdadm /dev/md0 --re-add --readwrite /dev/whatever

... or you would if it actually worked... That's odd, I cannot have
tested that....  I'll have to think about that too.

> 
> 
> Wrinkle "B": When I did the above, when I --re-add'ed /dev/nbd0, it
> went into "recovery" mode, which completed instantly. My recollection
> of "recovery" is that it does not update the bitmap until the entire
> process is complete. Is this correct? If so, I'd like to try to
> convince you (Neil Brown) that it's worthwhile to behave the same WRT
> the bitmap and up-to-dateness regardless of whether it's recovery or
> resync.

If the recovery is completing instantly, I wonder why you care exactly
when in that instant the bitmap is updated.... but I suspect that is
missing the point.

No, the bitmap isn't updated during recovery... Maybe it could be...
More thinking.


Mean while, this patch should fix your original problem.

commit 67ad8eaf70c5ca2948b482138d3f88764b3e8ee5
Author: NeilBrown <neilb@suse.de>
Date:   Wed Feb 11 15:33:21 2009 +1100

    md: never clear bit from the write-intent bitmap when the array is degraded.
    
    
    It is safe to clear a bit from the write-intent bitmap for a raid1
    when if we know the data has been written to all devices, which is
    what the current test does.
    But it is not always safe to update the 'events_cleared' counter in
    that case.  This is one request could complete successfully after some
    other request has partially failed.
    
    So simply disable the clearing and updating of events_cleared whenever
    the array is degraded.  This might end up not clearing some bits that
    could safely be cleared, but it is safest approach.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 01e3cff..d875172 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -386,7 +386,8 @@ static void raid1_end_write_request(struct bio *bio, int error)
 			/* clear the bitmap if all writes complete successfully */
 			bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
 					r1_bio->sectors,
-					!test_bit(R1BIO_Degraded, &r1_bio->state),
+					!test_bit(R1BIO_Degraded, &r1_bio->state)
+					&& !r1_bio->mddev->degraded,
 					behind);
 			md_write_end(r1_bio->mddev);
 			raid_end_bio_io(r1_bio);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6736d6d..9797a85 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -332,7 +332,8 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		/* clear the bitmap if all writes complete successfully */
 		bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
 				r10_bio->sectors,
-				!test_bit(R10BIO_Degraded, &r10_bio->state),
+				!test_bit(R10BIO_Degraded, &r10_bio->state) &&
+				!r10_bio->mddev->degraded,
 				0);
 		md_write_end(r10_bio->mddev);
 		raid_end_bio_io(r10_bio);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a5ba080..4d71cce 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2076,7 +2076,8 @@ static void handle_stripe_clean_event(raid5_conf_t *conf,
 					bitmap_endwrite(conf->mddev->bitmap,
 							sh->sector,
 							STRIPE_SECTORS,
-					 !test_bit(STRIPE_DEGRADED, &sh->state),
+					 !test_bit(STRIPE_DEGRADED, &sh->state) &&
+					 !conf->mddev->degraded,
 							0);
 			}
 		}
