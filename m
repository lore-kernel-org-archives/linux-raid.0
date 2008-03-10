From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: LVM performance
Date: Mon, 10 Mar 2008 21:04:56 +0000
Message-ID: <18389.41592.494811.875055@tree.ty.sabi.co.uk>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
	<20080218062604.05ae4821@szpak>
	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>
	<20080218154203.6e2d1483@szpak>
	<47BB30DF.1080006@student.tuwien.ac.at>
	<18364.6868.854623.613958@tree.ty.sabi.co.UK>
	<47BED119.4070000@student.tuwien.ac.at>
	<18384.63840.605334.155518@tree.ty.sabi.co.UK>
	<47D440D6.90509@student.tuwien.ac.at>
	<8D0FC34E-F0B0-4BAF-A466-2C8BC439E7FF@it-loops.com>
	<47D47264.4070404@student.tuwien.ac.at>
	<3AF45EEC-EC43-4AD4-ACD1-4EEDDE798346@it-loops.com>
	<47D4F72F.40203@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47D4F72F.40203@student.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Mon, 10 Mar 2008 09:54:07 +0100, Oliver Martin
>>> <oliver.martin@student.tuwien.ac.at> said:

[ ... ]

> I was talking about stripe size, not chunk size. That 128KB
> stripe size is made up of n-1 chunks of an n-disk raid-5. In
> this case, 3 disks and 64KB chunk size result in 128KB stripe
> size.

Uhm, usually I would say that in such a case the stripe size is
192KiB, of which 128KiB are the data capacity/payload.

I usually think of the stripe as it is recorded on the array,
from the point of view of the RAID software. As you say here:

> I assume if you tell the file system about this stripe size
> (or it figures it out itself, as xfs does), it tries to align
> its structures such that whole-stripe writes are more likely
> than partial writes. This means that md only has to write
> 3*64KB (2x data + parity).

Indeed, indeed the application above the filesystem has to write
carefully in 128KiB long, 128KiB aligned (to the start of the
array, not the start of the overlaying volume, as you point out)
transactions to avoid the high costs you describe here and
elsewhere.

As I was arguing in a recent post (with very explicit examples),
the wider the array (and the larger the chunks size) the worse
the cost and chances that the application (usually the file
system) manage to put together properly sized and aligned
transactions. XFS delayed writes are useful as to that.

But then one of the many advantages of RAID10 is that all these
complications are largely irrelevant with it...

[ ... ]
