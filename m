From: Gordon Henderson <gordon@drogon.net>
Subject: Re: ibm serveraid
Date: Fri, 7 Feb 2003 12:56:33 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0302071249050.7621-100000@unicorn.drogon.net>
References: <20030207152510.3e3be8ef.agri@desnol.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030207152510.3e3be8ef.agri@desnol.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Feb 2003, Vitaly wrote:

> Hello
>
> I have IBM ServeRAID controller
> > lspci -v
> <01:06.0 RAID bus controller: IBM Netfinity ServeRAID controller
> <        Subsystem: IBM: Unknown device 020e
> <        Flags: bus master, 66Mhz, slow devsel, latency 96, IRQ 10
> <        Memory at edffe000 (32-bit, prefetchable) [size=8K]
> <        Expansion ROM at <unassigned> [disabled] [size=512K]
> <        Capabilities: [80] Power Management version 2
> I want to compile new kernel with full support for the controller.
> What i need? Is scsi support enough and all disk array will work correctly? Or there should be some special initialization during boot time and i need some special features compiled in?
> Can i compile serverRAID support as a module?
> I already have working system based on linux with configured raid controller.

Just compile the driver into the kernel and off you go - IBM supply some
configuration utilities for it which you'll need to search for. You don't
need Liunx (software) RAID at all for this device. You'll need IBMs tools
to combine the disks into whatever RAID setting you have - eg. mirroring
or RAID5, etc. Once configured with the IBM tools, the disks just look
like one SCSI disk to the system which you can then partition as you like
with fdisk, etc. (I think their tools can create N drives too, but I only
created one big volume when I last used one)

> PS: i suppose that ibm support team can't answer "2 x 2 = ?" :-(

Indeed. I setup a system with one of these about 8 months ago. It worked,
however there are problems with it. I could trigger a data timeout when
running 8 copies of Bonnie on it. As far as I could tell it didn't result
in any data corruption, but did stall the unit for 30 seconds every now
and then. I still have an outstanding support request with IBM over this.
One story they told me was that the controller buffers data and that when
the buffers are full it can take over 30 seconds to flush it out to the
disks - meanwhile, Linux, unlike NT, or other Unixes that they have
drivers for time-out... I didn't believe them as as didn't have
write-caching turned on at the time (no UPS!)

IBM won't support you unless yo run the exact version of RedHat + kernel
that they support, even though the driver is avalable as a kernel module
and source and is integraed into the rleased kernel tree.

Good luck...

Gordon

