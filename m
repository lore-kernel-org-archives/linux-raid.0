From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Subject: Re: Fault tolerance with badblocks
Date: Fri, 5 May 2017 21:23:04 +0100
Message-ID: <22796.57128.627832.878830@tree.ty.sabi.co.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> No. With modern hard drives, no filesystem should pay any
>> attention to badblocks - it's all handled in the drive firmware.

> ext4 supports this,

Also JFS also supports bad-block avoidance, but only at 'mkfs' time
and JFS does this for legacy reason: Linux JFS supports this because
it is a port of JFS/2 from OS/2 which was a port of JFS version 1
from AIX in 1990.

> and is a relatively modern filesystem released in December
> 2008.

It is just a retread of 'ext3' which itself was a recycling of
'ext2' which was in turn a clone of the 4BSD FFS, and we are talking
of design decisions taken in 1982-3, not 2008.

> While it could be argued that this is for legacy support,

It is for legacy support. Once upon a time a drive's controller was
the main CPU itself, and the kernel had to manage bad block sparing
(as well as rotational layout and track buffering). That was up to
around 20-30 years ago :-).

> This feature still adds value (see below).

It adds value if one underestimates typical disk drive failure
modes.  It is quite irritating even for me that a drive with way
less than 1% bad blocks becomes effectively unusable, but long
experience tells me that once a drive starts to grow defects to the
point that manufacturer spare sectors run out there is usually a
reason for it and sooner than later it will be almost completely
unusable.

[ ... ]

> The use case is simple: What if I want to have more goodblocks to
> correct for badblocks than Seagate thinks I should have?

The answer is also simple: if you think you know better than
Seagate, or if you think that Seagate deliberately allocates too few
spare sector, you ask Seagate for custom firmware that allocates
more of a disk capacity for spares. I suspect that with an order of
at least 100,000 drives they will be happy to help. :-)

> Eg, a charity or poor student wanting to get the most out of their
> old hardware.

If it is your itch, and you think you know better than the rest
of the industry, scratch your itch: send patches :-).

Other people know that usually keeping decaying drives in use is
fairly pointless. Legend is that USSR computer engineers perfected
that art though, but they worked in special circumstances.  For a
similar example look at the BadRAM and similar modules:

  https://help.ubuntu.com/community/BadRAM
  http://rick.vanrein.org/linux/badram/

They haven't become that popular... :-)
