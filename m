From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [Benchmarks] How do I set the memory invalidate bit for a 3ware
 9550SXU-12 controller?
Date: Thu, 08 Jan 2009 23:52:21 +0000
Message-ID: <496691B5.2020607@anonymous.org.uk>
References: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/01/2009 14:20, Justin Piszcz wrote:
> System = RHEL5 x86_64
> Kernel = 2.6.18-53.1.13.el5

Not on the topic of your query, but why are you running a year-old 
kernel? There have been about 10 updates since then.

[...]
> Also tried:
> # setpci -d *:* e6.b=2e

Eeek, don't do that, that's asking for trouble, throwing settings at 
every PCI device in your system. Really, you should look up the PCI spec 
and see.

If you're sure you're not going to hose your system and lose data, or 
you don't care for the sake of experiment, you might try:

# setpci -s 03:01.0 COMMAND=0:0010

that's -s 03:01.0 to select your card by its bus and slot, COMMAND to 
play with the command register, 0 to set to zero, 0010 as a mask to 
affect only bit 4. But I may have got it wrong - as I said you should 
look up the PCI spec for yourself, as well as the setpci man page - and 
in any case I take no responsibility if it goes wrong.

Cheers,

John.
