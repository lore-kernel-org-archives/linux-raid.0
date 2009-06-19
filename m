From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Write intent bitmaps
Date: Fri, 19 Jun 2009 07:21:31 +0200
Message-ID: <87ab44x0h0.fsf@frosties.localdomain>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
	<18989.6010.582386.812296@fisica.ufpr.br>
	<874oue9cr1.fsf@frosties.localdomain>
	<19002.63208.449137.964133@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19002.63208.449137.964133@notabene.brown> (Neil Brown's message
	of "Fri, 19 Jun 2009 12:24:40 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Thursday June 18, goswin-v-b@web.de wrote:
>> carlos@fisica.ufpr.br (Carlos Carvalho) writes:
>> >  >2. On a RAID5 or RAID6 array, how much of a performance hit might I expect?
>> >
>> > Depends on the chunk and where the bitmap is. With an internal one the
>> > default chunk will cause a BIG hit. Fortunately it's very easy to try
>> > different settings with the array live, so you can easily revert when
>> > the world suddenly freezes around you... Our arrays are rather busy,
>> > so performance is important and I gave up on it. If you can put it on
>> > other disks I suppose it's possible to find a chunk size compatible
>> > with performance.
>> 
>> Worst case every write to the raid requires a write to the bitmap. So
>> your speed will be ~half. It is not (much) less than half though. You
>> could think that the seek to and from the bitmap must slow things down
>> even more but worst case is random access, which means there already
>> is a seek between each write. The bitmap just adds one write and one
>> seek for each write and seek.
>
> I think half-speed would be very very unlikely.  md tries to gather
> bitmap updates so that - where possible - it might update several bits
> all at once.
>
> I have measured a 10% performance drop.  However it is very dependant
> on workload and, and you say, bitmap chunk size.

From my tests with internal bitmaps half is what you get with the
default size. At least that was what I got with a software raid over
external raid enclosures. Might be a side effect of bitmap writes not
covering a stripe on the external raid enclosures and them slowing
them down in the hope of getting more data for that stripe. But it was
quite unusable.

>> One benefit of the bitmap during a full resync though is (afaik) that
>> the bitmap (better) indicates the amount done already. If the system
>> crashes and reboots the resync will resume instead of restart.
>
> When you a rebuilding a drive that had failed, we call that "recovery"
> not "resync".
> With 0.90 metadata, a recovery will always restart at the beginning.
> With 1.x metadata, we checkpoint the recovery so it won't duplicated
> very much work.
>
>
> NeilBrown

One of these days I have to redo my home raids with newer metadata.

MfG
        Goswin
