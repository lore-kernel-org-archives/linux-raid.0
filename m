From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Questions about bitrot and RAID 5/6
Date: Mon, 20 Jan 2014 22:55:06 +0000
Message-ID: <21213.43338.397566.928634@tree.ty.sabi.co.uk>
References: <20140120203433.GY6553@blisses.org>
	<20140121084617.582f9b75@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121084617.582f9b75@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> In short, I'm trying to understand if there's a reasonable way to
>> get something equivlant to ZFS/BTRFS on-a-mirror-with-scrubbing
>> if I'm using MD RAID 6.  [ ... ] "Single-disk corruption
>> recovery". What I'm wondering if he's describing something
>> theoretically possible given the redundant data RAID 6 stores,

This seems to me a stupid idea that comes up occasionally on
this list, and the answer is always the same: the redundancy in
RAID is designed for *reconstruction* of data, not for integrity
*checking* of data, and RAID assumes that the underlying storage
system reports *every* error, that is there are never undetected
errors from the lower layer. When an error is reported, RAID
uses redundancy to reconstruct the lost data. That's how it was
designed, and for good reasons including simplicity (also see
later).

It might be possible to design RAID systems that provide
protection against otherwise undetected storage errors, but it
would cost a lot in time and complexity (issues with both BTRFS
and ZFS) and would be rather pointless in many if not most
cases.

Existing facilities like 'check' in MD RAID are there for extra
convenience, as opportunistic little hints, and should not be
relied upon for data integrity; they are mostly there to
exercise the storage layer, not to detect otherwise undetected
errors.

> ars technica recently had an article about "Bitrot and atomics
> COWs: Inside "next-gen" filesystems."
> http://feeds.arstechnica.com/~r/arstechnica/everything/~3/Cb4ylzECYVQ/
> Early on it talks about creating a brtfs filesystem with RAID1
> configured and then binary-editing one of the device to flip one
> bit. Then magically btrfs survives while some other filesystem
> suffered data corruption. That is where I stopped reading
> because that is *not* how bitrot happens.

Indeed, and "bitrot" happens for example as reported here:

  http://w3.hepix.org/storage/hep_pdf/2007/Spring/kelemen-2007-HEPiX-Silent_Corruptions.pdf

> Drives have sophisticated error checking and correcting codes.
> If a pbit on the media changes, the device will either fix it
> transparently or report an error [ ... ]

That's also because storage manufacturers understand that RAID
systems and filesystems are designed to absolutely rely on error
reporting by the storage layer...

> On the path from the CCD which captures the photo of the cat,
> to the LCD which displays the image, there are lots of memory
> buffers and busses which carry the data. Any one of those
> could theoretically flip one or more bits.

That's part of what the CERN study above reports: a significant
number of otherwise undetected error not because of failing
hardware, but pretty obviously from bugs in the Linux kernel, in
drivers, in host adapter firmware, in buses, in drive firmware.

  Note: I have seen situations where "bad" devices on a PCI bus
  would corrupt random memory locations *after* the storage
  layer and filesystem had verified the checksums...

Note that in th CERN tests *all* disks were modern devices with
extensive ECC, and all servers were "enterprise" class stuff.

> Each of them *should* have appropriate error detecting and
> correcting codes.

That's more than arguable, especially as to "correcting". For
much data even error detection is not that important, and for a
large amount of content correction is even less important.

A lot of disk drives are full of graphical or audio content
where uncorrected errors are unnoticeable, for example. After
all essentially all consumer devices don't have RAM ECC and
nobody seems to complain about the inevitable undetected
errors...

In general the "end-to-end" argument applies: if some data
really needs strong error detection and/or correction, put it in
the file format itself, so that the relevant costs are only paid
in the specific cases, and it is portable across filesystems and
storage layers, so that those extremely delicate and critical
filesystems and storage layers can stay skinny and simple.

[ ... ]
