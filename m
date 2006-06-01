From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Thu, 1 Jun 2006 12:51:20 +1000
Message-ID: <17534.22056.981033.686846@cse.unsw.edu.au>
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
	<17531.35050.632471.433333@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>
	<17532.59212.364233.765155@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>
	<17532.62343.933852.982391@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Tuesday May 30
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 30, dean@arctic.org wrote:
> On Wed, 31 May 2006, Neil Brown wrote:
> 
> > On Tuesday May 30, dean@arctic.org wrote:
> > > 
> > > actually i think the rate is higher... i'm not sure why, but klogd doesn't 
> > > seem to keep up with it:
> > > 
> > > root@neemlark:~# grep -c kblockd_schedule_work /var/log/messages
> > > 31
> > > root@neemlark:~# dmesg | grep -c kblockd_schedule_work
> > > 8192
> > 
> > # grep 'last message repeated' /var/log/messages
> > ??
> 
> um hi, of course :)  the paste below is approximately correct.
> 

Ok, so thousands of times a second.  Not what I expected at all...

So I read the code more carefully, and can see that patch was all
wrong.  It might actually make the problem go away, but isn't really
the right fix.

I think I will be able to suggest a fix which should work a be a
reasonable thing to do, but it still won't help me understand the
problem.

I've got one more long-shot I would like to try first.  If you could
backout that change to ll_rw_block, and apply this patch instead.
Then when it hangs, just cat the stripe_cache_active file and see if
that unplugs things or not (cat it a few times).

If it does, I think I am on to the problem.
If it doesn't I'll give up and give you a patch that should work
around the problem in a reasonable way.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    3 +++
 1 file changed, 3 insertions(+)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-05-28 21:56:56.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-01 12:44:52.000000000 +1000
@@ -1840,6 +1840,9 @@ stripe_cache_active_show(mddev_t *mddev,
 		spin_unlock_irq(&conf->device_lock);
 		n += sprintf(page+n, "bitlist=%d delaylist=%d\n", c1, c2);
 		trigger = 0xffff;
+
+		/* incredible long shot... */
+		kblockd_flush();
 		return n;
 	} else
 		return 0;
