From: "MOgWai46[Saurceful of Secrets]" <street41@gmail.com>
Subject: Re: Western Digital RE3: Raid Failure
Date: Thu, 3 Sep 2009 11:14:45 +0200
Message-ID: <b9f8dfb10909030214u2144b4fag417997ff9a38f315@mail.gmail.com>
References: <b9f8dfb10908270243u1213576cs7c5cbc743d637c1c@mail.gmail.com>
	 <4A9C3969.8000304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A9C3969.8000304@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/8/31 Zdenek Kaspar <zkaspar82@gmail.com>:

> Do you have some sort of port multiplier [because it looks like there
> are 2 devices on ata2 -> ata2.00 (sdc),ata2.01 (sdd?)] and can you
> provide smartctl -a /dev/sdc output ?

This is the output of smartctl -a /dev/sdc: http://nopaste.com/p/aXwmnSEphb

This is the output of smartctl -a /dev/sdd: http://nopaste.com/p/aYzhpzppv

There isn't any port replicator on this little server (is not a
critical or production server). It has 4 SATA Port on the Mainboard:

# lspci -v

00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
SATA IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company Unknown device 3206
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 233
        I/O ports at <unassigned>
        I/O ports at <unassigned>
        I/O ports at <unassigned>
        I/O ports at <unassigned>
        I/O ports at 3080 [size=16]
        Memory at 88000000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] Power Management version 2

Thanks, Andrea
