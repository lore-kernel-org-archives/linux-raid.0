From: Spelic <spelic@shiftmail.org>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA
 questions for HW owners/users
Date: Sun, 23 Jan 2011 05:00:35 +0100
Message-ID: <4D3BA7E3.1070400@shiftmail.org>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com>
 <4D39D8B5.1090901@hardwarefreak.com>
 <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
 <4D3B0009.6020006@hardwarefreak.com>
 <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
 <4D3B6B05.1020303@shiftmail.org> <4D3B9617.9010800@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4D3B9617.9010800@tomt.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: Michael Evans <mjevans1983@gmail.com>, Spelic <spelic@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/23/2011 03:44 AM, Andre Tomt wrote:
>
> Since we're talking about "non hardware raid" usage, I don't really 
> understand how it would be harder to manage mixed controllers? Care to 
> explain? 

Well, yeah, probably I have exxagerated. If you need to replace a drive 
you have to associate the drive letter to the hardware slot, and if you 
have two controllers you have to remember two mappings. Also you have to 
know the idiosincracies of 2 controllers, like, do they support hot swap 
or they freeze? Do the support smartmontools well or not, are both 
capable of withstanding high IOPS situation or one drops out and 
degrades the array... but probably the OP can accept these drawbacks.

> I can't quite get the performance statement to compute, either.. Its 
> not like the same I/O goes out to all controllers. If your other 
> controller is slower, just put fewer drives on it. Balance it out.

I was thinking more to the round trip time, which will be different for 
the 2 controllers, and supposing the OP is creating an array spanning 
both controllers.

>
> Anyways, If you settle for SATA and a desktop motherboard, most mid to 
> high end s1156/1155 motherboards nowadays are fitted with 6 to 8 SATA 
> ports. They're in now way hard to come by - even 8 ports seems to be 
> available at $130 (I spent 10 seconds looking on newegg). 

I think other mainboards can cost down to $50, but I haven't checked 
recently

