From: Neil Brown <neilb@suse.de>
Subject: Re: Superblock checksum problems
Date: Tue, 5 Sep 2006 07:35:38 +1000
Message-ID: <17660.39978.663609.990424@cse.unsw.edu.au>
References: <1157236610.8070.7.camel@localhost>
	<17659.46517.979409.131348@cse.unsw.edu.au>
	<1157385612.2990.4.camel@localhost>
	<1157403347.2990.11.camel@localhost>
	<1157404398.2990.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Josh Litherland on Monday September 4
Sender: linux-raid-owner@vger.kernel.org
To: josh@temp123.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 4, josh@temp123.org wrote:
> 
> This one will really curl your hair.  So, operating with the knowledge
> that the checksum's state of correctness or incorrectness was changing
> all the time, I did this:
> 
> while [ $? != 0 ] ; do
> 	mdadm -A /dev/md0 /dev/sd[abcd]1
> done
> 
> after 1,518 trials it successfully assembled.
> 
> *beats head against wall*

I think maybe you should beat the computer against the wall, and then
get it replaced under warranty ...

Something is SERIOUSLY wrong.
As it affects all drives, I suspect the drives are fine.
As that machine doesn't crash instantly, I suspect the cpu/memory is
fine.
Which leaves the controller and cables.
Try
 for i in `seq 1 20`; do
  dd if=/dev/sda of=/tmp/try-$i conv=direct
 done
 for i in `seq 2 20`; do
  cmp -l /tmp/try-1 /tmp/try=$i
 done

and look for a pattern.

NeilBrown

