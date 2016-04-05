From: Ron Leach <ronleach@tesco.net>
Subject: Re: Repairing R1: Part tabl, & precise command
Date: Tue, 05 Apr 2016 13:22:48 +0100
Message-ID: <5703AE18.700@tesco.net>
References: <57038211.6040101@tesco.net> <57039BCC.6040103@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57039BCC.6040103@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/04/2016 12:04, Ron Leach wrote:

>
> I'll look at parted and gdisk.
>

gdisk reports /dev/sdb has a damaged main GPT partition table, and a 
reasonable backup GPT partition table - but with an invalid header. 
(/dev/sda and /dev/sdc are fine.)  So the immediate problem here is 
fixing the GPT partition table.

Strictly, that isn't a RAID1 problem and I don't think it's 
appropriate to ask for comment on that issue on the raid list; people 
here are truly helpful so I'll fix the partition but I could use a 
comment on whether I should then just use the

mdadm  -- manage  ..  --add  ..

commands and whether mdadm needs to be inhibited from taking any 
automatic remedial action.

regards, Ron

