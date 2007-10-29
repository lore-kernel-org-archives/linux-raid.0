From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Raid-10 mount at startup always has problem
Date: Tue, 30 Oct 2007 07:56:14 +1300
Message-ID: <47262CCE.9050301@sauce.co.nz>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>	 <471FA485.6010705@tmr.com>  <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <472576A5.3030603@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472576A5.3030603@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel L. Miller wrote:

> Nothing in the documentation (that I read - granted I don't always read 
> everything) stated that partitioning prior to md creation was necessary 
> - in fact references were provided on how to use complete disks.  Is 
> there an "official" position on, "To Partition, or Not To Partition"?  
> Particularly for my application - dedicated Linux server, RAID-10 
> configuration, identical drives.

My simplistic reason for always making one partition on md drives, about 
100MB smaller than the full space, has been as insurance to allow use of 
a replacement drive from another manufacturer, which while nominally 
marked as the same size as the originals, is in fact slightly smaller.

Regards,

Richard
