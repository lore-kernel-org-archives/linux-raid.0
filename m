From: Peter Kieser <peter@kieser.ca>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 15:47:59 -0700
Message-ID: <4BAD399F.5070009@kieser.ca>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>	 <5bdc1c8b1003261359i2f6f1bdai3261aec30bb663bf@mail.gmail.com>	 <4BAD20A2.20606@kieser.ca>	 <5bdc1c8b1003261406m2ae66154u55a70aada56a91c1@mail.gmail.com>	 <5bdc1c8b1003261416xdc883a4qdba1cdf049cca437@mail.gmail.com>	 <4BAD24EB.4020606@sauce.co.nz> <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/26/2010 3:38 PM, Mark Knecht wrote:
> I wonder if I'm seeing something like Matt is seeing with the drive
> continually being woken up. I know most of the time it just sits idle
> from a user's perspective, but I've done nothing to stop daemons or
> anything like that. It runs screen savers, gets used every day for an
> hour or two, but is always powered up so that I can administer it from
> 350 miles away.
>    

I originally noticed the problem after having the drives for 4 weeks. 
They LCC was at around 27,000 on each drive until I changed the timeout 
on the drives to 300 seconds.

-Peter
