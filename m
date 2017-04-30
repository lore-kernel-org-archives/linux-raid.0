From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Sun, 30 Apr 2017 21:47:29 +0500
Message-ID: <20170430214729.2a02cce5@natsu>
References: <590117CD.1000009@tesco.net>
 <22785.65375.947842.648174@quad.stoffel.home>
 <5492628.c8B43Z4h0G@matkor-lenovo>
 <22786.16524.435313.304834@quad.stoffel.home>
 <87o9veje3v.fsf@esperi.org.uk>
 <20170430182134.0e8c6dc0@natsu>
 <87fugpkhap.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fugpkhap.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 30 Apr 2017 17:10:22 +0100
Nix <nix@esperi.org.uk> wrote:

> > It's not like the difference between the so called "fast" and "slow" parts is
> > 100- or even 10-fold. Just SSD-cache the entire thing (I prefer lvmcache not
> > bcache) and go.
> 
> I'd do that if SSDs had infinite lifespan. They really don't. :)
> lvmcache doesn't cache everything, only frequently-referenced things, so
> the problem is not so extreme there -- but

Yes I was concerned the lvmcache will over-use the SSD by mistakenly caching
streaming linear writes and the like -- and it absolutely doesn't. (it can
during the initial fill-up of the cache, but not afterwards).

Get an MLC-based SSD if that gives more peace of mind, but tests show even the
less durable TLC-based ones have lifespan measuring in hundreds of TB.
http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-all-dead

One SSD that I have currently has 19 TB written to it over its entire 4.5 year
lifespan. Over the past few months of being used as lvmcache for a 14 TB
bulk data array and a separate /home FS, new writes average at about 16 GB/day.
Given a VERY conservative 120 TBW endurance estimate, this SSD should last me
all the way into year 2034 at least.

> the fact that it has to be set up anew for *each LV* is a complete killer
> for me, since I have encrypted filesystems and things that *have* to be on
> separate LVs and I really do not want to try to figure out the right balance
> between distinct caches, thanks (oh and also you have to get the metadata
> size right, and if you get it wrong and it runs out of space all hell breaks
> loose, AIUI). bcaching the whole block device avoids all this pointless
> complexity. bcache just works.

Oh yes I wish they had a VG-level lvmcache. Still, it feels more mature than
bcache, the latter barely has any userspace management and monitoring tools
(having to fiddle with "echo > /sys/..." and "cat /sys/..." is not the state
of something you'd call a finished product). And the killer for me was that
there is no way to stop using bcache on a partition, once it's a "bcache
backing device" there is no way to migrate back to a raw partition, you're
stuck with it.

> This is a one-off with tooling to manage it: from my perspective, I just
> kick off the autobuilders etc and they'll automatically use transient
> space for objdirs. (And obviously this is all scripted so it is no
> harder than making or removing directories would be: typing 'mktransient
> foo' to automatically create a dir in transient space and set up a bind
> mount to it -- persisted across boots -- in the directory' foo' is
> literally a few letters more than typing 'mkdir foo'.)

Sorry for being rather blunt initially, still IMO the amount if micromanagement
required (and complexity introduced) is staggering compared to the benefits
reaped -- and it all appears to stem from underestimating the modern SSDs.
I'd suggest just get one and try "killing" it with your casual daily usage,
you'll find (via TBW numbers you will see in SMART compared even to vendor
spec'd ones, not to mention what tech sites' field tests show) that you just
can't, not until deep into a dozen of years later into the future.

-- 
With respect,
Roman
