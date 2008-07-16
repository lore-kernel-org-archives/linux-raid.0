From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 15:55:37 +1200
Message-ID: <487D7139.5050302@sauce.co.nz>
References: <1216130769.5633.318.camel@sam.localdomain>	 <487CC660.9030004@ziu.info> <1216179392.5633.348.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216179392.5633.348.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Martin wrote:

> I have been meaning to ask for a while, why is the stripe_cache_size
> set so low by default if it has such an effect on performance? 

I can't comment on the above, but looking at this:

http://marc.info/?l=linux-raid&m=120668318422034&w=2

with the 2.6.26 release, bumping up the stripe cache should no longer be 
necessary.

Regards,

Richard
