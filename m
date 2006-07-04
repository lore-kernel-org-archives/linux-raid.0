From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux SATA Support Question - Is the ULI M1575 chip supported?
Date: Tue, 4 Jul 2006 04:06:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607040405370.30019@p34.internal.lan>
References: <Pine.LNX.4.64.0607031756510.3342@p34.internal.lan>
 <44A9BD0B.8010104@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A9BD0B.8010104@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 3 Jul 2006, Jeff Garzik wrote:

> Justin Piszcz wrote:
>> 
>> In the source:
>> 
>> enum {
>>         uli_5289                = 0,
>>         uli_5287                = 1,
>>         uli_5281                = 2,
>>
>>         uli_max_ports           = 4,
>>
>>         /* PCI configuration registers */
>>         ULI5287_BASE            = 0x90, /* sata0 phy SCR registers */
>>         ULI5287_OFFS            = 0x10, /* offset from sata0->sata1 phy 
>> regs */
>>         ULI5281_BASE            = 0x60, /* sata0 phy SCR  registers */
>>         ULI5281_OFFS            = 0x60, /* offset from sata0->sata1 phy 
>> regs */
>> };
>> 
>> However, in the manual for this motherboard it states it has a ULI M1575, 
>> can anyone comment?
>> 
>> http://us.dfi.com.tw/Upload/Manual/90800601.pdf
>
> What is the PCI ID?
>
> 	Jeff
>
>
>

Don't have the board yet, researching different motherboards for Linux 
compatbility -before- purchase..

Justin.
