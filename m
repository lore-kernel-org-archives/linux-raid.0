From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Tue, 06 Aug 2013 14:37:55 -0500
Message-ID: <52015093.3040100@hardwarefreak.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com> <51FE529C.6000502@hardwarefreak.com> <CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Orrifolius <porrifolius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/5/2013 8:54 PM, P Orrifolius wrote:
> Thanks for your response...

I'm glad I asked the crucial questions.

> 8x2TB SATA drives, split across two Vantec NexStar HX4 enclosures.
> These separately powered enclosures have a single USB3 plug and a
> single eSATA plug.  The documentation states that a "Port Multiplier
> Is Required For eSATA".

These enclosures are unsuitable for RAID duty for multiple reasons
including insufficient power delivery, very poor airflow thus poor drive
cooling, and USB connectivity.  USB is unsuitable for RAID duty due to
the frequent resets.  USB is unsuitable for carrying block device
traffic reliably due to resets, even for single drives.  Forget about
using USB.

...
> Subsequently I determined that my motherboard only
> supports command-based not FIS.  I had a look for a FIS
> port-multiplier card but USB3 (which my motherboard doesn't support)
> controllers seemed about a 1/4 the price so I thought I'd try that
> out.  lsusb tells me that there are JMicron USB3-to-ATA bridges in the
> enclosures.

Forget about enclosures with SATA PMP ASICs as well.  Most products
integrating them are also cheap consumer oriented stuff and not suitable
for reliable RAID operation.  You'd likely continue to have problems of
a similar nature using the eSATA connections, though probably less
frequently.

Newegg sells these Vantecs for $100 USD each.  For not substantially
more than what you spent on two of these and the USB3 controller, given
the increase in reliability, performance, and stability, you could have
gone with a combination of quality consumer and enterprise parts to
achieve a fast and stable RAID.  You could have simply swapped your PC
chassis and PSU, acquired a top notch 8 port SAS/SATA HBA, two SFF8087
to discrete SATA breakout cables, and 3 Molex to SATA power splitters.
For example:

http://www.newegg.com/Product/Product.aspx?Item=N82E16811124156
http://www.newegg.com/Product/Product.aspx?Item=N82E16817170018
http://www.newegg.com/Product/Product.aspx?Item=N82E16816118112
http://www.newegg.com/Product/Product.aspx?Item=N82E16816132040 x2
http://www.newegg.com/Product/Product.aspx?Item=N82E16812422777 x3

Total:  $355 USD

This would give you plenty of +12VDC power for all drives concurrently
(unlike the Vantec wall wart transformers), rock solid stability, full
bandwidth to/from all drives, and at least 20x better drive cooling than
the Vantecs.

...
> Logs show that all 4 drives connected to one of the ports were reset
> by the XHCI driver (more or less simultaneously) losing the drives and
> failing the array.

...
> Perhaps that suggests the enclosure bridge is at fault, unless an
> individual port on the controller freaked out.  Definitely not a power
> failure, could be a USB3 cable issue I guess.

No, this is just the nature of running storage protocols over USB.
There's a nice thread in the XFS list archives of a user experiencing
filesystem corruption multiple times due to USB resets, with a single
external USB drive.

> Truth is the USB3 has been a bit of a pain anyway... the enclosure
> bridge seems to prevent direct fdisk'ing and SMART at least.  My
> biggest concern was that it spits out copious 'needs
> XHCI_TRUST_TX_LENGTH quirk?' warnings.
> But I burned it in with a few weeks of read/write/validate work
> without any apparent negative consequence and it's been fine for about
> a year of uptime under light-moderate workload.  My trust was perhaps
> misplaced.

Definitely misplaced.  I wish you'd have asked here before going the USB
route and buying those cheap Vantec JBOD enclosures.  I could have saved
you some heartache and wasted money.  Build a reliable solution similar
to what I described above and Ebay those Vantecs.

> It seems I'd probably be better of going to eSATA... any
> recommendations on port multipying controllers?

First, I recommend you not use eSATA products for RAID as most are not
designed for it, including these Vantecs.  Second, you seem to be
confused about how/where SATA Port Multipliers are implemented.  PMPs
are not PCIe HBAs.  They are ASICs, i.e. individual chips, nearly always
implemented in the circuit board logic inside a JBOD storage enclosure,
i.e. at the far end of the eSATA cable.  The PMP in essence turns that
one eSATA cable between the boxes into 4 or 5 'cables' inside the JBOD
chassis connecting to all the drives, usually implemented as traces on a
backplane PCB.

There are standalone PCB based PMPs that can be mounted into a PCI/e
bracket opening, but they do not plug into the PCI/e slot, and they do
not provide the same function as in the typical scenario above.  Power
comes from a PSU Molex plug, and data comes from a single SATA cable
connected to one port of a standard SATA HBA or mobo Southbridge SATA
port.  As the name implies, the device multiplies one port into many, in
this scenario usually 1:5.  Here you're creating 5 drive ports from one
HBA port but strictly inside the host chassis.  There can be no external
cabling, no eSATA, as the signalling voltage needs to be slightly higher
for eSATA.  All such PMP devices I'm aware of use the Silicon Image 3726
ASIC.  For example this Addonics product:

http://www.addonics.com/products/ad5sapm.php

Two of these will give you 10 drive ports from a 2 port HBA or two mobo
ports, but again only inside the PC chassis.  This solution costs ~$150
and limits you to 600MB/s aggregate drive bandwidth.  Since most people
using this type of PMP device are most often using a really cheap 2 port
Sil based HBA, it may not tend to be reliable, and definitely not speedy.

It makes more sense to spend 50% more, $75, for the native 8 port LSI
enterprise SAS/SATA HBA for guaranteed stability/reliability and the
available 4GB/s aggregate drive bandwidth.  With 8 of the fastest rusty
drives on the market you can achieve 1+ GB/s throughput with this LSI.
With the same drives on two Sil PMPs and a cheap HBA you'd be hard
pressed to achieve 400MB/s with PCIe x1 2.0.

> Is the Highpoint RocketRAID 622 ok?

I strongly suggest you dump the Vantecs and avoid all eSATA solutions.
The PMP+firmware in the Vantecs is not designed for nor tested for RAID
use, just as the rest of the product is not designed for RAID use.  In
addition their (lack of) documentation in what they consider a user
manual makes this abundantly clear.

> Good news is I worked through the recovery instructions, including
> setting up the overlays (due to an excess of paranoia), and I was able
> to mount each XFS filesystem and get a seemingly good result from
> xfs_repair -n.

You can't run xfs_repair on a mounted filesystem, so I assume you simply
have the order of events reversed here.  "Seemingly" makes me
wonder/worry.  If errors are found they are noted in the output.  There
is no ambiguity.  "-n" means no modify, so any errors that might have
been found, and displayed, were not corrected.

Note that xfs_repair only checks the filesystem structure for errors.
It does not check files for damage.  You should manually check any files
that were being modified within a few minutes before or during the USB
reset and subsequent array failure, to make sure they were not zeroed,
truncated, or mangled in some other way.

> Haven't managed to get my additional backups up to date yet due to USB
> reset happening again whilst trying but I presume the data will be
> ok... once I can get to it.

The solution I described above is likely more than you wish to spend to
fix this problem, but it is a tiny sum to part with considering the
stability and performance you'll gain.  Add the fact that once you have
this up and working it should be rock solid and you won't have to screw
with it again.

You could reduce that ~$355 USD to ~$155 by substituting something like
two of these for the LSI HBA

http://www.newegg.com/Product/Product.aspx?Item=N82E16816124064

though I can't attest to any qualities of this card.  If they're decent
these will work better direct connected to the drives than any eSATA
card connected to those Vantecs.

With cost cutting in mind, consider that list member Ramon Hofer spent
~$500 USD on merely an LSI HBA and Intel SAS expander not that long ago,
based on my architectural recommendation, to square away his 20 drive
server.  If you ask him I'm sure he'd say he's very glad to have spent a
little extra on the HBA+expander hardware given the stability and
performance.  And I'm sure he'd express similar appreciation for the XFS
over concatenated constituent RAID5 arrays architecture I recommended.
Here's the most recent list thread concerning his system:

http://www.spinics.net/lists/raid/msg43410.html

I hope the advice I've given here is beneficial, and not too preachy.  I
didn't intend for this to be so long.  I think this is primarily due to
where you are and where you need to be.  The journey through storage
education requires more than a few steps, and I've covered but a tiny
fraction of it here.

-- 
Stan

