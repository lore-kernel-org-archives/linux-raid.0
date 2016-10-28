From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed raid5
Date: Sat, 29 Oct 2016 01:45:29 +0200
Message-ID: <20161028234529.GA3909@metamorpher.de>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133304.GA11564@metamorpher.de>
 <b878efa4-2581-9284-90ca-170ece7219b5@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b878efa4-2581-9284-90ca-170ece7219b5@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Alexander Shenkin <al@shenkin.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 28, 2016 at 05:16:27PM -0400, Phil Turmel wrote:
> Andreas' approach is rather expensive in practice

Not really. Currently all of my disks are out of their warranty period. 
Whenever I bring this up the first thing I hear is that I'm just 
not noticing these errors that are happening all the time... oh well.

I run SMART selftests daily (select,cont), I run mdadm checks and check 
for mismatch_cnt afterwards (always 0 thus far). Not sure what else to 
do... haven't gone as far as patching the kernel to be more verbose. 
There's only so much you can do.

I'm mainly using cheap WD Green drives. I don't like enterprise drives, 
there's nothing that makes them more reliable, and in a home use where 
they twiddle their thumbs most of the time what's the point of it all? 
Expensive drives are more likely to turn you into a penny-pincher 
when replacement would be the right thing to do...

> manufacturers of consumer-grade drives specify an error rate of less
> than 1 per 10^14 bits read.  That's only 12.5TB.

Yes, according to that math you get stuff like that:

    http://www.zdnet.com/article/why-raid-5-stops-working-in-2009/

Or perhaps that just isn't how failures happen.

    https://www.high-rely.com/blog/why-raid-5-stops-working-in-2009-not/

I'm sure there are better links on the topic.

If there actually was one failure for every 12.5TB, this technology 
would be unusable. It's a LOT more reliable than that, thankfully. 
So no, I don't replace my disks every 12.5TB. That'd be ridiculous.

Maybe you didn't mean it this way.

> Pending relocations are often just glitches that are gone after the
> sector is rewritten.

That's the other opinion I was referring to.

There's no way to tell what caused sectors to become unreadable. 
Is it just a glitch in the matrix, never happen again once fixed? 
Or is it a serious issue, likely to reoccur or get even worse.
Who knows? It's not like you can open it and check. 

> a weekly or monthly "check" scrub will help flush them out 
> in a timely fashion.

Our advice is not that different. You recommend regular checks. 
I recommend regular checks.

I just don't believe in the "it will magically fix itself and 
never happen again" kind of story. It's a trust issue, I just 
can't bring myself to trust disks that have already lost data 
once. Elsewhere people add checksums to filesystems because 
they worry about single bit flips, not entire sectors gone... 
how come one is completely fine but not the other.
(I'm not worried about bit flips, either.)

I see this timeout thing as a fad, it's brought up in every 
other thread about raid failures on this list, regardless 
how little / none indication there was that timeouts were 
related in any way at all to the failure in question.

You'd think timeouts would solve all problems. They probably don't. 
In some exceedingly rare cases, they might not even matter at all.

> Andreas' is flat-out wrong on this.

I say his raid failed due to not running checks, 
running checks is something you recommend too.
There is some common ground there, however tiny.

> Not that I recommend running without the SMART features

That's the general gist I get from reading your posts, though.

> -- you will still want to know when your drives have real problems.

What's a real problem then, when pending sectors and read failures 
in selftest are not real enough?

Some arbitrarily chosen number of errors...

Disks just go bad. You can make up whatever reasons to not replace them, 
but whether your RAID will survive it, seems like a gamble to me.
Backups are a failsafe. I like the safe part, I try to avoid the fail.

Everyone has to find their own approach to things.

Regards
Andreas Klauer
