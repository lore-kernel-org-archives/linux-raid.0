From: Twigathy <twigathy@gmail.com>
Subject: Re: Multiple siI SATA cards and data corruption
Date: Wed, 7 May 2008 15:20:19 +0100
Message-ID: <1f0f1a960805070720y4908b17dqe098d969f03ec37d@mail.gmail.com>
References: <1f0f1a960805061741t16bb165fp342ceb8f97f4347d@mail.gmail.com>
	 <e9c3a7c20805062212x73a837d7l37905042d835e0a7@mail.gmail.com>
	 <1f0f1a960805070234o2f9dfe07j42a1bd005b607791@mail.gmail.com>
	 <1af518580805070648r6060ca9ase0d03e9a17ffe0c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1af518580805070648r6060ca9ase0d03e9a17ffe0c7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It could be cables, although that wouldn't explain the disks working
perfectly well (Maxed out, too in the case of doing a badblocks test)
when they are by themselves.

I'm inclined to blame the no-name SATA card - it was dirt cheap and I
have had a similar (Although 4 port version) flake out before.

I think I could use some better kit ;-)

2008/5/7 Hardy Garten <mailingliste@hg74.de>:
> Hi,
>
>  have you ever considered bad S-ATA cables?
>
>  Lately I read in a forum about a very similar problem: freezes after
>  some time of operation and in case of a transfer of large files.
>  The problems were solved with some quality S-ATA cables that replaced
>  the originally provided cables of the card supplier.
>
>  You might guess it already: It was an SIL-No-Name-SATA-PCI-Card.
>
>  Sometimes it is not the software. Hardware can be buggy too.
>
>  Cheers
>  Hardy
>
>  2008/5/7, Twigathy <twigathy@gmail.com>:
>
>
> > Kernel version 2.6.24-16-server with mdadm - v2.6.3 - 20th August
>  > 2007. In dmesg I'll see something like this:
>  >
>  > [  244.588897] ata11.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>  > [  244.591333] ata11.00: cmd c8/00:00:3f:11:04/00:00:00:00:00/e0 tag 0
>  > dma 131072 in
>  > [  244.591335]          res 40/00:ff:ff:ff:ff/00:00:00:00:00/ff Emask
>  > 0x4 (timeout)
>  > [  244.597121] ata11.00: status: { DRDY }
>  > [  244.928825] ata11: soft resetting link
>  > [  245.088814] ata11: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
>  > [  245.130057] ata11.00: configured for UDMA/100
>  > [  245.130080] ata11: EH complete
>  > [  245.137809] sd 10:0:0:0: [sdf] 976773168 512-byte hardware sectors
>  > (500108 MB)
>  > [  245.138158] sd 10:0:0:0: [sdf] Write Protect is off
>  > [  245.138162] sd 10:0:0:0: [sdf] Mode Sense: 00 3a 00 00
>  > [  245.138183] sd 10:0:0:0: [sdf] Write cache: enabled, read cache:
>  > enabled, doesn't support DPO or FUA
>  >
>  > Obviously ports freezing isn't too good for raid and things go splat
>  > pretty quickly from there!
>  >
>  >
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
