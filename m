From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: WD "RED" drives - are they any good for mdadm?
Date: Fri, 08 Feb 2013 16:47:42 -0500
Message-ID: <5115727E.9050601@tmr.com>
References: <50CF2112.1090406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50CF2112.1090406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

maurice wrote:
> Thinking about trying some WD "RED" drives for a build.
> Model # WD20EFRX
>
> Does anyone have any experience with these they would care to share?
>
No, they're available big and cheap, but I confess that I don't see why a drive 
series (red) is needed for NAS use, as opposed to cabled (eSATA) connection. Not 
sure how the drive use would be different, but they are, as noted, big and cheap.

This has some data on the goals for the drive: 
http://www.newegg.com/Product/Product.aspx?Item=N82E16822236344&nm_mc=EMC-IGNEFL020813&cm_mmc=EMC-IGNEFL020813-_-EMC-020813-Index-_-InternalHardDrives-_-22236344-L0A

But the actual seek time, rpm and such, didn't pop up in the few places which I 
checked. Note these drives are (a) low power and noise, (b) designed for 7x24 
operation, and (c) three year warranty rather than two. I would definitely 
expect them to be a good choice for a RAID array no matter how it's connected.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
