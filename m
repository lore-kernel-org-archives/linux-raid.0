From: NeilBrown <neilb@suse.com>
Subject: Re: raid5 regression in 4.1.x
Date: Fri, 31 Jul 2015 08:57:24 +1000
Message-ID: <20150731085724.025f3b2b@noble>
References: <CAMGsXDSySVJA3PFo=v+_hWS+4K9VmuHMUEb3hSNtxqRG0P4=8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGsXDSySVJA3PFo=v+_hWS+4K9VmuHMUEb3hSNtxqRG0P4=8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas Papan <tomas.papan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 09:21:22 +0200 Tomas Papan <tomas.papan@gmail.com>
wrote:

> Hello there,
> 
> I found a bug on my system. I do not know if this was already
> reported. I can't find it anywhere.
> Would you please have a look at this trace (attached)
> 
> 
> 
> Unfortunately it happens completely random (after few days in this
> case, with 4.1.0 it was in matter of hours) and I'm not able to bisect
> this.
> 
> Regards
> Tomas

Thanks for the report.

The crash is happening in get_free_stripe() and the 'hash' argument is
stored in register RSI and has (32bit) value 0xFFFFFFFF.  i.e. -1.
That shouldn't happen - it should be from 0 to 7.

get_free_stripe was called from drop_one_stripe():

	int hash = (conf->max_nr_stripes - 1) % NR_STRIPE_HASH_LOCKS;

	spin_lock_irq(conf->hash_locks + hash);
	sh = get_free_stripe(conf, hash);

so it seems that conf->max-nr_stripes was 0, which it really should
never be.

There is a patch submitted for 4.2 which should get into -stable a
couple of weeks later which might help.

If you would like to try just applying that patch and see if the
problem goes away, it is

http://git.neil.brown.name/?p=md.git;a=commitdiff;h=2d5b569b665ea6d0b15c52529ff06300de81a7ce

or

http://git.neil.brown.name/?p=md.git;a=commitdiff_plain;h=2d5b569b665ea6d0b15c52529ff06300de81a7ce

I'll have another look at the code a bit later and see if I can
convince myself what happened.

Thanks,
NeilBrown
