From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Tyan, RAID-6, and other recent hassles... (long, a bit OT)
Date: Sat, 19 Feb 2005 22:15:55 -0800
Message-ID: <42182B1B.6070404@nsr500.net>
References: <Pine.GSO.4.33.0502192217280.5536-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.GSO.4.33.0502192217280.5536-100000@sweetums.bluetronic.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been running an S2885 since Feb 1.  After flashing to 2.02b and 
replacing a faulty SATA cable, zero problems.  System runs constantly as a 
NAS load generator client except for shutdowns needed to test different 
disks or memory configs.

I'll be getting 3 more next month, racked using:
http://www.antec.com/us/productDetails.php?ProdID=94326
http://www.antec.com/us/productDetails.php?ProdID=94550

Also a good EPS12V power supply does wonders.

Cheers.

Ricky Beam wrote:
> On Sun, 20 Feb 2005, Bernd Schubert wrote:
> 
>>>Mobo was a Tyan Thunder K8W. (S2885)
>>
>>personally I'm very disappointed about Tyan, well I only know their
>>opteron mainboards, but thats already sufficient to never buy their
>>mainboards again.
> 
> 
> You're doing yurself a huge disservice based on very little experience.
> Using one or two of a manufacturer's MBs is not sufficient grounds to
> blacklist them.  Tyan sells a lot of these boards.  If there were serious
> stability problems with them, tyan wouldn't be shipping them.
> 
> Tyan makes very good hardware.  I don't know what your problems are,
> but I've never had any such problems.  I've used Tyan hardware for
> a decade.  Yes, they've made a few mistakes over the years -- bad
> SIMM slots on the earily tomcat boards, using a VIA chipset for the
> tiger 133...
> 
> 
>>Server B (failover): S2880, as soon as a cable is plugged in into one of
>>the onboard broadcom NICs, the system crashes. Broadcom driver doesn't
>>need to be loaded, system may already crash during the pre-boot
>>initialisation or later on during the kernel boot-procedure.
> 
> 
> I've seen a few systems do this.  It was due to bad memory and bad memory
> configuration (BIOS).  Those systems (i7501's) have been running fine
> (over a year now) since replacing the RAM with Tyan "ok'ed" memory and
> disabling "spread spectrum" in the chipset.
> 
> --Ricky
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

