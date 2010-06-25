From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Building new RAID5 results in removed and failed devices
Date: Fri, 25 Jun 2010 06:06:58 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1006250605580.8623@uplift.swm.pp.se>
References: <4C23BF79.2070009@gmx.at> <20100624213848.GA17419@cthulhu.home.robinhill.me.uk> <4C23D7ED.9080000@gmx.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C23D7ED.9080000@gmx.at>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Krainz <ldm@gmx.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 25 Jun 2010, Markus Krainz wrote:

> Offline_Uncorrectable set to 1 while sdb has not. Is this a sign of disk 
> failure?

Yes, it means there is one sector that returned read error.

Check your kernel logs ("dmesg") and it's very likely you'll see media 
layer errors there.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
