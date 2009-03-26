From: Bill Davidsen <davidsen@tmr.com>
Subject: Thoughts on using SSD
Date: Thu, 26 Mar 2009 19:09:01 -0400
Message-ID: <49CC0B0D.5000904@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm building a fairly aggressive machine for both a backup host for 
virtual machines and spare time development platform, compile engine and 
testbed both. I want to get cost effective use from an SSD unit, and I 
propose to use a 32GB unit as follows: for the root filesystem, 12GB, 
which should hold all the usual root things, and 16GB for swap (12GB 
RAM, and I want boot and/or hibernate to happen NOW). The remaining 
space I think might be used for various high impact things, and one of 
those with speeding raid.

If I were to create a small raid device, raid1, made of the 4GB Ssd and 
4GB of SATA space, if I made the SATA write-mostly and write-behind, and 
put the journal for my raid arrays (and bitmaps?) that seems likely to 
provide a significant performance gain in small storage.

Am I missing anything here? Is there an obvious drawback I'm missing?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


