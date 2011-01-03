From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [Slightly OT] Cheap 4-port PCI-E SATA card?
Date: Mon, 03 Jan 2011 00:41:37 -0600
Message-ID: <4D216FA1.5010502@hardwarefreak.com>
References: <4D20E9F7.2080800@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D20E9F7.2080800@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson put forth on 1/2/2011 3:11 PM:
> Please could someone suggest a cheap PCI-E SATA card with 4 internal ports?

In your situation, going the PMP route may be a better choice.  Read on.

> I currently have 6 motherboard SATA ports and a 5-drive hot-swap
> chassis, I am thinking of adding a second 5-drive hot-swap chassis to my
> case and would need another 4 SATA ports to drive it.
> 
> Other requirements: known to work with RHEL/CentOS 5 kernels, even if it
> means installing a driver with DKMS or whatever.
> 
> Doesn't have to be PCI-E x1 because I've a spare x8 (logical)/x16
> (physical) slot, but I don't know if anything cheap's going to be
> anything other than PCI-E x1. v2.0 (5GT/s) would be nice though.

Go with one or two of these SATA II port multipliers with 1 host
interface and 5 drive interfaces--perfect for a 10 drive setup with two
5 drive cages.

http://www.addonics.com/products/host_controller/ad5sapm.asp

http://www.buy.com/prod/addonics-ad5sapm-serial-ata-controller-5-x-7-pin-serial-ata-300-serial/q/loc/101/213272437.html

http://www.siliconimage.com/products/product.aspx?pid=32

If your mobo SATA ports support FIS based switching, this PMP will give
you 5 SATA II drive ports.  It doesn't use a PCI slot of any kind.  No
additional software required.  No kernel driver issues.  300MB/s is
sufficient for 5 drives in an mdraid setup isn't it?

When I use these I remove the slot bracket and mount the PCB directly to
my server chassis side wall using mobo type standoffs.  You may need to
drill a couple of holes in the chassis depending on where you decide to
mount it.  If you're not a mechanically inclined DIY type person, just
use the supplied mounting bracket.  This may deny access to an
underlying PCI slot though.  I prefer the more solid mount and having
all slots available.

Personally, were I in your shoes, how I would do this is to buy two of
these so I'd have identical IO paths for all 10 drives in both cages, 5
on each PMP.  Connect each PMP to a mobo SATA II connector (again,
assuming you have mobo PMP/FIS support), leaving 4 mobo SATA ports free
for other stuff.  It'll run you $124 to do it this way, but it's so much
cleaner than having an asymmetric setup of 5 dives on individual mobo
ports and the other 5 running on one mobo port through the PMP,
especially if you plan to have drives in each 5 drive cage within the
same mdraid device.

If your mobo ports don't support PMP/FIS switching, grab one of these
for $40: http://www.newegg.com/Product/Product.aspx?Item=N82E16816124040
http://www.sybausa.com/productInfo.php?iid=979

SATA III
PCIe 2.0 x1 500MB/s
PMP FIS support
http://www.marvell.com/products/storage/storage_system_solutions/sata_controllers_pc_consumer/6_gbs_sata_raid_controller_88se91xx_product_brief.pdf

You're up to $165 now, and well worth it, esp if your mobo doesn't
support PMP/FIS.

Plug each PMP into this card.  Each 5 drive cage will be on a dedicated
IO path.  This setup will provide a combined 500MB/s of bandwidth (PCIe
x1 v2.0 limited) to the 10 disks which should be plenty for most
applications.  The driver for the Marvell chip is present in kernel
2.6.19 and later.  Considering that 2.6.19 is like 6 years old, I'd hope
your kernel is newer.

It may be a little more money than you were planning on spending, but
for little more than the cost of one hard drive, it's a really clean, no
hassle solution that you'll be happy with for some time.  One side
benefit is you free up all 6 mobo SATA ports for other uses.  Grab you a
40GB OCZ Vertex II for $100 off Newegg and plug it into one of the mobo
ports for use as a boot, system, log, temp drive.

I don't know your mobo model# or I'd have been able to give you more
concrete advice.  As someone else mentioned, some system boards don't
like x1 cards being plugged into their x8/x16 slots.  If this is the
case, I sure hope your mobo SATA chip supports PMP/FIS, as any x4/x8
SATA card that will work in such a finicky board is going to cost well
over $100 alone, and to get one that supports more than 4 drives will
likely be $200 or more and will have 2 mini SAS 8087 connectors, which
will drive your cable costs up.

-- 
Stan
