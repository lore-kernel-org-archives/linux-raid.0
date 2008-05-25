From: Andre Tomt <andre@tomt.net>
Subject: Re: Marvell 88SX7042 [4 Port SATA PCI-Express x4] Support/Questions
Date: Sun, 25 May 2008 21:43:28 +0200
Message-ID: <4839C160.6010409@tomt.net>
References: <alpine.DEB.1.10.0805250757550.18572@p34.internal.lan> <4839A63E.4050409@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4839A63E.4050409@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Lord wrote:
> Justin Piszcz wrote:
>> If one bought enough of these, one could possibly achieve speeds in 
>> excess(!) of 1 gigabyte/second with enough drives and SW RAID in Linux.
>> Does anyone have such a card? I would be interested if it could 
>> sustain the maximum rate from each disk without any contention.
> ..
> 
> Sure, if the bus and memory are fast enough.  You'll hit the Linux/libata
> transactions/sec limit at some point, but I don't know what that is.

I'm seeing 800MB/s on ICH8/9R class chipsets on concurrent non-raid I/O, 
however that's the limit of the PCIe bus used between the ICH (south, 
IO) and the MCH (north, memory/cpu/video-pcie hub). ICH10 is supposed to 
double that by moving up to PCI-e 2.0 on that link AFAIK.

> Eg. Here's a 4X (I think) card in my PCIe video slot:

Ah, of course making use of the video PCIe slot by putting as many ports 
as you can on it will improve the situation somewhat as its generally 
connected to the MCH directly. (mm, any plain/non-raid 88SX7xxx PCIe 
cards with 8 ports available?)
