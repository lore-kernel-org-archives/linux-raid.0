From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sat, 3 Dec 2005 14:49:16 -0500
Message-ID: <001b01c5f842$a4eca7b0$c700a8c0@NCNF5131FTH>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH> <4391A575.8060707@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> I hope that's a typo... you need to partition sdb, not the md_d0 raid 
> device.
> 

That's not a typo; md_d0 is a partitionable md device.

-- David
