From: Alex Tomas <alex@clusterfs.com>
Subject: Re: linear writes to raid5
Date: Wed, 12 Apr 2006 20:01:22 +0400
Message-ID: <m3d5fmrdf1.fsf@bzzz.home.net>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
	<m3y7ybrffe.fsf@bzzz.home.net>
	<17468.18087.901186.523228@cse.unsw.edu.au>
	<m3hd4yrdx3.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3hd4yrdx3.fsf@bzzz.home.net> (Alex Tomas's message of "Wed,
 12 Apr 2006 19:50:32 +0400")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> Alex Tomas (AT) writes:

 AT> I see. though my point is a bit different:
 AT> say, there is an application that's doing big linear writes in order
 AT> to achieve good throughput. on the other hand, most of modern storages
 AT> are very sensible to request size and tend to suck serving zillions
 AT> of small I/Os. raid5 breaks all incoming requests into small ones and
 AT> handles them separately. of couse, one might be lucky and after submiting
 AT> those small requests get merged to larger ones. but only due to luck,
 AT> I'm afraid. what I'm talking about is expressly code in raid5 that
 AT> would try to merge small requests in some obvious cases.
 AT> for example:


sorry, forgot to include the example ...

there is 3 disks raid5 with chunk=64K. one does 128K request.

and in make_request() we do something like this:

    struct context {
              struct bio *bios[FOR_EVERY_DISK];
    };

    /* initialize context with empty bio's */
    for (all internal stripes) {
        sh = get_active_stripe();
        add_stripe_bio(sh, bi, ...);
        handle_stripe(sh, context);
    }
    /* submit all non-empty bio's from the context */


and in handle_stripe(): instead of immediate calling
generic_make_request() try to merge request to correspondend
bio in the context.

I understand there are few different limits to bio size,
active stripes, etc. but what do you think about the idea in general?

thanks, Alex
