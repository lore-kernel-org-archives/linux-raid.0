From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 3ware 9650 tips
Date: Sat, 14 Jul 2007 11:04:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707141100230.29164@uplift.swm.pp.se>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
 <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 Jul 2007, Justin Piszcz wrote:

> You are using HW RAID then?  Those numbers seem pretty awful for that 
> setup, including linux-raid@ even it though it appears you're running HW 
> raid, this is rather peculiar.

No, it has been discussed numerous times on this list.

SW raid is faster because it has access to (often) gigabytes of block 
cache, which the HW raid controller doesn't have. SW raid is therefore 
able to avoid a lot of reads when it needs to write, speeding things up 
considerably.

I always use 3ware HW-raid though as I consider it more reliable. Since 
most of my access is "write once, read many" write speed isn't as 
important to me as data integrity.

Take your 3ware HW-raid, do a dd (read or write) to the device and see it 
being very quick (because it can fit all the data into its cache as it 
either reads or writes), then put a filesystem on it and do writes there, 
especially journaled writes, and see write speed go down to 1/10 or so.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
