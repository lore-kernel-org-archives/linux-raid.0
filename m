From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Questions answered by Neil Brown
Date: Wed, 26 Feb 2003 11:41:51 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5CEE4F.363A9FB6@SteelEye.com>
References: <200302260809.h1Q89Sa20683@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:

> > Yeah, I sure wish I knew who did that and why. I wonder if someone had a
> 
> A check of the buffer.c code shows b_this_page is always tested against

Right, but note that when raid1 is setting those 1s, it's in the bh's
that it's sending down to lower level devices, not in the bh's that came
in from above...a subtle distinction. So these 1s would be consumed only
by raid1's end_io routines. Any changes we make to b_this_page in the
"master_bh" will have to be handled correctly by the end_io of the upper
level code (stuff in buffer.c).


> > clever plan to use that field at some point, but never got around to it.
> > Setting that field to something besides a real address sure does seem
> > odd...and I can't see that it's ever used anywhere.
> 
> What is also puzzling me is that despite the horrible potential for
> what might happen from doing the original users end_io early, I
> can't see any consequences in actual tests!

Probably because the timing is so close...if we were to delay the
completion of I/O to one of the devices by several seconds, say, I
believe we'd see some really bad things happen. Another thing that
probably has to coincide with the I/O delays is memory pressure,
otherwise I think the system will just end up keeping the buffers cached
forever (OK, a really long time...) and nothing bad will happen. 

One thought I had for a test (when I get to the point of really
rigorously testing this stuff :)) is to set up an nbd-client/server pair
and insert a sleep into the nbd-server so that completion of I/O is
_always_ delayed by some period...(this will also help in performance
testing, to see how much benefit we get from doing async writes with
high latency).

BTW, I'm working on the code to duplicate the bh (and its memory buffer)
right now. It's basically coded, but not tested. I've based it off your
2.5 code. I'm also working on a simple queueing mechanism (to queue
write requests to backup devices). This will allow us to adjust the bit
to block ratio of the bitmap (intent log) to save disk space and memory.
This mechanism will also be needed if we want to increase the degree of
asynchronicity of the writes (we could just queue all writes and deal
with them later, perhaps in batches).
