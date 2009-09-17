From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 17:02:47 -0600
Message-ID: <200909171702.47552.tfjellstrom@shaw.ca>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <fa3b69580909171437s1074d7daqc4df84580ac9a9c3@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa3b69580909171437s1074d7daqc4df84580ac9a9c3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Bridges <john.bridges@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu September 17 2009, John Bridges wrote:
> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
> http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV8.cfm
> 
> It's an 8 port PCI-X card, works in both PCI and PCI-X slots.
> 
> SATA2
> 
> Drivers for Linux are stable, built in.
>

Have you had any experience with the AOC-SASLP-MV8? I've got one and have been 
having no end of issues with it under linux.

> You can disable the BIOS to put a LOT of cards into a single machine
> (I have four in one machine).
> 
> Costs about $100
> 
> http://www.newegg.com/Product/Product.aspx?Item=N82E16815121009
> 
> Reliable card from a real company.
> 
> 
> On Thu, Sep 17, 2009 at 4:44 AM, Rainer Fuegenstein
> 
> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
> > hi,
> >
> > I need to move my 4 disk raid5 array from a motherboard with 4 onboard
> > SATA ports to a mainboard with just 2 ports. therefore I'm looking for a
> > reliable and inexpensive 4port PCI controller.
> >
> > the less raid features it has the better since I fear that a raid
> > controller may initially write some management informationen (signatures
> > etc.) to the disks and therefore damage the linux raid5 setup.
> >
> > And, if possible, it should have low power consumption since it is about
> > to be used in a small server powered by photovoltaic panels.
> >
> > any recommendations aprreciated.
> >
> > thanks and best regards.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
