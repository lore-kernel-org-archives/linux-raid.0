From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Mon, 12 Sep 2016 15:37:53 -0600
Message-ID: <CAJCQCtRQmyvCqCqvmKazPg7cFrZ9A5SzZ+Yts_B3SxHU5s68GQ@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com> <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Sep 12, 2016 at 3:13 PM, Daniel Sanabria <sanabria.d@gmail.com> wrote:

> Error: Invalid argument during seek for read on /dev/sdc
> Retry/Ignore/Cancel? R
> Error: Invalid argument during seek for read on /dev/sdc
> Retry/Ignore/Cancel? I
> Error: The backup GPT table is corrupt, but the primary appears OK, so
> that will be used.
> OK/Cancel? O
> Model: ATA WDC WD30EZRX-00D (scsi)
> Disk /dev/sdc: 3001GB
> Sector size (logical/physical): 512B/4096B
> Partition Table: unknown
> Disk Flags:

What version of parted?

This looks like a problem due to the error, followed by "primary
appears OK" but instead of using that like it says, it reports the
Partition Table as unknown. Not expected.



> Error: Invalid argument during seek for read on /dev/sde
> Retry/Ignore/Cancel? C
> Model: ATA WDC WD30EZRX-00D (scsi)
> Disk /dev/sde: 3001GB
> Sector size (logical/physical): 512B/4096B
> Partition Table: unknown
> Disk Flags:


And the same thing with a second drive? What are the chances? Can you
post a complete dmesg somewhere? Are these two drives on the same
controller?


smartctl -x for each drive?


-- 
Chris Murphy
