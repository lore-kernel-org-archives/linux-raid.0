From: Brad Campbell <brad@wasp.net.au>
Subject: Re: SATA chipset recomendations
Date: Wed, 09 Jun 2004 12:44:54 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C6CE06.8050907@wasp.net.au>
References: <200406082012.58968.linux_mail@rozpooh.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406082012.58968.linux_mail@rozpooh.com>
To: chris <linux_mail@rozpooh.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

chris wrote:
> I want to setup a Linux software RAID 1 / Mirror array in the 2.6 kernel.  I 
> am looking for feedback regarding the best supported SATA chipsets.  Do any 
> of these cards stick out as having better driver support?  Can you reccommend 
> another card I have not mentioned?
> 
> (I am not wanting to spend the big bucks on hardware RAID, so I am not much 
> interested the expensive 3Ware or Adaptec cards)
> 
> Promise SATA150 TX4 ~ $65
> (I don't really need 4 ports, but, I would not mind having them for future 
> use)

I have 3 of these in my server. They are great and I believe Promise supports Jeff with Specs and 
Hardware. Support those that support linux!

I used them to replace 2 Highpoint RocketRaid 1540's which worked ok with the Highpoint supplied 2.4 
driver but were flaky and limited to about 15MB/s under all 2.4 and 2.6 native drivers that I tried.

My ASUS A7V600 has onboard 2 Channel VIA SATA raid (with the BIOS disabled) and libata runs that 
well too.

I also have a Cardbus SIL-3112 based card which works ok also.

I have to say I it's my belief that the Promise cards appear to be the best supported natively. They 
would be my bet anyway. With 1 SATA150 and 3 drives I can max out the PCI bus easily, with 3 cards 
and 10 drives it's out of the park.

Regards,
Brad
