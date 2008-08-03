From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: (root cause found....may be not)64k Page size + ext3 errors
Date: Sun, 3 Aug 2008 12:00:35 +0100
Message-ID: <18581.36819.50176.623707@tree.ty.sabi.co.uk>
References: <632622.79880.qm@web81307.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <632622.79880.qm@web81307.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> After lots of debugging and dumping file system information.
> I found that=A0 super block is being corrupted=A0 during SATA dma
> transfer. I am using PCI-E based SATA card to attach hard disks.
> Looks with 64k page size SATA DMA seems to be stressed so much
> compared to 4k page size.

Well, that depends quite a bit on a lot of factors, but if for
example a 64KiB IO block size means is transferred as one PCI
transaction, things will likely be bad indeed.

> I used another SATA card which is more stable(it does not use=A0
> libata). It worked finw with RAID-5 and 64k page size.

It would be interesting to see if the PCI latency timers for the
two cards default to the same value or different values. Quite a
few (GPU and other) cards set high latency timer values to game
benchmarks.

> I have used a small C program to create w2GB size file and
> read it back and check the data consistency. So far no errors
> found. I also used IO meter test , which worked fine too. [
> ... ]

This very interesting paper from CERN on silent corruptions may
be relevant too.

  https://indico.desy.de/contributionDisplay.py?contribId=3D65&sessionI=
d=3D42&confId=3D257
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
