From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Linux SATA Support Question - Is the ULI M1575 chip supported?
Date: Mon, 3 Jul 2006 17:58:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607031756510.3342@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


In the source:

enum {
         uli_5289                = 0,
         uli_5287                = 1,
         uli_5281                = 2,

         uli_max_ports           = 4,

         /* PCI configuration registers */
         ULI5287_BASE            = 0x90, /* sata0 phy SCR registers */
         ULI5287_OFFS            = 0x10, /* offset from sata0->sata1 phy 
regs */
         ULI5281_BASE            = 0x60, /* sata0 phy SCR  registers */
         ULI5281_OFFS            = 0x60, /* offset from sata0->sata1 phy 
regs */
};

However, in the manual for this motherboard it states it has a ULI M1575, 
can anyone comment?

http://us.dfi.com.tw/Upload/Manual/90800601.pdf

