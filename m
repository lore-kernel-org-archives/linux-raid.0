From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: RAID-0 read perf. decrease after 2.4.20
Date: Fri, 21 Nov 2003 11:47:49 -0200 (BRST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311211144130.15440-100000@logos.cnet>
References: <Pine.OSF.4.58.0311201827090.515286@soul.helsinki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.OSF.4.58.0311201827090.515286@soul.helsinki.fi>
To: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 20 Nov 2003, Mikael Johansson wrote:

> 
> Hello All!
> 
> Has anyone else experienced a drastic drop in read performance on software
> RAID-0 with post 2.4.20 kernels? We have a few Athlon XP's here at our
> lab with double IDE disks on different channels set up as RAID-0. Some
> bonnie++ benchmark results with various kernels, on the same machine
> (Athlon XP 2400+, 2 GHz, 1.5 GB RAM, VIA chipset, 2*Maxtor 120 GB
> 6Y060L0):
> 		write	read
> 2.4.20-ac1:	88,000 	135,000 K/sec
> 2.4.21-pre7:	93,000   75,000
> 2.4.22-ac4:	94,000	 82,000
> 
> So the write speed has gone up a bit, but the read speed performance has
> plunged. Any ideas on what happened between 2.4.20 and 2.4.21 and what to
> do about it? I'm eagerly awaiting suggestions, good read speed is quite
> critical for many of our calculations :-) I will of course provide more
> details if necessary.

There have been no significant changes in the RAID driver in 2.4.21, so I
suspect the cause for the slowdowns might the changes to the IO scheduler
(ll_rw_blk.c) or VM changes.

Isolating the -pre which the slowdown starts helps a lot.



