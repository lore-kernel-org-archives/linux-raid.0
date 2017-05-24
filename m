From: Nix <nix@esperi.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Wed, 24 May 2017 14:28:33 +0100
Message-ID: <87bmqio03i.fsf@esperi.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
        <87a865jf9a.fsf@notabene.neil.brown.name>
        <87fufwy3lr.fsf@esperi.org.uk>
        <87poezhwsa.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87poezhwsa.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Wed, 24 May 2017 11:24:21 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 May 2017, NeilBrown uttered the following:

> On Mon, May 22 2017, Nix wrote:
>
>> Everything else hangs the same way, too. This was surprising enough that
>> I double-checked to be sure the patch was applied: it was. I suspect the
>> deadlock is somewhat different than you supposed... (and quite possibly
>> not a race at all, or I wouldn't be hitting it so consistently, every
>> time. I mean, I only need to miss it *once* and I'll have reshaped... :) )
>>
>> It seems I can reproduce this on demand, so if you want to throw a patch
>> with piles of extra printks my way, feel free.
>
> Did you have md_write_start being called by syslog-ng again?

Yeah.

> I wonder what syslog is logging - presumably something about the reshape
> starting.

Almost certainly.

> If you kill syslog-ng, can you start the reshape?

If I kill syslog-ng the entire network gets very unhappy and most of
userspace across all of it blocks solid waiting for a syslog-ng that
isn't there in very little time. It's the primary log host... :/ I might
switch back to the old log host (primary until three weeks ago) and try
again, but honestly the amount of ongoing traffic on this array is such
that I suspect *something* will creep in no matter what you do. (The
only reason process accounting's not going there is because I'm dumping
it on the RAID-0 array I already reshaped.)

(e.g. this time I also saw write traffic from mysqld. God knows what it
was doing: the database there is about the most idle database ever --
which is why I don't care about its being on RAID-5/6 -- and I know for
sure that it currently has a grand total of zero clients connected.)

Plus there's the usual pile of ongoing "you are still breathing so I'll
do more backlogged stuff" XFS metadata updates, rmap traffic, etc.

> Alternately, this might do it.
> I think the root problem is that it isn't safe to call mddev_suspend()
> while holding the reconfig_mutex.
> For complete safety I probably need to move the request_module() call
> earlier, as that could block if a device was suspended (no memory
> allocation allowed while device is suspended).

I'll give this a try!

(I'm not sure what to do if it *works* -- how do I test any later
changes? I might reshape back to RAID-5 + spare again just so I can test
later stuff, but that would take ages: the array is over 14TiB...)

-- 
NULL && (void)
