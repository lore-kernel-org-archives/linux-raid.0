From: Neil Brown <neilb@suse.de>
Subject: Re: Suggestion needed for fixing RAID6
Date: Mon, 3 May 2010 12:17:47 +1000
Message-ID: <20100503121747.7f2cc1f1@notabene.brown>
References: <626601cae203$dae35030$0400a8c0@dcccs>
	<20100423065143.GA17743@maude.comedia.it>
	<695a01cae2c1$a72907d0$0400a8c0@dcccs>
	<4BD193D0.5080003@shiftmail.org>
	<717901cae3e5$6a5fa730$0400a8c0@dcccs>
	<4BD3751A.5000403@shiftmail.org>
	<756601cae45e$213d6190$0400a8c0@dcccs>
	<4BD569E2.7010409@shiftmail.org>
	<7a3e01cae53f$684122c0$0400a8c0@dcccs>
	<4BD5C51E.9040207@shiftmail.org>
	<80a201cae621$684daa30$0400a8c0@dcccs>
	<4BD76CF6.5020804@shiftmail.org>
	<20100428113732.03486490@notabene.brown>
	<4BD830B0.1080406@shiftmail.org>
	<025e01cae6d7$30bb7870$0400a8c0@dcccs>
	<4BD843D4.7030700@shiftmail.org>
	<062001cae771$545e0910$0400a8c0@dcccs>
	<4BD9A41E.9050009@shiftmail.org>
	<0c1201cae7e0$01f9a930$0400a8c0@dcccs>
	<4BDA0F88.70907@shiftmail.org>
	<0d6401cae82c$da8b5590$0400a8c0@dcccs>
	<4BDB6DB6.5020306@shiftmail.org>
	<12cf01cae911$f0d92940$0400a8c0@dcccs>
	<4BDC6217.9000209@shiftmail.org>
	<154b01cae977$6e09da80$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <154b01cae977$6e09da80$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: MRK <mrk@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 May 2010 23:44:04 +0200
"Janos Haar" <janos.haar@netcenter.hu> wrote:

> The general problem is, i have one single-degraded RAID6 + 2 badblock disk 
> inside wich have bads in different location.
> The big question is how to keep the integrity or how to do the rebuild by 2 
> step instead of one continous?

Once you have the fix that has already been discussed in this thread, the
only other problem I can see with this situation is if attempts to write good
data over the read-errors results in a write-error which causes the device to
be evicted from the array.  And I think you have reported getting write
errors.

The following patch should address this issue for you.  It is *not* a
general-purpose fix, but a specific fix to address an issue you are having.
It might be appropriate to make this configurable via sysfs, or possibly even
to try to auto-detect the situation and don't bother writing.

Longer term I want to add support for storing a bad-block-list per device
so that a write error just fails that block, not the whole device.  I just
need to organise my time so that I make progress on that project.

NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c181438..fd73929 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3427,6 +3427,12 @@ static void handle_stripe6(struct stripe_head *sh)
 			    && !test_bit(R5_LOCKED, &dev->flags)
 			    && test_bit(R5_UPTODATE, &dev->flags)
 				) {
+#if 1
+				/* We have recovered the data, but don't
+				 * trust the device enough to write back
+				 */
+				clear_bit(R5_ReadError, &dev->flags);
+#else
 				if (!test_bit(R5_ReWrite, &dev->flags)) {
 					set_bit(R5_Wantwrite, &dev->flags);
 					set_bit(R5_ReWrite, &dev->flags);
@@ -3438,6 +3444,7 @@ static void handle_stripe6(struct stripe_head *sh)
 					set_bit(R5_LOCKED, &dev->flags);
 					s.locked++;
 				}
+#endif
 			}
 		}
 
