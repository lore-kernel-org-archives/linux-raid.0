From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: raid5 performance - 2.4.28
Date: Tue, 11 Jan 2005 21:18:44 -0800
Message-ID: <41E4B334.2020104@nsr500.net>
References: <Pine.LNX.4.44.0501101600250.28809-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0501101600250.28809-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
...
>>I'm also experimenting with this patch to see if the xor hardwire for 
>>modern intel/AMD architectures is still valid.  With the old processor 
>>p5_mmx was always picked and always within a few MB/s.  The new XP is all 
>>over the map.
> 
> 
> this choice (using pIII_sse even if there's a faster alternative)
> is made because it doesn't dirty the cache.  are you suggesting that 
> whole-system performance is better with p5_mmx, even though or *because*
> the blocks are then in cache?  seems unlikley to me, since the checksum
> is only used on writes or degraded mode.  having written blocks in cache
> seems worthless, almost...

I'm an experimentor, not a theorist.  I am running a series of experiments 
to determine if, and by how much, the xor algorithm in 
include/asm-<arch>/xor.h influences RAID5 write performance and reconstruction.

I'll post results.

-- 
