From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Fri, 9 May 2008 16:01:17 +1000
Message-ID: <18467.59565.676987.926988@notabene.brown>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	<18464.134.236488.251879@notabene.brown>
	<170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	<18466.39418.578722.92979@notabene.brown>
	<170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	<18467.43895.220708.254814@notabene.brown>
	<170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Friday May 9
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Friday May 9, snitzer@gmail.com wrote:
> On Thu, May 8, 2008 at 9:40 PM, Neil Brown <neilb@suse.de> wrote:
> >
> > On Thursday May 8, snitzer@gmail.com wrote:
> >  > On Thu, May 8, 2008 at 2:13 AM, Neil Brown <neilb@suse.de> wrote:
> >  > > On Tuesday May 6, snitzer@gmail.com wrote:
> >  > >  >
> >  > >  > It looks like bitmap_update_sb()'s incrementing of events_cleared (on
> >  > >  > behalf of the local member) could be racing with the fact that the NBD
> >  > >  > member becomes faulty (whereby making the array degraded).  This
> >  > >  > allows the events_cleared to reflect a clean->dirty transition last
> >  > >  > occurred before the array became degraded.  My reasoning is: If it was
> >  > >  > a clean->dirty transition the bitmap still has the associated dirty
> >  > >  > bit set in the local member's bitmap, so using the bitmap to resync is
> >  > >  > valid.
> >  > >  >
> >  > >  > thanks,
> >  > >  > Mike
> >  > >
> >  > >  Thanks for persisting.  I think I understand what is going on now.
> >  > >
> >  > >  How about this patch?  It is similar to your, but instead of depending
> >  > >  on the odd/even state of the event counter, it directly checks the
> >  > >  clean/dirty state of the array.
> >  >
> >  > Hi Neil,
> >  >
> >  > Your revised patch works great and is obviously cleaner.
> >
> >  But I'm still not happy with it :-(
> >  I suspect there might be other cases where it will still do the wrong
> >  thing.
> >  The real problem is that we are updating events_cleared to early.  We
> >  are setting to the new event counter before that is even written out.
> >
> >  So I've come up with this patch, which I think more clearly
> >  encapsulated what events_cleared means.  It is now set to the current
> >  'events' counter immediately before we clear any bit.
> >
> >  If you could test it, I'd really appreciate it.
> 
> Unfortunately my testing with this patch results in a full resync.
> 
> Here is the state of the array after shutdown:
> # mdadm -X /dev/nbd0 /dev/sdq
>         Filename : /dev/nbd0
>            Magic : 6d746962
>          Version : 4
>             UUID : 7140cc3c:8681416c:12c5668a:984ca55d
>           Events : 896
>   Events Cleared : 897

Events Cleared is *larger* than Events!!! Is that repeatable?  I can
only see it happening if a very small race were lost.  You don't have
any other patches in there do you?

> 
> Was I supposed to use this latest patch in combination with your
> previous patch (to validate_super)?  Because you'll note that with
> your most recent patch nbd0's events (ev1) is still one less than
> sdq's events_cleared.  As such the validate_super's "ev1 <
> mddev->bitmap->events_cleared" check triggers a full rebuild.

No, you weren't suppose to combine it with the previous patch.

This patch should close the race, though I still find it hard to
believe that you lost the race.

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-09 11:02:13.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-09 16:00:07.000000000 +1000
@@ -465,8 +465,6 @@ void bitmap_update_sb(struct bitmap *bit
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (!bitmap->mddev->degraded)
-		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap_atomic(sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1094,9 +1092,21 @@ void bitmap_daemon_work(struct bitmap *b
 			} else
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 			lastpage = page;
-/*
-			printk("bitmap clean at page %lu\n", j);
-*/
+
+			/* We are possibly going to clear some bits, so make
+			 * sure that events_cleared is up-to-date.
+			 */
+			if (bitmap->events_cleared < bitmap->mddev->events) {
+				bitmap_super_t *sb;
+				bitmap->events_cleared = bitmap->mddev->events;
+				wait_event(mddev->sb_wait,
+				    !test_bit(MD_CHANGE_CLEAN, &mddev->flags));
+				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				sb->events_cleared =
+					cpu_to_le64(bitmap->events_cleared);
+				kunmap_atomic(sb, KM_USER0);
+				write_page(bitmap, bitmap->sb_page, 1);
+			}
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
