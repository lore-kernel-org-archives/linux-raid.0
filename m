From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID-5 implementation questions
Date: Fri, 3 Dec 2010 11:02:04 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1012031057070.9121@uplift.swm.pp.se>
References: <4CF8AF30.5070505@ka9q.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CF8AF30.5070505@ka9q.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 3 Dec 2010, Phil Karn wrote:

> Except for the admittedly somewhat useful side effect of scanning the 
> disks for bad sectors, all this activity seems rather unnecessary. Is 
> there a way to create a RAID-5 (or any other RAID level) array so that 
> it will immediately come up without an initial rebuild?

"--assume-clean".

> File systems generally don't read disk blocks that they haven't already
> written. So even when you build a RAID array from drives with old data,
> I can't see how skipping the initial rebuild can cause any real harm.
> The first write to any block causes the RAID system to initialize the
> parity in that stripe, thus making it possible to regenerate that block
> in case of a drive failure.

Some raid implementations won't read/write to all drives, but might 
instead read the block being written to, and the parity block, then write 
the new block and recalculate the parity, thus not read/writing to all 
blocks. If this is the case, if the parity is wrong, it'll still be wrong 
after the operation, thus you don't have any redundancy.

Doing a rebuild when creating the array is something I'd only skip if I 
was doing lab work, never in production. I use raid for redundancy, thus I 
want to make sure everything is ok and it doesn't matter to me if it takes 
half a day.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
