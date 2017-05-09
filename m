From: Christoph Hellwig <hch@infradead.org>
Subject: Re: In Direct I/O, no matter how big the read/write, the bio's are
 all 4KB
Date: Tue, 9 May 2017 13:14:41 -0700
Message-ID: <20170509201441.GA17309@infradead.org>
References: <CANWz5fgNgnZ6R9md1TwD16nZzhAzX-t8BaOsN5-x-FfEE3_h3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANWz5fgNgnZ6R9md1TwD16nZzhAzX-t8BaOsN5-x-FfEE3_h3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 09, 2017 at 10:03:24AM -1000, Chris Worley wrote:
> I realize DIO needs to be 4KB aligned,

Actually many file systems do support sector size aligned direct I/O,
which could be 512 byte aligned.  But as that's not your point :)

> but why do large I/Os get
> chopped down into 4KB bio's?

They shouldn't.  What kernel version is this on?

> Doing a blocktrace of the md device, even though the app is writing at
> 512KB, the MD driver is receiving 4KB bio's.

The direct I/O code is using bio_add_page to build the bios it submits.
It might be interesting to see which of the checks in it triggers
an early return after the first page.
