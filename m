From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Wed, 15 Sep 2010 15:41:01 -0500
Message-ID: <4C912F5D.5040305@hardwarefreak.com>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pol Hallen put forth on 9/15/2010 3:07 PM:
> Hello all :-)
> 
> I think about a low cost raid 6 hardware (6 disks):
> 
> On the motherboard 3 pci controllers (sil3114
> http://www.siliconimage.com/products/product.aspx?pid=28) cost for each
> about 10/15euro
> 
> and 2 disks by controllers
> 
> So I've 6 disks (raid 6 with mdadm) and if a controller breaks raid 6
> should be clean.
> 
> Is it a acceptable situation or I don't consider other unexpected?

Is your goal strictly to build a RAID6 setup, or is this a means to an
end. If you're merely excited by the concept of RAID6 then this hardware
setup should be fine.  With modern SATA drives, keep in mind that any
one of those six disks can nearly saturate the PCI bus.  So with 6 disks
you're only getting about 1/6th of the performance of the drives, or
133MB/s maximum data rate.

Most mid range mobos come with 4-6 SATA ports these days.  You'd be
better off overall, performance wise and money spent, if you used 4 mobo
SATA ports connected to the same SATA chip (some come with multiple SATA
chips--you want all drives connected to the same chip) and RAID5 instead
of 6.  You'd save the cost of 2 drives and 3 PCI SATA cards, which would
be enough to pay for the new mobo/CPU/RAM.  You'd have far better
performance for the same money.  With four SATA drives on a new mobo
with an AHCI chip you'd see over 400 MB/s, about 4 times that of the PCI
6 drive solution.  You'd have one drive less worth of capacity.

If I were you, I'd actually go with RAID 10 (1+0) over the 4 drives.
You only end up with 2 disks worth of capacity, but you'll get _much_
better performance, especially with writes.  Additionally, in the event
of a disk failure, rebuilding a 6x1TB RAID5/6 array will take forever
and a day.  With RAID 10 drive rebuilds are typically many many times
faster.

Get yourself a new AHCI mobo with 4 SATA ports on one chip, 4 x 1TB or
2TB 7.2k WD Blue drives, and configure them as a md RAID10.  You'll get
great performance, fast rebuild times, 1 or 2 TB of capacity, and the
ability to sustain up to two drive failures, as long as they are not
members of the same mirror set.

-- 
Stan
