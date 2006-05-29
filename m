From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 30 May 2006 09:51:06 +1000
Message-ID: <17531.35050.632471.433333@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
	<5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
	<4415F400.5030808@ucolick.org>
	<17429.64926.100005.904328@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
	<Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
	<17522.29813.189944.397154@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
	<17527.38282.35857.117651@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>
	<17529.37347.782285.77442@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Monday May 29
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 29, dean@arctic.org wrote:
> 
> hope there's a clue in this one :)  but send me another patch if you need 
> more data.

Thanks.  This confirms that the device is 'plugged' - which I knew had
to be the case, but equally knew that it couldn't be the case :-)

Whenever the device gets plugged a 3msec timer is set and when the
timer fires, the device gets unplugged.  So it cannot possibly stay
plugged for more than 3 msecs.  Yet obviously it does.

I don't think the timer code can be going wrong, as it is very widely
used and if there was a problem I'm sure it would have been noticed by
now.  Besides I've checked it and it looks good - but that doesn't
seem to prove anything :-(

Another possibility is another processor doing
    q->queue_flags |= (1 << some_flag);
at the same time that the timer does
    clear_bit(queue_plugged, &q->queue_flags);

That could cause the clearing of the bit to be lost.  But I don't
think that happens, certainly not after the last patch I gave you.

I now realise I should have got that cryptic printk to print the
result of
         timer_pending(&mddev->queue->unplug_timer);
but I'm fairly sure it would have said '0' which would leave me
equally in the dark.

Maybe you have bad memory with one bit that doesn't stay set (or
clear) properly, and that bit happen to always line up with the
QUEUE_FLAG_PLUGGED bit for this array.... Ok, that's impossible too,
especially as Patrik reported the same problem!

(stares at the code lots more, goes down several blind alleys...)

Well.... maybe.....
There does seem to be a small hole in the chain that leads from a
queue being plugged to it be unplugged again.  I'm not convinced that
the race can actually be lost, but obviously something fairly
unbelievable is happening...

Could you try this patch please?  On top of the rest.
And if it doesn't fail in a couple of days, tell me how regularly the
message 
   kblockd_schedule_work failed
gets printed.

Thanks,
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff ./block/ll_rw_blk.c~current~ ./block/ll_rw_blk.c
--- ./block/ll_rw_blk.c~current~	2006-05-30 09:48:02.000000000 +1000
+++ ./block/ll_rw_blk.c	2006-05-30 09:48:48.000000000 +1000
@@ -1636,7 +1636,11 @@ static void blk_unplug_timeout(unsigned 
 {
 	request_queue_t *q = (request_queue_t *)data;
 
-	kblockd_schedule_work(&q->unplug_work);
+	if (!kblockd_schedule_work(&q->unplug_work)) {
+		/* failed to schedule the work, try again later */
+		printk("kblockd_schedule_work failed\n");
+		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
+	}
 }
 
 /**
