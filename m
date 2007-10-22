From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Subject: Re: slow raid5 performance
Date: Mon, 22 Oct 2007 21:18:59 +0100
Message-ID: <18205.1459.420040.785140@base.ty.sabi.co.UK>
References: <352991.69437.qm@web52803.mail.re2.yahoo.com>
	<471CF89D.6020104@sauce.co.nz>
	<Pine.LNX.4.64.0710221532570.29106@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710221532570.29106@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Mon, 22 Oct 2007 15:33:09 -0400 (EDT), Justin Piszcz
>>> <jpiszcz@lucidpixels.com> said:

[ ... speed difference between PCI and PCIe RAID HAs ... ]

>> I recently built a 3 drive RAID5 using the onboard SATA
>> controllers on an MCP55 based board and get around 115MB/s
>> write and 141MB/s read.  A fourth drive was added some time
>> later and after growing the array and filesystem (XFS), saw
>> 160MB/s write and 178MB/s read, with the array 60% full.

jpiszcz> Yes, your chipset must be PCI-e based and not PCI.

Broadly speaking yes (the MCP55 is a PCIe chipset), but it is
more complicated than that. The "south bridge" chipset host
adapters often have a rather faster link to memory and the CPU
interconnect than the PCI or PCIe buses can provide, even when
they are externally ''PCI''.

Also, when the RAID HA is not in-chipset it also matters a fair
bit how many lanes the PCIe slot (or whether it is PCI-X 64 bit
and 66MHz) it is plugged in has -- most PCIe RAID HAs can use 4
or 8 lanes (or equivalent for PCI-X).

