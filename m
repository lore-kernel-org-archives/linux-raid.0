From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: OT: sas controllers/expanders and "desktop" drives?
Date: Sat, 20 Mar 2010 11:34:19 -0400
Message-ID: <4BA4EAFB.1050302@tmr.com>
References: <20100317143602.GA18298@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100317143602.GA18298@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Garman wrote:
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
>
>
>   
I have the feeling that what they meant is that the drives have firmware 
intended for desktop use and will not work well in RAID usage. This has 
been discussed here before, the desktop drives have firmware which tries 
repeatedly to recover data on a failed read, and which therefore may 
hang for 20-30 sec before reporting an error or finally returning the 
data without an error indication.

Until/unless Neil changes his idea that timeout should be in the driver 
or the driver, these drives work poorly with RAID.

Note, this is just the way I read the reply, and there may be a way to 
tell the firmware to fast fail, depending on tools and firmware.

> [1] http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3081er/index.html
>
> [2] http://www.supermicro.com/products/chassis/4U/846/SC846TQ-R900.cfm
>
> [3] http://www.supermicro.com/support/faqs/faq.cfm?faq=8230
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

