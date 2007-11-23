From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Re: Offtopic: hardware advice for SAS RAID6
Date: Fri, 23 Nov 2007 12:22:57 +0100
Message-ID: <xfk4pfdqk8e.fsf@uxzb53.drewag.de>
References: <20071120160806.GD24510@server>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071120160806.GD24510@server> (Richard Michael's message of
 "Tue, 20 Nov 2007 11:08:06 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Michael <rmichael-raid@edgeofthenet.org> writes:

> I'm considering my first SAS purchase.  I'm planning to build a software
> RAID6 array using a SAS JBOD attached to a linux box.  I haven't decided
> on any of the hardware specifics.
>
> I'm leaning toward this PCI express LSI 3801e controller:
> http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3801e/index.html

I use a very similiar controllers, the LSI 3442X-R and 3442E-R. They
have only one external connector, and this is a different connector
type. It looks a bit more stable (mechanically), but this might be a
matter of taste and I have never used the other connector type.  (I
had to update the controllers using the latest firmware available on
the LSI web site.)

> The JBOD would ideally be 1U or 2U holding 8 or 10 disks.  If I
> understand SAS correctly, I'd probably have a unit with 2 SFF-8088
> miniSAS connectors (although, I believe these connectors only support 4
> devices, so if the JBOD is >8 disks, I don't know what would happen).

The JBODs that I am aware of use internal SAS port expanders (see
<http://en.wikipedia.org/wiki/Serial_Attached_SCSI#SAS_Expanders>). The
connection to the host has four SAS lanes (the concept is similiar to
the up to 16 lanes on a PCI-Express card). Each disk is connected via
one SAS lane, and all these lanes are switched by the port
expander. So you do not need 8 lanes on the host computer in order to
connect 8 disks. 

I use DELLs MD1000 JBOD (some with SATA, some with SAS), and it works
fine. I have up to three JBODs connected to one SAS host port.

> I'd appreciate feedback and suggestions on the hardware above, or a
> discussion of the performance.  (E.g. a discussion of SAS
> ports/bandwith, PCI express lanes/bandwidth, disks and network to
> determine the through put of this setup.)

Currently I don't see limits that must be considered. Simple math with
bandwidths. Nowadays I prefer PCI-Express over PCI-X. AFAIR the LSI
cards have 8 PCI-Express lanes, so you need a matching port on the
mainboard.

	Sven

