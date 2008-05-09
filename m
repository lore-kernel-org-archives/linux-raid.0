From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Fri, 9 May 2008 11:40:07 +1000
Message-ID: <18467.43895.220708.254814@notabene.brown>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	<18464.134.236488.251879@notabene.brown>
	<170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	<18466.39418.578722.92979@notabene.brown>
	<170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Thursday May 8
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Thursday May 8, snitzer@gmail.com wrote:
> On Thu, May 8, 2008 at 2:13 AM, Neil Brown <neilb@suse.de> wrote:
> > On Tuesday May 6, snitzer@gmail.com wrote:
> >  >
> >  > It looks like bitmap_update_sb()'s incrementing of events_cleared (on
> >  > behalf of the local member) could be racing with the fact that the NBD
> >  > member becomes faulty (whereby making the array degraded).  This
> >  > allows the events_cleared to reflect a clean->dirty transition last
> >  > occurred before the array became degraded.  My reasoning is: If it was
> >  > a clean->dirty transition the bitmap still has the associated dirty
> >  > bit set in the local member's bitmap, so using the bitmap to resync is
> >  > valid.
> >  >
> >  > thanks,
> >  > Mike
> >
> >  Thanks for persisting.  I think I understand what is going on now.
> >
> >  How about this patch?  It is similar to your, but instead of depending
> >  on the odd/even state of the event counter, it directly checks the
> >  clean/dirty state of the array.
> 
> Hi Neil,
> 
> Your revised patch works great and is obviously cleaner.

But I'm still not happy with it :-(
I suspect there might be other cases where it will still do the wrong
thing.
The real problem is that we are updating events_cleared to early.  We
are setting to the new event counter before that is even written out.

So I've come up with this patch, which I think more clearly
encapsulated what events_cleared means.  It is now set to the current
'events' counter immediately before we clear any bit.

If you could test it, I'd really appreciate it.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-09 11:02:13.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-09 11:38:35.000000000 +1000
@@ -465,8 +465,6 @@ void bitmap_update_sb(struct bitmap *bit
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (!bitmap->mddev->degraded)
-		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap_atomic(sb, KM_USER0);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1094,9 +1092,19 @@ void bitmap_daemon_work(struct bitmap *b
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
+				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				bitmap->events_cleared = bitmap->mddev->events;
+				sb->events_cleared =
+					cpu_to_le64(bitmap->events_cleared);
+				kunmap_atomic(sb, KM_USER0);
+				write_page(bitmap, bitmap->sb_page, 1);
+			}
 			spin_lock_irqsave(&bitmap->lock, flags);
 			clear_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 		}
