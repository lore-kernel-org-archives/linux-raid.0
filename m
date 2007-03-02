From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Does anyone on this list have a Raptor74/150 sw raid with > 8 drives?
Date: Fri, 2 Mar 2007 12:54:13 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703021252050.22009@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Who runs software raid with PCI-e or dedicated PCI-X controllers?

I was wondering what would one get with 10 150GB raptors, each on their 
own dedicated PCI-e card...

When I max out two separate raids on my PCI-e based motherboard, I see 
speeds in excess of 430-450MB/s.

1. 4 raptor 150s
2. 5 (at the time of benchmark) 400s (now 6)

I was wondering what kind of throughput you get?

With 4 raptors, it is generally in the 188-210MB/s range for RAID5.
RAID0 is 320-327MB/s both ways.

Justin.
