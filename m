From: "Marc Marais" <marcm@liquid-nexus.net>
Subject: Re: Poor RAID5 performance on new SMP system
Date: Tue, 19 Oct 2004 01:26:00 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041018172202.M60005@liquid-nexus.net>
References: <20041018015803.M50347@liquid-nexus.net> <41733C14.8020000@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41733C14.8020000@sauce.co.nz>
To: Richard Scobie <richard@sauce.co.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've moved one of the IDE cards to the 64 bit bus and thats improved things a
lot. The 2nd card isnt 3.3v capable and won't go into the 64 bit slot though
so I'm going to replace it. 

I noticed using vmstat that the average latency (await) is over 50ms for the
card on the secondary PCI bus and less than 20ms on the 64 bit bus... Very
interesting...

Thanks Richard, and everyone else for your input(s).


(Oh I tried 2.6.8 - didn't make a difference at all - I'm sticking with 2.4.26 :)
--


---------- Original Message -----------
From: Richard Scobie <richard@sauce.co.nz>
To: linux-raid@vger.kernel.org
Sent: Mon, 18 Oct 2004 16:44:20 +1300
Subject: Re: Poor RAID5 performance on new SMP system

> Marc wrote:
> > Hi,
> > I recently upgraded my file server to a dual AMD 2800+ on a Tyan Tiger MPX 
> > motherboard. The previous server was using a PIII 700 on an Intel 440BX 
> > motherboard. I basically just took the IDE drives and their controllers 
> > across to the new machine. The strange thing is that the RAID-5 performance 
> > is worse than before! Have a look at the stats below:
> 
> Hi Marc,
> 
> Unfortunately you have a lemon :(
> 
> I spent some time trying to get acceptable performance out of an 
> Adaptec SCSI RAID 0 on the 32 bit, 33MHz bus of one of these boards 
> and eventually found this:
> 
>
http://forums.2cpu.com/showthread.php?s=c8040a4e9c9b6390dd389f1b3cca32de&threadid=31211&perpage=15
> 
> The executive summary is
> 
> "After testing AMD determined that the problem was identified as a 
> bandwidth issue(this was startling information). It appears that the 
> motherboard has a bandwidth limitation of 25MB/s on PCI devices that 
> are connected through the AMD 768 Southbridge."
> 
> This was in line with my findings.
> 
> I have not tried, but it is possible that a 64 bit 66MHz IDE card 
> will be OK.
> 
> Regards,
> 
> Richard
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

