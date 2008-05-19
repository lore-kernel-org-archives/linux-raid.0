From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Mon, 19 May 2008 15:27:01 +1000
Message-ID: <18481.4005.570022.160686@notabene.brown>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	<18464.134.236488.251879@notabene.brown>
	<170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	<18466.39418.578722.92979@notabene.brown>
	<170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	<18467.43895.220708.254814@notabene.brown>
	<170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	<18467.59565.676987.926988@notabene.brown>
	<170fa0d20805090800p45654901p36eea51e1ea7e9c7@mail.gmail.com>
	<18477.30199.992302.271647@notabene.brown>
	<170fa0d20805182133o46501cc4va81b087fb6b417bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Monday May 19
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Monday May 19, snitzer@gmail.com wrote:
> 
> Hi Neil,
> 
> Sorry about not getting back with you sooner.  Thanks for putting
> significant time to chasing this problem.
> 
> I tested your most recent patch and unfortunately still hit the case
> where the nbd member becomes degraded yet the array continues to clear
> bits (events_cleared of the non-degraded member is higher than the
> degraded member).  Is this behavior somehow expected/correct?

It shouldn't be..... ahhh.
There is a delay between noting that the bit can be cleared, and
actually writing the zero to disk.  This is obviously intentional
in case the bit gets set again quickly.
I'm sampling the event count at the latter point instead of the
former, and there is time for it to change.

Maybe this patch on top of what I recently sent out?

Thanks,
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   10 ++++++++--
 ./include/linux/raid/bitmap.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-19 15:23:42.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-19 15:24:56.000000000 +1000
@@ -1092,9 +1092,9 @@ void bitmap_daemon_work(struct bitmap *b
 			/* We are possibly going to clear some bits, so make
 			 * sure that events_cleared is up-to-date.
 			 */
-			if (bitmap->events_cleared < bitmap->mddev->events) {
+			if (bitmap->need_sync) {
 				bitmap_super_t *sb;
-				bitmap->events_cleared = bitmap->mddev->events;
+				bitmap->need_sync = 0;
 				wait_event(bitmap->mddev->sb_wait,
 				    !test_bit(MD_CHANGE_CLEAN,
 					      &bitmap->mddev->flags));
@@ -1273,6 +1273,12 @@ void bitmap_endwrite(struct bitmap *bitm
 			return;
 		}
 
+		if (success &&
+		    bitmap->events_cleared < bitmap->mddev->events) {
+			bitmap->events_cleared = bitmap->mddev->events;
+			bitmap->need_sync = 1;
+		}
+
 		if (!success && ! (*bmc & NEEDED_MASK))
 			*bmc |= NEEDED_MASK;
 

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2008-05-19 15:23:50.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2008-05-19 15:24:56.000000000 +1000
@@ -221,6 +221,7 @@ struct bitmap {
 	unsigned long syncchunk;
 
 	__u64	events_cleared;
+	int need_sync;
 
 	/* bitmap spinlock */
 	spinlock_t lock;
