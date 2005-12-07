From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID5 resync question
Date: Wed, 7 Dec 2005 02:32:49 +0100
Message-ID: <020201c5face$23700cc0$0400a8c0@dcccs>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs><17300.56329.638969.509384@cse.unsw.edu.au><004201c5f9fe$50cc41a0$0400a8c0@dcccs><17300.58327.193597.248431@cse.unsw.edu.au><002b01c5fa53$cd3d3fa0$0400a8c0@dcccs> <17302.9182.322057.18613@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >
> > One time while my array is really rebuild one disk (paralel normal
> > workload), i see, the new drive in the array *only* writes.
> > i means with "better handling of half-synced array" is this:
> > If read request comes to the ?% synced array, and if the read is on the
> > synced half, only need to read from *new* device, instead reading all
other
> > to calculate data from parity.
> >
> > On a working system this can be a little speed up the rebuild process,
and
> > some offload the system.
> > Or i'm on a wrong clue? :-)
>
> Yes, it would probably be possible to get it to read from the
> recovering drive once that section had been recovered.  I'll put it on
> my todo list.

If i can add some idea to the world's greatest raid software, it is my
pleasure! :-)

But, Neil!
It is still something what i cannot understand.

(Preliminary, i never have read the raid5 code.
However i cannot programming in C or C++, only a little can read.)

I cannot cleanly understand what u sad about the parity-updating!

If the array is clean, the parity spaces (blocks) only need to write. (or
not?)
Why use the raid code read-modify-write?
I think it is unnecessary to read these blocks!
The parity block recalculate in memory is more faster than
read-modify-write.

Why the parity space is continous area? (if it is...)
I think it is only need to be block-based, from a lot of independent blocks.
This can be speed up the resync, easy to using always checkpoints, and some
more...

And if the parity data is damaged (like system crash or sg.), and it is
impossible to detect, the next write to the block will turn to correct again
the parity.

Cheers,
Janos



>
> NeilBrown

