From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: new raid system for home use
Date: Sun, 18 Apr 2004 16:48:04 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404182048.i3IKm9b00691@dns1.watkins-home.com>
References: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>, 'Paul Phillips' <paulp@improving.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You said:
================
>   * hot swap

thankfully, this is starting to be almost standard in a chassis designed
for more than a couple disks.
================

I think I have read that Linux does not support hot swap SATA disks.
Not yet.
I think SCSI is the only hot swap option unless he goes with hardware RAID.
Also, hardware RAID does real hot swap (remove bad disk, insert good disk,
back to computer games).  With software RAID you must issue magic
incantations to swap a disk.  Some would argue against software RAID because
of this.  These incantations are beyond most computer operators (in the real
world).  They know how to change a tape at the correct time, but know little
about the OS.  In my opinion!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Sunday, April 18, 2004 2:50 PM
To: Paul Phillips
Cc: linux-raid@vger.kernel.org
Subject: Re: new raid system for home use

> three terabyte capacity.  My tentative plan is to use 8 of the new Hitachi
> Deskstar 7K400 400 GB SATA drives in a RAID-5 configuration, and 2

highest-capacity disks are noticably more expensive than more routine ones.

> additional drives in a RAID-1 configuration as the boot device and higher
> priority data storage. 

I wouldn't bother, since raid5 is plenty fast.  it's nothing but marketing
that the storage vendors push this concept of "near-line" disk storage.

> I'd like to use debian unstable and kernel v2.6.

distributions are irrelevant.  the only reason I can think to prefer 2.6
is better support for very large block devices.

> I did not find the web overflowing with instances of people building such
> large linux RAID servers in non-business settings.

I can't think of anything about data servers that is "setting specific".

>   * top-notch linux support for { RAID card, gigabit ethernet chipset, ???
}

why a raid card?  they're slow and expensive.  I'd use two promise
sata150tx4
cards.  reasons for prefering sw raid have been discussed here before and
the 
facts remain unchanged.

broadcom or intel gigabit nics seem to be quite safe choices.

>   * components with proven linux functionality/reliability
>   * easy expandability
>   * no bottlenecks if I want to stream video to up to four locations

but we're talking piddly little streams, no?  just compressed video at 
a MB/s or two?

>   * doesn't demand rack-mount

nothing requires rack-mount.  even giant-sized motherboards will fit
into *some* mid-tower-ish chassis.

naturally, a lot of disks should make you very concerned for the 
size of your power supply.

>   * open source drivers for all components if possible, or most if not
>   * all things being equal, the quieter and cooler-running version

big PSU's tend not to be quiet.  and even though modern non-SCSI disks 
are quiet, enough of them does make some noise.

>   * endless oodles of CPU (I'd think 2x3GHz would be megaplenty)

too much, I'd say.  a single p4/2.6 would be fine.  it's true though that 
if you have your heart set on high bandwidth, that necessitates PCI-X,
and they're uncommonly found outside of dual xeon/opteron "server" boards.
you can, of course, sensibly run such a board with 1 cpu.

>   * hot swap

thankfully, this is starting to be almost standard in a chassis designed
for more than a couple disks.

>   * uptime > 99.9%

trivial.

>   * drive reliability (willing to keep spares handy and drop them
>       in as the occasion warrants)

it's not hot if you have to do something to use it.

>   * price (not cost-unconscious, but not spend-averse)

if you like the integrated approach (windows, etc), then just get a 
sata-based storage box supported by some real company.  as with all 
integrated solutions, the pitch is based on them worrying about it,
not you.  yes, you pay through the nose, but that's the tradeoff you 
have to evaluate.

> Other matters of interest:
> 
>   * Would RAID-6 be overkill? I doubt I'll be backing up the big array,
>       ever.  Losing it would suck a lot but not end my existence.

r5+hotspare is plenty reliable.  I think r6 is a bit immature, but I haven't
tried it.

>   * Is EVMS mature enough to use if I'm bleeding edge averse in that
>       area? I'd never heard of it before reading this list.

EVMS is afflicted by featuritis, IMO, compared to LVM.  but why do you
think you need it?  volume managers are for people who want to divide
their storage into little chunks, and then experience the bofhish grandeur 
of requiring the lusers to beg for more space.

big storage should be left in big chunks, unles there's some good reason
for it.

>   * Software vs. Hardware RAID? I imagine this is a good place for
>       Hardware if I buy the right card, but maybe Software would require
>       less expertise and fiddling to get running in peak form.

fiddling is required if you're trying to tweak either approach.
do you want to tweak via some proprietary/integrated interface,
talking to a $1k card that's slower than a $100 card?

I don't believe anyone would claim that hw raid is somehow more reliable.
people who like embedded/gui interfaces would claim that hw raid is more
usable.

>   * Would I be smarter to settle for kernel 2.4 at this time?

no.  your have no real performance issues, and sata support in 2.6 is very
good, as is large-block-dev.

>   * I'm probably failing to consider the five most important factors...

the only really important factor is that disks should be 3+ year warrantee.
hw raid is fine if you like that kind of thing, and want the security of 
paying more for slower performance, but the privilege of waiting on hold
at a telephone support number.

>   *  Chassis: http://www.baber.com/cases/mpe_ft2_black.htm

jeez.  that's a penis surrogate.  why not just get a straightforward
3-4U rackmount chassis and sit it on a little wheeled dolly from Ikea?

400W PS is not enough for 8-10 disks, and you probably want 
> ATX support (EATX/SSI/etc).

note also that 5.25 bays are in some ways a disadvantage, since all
disks are 3.5 (and you probably want a couple multi-bay hotswap 
converters that put, eg, 4 3.5's in 3 5.25's.)

>   *     RAID: http://www.3ware.com/products/serial_ata9000.asp

for a hw raid card, 3ware is pretty good.  they're still much more expensive
than sw raid, and by most reports, slower.

>   * 10 Disks: http://www.hitachigst.com/hdd/desk/7k400.html

use two promise 4-port controllers and the 1-2 sata ports that come 
with your MB.  you'll find that r5 is plenty fast for normal use,
so you don't need to waste a disk with a separate r1.

>   *     MoBo: ???

any Intel i75xx, i875, or AMD 8xxx from a recognizable vendor (tyan,
supermicro, asus, intel, etc.)

>   * CPU, RAM: TBD based on MoBo

you don't need much CPU power, and unless you have high locality
of reference, lots of memory is wasted on fileservers.  get 1-2GB ECC.

you should also think about whether you really require this to be a 
single server.  components at the basic level are quite cheap, but 
as you go higher-end, costs go upward quite steeply.

regards, mark hahn.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


