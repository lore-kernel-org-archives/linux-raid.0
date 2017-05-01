From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Mon, 01 May 2017 22:13:59 +0100
Message-ID: <8737cojn54.fsf@esperi.org.uk>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
        <22786.16524.435313.304834@quad.stoffel.home>
        <87o9veje3v.fsf@esperi.org.uk> <20170430182134.0e8c6dc0@natsu>
        <87fugpkhap.fsf@esperi.org.uk> <20170430214729.2a02cce5@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170430214729.2a02cce5@natsu> (Roman Mamedov's message of "Sun,
        30 Apr 2017 21:47:29 +0500")
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[linux-raid list: sorry, this is getting quite off-topic, though I'm
 finding the argument(?) quite fascinating. I can take it off-list if
 you like.]

On 30 Apr 2017, Roman Mamedov told this:

> On Sun, 30 Apr 2017 17:10:22 +0100
> Nix <nix@esperi.org.uk> wrote:
>
>> > It's not like the difference between the so called "fast" and "slow" parts is
>> > 100- or even 10-fold. Just SSD-cache the entire thing (I prefer lvmcache not
>> > bcache) and go.
>> 
>> I'd do that if SSDs had infinite lifespan. They really don't. :)
>> lvmcache doesn't cache everything, only frequently-referenced things, so
>> the problem is not so extreme there -- but
>
> Yes I was concerned the lvmcache will over-use the SSD by mistakenly caching
> streaming linear writes and the like -- and it absolutely doesn't. (it can
> during the initial fill-up of the cache, but not afterwards).

Yeah, it's hopeless to try to minimize SSD writes during initial cache
population. Of course you'll write to the SSD a lot then. That's the point.

> Get an MLC-based SSD if that gives more peace of mind, but tests show even the
> less durable TLC-based ones have lifespan measuring in hundreds of TB.
> http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-all-dead

That was a fascinating and frankly quite reassuring article, thank you! :)

> One SSD that I have currently has 19 TB written to it over its entire 4.5 year
> lifespan. Over the past few months of being used as lvmcache for a 14 TB
> bulk data array and a separate /home FS, new writes average at about 16 GB/day.

That's a lot less than I expect, alas. Busy machine, lots of busy source
trees and large transient writes -- and without some careful management
the SSD capacity would not be larger than the expected working set
forever. That's what the fast/slow division is for.

> Given a VERY conservative 120 TBW endurance estimate, this SSD should last me
> all the way into year 2034 at least.

The lifetime estimate on mine says three years to failure, at present
usage rates (datacenter-quality SSDs are neat, they give you software
that tells you things like this). I'll probably replace it with one
rated for higher write loads next time. They're still beyond my price
point right now, but in three years they should be much cheaper!)

>> the fact that it has to be set up anew for *each LV* is a complete killer
>> for me, since I have encrypted filesystems and things that *have* to be on
>> separate LVs and I really do not want to try to figure out the right balance
>> between distinct caches, thanks (oh and also you have to get the metadata
>> size right, and if you get it wrong and it runs out of space all hell breaks
>> loose, AIUI). bcaching the whole block device avoids all this pointless
>> complexity. bcache just works.
>
> Oh yes I wish they had a VG-level lvmcache. Still, it feels more mature than
> bcache, the latter barely has any userspace management and monitoring tools

I was worried about that, but y'know you hardly need them. You set it up
and it just works. (Plus, you can do things like temporarily turn the
cache *off* during e.g. initial population, have it ignore low-priority
I/O, streaming reads etc, none of which lvmcache could do last time I
looked. And nearly all the /sys knobs are persistently written to the
bcache superblock so you only need to tweak them once.)

I far prefer that to LVM's horribly complicated tools, which I frankly
barely understand by this point. The manpages randomly intermingle
ordinary LV, snapshotting, RAID, caching, clustering, and options only
useful for other use cases in an almighty tangle, relying on examples at
the bottom of the manpage to try to indicate which options are useful
where. Frankly they should be totally reorganized to be much more like
mdadm's -- divided into nice neat sections or at least with some sort of
by-LV-type options chart.

As for monitoring, the stats in /sys knock LVM's completely out of the
park, with continuously-updated stats on multiple time horizons.

To me, LVM feels both overdesigned and seriously undercooked for this
use case, definitely not ready for serious use as a cache.

> (having to fiddle with "echo > /sys/..." and "cat /sys/..." is not the state
> of something you'd call a finished product).

You mean, like md? :)

I like /sys. It's easy to explore and you can use your standard fs tools
on it. The only downside is the inability to comment anything :( but
that's what documentation is for. (Oh, also, if you need ordering or
binary data, /sys is the wrong tool. But for configuration interfaces
that is rarely true.)

>                                              And the killer for me was that
> there is no way to stop using bcache on a partition, once it's a "bcache
> backing device" there is no way to migrate back to a raw partition, you're
> stuck with it.

That doesn't really matter, since you can turn the cache off completely
and persistently with

echo none > /sys/block/bcache$num/bcache/cache_mode

and as soon as you do, the cache device is no longer required for the
bcache to work (though if you had it in use for writeback caching,
you'll have some fscking to do), and it imposes no overhead that I can
discern.

(The inability to use names with bcache devices *is* annoying: LVM and
indeed md beats it there.)

>> This is a one-off with tooling to manage it: from my perspective, I just
>> kick off the autobuilders etc and they'll automatically use transient
>> space for objdirs. (And obviously this is all scripted so it is no
>> harder than making or removing directories would be: typing 'mktransient
>> foo' to automatically create a dir in transient space and set up a bind
>> mount to it -- persisted across boots -- in the directory' foo' is
>> literally a few letters more than typing 'mkdir foo'.)
>
> Sorry for being rather blunt initially, still IMO the amount if micromanagement
> required (and complexity introduced) is staggering compared to the benefits

I was worried about that, but it's almost entirely scripted, so "none to
speak of". The only admin overhead I see in my daily usage is a single
"sync-vms" command every time I yum update my more write-insane test
virtual machines. (I don't like writing 100GiB to the SSD ten times a
day, so I run those VMs via CoW onto the RAID-0 transient fs, and write
them back to their real filesystems on the cached/journalled array after
big yum updates or when I do something else I want long-term
preservation for. That happens every few weeks, at most.)

Everything else is automated: my autobuilders make transient bind-mounts
onto the RAID-0 as needed, video transcoding drops stuff in there
automatically, and backups run with ionice -c3 so they don't flood the
cache either. I probably don't run mktransient by hand more than once a
month.

I'd be more worried about the complexity required to just figure out the
space needed for half a dozen sets of lvmcache metadata and cache
filesystems. (How do you know how much cache you'll need for each fs in
advance, anyway? That seems like a much harder question to answer than
"will I want to cache this at all".)

> reaped -- and it all appears to stem from underestimating the modern SSDs.
> I'd suggest just get one and try "killing" it with your casual daily usage,

When did I say I was a casual daily user? Build-and-test cycles with
tens to hundreds of gigs of writes daily are routine, and video
transcoding runs with half-terabyte to a terabyte of writes happen quite
often. I care about the content of those writes for about ten minutes
(one write, one read) and then couldn't care less about them: they're
entirely transient. Dumping them to an SSD cache, or indeed to the md
journal, is just pointless. I'm dropping some of them onto tmpfs, but
some are just too large for that.

I didn't say this was a setup useful for everyone! My workload happens
to have a lot of large briefly-useful writes in it, and a lot of
archival data that I don't want to waste space caching. It's the *other*
stuff, that doesn't fit into those categories, that I want to cache and
RAID-journal (and, for that matter, run routine backups of, so my own
backup policies told me what data fell into which category.)


As for modern SSDs... I think my Intel S3510 is a modern SSD, if not a
write-workload-focused one (my supplier lied to me and claimed it was
write-focused, and the spec sheet that said otherwise did not become
apparent until after I bought it, curses).

I'll switch to a write-focused 1.2TiB S3710, or the then-modern
equivalent, when the S3510 burns out. *That* little monster is rated for
14 petabytes of writes before failure... but it also costs over a
thousand pounds right now, and I already have a perfectly good SSD, so
why not use it until it dies? I'd agree that when using something like
the S3710 I'm going to stop caring about writes, because if you try to
write that much to rotating rust it's going to wear out too. But the
480GiB S3510, depending on which spec sheets I read, is either rated for
290TiB or 876TiB of writes before failure, and given the Intel SSD
"suicide-pill" self-bricking wearout failure mode described in the
article you cited above, I think being a bit cautious is worthwhile.
290TiB is only the equivalent of thirteen complete end-to-end writes to
the sum of all my RAID arrays... so no, I'm not treating it like it has
infinite write endurance. Its own specs say it doesn't. (This is also
why only the fast array is md-journalled.)

(However, I do note that the 335 tested in the endurance test above is
only rated for 20GiB of daily writes for three years, which comes to
only 22TiB total writes, but in the tests it bricked itself after
*720TiB*. So it's quite possible my S3510 will last vastly longer than
its own diagnostic tools estimate, well into the petabytes. I do hope it
does! I'm just not *trusting* that it does. A bit of fiddling and
scripting at setup time is quite acceptable for that peace of mind.
It wouldn't be worth it if this was a lot of work on an ongoing basis,
but it's nearly none.)

> you'll find (via TBW numbers you will see in SMART compared even to vendor
> spec'd ones, not to mention what tech sites' field tests show) that you just
> can't, not until deep into a dozen of years later into the future.

I'm very impressed by modern SSD write figures, and suspect that in a
few years they will be comparable to rotating rust's. They're just not,
yet. Not quite, and my workload falls squarely into the 'not quite' gap.
Given how easy it was for me to script my way around this problem, I
didn't mind much. With a hardware RAID array, it would have been much
more difficult! md's unmatched flexibility shines yet again.

-- 
NULL && (void)
