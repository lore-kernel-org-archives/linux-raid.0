From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Port Multipliers
Date: Thu, 10 Sep 2009 20:45:11 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0909102043000.20805@uplift.swm.pp.se>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>  <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com> <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 10 Sep 2009, Drew wrote:

> each PM, what sort of speed degradation would I be looking at compared 
> to making a RAID5 off just the 3124?

My biggest beef with some of the PMPs out there are the caveats that come 
with some of them, such as "you have to have a drive in port 0 otherwise 
all the drives on that PMP goes haywire".

So whatever solution you go for, test it properly so it works in your 
environment. Try hotswapping all drives, make sure you understand what the 
OS reaction is to combinations of drives being there and not, try 
rebooting in degraded modes etc.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
