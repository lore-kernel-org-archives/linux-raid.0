From: Chris Worley <worleys@gmail.com>
Subject: Re: In Direct I/O, no matter how big the read/write, the bio's are
 all 4KB
Date: Tue, 9 May 2017 11:26:23 -1000
Message-ID: <CANWz5fh_wkbug56gPwqH9pYO+hGdSgi+H-56bANpb8Q159zOfQ@mail.gmail.com>
References: <CANWz5fgNgnZ6R9md1TwD16nZzhAzX-t8BaOsN5-x-FfEE3_h3Q@mail.gmail.com>
 <20170509201441.GA17309@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170509201441.GA17309@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 9, 2017 at 10:14 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, May 09, 2017 at 10:03:24AM -1000, Chris Worley wrote:
>> I realize DIO needs to be 4KB aligned,
>
> Actually many file systems do support sector size aligned direct I/O,
> which could be 512 byte aligned.  But as that's not your point :)
>
>> but why do large I/Os get
>> chopped down into 4KB bio's?
>
> They shouldn't.  What kernel version is this on?

$ uname -r
3.10.0-514.6.2.el7.x86_64

>
>> Doing a blocktrace of the md device, even though the app is writing at
>> 512KB, the MD driver is receiving 4KB bio's.
>
> The direct I/O code is using bio_add_page to build the bios it submits.
> It might be interesting to see which of the checks in it triggers
> an early return after the first page.

I vaguely recall the noop scheduler's only task is to merge adjacent
blocks.  In my case, there's "none" (no schedular at all) for all
block devices chained together.  Is that the issue?

Thanks,

Chris
