From: Twigathy <twigathy@gmail.com>
Subject: Re: Multiple siI SATA cards and data corruption
Date: Wed, 7 May 2008 10:34:21 +0100
Message-ID: <1f0f1a960805070234o2f9dfe07j42a1bd005b607791@mail.gmail.com>
References: <1f0f1a960805061741t16bb165fp342ceb8f97f4347d@mail.gmail.com>
	 <e9c3a7c20805062212x73a837d7l37905042d835e0a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20805062212x73a837d7l37905042d835e0a7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kernel version 2.6.24-16-server with mdadm - v2.6.3 - 20th August
2007. In dmesg I'll see something like this:

[  244.588897] ata11.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[  244.591333] ata11.00: cmd c8/00:00:3f:11:04/00:00:00:00:00/e0 tag 0
dma 131072 in
[  244.591335]          res 40/00:ff:ff:ff:ff/00:00:00:00:00/ff Emask
0x4 (timeout)
[  244.597121] ata11.00: status: { DRDY }
[  244.928825] ata11: soft resetting link
[  245.088814] ata11: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  245.130057] ata11.00: configured for UDMA/100
[  245.130080] ata11: EH complete
[  245.137809] sd 10:0:0:0: [sdf] 976773168 512-byte hardware sectors
(500108 MB)
[  245.138158] sd 10:0:0:0: [sdf] Write Protect is off
[  245.138162] sd 10:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[  245.138183] sd 10:0:0:0: [sdf] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

Obviously ports freezing isn't too good for raid and things go splat
pretty quickly from there!

2008/5/7 Dan Williams <dan.j.williams@gmail.com>:
>
> On Tue, May 6, 2008 at 5:41 PM, Twigathy <twigathy@gmail.com> wrote:
>  > Hi all,
>  >
>  >  This is somewhat offtopic; bear with me, someone may be able to help!
>  >  I posted a short while back that I'd suffered quite a large data loss
>  >  with mdadm and a handful of SATA disks, it looks like it was caused by
>  >  a bug in the sata_sil driver as there is stuff posted here:
>  >  http://www.ussg.iu.edu/hypermail/linux/kernel/0707.1/0024.html as well
>  >  as a bug on Ubuntu's launchpad site:
>  >  https://bugs.launchpad.net/ubuntu/+bug/208551
>  >
>  >  I'm no kernel hacker, and I have not found much more evidence to
>  >  support the fact it's a bug other than I can reproduce the failure
>  >  pretty consistently (6 hard disks over 3 PCI sil 3512 based SATA
>  >  cards). I've just ordered a new motherboard, CPU etc. for the
>  >  fileserver in question and can test things a bit more thoroughly once
>  >  they appear and I have time to swap out the guts of my current
>  >  machine. Does anyone know how I'd go about even starting to help fix
>  >  this sata_sil maybe-bug, or indeed if a fix has already been committed
>  >  to the kernel, or at least how to help track it down?
>  >
>
>  What kernel version are you able to reproduce the problem?
>
>  --
>  Dan
>
