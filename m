From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Fri, 10 Jun 2011 11:25:27 +0100
Message-ID: <4DF1F117.5010604@anonymous.org.uk>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>	<4DECF025.9040006@fnarfbargle.com>	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>	<4DECF841.1060906@fnarfbargle.com> <BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com> <4DEDE6E7.40301@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEDE6E7.40301@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/06/2011 09:52, John Robinson wrote:
> On 06/06/2011 19:06, Durval Menezes wrote:
> [...]
>> It would be great to have a
>> "duplicate-this-bad-old-disk-into-this-shiny-new-disk" functionality,
>> as it would enable an almost-no-downtime disk replacement with
>> minimum risk, but it seems we can't have everything... :-0 Maybe it's
>> something for the wishlist?
>
> It's already on the wishlist, described as a hot replace.

Actually I've been thinking about this. I think I'd rather the hot 
replace functionality did a normal rebuild from the still-good drives, 
and only if it came across a read error from those would it attempt to 
refer to the contents of the known-to-be-failing drive (and then also 
attempt to repair the read error on the supposedly-still-good drive that 
gave a read error, as already happens).

My rationale for this is as follows: if we want to hot-replace a drive 
that's known to be failing, we should trust it less than the remaining 
still-good drives, and treat it with kid gloves. It may be suffering 
from bit-rot. We'd rather not hit all the bad sectors on the failing 
drive, because each time we do that we send the drive into 7 seconds (or 
more, for cheap drives without TLER) of re-reading, plus any Linux-level 
re-reading there might be. Further, making the known-to-be-failing drive 
work extra hard (doing the equivalent of dd'ing from it while also still 
using it to serve its contents as an array member) might make it die 
completely before we've finished.

What will this do for rebuild time? Well, I don't think it'll be any 
slower. On the one hand, you'd think that copying from one drive to 
another would be faster than a rebuild, because you're only reading 1 
drive instead of N-1, but on the other, your array is going to run 
slowly (pretty much degraded speed) anyway because you're keeping one 
drive in constant use reading from it, and you risk it becoming much, 
much slower if you do run in to hundreds or thousands of read errors on 
the failing drive.

So overall I think hot-replace should be a normal replace with a 
possible second source of data/parity.

Thoughts?

Yes, I know, -ENOPATCH

Cheers,

John.

