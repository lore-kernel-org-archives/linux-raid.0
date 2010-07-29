From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: MD raid and different  elevators  (disk i/o schedulers)
Date: Thu, 29 Jul 2010 12:53:35 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1007291251250.9875@uplift.swm.pp.se>
References: <4C51540E.9050005@kurgan.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C51540E.9050005@kurgan.org>
Sender: linux-raid-owner@vger.kernel.org
To: Fabio Muzzi <liste@kurgan.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 29 Jul 2010, Fabio Muzzi wrote:

> Is this true? Are there compatibility issues using different i/o 
> schedulers with software raid?

I'd actually like to raise this one level further:

In the case of (drives)->md->dm(crypto)->lvm->fs, how do the schedulers, 
readahead settings, blocksizes, barriers etc interact thru all these 
layers? Is block caching done on all layers? Is readahead done on all 
layers?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
