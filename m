From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] md - 1 of 2 - Use "shedule_timeout(2)" instead of
 yield() as it seems to wait for less time.
Date: Thu, 4 Mar 2004 22:16:21 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040304221621.47dd459f.akpm@osdl.org>
References: <20040305164342.7205.patches@notabene>
	<E1Az89R-0001su-00@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1Az89R-0001su-00@notabene>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> +		schedule_timeout(2);

Are you sure we want to sleep for 20-30 milliseconds on a 100 Hz machine?

Wouldn't it be better to do

diff -puN drivers/md/raid5.c~md-use-schedule_timeout drivers/md/raid5.c
--- 25/drivers/md/raid5.c~md-use-schedule_timeout	2004-03-04 22:15:14.000000000 -0800
+++ 25-akpm/drivers/md/raid5.c	2004-03-04 22:15:41.000000000 -0800
@@ -1409,7 +1409,8 @@ static int sync_request (mddev_t *mddev,
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access 
 		 */
-		yield();
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(max(HZ/500, 1));
 	}
 	spin_lock(&sh->lock);	
 	set_bit(STRIPE_SYNCING, &sh->state);
diff -puN drivers/md/raid6main.c~md-use-schedule_timeout drivers/md/raid6main.c
--- 25/drivers/md/raid6main.c~md-use-schedule_timeout	2004-03-04 22:15:14.000000000 -0800
+++ 25-akpm/drivers/md/raid6main.c	2004-03-04 22:15:50.000000000 -0800
@@ -1571,7 +1571,8 @@ static int sync_request (mddev_t *mddev,
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
 		 */
-		yield();
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(max(HZ/500, 1));
 	}
 	spin_lock(&sh->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);

_

?
