From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: OT: sas controllers/expanders and "desktop" drives?
Date: Fri, 2 Apr 2010 23:37:14 -0600
Message-ID: <201004022337.14896.tfjellstrom@shaw.ca>
References: <20100317143602.GA18298@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100317143602.GA18298@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On March 17, 2010, Matt Garman wrote:
> Hello,
> 
> For building a Linux md system with many disks, I've been looking at
> the LSI SAS 3081E-R controller card[1] with the SuperMicro
> 846TQ-R900B chassis[2].  The SAS3018E card looks like it has a
> mature open-source Linux driver.  The chassis has a SAS expander;
> I'm not sure which one (but I have a question in to SuperMicro).
> 
> Anyway, my question is this: has anyone used this setup, or one
> like it (sas controller + sas expander) with "desktop" class drives?
> The web research I've done suggests that most SAS controllers and
> expanders are targeted at the enterprise market, and therefore,
> aren't guaranteed to work with the (significantly cheaper) desktop
> drives.
> 
> For example, from the FAQ for that SuperMicro chassis[3]:
> 
>     Question: We want to use the new Seagate 1.5TB ST31500341AS
>     drives in combination with a storage solution based on your
>     846TQ chassis, is this compatible?
> 
>     Answer: This ST31500341AS hard drive is designed to be a Desktop
>     type hard drive, not an Enterprise hard drive which is needed in
>     this setup.  We don't recommend this combination, so please use
>     the Seagate 1TB ST31000340NS drive instead. This drive is an
>     Enterprise drive and validated for our 846TQ chassis.
> 
> In short, we want to build a server with 24 drives.  The desktop
> drives are significantly cheaper than the enterprise drives.  But
> getting 24 ports is cheapest with these SAS controllers + expanders.

If it helps at all, I'm using an 8 port SAS card to run my 5 disk md RAID 5 
array with plain old 1TB Seagate Baracuda's. Works fine. Its been running 
for a good 6 months now. I can't say how well it'll work in the future, but 
it works well enough for now.

> Thanks,
> Matt
> 
> 
> [1]
> http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas
> /lsisas3081er/index.html
> 
> [2] http://www.supermicro.com/products/chassis/4U/846/SC846TQ-R900.cfm
> 
> [3] http://www.supermicro.com/support/faqs/faq.cfm?faq=8230
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
