From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Disk Order
Date: Mon, 13 Aug 2012 00:03:59 +0100
Message-ID: <20520.13944.139606.72566@tree.ty.sabi.co.UK>
References: <50281BB1.6030309@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50281BB1.6030309@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Our server currently has 6 SATA ports on the motherboard
> filled with 6 drives in RAID10. [ ... ] additional PCIe SATA
> controller in a server [ ... ] give me a little redundancy in
> case the new controller card were to fail (I don't want the
> new controller to bring down 2 drives).

It would be nice to split each pair of your new RAID1 and the
existing RAID10 over the two host adapters (the controllers are
the PCBs on the bottom of the drive...) you will have.

As in one member of each pair on the motherboard and the other
on the PCIe card.

Ideally therefore get a 4-drive PCIe card, so you can put on it
3 members of your existing RAID10 set, plus one member of your
new RAID1 set. SPAN.com tend to have reasonable non-RAID SATA
cards.

> When setting up MD RAID in this configuration, how would I go
> about tell MD RAID which disk is which in the array (referring
> to the near/far configurations)?

If you are using a recent MD setup each member block device (not
necessarily disk) has an MD descriptor block with an UUID (or a
name) for the array and one for the member, and ideally you
would use that.

You can use 'mdadm -E /dev/sd?' to get the relevant information,
and them put the relevant UUID (or name) in '/etc/mdadm.conf'

> I'm assuming by default that MD RAID just uses alphabetical
> order in order to determine the drive order? Let's say the
> RAID10 drives will be sda sdb sdc sdd sde sdg* [ ... ]

Drive names can change on any reboot. You cannot rely on them.

> Will there be a performance hit since one drive in the RAID10
> array will be on a different controller?

PCIe host adapters tend to have lower host bus bandwith than
motherboard ones, but this should not matter in your case (if
your host adapter has a 4-lane PCIe interface).
