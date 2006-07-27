From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: ICH7R "strip" size
Date: Thu, 27 Jul 2006 01:18:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607270113120.19846@coffee.psychology.mcmaster.ca>
References: <7.0.1.0.2.20060726194627.06340898@jeffwoods.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7.0.1.0.2.20060726194627.06340898@jeffwoods.us>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Woods <Kazrak+kernel@cesmail.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> My question: What are the chunk and usable storage sizes per stripe for four 
> discs in RAID-0 on an ICH7R configured for a 128KB "strip"?

raid0 always has 100% usable; configuring it is deciding how much 
concurrency you want.

if your writes are 64K and you have 4 disks, your max concurrency would
be at 64K per disk (stripe size in MD), or 256K for a whole stripe.
if you want max bandwidth, but concurrency of 1, you want the 64k write
to busy all the disks, for a 16K stripe size (64K whole-stripe).

with raid5, the main thing additional factor is to try to arrange 
"blind" whole-stripe writes if possible.  that is, you pay the
read-modify-write penalty unless you write a whole stripe at once:
n-1 * stripe size if you can manage it aligned, or at least several
whole stripes to amortize the reads necessary on the edges...
