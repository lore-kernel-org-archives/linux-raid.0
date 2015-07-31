From: Tomas Papan <tomas.papan@gmail.com>
Subject: Re: raid5 regression in 4.1.x
Date: Fri, 31 Jul 2015 10:52:26 +0200
Message-ID: <CAMGsXDR3HRe7afWvdAQoR+mgecCo-6V9ABDCPS5b6gZg4FtA3w@mail.gmail.com>
References: <CAMGsXDSySVJA3PFo=v+_hWS+4K9VmuHMUEb3hSNtxqRG0P4=8A@mail.gmail.com>
	<20150731085724.025f3b2b@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150731085724.025f3b2b@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thanks for the explanation, I've installed the 4.2.0-rc4 (which has
your patch in it).
It booted and so far dmesg looks clean. I'll report back in couple of days.

Thanks
Tomas

On Fri, Jul 31, 2015 at 12:57 AM, NeilBrown <neilb@suse.com> wrote:
> On Wed, 29 Jul 2015 09:21:22 +0200 Tomas Papan <tomas.papan@gmail.com>
> wrote:
>
>> Hello there,
>>
>> I found a bug on my system. I do not know if this was already
>> reported. I can't find it anywhere.
>> Would you please have a look at this trace (attached)
>>
>>
>>
>> Unfortunately it happens completely random (after few days in this
>> case, with 4.1.0 it was in matter of hours) and I'm not able to bisect
>> this.
>>
>> Regards
>> Tomas
>
> Thanks for the report.
>
> The crash is happening in get_free_stripe() and the 'hash' argument is
> stored in register RSI and has (32bit) value 0xFFFFFFFF.  i.e. -1.
> That shouldn't happen - it should be from 0 to 7.
>
> get_free_stripe was called from drop_one_stripe():
>
>         int hash = (conf->max_nr_stripes - 1) % NR_STRIPE_HASH_LOCKS;
>
>         spin_lock_irq(conf->hash_locks + hash);
>         sh = get_free_stripe(conf, hash);
>
> so it seems that conf->max-nr_stripes was 0, which it really should
> never be.
>
> There is a patch submitted for 4.2 which should get into -stable a
> couple of weeks later which might help.
>
> If you would like to try just applying that patch and see if the
> problem goes away, it is
>
> http://git.neil.brown.name/?p=md.git;a=commitdiff;h=2d5b569b665ea6d0b15c52529ff06300de81a7ce
>
> or
>
> http://git.neil.brown.name/?p=md.git;a=commitdiff_plain;h=2d5b569b665ea6d0b15c52529ff06300de81a7ce
>
> I'll have another look at the code a bit later and see if I can
> convince myself what happened.
>
> Thanks,
> NeilBrown
