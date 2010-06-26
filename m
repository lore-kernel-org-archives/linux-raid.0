From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID5 write hole?
Date: Sat, 26 Jun 2010 17:42:56 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1006261737430.8623@uplift.swm.pp.se>
References: <20100626143125.GA1010@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100626143125.GA1010@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Shaochun Wang <scwang@ios.ac.cn>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 26 Jun 2010, Shaochun Wang wrote:

> Hi:
>
> Recently I heard of the so called "write hole" problem of raid5 in
> Linux software raid. I use ext4 filesystem on my NAS, which assembles
> data disks using Linux software raid. So I wonder how safe my such
> system!

RAID is never a replacement for backups, corruption can happen at multiple 
levels in your system for different reasons. Non-ECC memory can have bit 
flips which corrupts your data, write hole can cause data corruption, etc.

Generally, unless you have really really high demands on data integrity, 
this is not a major problem.

Ext4 has other potential software/fs interactions when it comes to data 
integrity, in that it write buffers for quite some time, so even if you 
think your file is saved, it might take many seconds before it's actually 
on disk if your software doesn't fsync() it. Most don't, because Ext3 took 
so long to do it.

So generally, don't worry too much, but make sure you have backups for 
your important data.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
