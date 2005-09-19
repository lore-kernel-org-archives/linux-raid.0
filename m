From: "Greg Brackley" <greg.brackley-gmane@lucidsolutions.co.nz>
Subject: Re: Highpoint 1820A
Date: Mon, 19 Sep 2005 22:20:38 +1200
Message-ID: <dgm3cr$iv1$1@sea.gmane.org>
References: <Pine.LNX.4.62.0509170714560.21650@uplift.swm.pp.se>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Mikael Abrahamsson" <swmike@swm.pp.se> wrote in message 
news:Pine.LNX.4.62.0509170714560.21650@uplift.swm.pp.se...
> functioning and failing. Does anyone have a success story with this card 
> under linux?

I've generally had quite positive experiences with the card under FC3 and 
FC4 x86_64 using Linux software RAID 5 and the OpenBuild driver.  The driver 
has generally been quite good, however it doesn't appear to support SMART 
I/O controls.  I like to monitor SMART parameters so I can swap out disks 
before they catastrophically fail.

I have started using the now GNU licensed Marvell driver [1] with my 1820a. 
I haven't had a chance to benchmark it, however it works and it does support 
SMART I/O controls. It seems to require a full kernel source tree to build. 
I'm using it with FC4 x86_64.

In the future I am looking forward to using the Brett Russ libata Marvell 
driver that is going in the kernel. I haven't tried the PIO only driver.

Greg :-)

[1] http://www.keffective.com/mvsata/ 



