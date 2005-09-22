From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Thu, 22 Sep 2005 18:32:20 +0200
Message-ID: <20050922163220.GA27401@uio.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050920153622.GA14287@uio.no> <17202.55529.310871.877019@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17202.55529.310871.877019@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 22, 2005 at 06:16:41PM +0200, Neil Brown wrote:
> Yes, that reindenting is a problem as it makes the patch hard to read
> -- it's hard to see which bits need to be checked and which don't.  If
> you could remove them for the next version, it would help....

I'll look into it.

> 1/ in raid5_reshape, rather than allocate a separate set of
>   stripe_heads, I think it would be good to re-size all of the stripes
>   and the continue running with the new set of stripe_heads.

Hm, that's an idea. OTOH, I'm not sure how much code it really saves; you
still need to have a notion about how many disks there are in a stripe, so
you can read and write the correct amount, calculate parity correctly etc...
and thus there is a distinction after all. It's an interesting thought,
though; I'd probably try to get it all working properly first, and then go
onto that later.

> 2/ Reserve the stripe_heads needed for a chunk-resize in make_request
>    (where it is safe to block) rather than in handle_stripe.

Hm. make_request is never called from the sync code, is it? My understanding
was that make_request was called whenever userspace wanted to read/write
something, and only then.

>    Once the reads are done, shuffle the pages (rather then memcpy,
>    just fiddle with pointers), and cause write-out to commence.

Ah, flipping the pointers is a good idea. I was searching for a way of doing
optimized page-to-page memcpy operations, but of course just moving the
pointers will work fine.

I've fixed what I believe is a race condition that might lead to the subtle
corruption I've been seeing (conf->expand_progress can change between the
geometry calculation and actual writing in make_request); I'm testing it now,
but random bugs are naturally hard to verify fixed :-) OTOH, I haven't seen
the problem with uninterruptable sleep for a while, so I hope my other fix
got that.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
