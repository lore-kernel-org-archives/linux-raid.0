From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: sw raid5 hungs on resync and high IO load, 2.6.32.23
Date: Wed, 27 Oct 2010 10:50:10 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1010271046230.29868@uplift.swm.pp.se>
References: <4CC7D635.6050000@nangu.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CC7D635.6050000@nangu.tv>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Hamrle <martin.hamrle@nangu.tv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Oct 2010, Martin Hamrle wrote:

> I am not sure what is the reason of the end of the weird state. I think 
> the end was caused by starting copying kernel source into array.

It might be a 2.6.32 problem. I booted Ubuntu 10.04 LTS live off of an USB 
stick two days ago, proceeded to mount an external USB drive and started 
dd:ing my laptop drive to the external drive. To check the progress/speed 
I continued to do "apt-get install sysstat" (to get iostat). This install 
didn't succeed until the dd was over, I also about 40 gigs into the dd ran 
"sync" which blocked also until the dd was over.

So basically, dd:ing an internal 80 gig drive to external usb hd made two 
commands ("apt-get install" and sync) block and not succeed until the 
write pressure from dd was over. There might be something rotten here...

This was on a Thinkpad X200 laptop with 4 gigs of ram.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
