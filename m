From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software raid - controller options
Date: Thu, 08 Nov 2007 13:10:32 -0500
Message-ID: <47335118.9070407@tmr.com>
References: <1194315635.17361.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194315635.17361.20.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Lyle Schlueter <lyle@xkubed.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lyle Schlueter wrote:
> Hello,
>
> I just started looking into software raid with linux a few weeks ago. I
> am outgrowing the commercial NAS product that I bought a while back.
> I've been learning as much as I can, suscribing to this mailing list,
> reading man pages, experimenting with loopback devices setting up and
> expanding test arrays. 
>
> I have a few questions now that I'm sure someone here will be able to
> enlighten me about.
> First, I want to run a 12 drive raid 6, honestly, would I be better of
> going with true hardware raid like the areca ARC-1231ML vs software
> raid? I would prefer software raid just for the sheer cost savings. But
> what kind of processing power would it take to match or exceed a mid to
> high-level hardware controller?
>
> I haven't seen much, if any, discussion of this, but how many drives are
> people putting into software arrays? And how are you going about it?
> Motherboards seem to max out around 6-8 SATA ports. Do you just add SATA
> controllers? Looking around on newegg (and some googling) 2-port SATA
> controllers are pretty easy to find, but once you get to 4 ports the
> cards all seem to include some sort of built in *raid* functionality.
> Are there any 4+ port PCI-e SATA controllers cards? 
>   

Depending on your needs for transfer rate vs. capacity, newegg has at 
least one external enclosure which holds (from memory) 8 drives, and 
brings the data down on a single SATA connector. If you need lots of 
data online but not a high transfer rate, this might be useful. I was 
offered the enclosure as a "deal" with a DVD burner, don't know what 
they were thinking there. Ordered the DVD Tues, arrived Wed, but I don't 
need the hot swap case.
> Are there any specific chipsets/brands of motherboards or controller
> cards that you software raid veterans prefer?
>
> Thank you for your time and any info you are able to give me!
>
> Lyle
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

