From: David Rees <drees76@gmail.com>
Subject: Re: It is possible to put write cache on ssd?
Date: Tue, 8 Jun 2010 15:48:16 -0700
Message-ID: <AANLkTinPimwvZZJjnZeNdok3nS5tXBqx-FuJC2vefCc4@mail.gmail.com>
References: <loom.20100604T102522-67@post.gmane.org> <4C0D44FC.8020908@tmr.com>
	<1275972895.4313.51.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1275972895.4313.51.camel@sibyl.beware.dropbear.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Dall <ian@beware.dropbear.id.au>
Cc: Bill Davidsen <davidsen@tmr.com>, Mario <mgiammarco@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 7, 2010 at 9:54 PM, Ian Dall <ian@beware.dropbear.id.au> wrote:
> On Mon, 2010-06-07 at 15:14 -0400, Bill Davidsen wrote:
>> Actually playing with that now. I got an Intel SATA 40GB SSD, and I am
>> trying various combinations of things to put on it. One thing which I
>> hoped would benefit was to put a f/s journal on SSD and then use the
>> option to push all through the journal (data=journal) in hopes that it
>> would then free the RAM needed for cache and thus speed operation.
>>
>> Since none of that has generated the performance I hoped,
>
> Interesting. If its the X25-V that you have, write performance is
> nothing to write home about even compared to a single hard drive, let
> alone a raid. By journaling data as well (as metadata), you just add
> extra write overhead, possibly even a new bottleneck.

Depends on whether you are talking about small, seeky writes or large
writes.  Even the X25-V will kill any rotating drive in small seeky
writes, but if you are trying to write big files faster than ~40MB/s,
the the rotating disk might win depending on the exact one you are
comparing it to.

>> I also played with mirroring and write mostly, etc. Does provide a
>> general solution, at least in my tests.
>
> Do you mean "does NOT"?

write-mostly DOES work well in my tests...

-Dave
