From: Lyle Schlueter <lyle@xkubed.com>
Subject: Re: Software raid - controller options
Date: Tue, 06 Nov 2007 06:20:14 +0300
Message-ID: <1194319214.17361.36.camel@localhost.localdomain>
References: <1194315635.17361.20.camel@localhost.localdomain>
	 <472FD6A4.5030907@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472FD6A4.5030907@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Tue, 2007-11-06 at 15:51 +1300, Richard Scobie wrote:
> Lyle Schlueter wrote:
> 
> 
> > Are there any 4+ port PCI-e SATA controllers cards? 
> 
> Hi Lyle,
> 
> I've been doing a similar exercise here and have been looking at 
> portmultiplier options using the Silicon Image 3124.
Is a port multiplier a decent option? I looked at the 3124 after you
mentioned it and a few of the other controllers offered by Silicon
Image.

I had been looking at the Adaptec 2240900-R PCI Express and HighPoint
RocketRAID 2300 PCI Express. These are both *raid* cards. But if they
can be used as a regular controller card, they both provide 4 SATA ports
and are PCI-e. But sounds like the RocketRAID doesn't work with the
2.6.22+ kernel (according to newegg reviewers). It sounds like the
Adaptec works quite nicely though. 
> 
> The other possibility is the Marvell based 8 port "dumb" SATA controller 
> from Supermicro.
> 
> http://www.supermicro.com/products/accessories/addon/AoC-SAT2-MV8.cfm
> 
> It is PCI-X though, but there are plenty of boards around still with 
> these slots.
> 
> My only concern here is the opening comment in the driver:
> 
> " 1) Needs a full errata audit for all chipsets.  I implemented most
>    of the errata workarounds found in the Marvell vendor driver, but
>    I distinctly remember a couple workarounds (one related to PCI-X)
>    are still needed."
Sounds pretty iffy there. That Adaptec card I mentioned is going for
about 100 USD. Seems like a lot for 4 ports. But sounds like it works
nicely with linux, and I would only need 1 or 2 of them (plus the 6 or 8
ports on the motherboard) to be able to use all 12 drives.

Do you know of any concerns of using all the ports on a motherboard?
Slowdowns or anything like that?
> 
> Enquiries here previously have not found anyone using this card.
> 
> Regards,
> 
> Richard
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

Lyle

