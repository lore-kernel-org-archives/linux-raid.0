From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Wed, 17 Dec 2008 22:50:06 -0600
Message-ID: <cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <18757.62097.166706.244330@notabene.brown>
	 <cccedfc60812150542y5607d168q94c09d8dc3438226@mail.gmail.com>
	 <18758.52536.345145.238926@notabene.brown>
	 <cccedfc60812151347j659112c5na3aa8cd0eb044669@mail.gmail.com>
	 <18759.678.74091.236787@notabene.brown>
	 <18761.54425.725696.255055@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18761.54425.725696.255055@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 17, 2008 at 10:42 PM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday December 16, neilb@suse.de wrote:
>> On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>> > On Mon, Dec 15, 2008 at 3:33 PM, Neil Brown <neilb@suse.de> wrote:
>> > > On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
>> > >>
>> > >> Aha!  This explains a question I raised in another email. What
>> > >> happened there is a previously fully active member of the raid got
>> > >> added, somehow, as a spare, via --incremental. That's when the entire
>> > >> raid thought it needed to be rebuilt. How did that (the device being
>> > >> treated as a spare instead of as a previously fully active member)
>> > >> happen?
>> > >
>> > > It is hard to guess without details, and they might be hard to collect
>> > > after the fact.
>> > > Maybe if you have the kernel logs of when the server rebooted and the
>> > > recovery started, that might contain some hints.
>> >
>> > I hope this helps.
>>
>> Yes it does, though I generally prefer to get more complete logs.  If
>> I get the surrounding log lines then I know what isn't there as well
>> as what is - and it isn't always clear at first which bits will be
>> important.
>>
>> The problem here is that --incremental doesn't provide the --re-add
>> functionality that you are depending on.  That was an oversight on my
>> part.  I'll see if I can get it fixed.
>> In the mean time, you'll need to use --re-add (or --add, it does the
>> same thing in your situation) to add nbd0 to the array.
>
> Actually, I'm wrong.
> --incremental does do the right thing w.r.t. --re-add.
> I couldn't reproduce your symptoms.

OK.

> It could be that you are hitting the bug fixed by
>  commit a0da84f35b25875870270d16b6eccda4884d61a7

That sure sounds like it. I'd have to log to see what happened,
exactly, but I've added substantial logging around the device
discovery and addition section which manages this particular raid.

> You would need 2.6.26 or later to have that fixed.
> Can you try with a newer kernel???

I hope to be giving opensuse 11.1 a try soon, which uses 2.6.27.X
afaik.  I suspect I can also backport that patch to 2.6.25 easily.



-- 
Jon
