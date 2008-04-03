From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Thu, 3 Apr 2008 22:01:17 +0100
Message-ID: <18421.17821.6915.929392@tree.ty.sabi.co.uk>
References: <47F020C6.1060809@tigertech.com>
	<47F0281F.1070404@harddata.com>
	<47F11F12.7010309@tigertech.com>
	<18417.16752.269484.583258@tree.ty.sabi.co.uk>
	<47F3D173.8060502@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47F3D173.8060502@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Wed, 02 Apr 2008 11:33:23 -0700, Robert L Mathews
>>> <lists@tigertech.com> said:

[ ... transfer errors on one disk affect transfers on a disk
attached to the same chip ... ]

> Just for the record, this isn't "slapped together"
> hardware. They're off-the-shelf, server-grade, currently
> sold, genuine Intel, etc. SuperMicro servers, [ ... ]

Yes, but system integration engineers spend time and effort
qualifying even good quality stuff like SuperMicro motherboards
in the specific configurations designed, because there are
*lots* of potential pitfalls.

One amusing example I heard about recently is that at CERN a
whole batch of storage servers built using excellent bits was
running much slower than expected because some cooling fans were
making drives vibrate a bit thus making arm seek stabilization
a lot more difficult, and then causing drive failure much sooner
than expected.

> [ ... ] The only storage system design we've done is connect a
> SATA drive to each of the two motherboard SATA ports and use
> software RAID 1 (yeah, I know that's "design", and we did
> think about it and test it, but still).

But have you checked whether the two ports use shared circuitry
and in effect the two ports are on the same channel? Because my
impression and that of another poster is that your drives are
sharing the same transfer logic, as if two IDE drives on the
same ribbon.

The ICH5R chipset was the first Intel one with SATA support and
it has extensive IDE/ATA compatibility:

  http://en.Wikipedia.org/wiki/I/O_Controller_Hub#ICH5
  http://WWW.Intel.com/design/chipsets/manuals/25267102.pdf

Perhaps corners were cut and the chip does not actually operate
the SATA channels independently At least that is what looks like
given the errors that you are seeing.

For example this guy noticed the exact same problem you are
seeing with a slightly different (one drive going offline)
cause:

  http://www.mail-archive.com/linux-ide%40vger.kernel.org/msg07691.html

Note also the driver developer's response...

[ ... ]
