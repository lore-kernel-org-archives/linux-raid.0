From: Josh Litherland <josh@temp123.org>
Subject: Re: Superblock checksum problems
Date: Mon, 04 Sep 2006 17:46:58 -0400
Message-ID: <1157406418.2990.20.camel@localhost>
References: <1157236610.8070.7.camel@localhost>
	 <17659.46517.979409.131348@cse.unsw.edu.au>
	 <1157385612.2990.4.camel@localhost> <1157403347.2990.11.camel@localhost>
	 <1157404398.2990.14.camel@localhost>
	 <17660.39978.663609.990424@cse.unsw.edu.au>
Reply-To: josh@temp123.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17660.39978.663609.990424@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2006-09-05 at 07:35 +1000, Neil Brown wrote:

> Something is SERIOUSLY wrong.
> As it affects all drives, I suspect the drives are fine.
> As that machine doesn't crash instantly, I suspect the cpu/memory is
> fine.
> Which leaves the controller and cables.

>  for i in `seq 1 20`; do
>   dd if=/dev/sda of=/tmp/try-$i conv=direct
>  done
>  for i in `seq 2 20`; do
>   cmp -l /tmp/try-1 /tmp/try=$i
>  done
> 
> and look for a pattern.

-nod-  You're thinking the card is reading/writing different values intermittently, I'm guessing.  The only thing
which makes me dubious about that is, once the md is up and running it seems to do perfectly fine.  I've only used
it for a couple days, but never got any read errors or invalid file problems.  I was doing pretty heavy IO on it,
and these header checksum readings are changing several times a SECOND.

The other is that the actual checksum value being generated never changes, just the kernel's idea of whether it's
valid or invalid.

Weird, weird, weird.  I will probably get a new card, but I'd like to keep examining this one for SCIENCE for a 
little while longer.

-- 
Josh Litherland (josh@temp123.org)

