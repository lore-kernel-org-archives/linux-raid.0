From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: SMART, RAID and real world experience of failures.
Date: Fri, 6 Jan 2012 11:22:03 +0000
Message-ID: <20230.55643.346235.891308@tree.ty.sabi.co.UK>
References: <4F063808.6040000@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F063808.6040000@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> I got a SMART error email yesterday from my home server with a
> 4 x 1Tb RAID6. [ ... ]

That's an (euphemism alert) imaginative setup. Why not a 4 drive
RAID10? In general there are vanishingly few cases in which
RAID6 makes sense, and in the 4 drive case a RAID10 makes even
more sense than usual. Especially with the really cool setup
options that MD RAID10 offers.

[ ... ]

>> dd if=/dev/zero of=/dev/sdd bs=10M
>> mdadm /dev/md2 --manage --add /dev/sdd
> < a resync occurred here, afterwards >

That means that *two* writes-over have been done, one by way of
'dd' and one by way of resyncing.

Usually if one wants to "refresh"/"retest" a drive doing a
SECURITY ERASE UNIT is possibly more suitable than a zero-over:

  http://www.sabi.co.uk/blog/12-one.html#120104c

but before the security erase was available the zero-over was
the choice.

> This makes me ponder. Has the drive recovered? Has the sector
> with the read failure been remapped and hidden from view? Is
> it still (more?)  likely to fail in the near future?

Uhmmm, slightly naive questions. A 1TB drive has almost 2
billion sectors, so "bad" sectors should be common.

But the main point is that what is a "bad" sector is a messy
story, and most "bad" sectors are really marginal (and an
argument can be made that most sectors are marginal or else PRML
encoding would not be necessary). So many things can go wrong,
and not all fatally. For example when writing some "bad" sectors
the drive was vibrating a bit more and the head was accordingly
a little bit off, etc.

Writing-over some marginal sectors often refreshes the
recording, and it is no longer marginal, and otherwise as you
guessed the drive can substitute the sector with a spare
(something that it cannot really do on reading of course).
