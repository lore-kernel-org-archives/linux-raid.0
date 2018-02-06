From: Liwei <xieliwei@gmail.com>
Subject: Re: Buffer I/O error... async page read
Date: Tue, 6 Feb 2018 21:55:30 +0800
Message-ID: <CAPE0SYxdUMivzCv++RaHWt90QkMBBV-oCAiGjMUxVsWdezS0mg@mail.gmail.com>
References: <CAPE0SYxDgs6NY_ZALVY5kB5a-vrpK1GQvqqtf60gjCCmn2eP8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPE0SYxDgs6NY_ZALVY5kB5a-vrpK1GQvqqtf60gjCCmn2eP8g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6 February 2018 at 03:10, Liwei <xieliwei@gmail.com> wrote:
> Hi list,
>
> tl;dr: Array seems to be remembering bad blocks from recovered drive,
> even though drive the image is on is fine. Is there a way to make
> array forget the blocks? Is it safe?
>
>
>     We had a raid6 array that went down because 2 drives went down and
> 1 drive encountered bad sectors.
>     We managed to recover the 1 drive with bad sectors (we engaged a
> recovery lab), and the remaining drives in the array report neither
> pending nor re-allocated sectors (from smartctl).
>
>     After re-integrating the (image of the) recovered drive with bad
> sectors and starting the array in degraded mode, we realised we are
> still unable to read from some sectors in the md device. I believe
> they correspond to where the bad sectors were previously.
>
>     When trying to read from said sectors, this comes up in dmesg:
>
> [Feb 6 02:05] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [  +0.000458] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [ +13.297834] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [  +0.000438] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [Feb 6 02:06] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [  +0.000390] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [ +13.284550] Buffer I/O error on dev dm-26, logical block 5166102915,
> async page read
> [  +0.000448] Buffer I/O error on dev dm-26, logical block 5166102915,
> async page read
> [Feb 6 02:17] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [  +0.000341] Buffer I/O error on dev dm-26, logical block 5166101891,
> async page read
> [Feb 6 02:24] Buffer I/O error on dev dm-26, logical block 5166118804,
> async page read
> [  +0.002417] Buffer I/O error on dev dm-26, logical block 5166118804,
> async page read
> [  +2.972446] Buffer I/O error on dev dm-26, logical block 5166118804,
> async page read
> [  +0.002172] Buffer I/O error on dev dm-26, logical block 5166118804,
> async page read
> [Feb 6 02:25] Buffer I/O error on dev dm-26, logical block 5166118804,
> async page read
> [  +0.002130] Buffer I/O error on dev dm-26, logical block 5166118804,
> async page read
>
>     However, I've checked smartctl and ran a pass of (read-only)
> badblocks over the drives, all sectors are readable, there are no
> pending sectors, and no reallocated sectors.
>
>     So what is generating these buffer I/O errors?
>
>     Also, upon investigating, I'm astonished to find a non-empty list when I do:
>         /sys/block/md126/md/dev-*/bad_blocks
>
>     Almost every drive in the array has a few entries. That's not
> normal isn't it? My theory is that since these are consumer-grade SATA
> drives, some odd read/write timeout must have occurred at some point,
> causing md to think that the sectors are bad? Is there a way to make
> md forget about these blocks? Is it safe to do so?
>
> Warm regards,
> Liwei

Just answering my question. Turns out the I/O errors are caused by the
MD bad blocks log. There wasn't an easy way to clear the log unless I
wrote over the supposedly bad blocks.

But turns out since the log is in the superblock, I dd-ed it out,
edited the log entries to all FF, cleared the bad blocks feature bit
in the header, updated the checksum, dd-ed the edited superblock back
in, and viola, no more read errors and I have access to my data!

Disclaimer: I had offline backup of the drive images and a write
overlay, please ensure there's a way back if anyone tries something
like this.
