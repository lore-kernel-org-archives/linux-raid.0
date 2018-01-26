From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: USB-to-SATA and RAID
Date: Fri, 26 Jan 2018 12:23:10 +0100
Message-ID: <20180126112310.GC2957@otheros>
References: <20180123201614.GI23784@otheros>
 <5A698FB1.4090702@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5A698FB1.4090702@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks to everyone again! By the way, why I am considering to use
USB at all is that the storage system is for a solar powered site.
And therefore I have to limit power usage to roughly 10-15W...

So my thinking was to use some ARM board and low-power 2.5" disks.

Unfortunately, many of the low-power, ARM based boards seem to
have no SATA. Or just a single SATA port, often internally wired
to USB...

And yeah, I basically bought a Pi3 and some SATA-to-USB dongles
before stumbling over this entry in the Wiki... my fault...


But I'm glad to hear that there does not seem to be an issue with
USB itself, but more the circumstances.

Regarding cabling and temperature, I'm not too worried. I already
3D-printed some stackable enclosures, even with snap-in mechanisms
and holes for srews, and with hopefully enough airflow capabilities
(people had uploaded some nice designs at thingiverse.com).

But I'll keep an eye on what other ARM based boards with on-board
SATA will come out in the future. And will keep in mind to swap
the board later.

Again, many thanks!

Regards, Linus

PS: And sharing one nightmare story with USB, too: Had a disk
from Toshiba connected to a SATA-to-USB adapter with no extra
power supply and that was connected to an Odroid C1+ (an ARM board
from Hardkernel). The Odroid was not capable of providing enough
power and turned off the USB port for half a second upon noticing.
So I had this nice sound of a disk trying to spin up about twice
a second. Ten seconds later I caught up with what was going on and
disconnected the disk. Nevertheless too late, the disk was broken
then... unrecoverable bad sectors even after trying to wipe the
disk. So in that case, an external USB Hub with its own power supply
would have actually saved that disk, I guess.
