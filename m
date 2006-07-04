From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux SATA Support Question - Is the ULI M1575 chip supported?
Date: Mon, 03 Jul 2006 20:57:47 -0400
Message-ID: <44A9BD0B.8010104@garzik.org>
References: <Pine.LNX.4.64.0607031756510.3342@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0607031756510.3342@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> In the source:
> 
> enum {
>         uli_5289                = 0,
>         uli_5287                = 1,
>         uli_5281                = 2,
> 
>         uli_max_ports           = 4,
> 
>         /* PCI configuration registers */
>         ULI5287_BASE            = 0x90, /* sata0 phy SCR registers */
>         ULI5287_OFFS            = 0x10, /* offset from sata0->sata1 phy 
> regs */
>         ULI5281_BASE            = 0x60, /* sata0 phy SCR  registers */
>         ULI5281_OFFS            = 0x60, /* offset from sata0->sata1 phy 
> regs */
> };
> 
> However, in the manual for this motherboard it states it has a ULI 
> M1575, can anyone comment?
> 
> http://us.dfi.com.tw/Upload/Manual/90800601.pdf

What is the PCI ID?

	Jeff



