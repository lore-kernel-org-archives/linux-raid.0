From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Fri, 2 Jun 2006 17:27:36 +1000
Message-ID: <17535.59496.431182.785563@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
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
	<17531.35050.632471.433333@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>
	<17532.59212.364233.765155@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>
	<17532.62343.933852.982391@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>
	<17534.22056.981033.686846@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Friday June 2
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 2, dean@arctic.org wrote:
> On Thu, 1 Jun 2006, Neil Brown wrote:
> 
> > I've got one more long-shot I would like to try first.  If you could
> > backout that change to ll_rw_block, and apply this patch instead.
> > Then when it hangs, just cat the stripe_cache_active file and see if
> > that unplugs things or not (cat it a few times).
> 
> nope that didn't unstick it... i had to raise stripe_cache_size (from 256 
> to 768... 512 wasn't enough)...
> 
> -dean

Ok, thanks.
I still don't know what is really going on, but I'm 99.9863% sure this
will fix it, and is a reasonable thing to do.
(Yes, I lose a ';'.  That is deliberate).

Please let me know what this proves, and thanks again for your
patience.

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-05-28 21:56:56.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-02 17:24:07.000000000 +1000
@@ -285,7 +285,7 @@ static struct stripe_head *get_active_st
 						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
 						    conf->device_lock,
-						    unplug_slaves(conf->mddev);
+						    raid5_unplug_device(conf->mddev->queue)
 					);
 				conf->inactive_blocked = 0;
 			} else
