From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: What does --replace actually do?
Date: Fri, 15 Apr 2016 14:11:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1604151410040.16013@uplift.swm.pp.se>
References: <5710CFF8.70508@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5710CFF8.70508@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 15 Apr 2016, Eyal Lebedinsky wrote:

> When I request to replace sda with sdj (RAID6 in my case), does it 
> create sdj from the other members (NOT using sda) or does it make a copy 
> of (by reading) sda?

It reads sda and copies it to sdj. When it's done it'll fail sda. If it 
has problems reading from sda, it'll use the rest of the drives to 
recreate/recalculate the block and write that to sdj.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
