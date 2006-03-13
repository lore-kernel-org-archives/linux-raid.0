From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 14 Mar 2006 10:17:50 +1100
Message-ID: <17429.64926.100005.904328@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
	<5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
	<4415F400.5030808@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Patrik Jonsson on Monday March 13
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 13, patrik@ucolick.org wrote:
> Hi all,
> 
> I just experienced some kind of lockup accessing my 8-drive raid5
> (2.6.16-rc4-mm2). The system has been up for 16 days running fine, but
> now processes that try to read the md device hang. ps tells me they are
> all sleeping in get_active_stripe. There is nothing in the syslog, and I
> can read from the individual drives fine with dd. mdadm says the state
> is "active".

Hmmm... That's sad. That's going to be very hard to track down.

If you could
  echo t > /proc/sysrq-trigger

and send me the dump that appears in the kernel log, I would
appreciate it.  I doubt it will be very helpful, but it is the best
bet I can come up with.

> 
> I'm not sure what to do now. Is it safe to try to reboot the system or
> could that cause the device to get corrupted if it's hung in the middle
> of some important operation?

You could try increasing the size of the stripe cache
  echo 512 > /sys/block/mdX/md/stripe_cache_size
(choose and appropriate 'X').
Maybe check the content of
         /sys/block/mdX/md/stripe_cache_active
as well.

Other than that, just reboot.  The raid5 will do a resync, but the
data should be fine.

NeilBrown
