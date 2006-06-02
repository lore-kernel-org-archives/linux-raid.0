From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 hang on get_active_stripe
Date: Fri, 2 Jun 2006 00:10:31 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
 <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
 <4415F400.5030808@ucolick.org> <17429.64926.100005.904328@cse.unsw.edu.au>
 <Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
 <Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
 <17522.29813.189944.397154@cse.unsw.edu.au> <Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
 <17527.38282.35857.117651@cse.unsw.edu.au> <Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>
 <17529.37347.782285.77442@cse.unsw.edu.au> <Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>
 <17531.35050.632471.433333@cse.unsw.edu.au> <Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>
 <17532.59212.364233.765155@cse.unsw.edu.au> <Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>
 <17532.62343.933852.982391@cse.unsw.edu.au> <Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>
 <17534.22056.981033.686846@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17534.22056.981033.686846@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 1 Jun 2006, Neil Brown wrote:

> I've got one more long-shot I would like to try first.  If you could
> backout that change to ll_rw_block, and apply this patch instead.
> Then when it hangs, just cat the stripe_cache_active file and see if
> that unplugs things or not (cat it a few times).

nope that didn't unstick it... i had to raise stripe_cache_size (from 256 
to 768... 512 wasn't enough)...

-dean
