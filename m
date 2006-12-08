From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm assemble question
Date: Sat, 9 Dec 2006 09:59:30 +1100
Message-ID: <17785.61010.745533.90298@cse.unsw.edu.au>
References: <200612081427.22117.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jacob Schmidt Madsen on Friday December 8
Sender: linux-raid-owner@vger.kernel.org
To: Jacob Schmidt Madsen <jacob@mungo.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 8, jacob@mungo.dk wrote:
> Hey,
> 
> I've added 2 new disks to an existing raid5 array and started the grow 
> process.
> 
> The grow process was unsuccessfull because it stalled at 98.1% and the system 
> log show a long list of "compute_blocknr: map not correct".

Not good!

> 
> Am I just blind or is it not possible to start an array without starting the 
> reshape process?

Normally you wouldn't want to....

Can you post the output of "mdadm --examine" on each of the component
devices please.  And tell me what version of the Linux kernel you are
using, and what version of mdadm?  I'll see if I can figure out what
happened and what the best way to fix it is.

Thanks,
NeilBrown
