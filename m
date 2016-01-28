From: Chien Lee <chienlee@qnap.com>
Subject: Re: [PATCH/RFC/RFT] md: allow resync to go faster when there is
 competing IO.
Date: Thu, 28 Jan 2016 12:42:08 +0800
Message-ID: <CAByoP052tnHBOdShca4AuUPgngWt8t1uKZyZiTDg9um9MfsaNQ@mail.gmail.com>
References: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com>
	<87si1k2do8.fsf@notabene.neil.brown.name>
	<CAByoP04se9yQv_u1Kc1pXk5shtzT_udTB4v4HYaJRfc0Eh1RqA@mail.gmail.com>
	<87wpqu1jrl.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wpqu1jrl.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, shli@kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Thanks for testing.
>
> I'd like to suggest that these results are fairly reasonable for the
> numjobs=64 case.  Certainly read-speed is reduced by presumably resync
> speed is increased.
> The numbers for numjob=1 are appalling though.  That would generally
> affect any synchronous load.  As the synchronous load doesn't interfere
> much with the resync load, the delays that are inserted won't be very
> long.
>
> I feel there must be an answer here -  I just cannot find it.
> I'd like to be able to dynamically estimate the bandwidth of the array
> and use (say) 10% of that, but I cannot think of a way to do that at all
> reliably.
>
> I'll ponder it a bit longer.  We may need to ultimately revert that
> patch, but not yet.
>
> Thanks,
> NeilBrown

Hello Neil,

This issue about competing between sync IO and non-sync IO is a
trade-off question
and need to consider deeply and widely. Thanks for your advice.

If any progress about this, please let me know first. I'm happy that I
can provide
my test results for community.

Thanks again,
Chien Lee
