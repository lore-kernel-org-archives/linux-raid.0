From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 and data safety?
Date: Fri, 8 Apr 2005 14:16:03 +0200
Message-ID: <399ii2-l1m.ln1@news.it.uc3m.es>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de> <16969.10547.894461.398225@cse.unsw.edu.au> <ipqnh2-o1n.ln1@news.it.uc3m.es> <1112645166.29559.37.camel@compaq-rhel4.xsintricity.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I forgot to say "thanks"! Thanks for the breakdown.

Doug Ledford <dledford@redhat.com> wrote:
(of event count increment)
> I think the best explanation is this:  any change in array state that

OK ..

> would necessitate kicking a drive out of the array if it didn't also
> make this change in state with the rest of the drives in the array

Hmmm.  

> results in an increment to the event counter and a flush of the
> superblocks.


> Transition from ro -> rw or from rw -> ro, transition from clean to
> dirty or dirty to clean, any change in the distribution of disks in the
> superblock (aka, change in number of working disks, active disks, spare
> disks, failed disks, etc.), or any ordering updates of disk devices in
> the rdisk array (for example, when a spare is done being rebuilt to
> replace a failed device, it gets moved from it's current position in the
> array to the position it was just rebuilt to replace as part of the
> final transition from being rebuilt to being an active, live component
> in the array).

I still see about 8-10 changes in the event count between faulting a
disk out and bringing it back into the array for hot-repair, even if
nothing is written meantime. I suppose I could investigate!

Of concern to me (only) is that I observe that a faulted disk seems to
have an event count that is 1-2 counts behind that stamped on the bitmap
left behind on the array as it starts up in response to the fault.  The
number behind varies.  Something races.

Peter

