From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: People using RAID-6?
Date: Thu, 12 Feb 2004 23:19:13 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <402C7A71.50501@zytor.com>
References: <c0hqc8$fvv$1@terminus.zytor.com> <20040213071519.GC1555@intern.kubla.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040213071519.GC1555@intern.kubla.de>
To: Dominik Kubla <dominik@kubla.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dominik Kubla wrote:
> 
> What is your own estimation? Is it useable for production systems?
> What is the recommended code basis? Our customers are _VERY_ conservative
> (read: bankers), so they are mostly going with mirrors or striped mirrors.
> 

I wouldn't try that at this point.  I'm trying to figure out if there is 
a userbase and how big it is, but the code is still very new.

> Is there any performance data for different work loads? Eg. how does it
> work for file service with different file sizes, read/write patterns.

It seems to be comparable to RAID-5 for reads down to about half the 
speed of RAID-5 for lots of small writes.

> Since most of our customers need database storage RAID1 still seems to be
> the best appoach.

Probably.

	-hpa

